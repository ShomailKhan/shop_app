import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helper_Widgets/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<CartProvider>(context).cart;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'your shopping cart',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                var cartItem = cart[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    tileColor: const Color.fromARGB(255, 170, 225, 248),
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage(
                        cartItem['image_url'] as String,
                      ),
                    ),
                    title: Text(
                      cartItem['title'] as String,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    subtitle: Text(
                      '\$${cartItem['price'].toString()}',
                      style: TextStyle(color: Colors.grey),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                'Delete Item',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              content: Text(
                                'are you sure to delete the selected item?',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'no',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Provider.of<CartProvider>(
                                      context, listen: false
                                    ).removeProduct(cartItem);
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'yes',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
