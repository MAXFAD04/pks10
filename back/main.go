package main

import (
	"log"
	"net/http"
	"strconv"

	"database/sql"

	_ "github.com/lib/pq"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

var DATABASE_URL string = "postgresql://book:book@localhost/bookstore?sslmode=disable"

type BookItem struct {
	Code        int    `json:"code"`
	Title       string `json:"title"`
	Author      string `json:"author"`
	Description string `json:"description"`
	Price       int    `json:"price"`
	Img         string `json:"img"`
	IsFavorite  bool   `json:"is_favorite"`
}

var booksStore = []BookItem {}

func main() {
		
	router := gin.Default()
	router.Use(cors.Default())

	router.GET("/books", getBooks)
	router.POST("/books/setfavorite/:code", setFavorite)
	router.POST("/books", addBook)
	router.DELETE("/books/:code", deleteBook)

	router.Run("localhost:3000")
}

func getBooks(c *gin.Context) {
	booksStore = []BookItem {}
	db, err := sql.Open("postgres", DATABASE_URL)
	if err != nil {
		log.Fatal(err)
		c.JSON(http.StatusBadRequest, gin.H{"message": err})
		return
	}
	rows, err := db.Query("SELECT code, title, author, price, img, description, isfavorite FROM books ORDER BY title")
	if err != nil {
		log.Fatal(err)
		c.JSON(http.StatusBadRequest, gin.H{"message": err})
		return
	}
	defer rows.Close()
	for rows.Next() {
		var code int
		var title string
		var author string
		var price int
		var img string
		var description string
		var isfavorite bool
		if err := rows.Scan(&code, &title, &author,	&price, &img, &description, &isfavorite); err != nil {
			log.Fatal(err)
			c.JSON(http.StatusBadRequest, gin.H{"message": err})
			return
		}
		var item = BookItem {Code: code, Title: title, Author: author, Price: price, Img: img, Description: description, IsFavorite: isfavorite}
		booksStore = append(booksStore, item)
	}
	c.JSON(http.StatusOK, booksStore)
}

func addBook(c *gin.Context) {
	var newBook BookItem
	if err := c.ShouldBindJSON(&newBook); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	db, err := sql.Open("postgres", DATABASE_URL)
	if err != nil {
		log.Fatal(err)
		c.JSON(http.StatusBadRequest, gin.H{"message": err})
		return
	}
	result, err := db.Exec("insert into books(code, title, author, price, img, description, isfavorite) values($1, $2, $3, $4, $5, $6, $7)", newBook.Code, newBook.Title, newBook.Author, newBook.Price, newBook.Img, newBook.Description, newBook.IsFavorite)
	if err != nil {
		log.Fatal(err)
		c.JSON(http.StatusBadRequest, gin.H{"message": err})
		return
	}
	rows, err := result.RowsAffected()
	if err != nil { c.JSON(http.StatusBadRequest, gin.H{"message": err}) }
	if rows != 1 { log.Fatalf("expected to affect 1 row, affected %d", rows) }
	booksStore = append(booksStore, newBook)
	c.JSON(http.StatusCreated, newBook)
}

func deleteBook(c *gin.Context) {
	codeStr := c.Param("code")
	code, err := strconv.Atoi(codeStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "invalid code"})
		return
	}
	for index, book := range booksStore {
		if book.Code == code {
			db, err := sql.Open("postgres", DATABASE_URL)
			if err != nil {
				log.Fatal(err)
				c.JSON(http.StatusBadRequest, gin.H{"message": err})
				return
			}
			result, err := db.Exec("delete from books where code = $1", code)
			if err != nil {
				log.Fatal(err)
				c.JSON(http.StatusBadRequest, gin.H{"message": err})
				return
			}
			rows, err := result.RowsAffected()
			if err != nil { c.JSON(http.StatusBadRequest, gin.H{"message": err}) }
			if rows == 0 { log.Fatalf("expected to affect 1 row, affected %d", rows) }

			booksStore = append(booksStore[:index], booksStore[index+1:]...)
			c.Status(http.StatusNoContent)
			return
		}
	}
	c.JSON(http.StatusNotFound, gin.H{"message": "book not found"})
}

func setFavorite(c *gin.Context) {
	codeStr := c.Param("code")
	code, err := strconv.Atoi(codeStr)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": "invalid code"})
		return
	}
	for index, book := range booksStore {
		if book.Code == code {
			booksStore[index].IsFavorite = !booksStore[index].IsFavorite

			db, err := sql.Open("postgres", DATABASE_URL)
			if err != nil {
				log.Fatal(err)
				c.JSON(http.StatusBadRequest, gin.H{"message": err})
				return
			}

			result, err := db.Exec("update books set isfavorite=$1 where code=$2", booksStore[index].IsFavorite, code)
			if err != nil {
				log.Fatal(err)
				c.JSON(http.StatusBadRequest, gin.H{"message": err})
				return
			}
			rows, err := result.RowsAffected()
			if err != nil { c.JSON(http.StatusBadRequest, gin.H{"message": err}) }
			if rows == 0 { log.Fatalf("expected to affect 1 row, affected %d", rows) }

			c.Status(http.StatusNoContent)
			return
		}
	}
	c.JSON(http.StatusNotFound, gin.H{"message": "book not found"})
}
