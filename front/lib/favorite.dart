import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_first_app/models/books.model.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bookStore = Provider.of<BooksStore>(context);
    final favorites = bookStore.favorites();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
      ),
      body: ListView.separated(
        itemCount: favorites.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.asset(
              'assets/img/${favorites[index].img}',
              width: 50,
              height: 50,
            ),
            title: Text(favorites[index].title),
            subtitle: Text(favorites[index].author),
            trailing: Text('${favorites[index].price} р.'),
            onTap: () {
              int i = bookStore.list
                  .indexWhere((item) => item.code == favorites[index].code);
              if (i > -1) {
                Navigator.of(context).pushNamed('/info', arguments: i);
              }
            },
          );
        },
      ),
    );
  }
}
