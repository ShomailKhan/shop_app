import 'package:flutter/material.dart';
import 'package:shop_app/screens/add_product.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddProduct()));
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            fixedSize: Size(MediaQuery.of(context).size.width * 1, 60),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            'add product',
            style: Theme.of(
              context,
            ).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
