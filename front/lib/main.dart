import 'package:flutter/material.dart';
import 'package:my_first_app/theme.dart';
import 'package:provider/provider.dart';
import 'package:my_first_app/booklist.dart';
import 'package:my_first_app/models/books.model.dart'; 
import 'package:my_first_app/bookinfo.dart';
import 'package:my_first_app/favorite.dart'; 
import 'package:my_first_app/cart.dart';
import 'package:my_first_app/profile.dart'; 


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BooksStore(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Книжный магазин',
        theme: DarkTheme,
        routes: {
          '/': (context) => BooksList(title: 'Книжный магазин'),
          '/info': (context) => BookInfo(title: 'Информация о книге'),
          '/favorites': (context) => const FavoritesPage(), 
          '/cart': (context) => const CartPage(),
          '/profile': (context) => ProfilePage(),
        },
      )
    );
  }
}
