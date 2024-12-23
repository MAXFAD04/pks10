import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_first_app/models/books.model.dart';

class BooksList extends StatefulWidget {
  const BooksList({super.key, required this.title});
  final String title;

  @override
  State<BooksList> createState() => _BooksList();
}

class _BooksList extends State<BooksList> {
  // final bookStore = Provider.of<BooksStore>(context);
  // final bookStore = Provider.of<BooksStore>(context, listen: false);

  @override
  void initState() {
    super.initState();
    // Вызов метода для загрузки книг
    Future.microtask(
        () => Provider.of<BooksStore>(context, listen: false).fetchBooks());
  }

  // Функция для удаления книги
  void _deleteBook(bookStore, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Подтверждение удаления'),
          content: const Text('Вы уверены, что хотите удалить эту книгу?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Удалить'),
              onPressed: () {
                setState(() {
                  bookStore.deleteBook(bookStore.list[index].code);
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addBook(bookStore) {
    final code = bookStore.maxCode() + 1;
    final titleController = TextEditingController();
    final authorController = TextEditingController();
    final priceController = TextEditingController();
    final descriptionController = TextEditingController();
    final imgController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Добавить книгу'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Название'),
                ),
                TextField(
                  controller: authorController,
                  decoration: const InputDecoration(labelText: 'Автор'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Цена'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Описание'),
                ),
                TextField(
                  controller: imgController,
                  decoration: const InputDecoration(
                      labelText: 'Изображение (имя файла)'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Добавить'),
              onPressed: () async {
                if (titleController.text.isNotEmpty &&
                    authorController.text.isNotEmpty &&
                    priceController.text.isNotEmpty &&
                    imgController.text.isNotEmpty) {
                  try {
                    final price = int.parse(priceController.text);
                    final newBook = BookItem(
                      code: code,
                      title: titleController.text,
                      author: authorController.text,
                      description: descriptionController.text,
                      price: price,
                      img: imgController.text,
                    );
                    await bookStore.addBook(newBook); // Отправка на сервер
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Ошибка: введите корректную цену.')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Ошибка: все поля должны быть заполнены.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookStore = Provider.of<BooksStore>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _addBook(bookStore),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: bookStore.length,
        separatorBuilder: (context, index) =>
            const Divider(color: Colors.white30),
        itemBuilder: (context, index) => ListTile(
          leading: Image.asset(
            'assets/img/${bookStore.list[index].img}',
            width: 50,
            height: 50,
          ),
          title: Text(bookStore.list[index].title,
              style: theme.textTheme.bodyMedium),
          subtitle: Text(bookStore.list[index].author,
              style: theme.textTheme.labelSmall),
          trailing: Wrap(
            children: [
              Text('${bookStore.list[index].price.toInt().toString()} р.',
                  style: theme.textTheme.labelSmall),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                icon: Icon(
                    bookStore.list[index].isFavorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: bookStore.list[index].isFavorite
                        ? Colors.red
                        : Colors.grey),
                onPressed: () {
                  bookStore.toggleFavorite(bookStore.list[index].code);
                },
              ),
              IconButton( // Корзина 
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                icon: Icon(
                  bookStore.BookInCart(bookStore.list[index].code)
                      ? Icons.shopping_basket
                      : Icons.shopping_basket_outlined,
                  color: bookStore.BookInCart(bookStore.list[index].code)
                      ? Colors.yellow
                      : Colors.grey
                ),
                onPressed: () => bookStore.addToCart(bookStore.list[index])
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                icon: Icon(Icons.delete, color: Colors.white),
                onPressed: () => _deleteBook(bookStore, index),
              ),
            ],
          ),
          onTap: () {
            Navigator.of(context).pushNamed('/info', arguments: index);
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Книги'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Избранное'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Корзина'), // Добавляем корзину
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[300],
        backgroundColor: Colors.black26,
        onTap: (index) {
          switch (index) {
            case 0:
              // Navigator.of(context).pushNamed('/');
              bookStore.fetchBooks();
              break;
            case 1:
              Navigator.of(context).pushNamed('/favorites');
              break;
            case 2:
              Navigator.of(context).pushNamed('/cart');
              break;
            case 3:
              Navigator.of(context).pushNamed('/profile');
              break;
          }
        },
      ),
    );
  }
}
