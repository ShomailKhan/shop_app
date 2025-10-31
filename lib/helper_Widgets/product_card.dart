import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final double price;
  final String imageUrl;
  final Color backgroundColor;
  const ProductCard({super.key, required this.title, required this.price, required this.imageUrl, required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,style:  Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 10),
            Text('\$$price' ,style:  Theme.of(context).textTheme.titleSmall),
            SizedBox(height: 10),
            Center(child: Image.network(imageUrl, height: 250)),
          ],
        ),
      ),
    );
  }
}