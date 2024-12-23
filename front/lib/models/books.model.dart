// repository.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BooksStore extends ChangeNotifier {
  // static const String baseUrl = 'http://localhost:3000/books';
  static const String baseUrl = 'http://10.0.2.2:3000/books';
  final List<BookItem> _books = [];
  final List<CartItem> _cart = [];
  UserProfile _userProfile = UserProfile();

  List<BookItem> get list => _books;
  List<CartItem> get cart => _cart;
  UserProfile get userProfile => _userProfile;

  double get cartTotal =>
      _cart.fold(0, (total, item) => total + item.price * item.count);

  bool BookInCart(code) {
    return _cart.indexWhere((item) => item.code == code) != -1;
  }

  int maxCode() {
    int maxCode = _books[0].code;
    for (int i = 1; i < _books.length; i++) {
      if (_books[i].code > maxCode) {
        maxCode = _books[i].code;
      }
    }
    return maxCode;
  }

  // List<BookItem> get favorites => _books.where((book) => book.isFavorite).toList();
  int get length => _books.length;

  List<BookItem> favorites() {
    return _books.where((book) => book.isFavorite).toList();
  }

  Future<void> fetchBooks() async {
    _books.clear();
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        // _books.addAll(jsonResponse.toList());
        List books =
            jsonResponse.map((book) => BookItem.fromJson(book)).toList();
        _books.addAll(books as List<BookItem>);
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    notifyListeners();
  }

  Future<void> addBook(BookItem newBook) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(newBook.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed add new book');
    }

    _books.insert(0, newBook);
    notifyListeners();
  }

  Future<void> updateBook(BookItem updBook) async {
    /* final response = await http.put(
      Uri.parse('$baseUrl/${upd_book.code}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(upd_book.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update book');
    } */

    int index = _books.indexWhere((item) => item.code == updBook.code);
    if (index > -1) _books[index] = updBook;
    notifyListeners();
  }

  Future<void> deleteBook(int code) async {
    final response = await http.delete(Uri.parse('$baseUrl/$code'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete book');
    }
    _books.removeWhere((item) => item.code == code);
    notifyListeners();
  }

  Future<void> toggleFavorite(int code) async {
    final response = await http.post(Uri.parse('$baseUrl/setfavorite/$code'));
    if (response.statusCode != 204) {
      throw Exception('Failed set favotite book');
    }
    int index = _books.indexWhere((item) => item.code == code);
    if (index != -1) _books[index].isFavorite = !_books[index].isFavorite;
    notifyListeners();
  }

  Future<void> addToCart(BookItem book) async {
    int index = _cart.indexWhere((item) => item.code == book.code);
    if (index == -1) {
      _cart.add(
          CartItem(code: book.code, book: book, count: 1, price: book.price));
    } else {
      _cart[index].count++;
    }
    notifyListeners();
  }

  Future<void> delFromCart(int code) async {
    int index = _cart.indexWhere((item) => item.code == code);
    if (index == -1) {
      return;
    } else {
      _cart[index].count--;
      if (_cart[index].count == 0) {
        _cart.removeAt(index);
      }
    }
    notifyListeners();
  }

  Future<void> updateProfile(UserProfile profile) async {
    _userProfile = profile;
    notifyListeners();
  }
}

class BookItem {
  final int code;
  final String title;
  final String author;
  final String description;
  final int price;
  final String img;
  bool isFavorite;

  BookItem({
    required this.code,
    required this.title,
    required this.author,
    this.description = '',
    this.price = 0,
    this.img = '',
    this.isFavorite = false,
  });

  factory BookItem.fromJson(Map<String, dynamic> json) {
    return BookItem(
      code: json['code'],
      title: json['title'],
      author: json['author'],
      description: json['description'],
      price: json['price'],
      img: json['img'],
      isFavorite: json['is_favorite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'title': title,
      'author': author,
      'description': description,
      'price': price,
      'img': img,
      'is_favorite': isFavorite,
    };
  }

  void toggleFavorite(int index) {
    // booksStore[index].isFavorite = !booksStore[index].isFavorite;
  }
}

class CartItem {
  final int code;
  final BookItem book;
  int count;
  int price;

  CartItem({
    required this.code,
    required this.book,
    this.count = 0,
    this.price = 0,
  });
}

class UserProfile {
  int uid;
  String name;
  String surname;
  String email;

  UserProfile({
    this.uid = 0,
    this.name = '',
    this.surname = '',
    this.email = '',
  });
}
