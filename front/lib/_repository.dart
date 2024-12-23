// repository.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

List<BookItem> cartStore = [];
List<BookItem> booksStore = [];

class Repository {
  // static const String baseUrl = 'http://localhost:3000/books';
  static const String baseUrl = 'http://10.0.2.2:3000/books';

  Future<List<BookItem>> fetchBooks() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List jsonResponse = json.decode(response.body);
        return jsonResponse.map((book) => BookItem.fromJson(book)).toList();
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      print(e.toString());
      throw Exception(e.toString());
    }
  }

  Future<void> addBook(BookItem book) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(book.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add book');
    }
  }

  Future<void> updateBook(BookItem book) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${book.code}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(book.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update book');
    }
  }

  Future<void> deleteBook(int code) async {
    final response = await http.delete(Uri.parse('$baseUrl/$code'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete book');
    }
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

/* List<BookItem> cartStore = [];

List<BookItem> booksStore = [
  BookItem(code: 1343, title: "1984", author: "Джордж Оруэлл", price: 800, img: '1.jpg', description: '«1984» (англ. Nineteen Eighty-Four, «тысяча девятьсот восемьдесят четвёртый») — роман-антиутопия Джорджа Оруэлла, изданный в 1949 году. Последнее и, по господствующему мнению, самое главное произведение писателя', isFavorite: false),
  BookItem(code: 22342, title: "Убить пересмешника", author: "Харпер Ли", price: 700, img: '2.jpg', description: '«Уби́ть пересме́шника» (англ. To Kill a Mockingbird) — роман-бестселлер американской писательницы Харпер Ли, опубликованный в 1960 году, за который в 1961 году она получила Пулитцеровскую премию. Её успех стал вехой в борьбе за права чернокожих.', isFavorite: false),
  BookItem(code: 3222, title: "Гордость и предубеждение", author: "Джейн Остин", price: 600, img: '3.jpg', description: 'Роман начинается с беседы мистера и миссис Беннет о приезде молодого мистера Бингли в Незерфилд-парк. Жена уговаривает мужа навестить соседа и свести с ним более тесное знакомство. Она надеется, что мистеру Бингли непременно понравится одна из их пяти дочерей. Мистер Беннет наносит визит молодому человеку, и тот через какое-то время наносит ответный.', isFavorite: false),
  BookItem(code: 496754, title: "Моби Дик", author: "Herman Melville", price: 750, img: '4.jpg', description: 'Повествование ведётся от имени американского моряка Измаила, ушедшего в рейс на китобойном судне «Пекод», капитан которого, Ахав (отсылка к библейскому Ахаву), одержим идеей мести гигантскому белому киту, убийце китобоев, известному как Моби Дик (в предыдущем плавании по вине кита Ахав потерял ногу, и с тех пор капитан использует протез).', isFavorite: false),
  BookItem(code: 5453, title: "Великий Гэтсби", author: "Фрэнсис Скотт Фицджеральд", price: 650, img: '2.jpg', description: 'Итоговое произведение литературы американского романтизма. Длинный роман с многочисленными лирическими отступлениями, проникнутый библейской образностью и многослойным символизмом, не был понят и принят современниками', isFavorite: false),
  BookItem(code: 63578, title: "Преступление и наказание", author: "Фёдор Достоевский", price: 900, img: '1.jpg', description: 'Итоговое произведение литературы американского романтизма. Длинный роман с многочисленными лирическими отступлениями, проникнутый библейской образностью и многослойным символизмом, не был понят и принят современниками', isFavorite: false),
  BookItem(code: 732234, title: "Анна Каренина", author: "Лев Толстой", price: 850, img: '4.jpg', description: 'Итоговое произведение литературы американского романтизма. Длинный роман с многочисленными лирическими отступлениями, проникнутый библейской образностью и многослойным символизмом, не был понят и принят современниками', isFavorite: false),
  BookItem(code: 85843, title: "Сияние", author: "Стивен Кинг", price: 800, img: '3.jpg', description: 'Итоговое произведение литературы американского романтизма. Длинный роман с многочисленными лирическими отступлениями, проникнутый библейской образностью и многослойным символизмом, не был понят и принят современниками', isFavorite: false),
  BookItem(code: 94622, title: "Три товарища", author: "Эрих Мария Ремарк", price: 700, img: '1.jpg', description: 'Итоговое произведение литературы американского романтизма. Длинный роман с многочисленными лирическими отступлениями, проникнутый библейской образностью и многослойным символизмом, не был понят и принят современниками', isFavorite: false),
  BookItem(code: 103468, title: "451 градус по Фаренгейту", author: "Рэй Брэдбери", price: 600, img: '4.jpg', description: 'Итоговое произведение литературы американского романтизма. Длинный роман с многочисленными лирическими отступлениями, проникнутый библейской образностью и многослойным символизмом, не был понят и принят современниками', isFavorite: false),
  BookItem(code: 119275, title: "Братья Карамазовы", author: "Фёдор Достоевский", price: 950, img: '2.jpg', description: 'Итоговое произведение литературы американского романтизма. Длинный роман с многочисленными лирическими отступлениями, проникнутый библейской образностью и многослойным символизмом, не был понят и принят современниками', isFavorite: false),
  BookItem(code: 125006, title: "Маленький принц", author: "Антуан де Сент-Экзюпери", price: 500, img: '3.jpg', description: 'Итоговое произведение литературы американского романтизма. Длинный роман с многочисленными лирическими отступлениями, проникнутый библейской образностью и многослойным символизмом, не был понят и принят современниками', isFavorite: false),
  BookItem(code: 13227, title: "Старик и море", author: "Эрнест Хемингуэй", price: 700, img: '1.jpg', description: 'Итоговое произведение литературы американского романтизма. Длинный роман с многочисленными лирическими отступлениями, проникнутый библейской образностью и многослойным символизмом, не был понят и принят современниками', isFavorite: false),
  BookItem(code: 14, title: "Война и мир", author: "Лев Толстой", price: 1200, img: '2.jpg', isFavorite: false),
  BookItem(code: 152342, title: "Дон Кихот", author: "Мигель де Сервантес", price: 800, img: '4.jpg', description: 'Итоговое произведение литературы американского романтизма. Длинный роман с многочисленными лирическими отступлениями, проникнутый библейской образностью и многослойным символизмом, не был понят и принят современниками', isFavorite: false),
  BookItem(code: 167732, title: "Собачье сердце", author: "Михаил Булгаков", price: 600, img: '3.jpg', description: 'Итоговое произведение литературы американского романтизма. Длинный роман с многочисленными лирическими отступлениями, проникнутый библейской образностью и многослойным символизмом, не был понят и принят современниками', isFavorite: false),
  BookItem(code: 172345, title: "Над пропастью во ржи", author: "Джером Д. Сэлинджер", price: 700, img: '1.jpg', description: 'Итоговое произведение литературы американского романтизма. Длинный роман с многочисленными лирическими отступлениями, проникнутый библейской образностью и многослойным символизмом, не был понят и принят современниками', isFavorite: false),
  BookItem(code: 185674, title: "Цветы для Элджернона", author: "Дэниел Киз", price: 650, img: '4.jpg', description: 'Итоговое произведение литературы американского романтизма. Длинный роман с многочисленными лирическими отступлениями, проникнутый библейской образностью и многослойным символизмом, не был понят и принят современниками', isFavorite: false),
  BookItem(code: 194178, title: "Тень ветра", author: "Карлос Руис Сафон", price: 800, img: '2.jpg', description: 'Итоговое произведение литературы американского романтизма. Длинный роман с многочисленными лирическими отступлениями, проникнутый библейской образностью и многослойным символизмом, не был понят и принят современниками', isFavorite: false)
];

 */
