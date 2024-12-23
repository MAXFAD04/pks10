import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_first_app/models/books.model.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final booksStore = Provider.of<BooksStore>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
      ),
      body: booksStore.cart.isEmpty
          ? const Center(child: Text('Корзина пуста'))
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: booksStore.cart.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      return ListTile(
                          leading: Image.asset(
                            'assets/img/${booksStore.cart[index].book.img}',
                            width: 50,
                            height: 70,
                            fit: BoxFit.scaleDown,
                          ),
                          title: Text(booksStore.cart[index].book.title),
                          subtitle: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(booksStore.cart[index].book.author,
                                  style: theme.textTheme.bodyMedium,
                                  textAlign: TextAlign.left),
                              Row(children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle,
                                      color: Colors.white70),
                                  onPressed: () {
                                    booksStore
                                        .delFromCart(booksStore.cart[index].code);
                                  },
                                ),
                                FittedBox(
                                    child: Text(
                                        booksStore.cart[index].count.toString(),
                                        style: TextStyle(
                                            fontSize: 24, color: Colors.white70),
                                        textAlign: TextAlign.center)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline,
                                      color: Colors.white),
                                  onPressed: () {
                                    booksStore
                                        .addToCart(booksStore.cart[index].book);
                                  },
                                ),
                              ])
                            ]
                          )),
                          trailing: Text(
                              '${(booksStore.cart[index].price * booksStore.cart[index].count).toString()} р.',
                              style: theme.textTheme.labelLarge));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Общая стоимость: ${/*cartTotal*/ booksStore.cartTotal} р.',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
    );
  }
}
