import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helper_Widgets/cart_provider.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({super.key, required this.product});
  final Map<String, dynamic> product;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  get product => null;
  int selectedSize = 0;

  List<int> _sizesFrom(dynamic raw) {
    if (raw == null) return <int>[];
    if (raw is List<int>) return raw;
    if (raw is List) {
      return raw.map((e) {
        if (e is int) return e;
        if (e is num) return e.toInt();
        return int.tryParse(e.toString()) ?? 0;
      }).toList();
    }
    return <int>[];
  }

  void onTap() {
    if (selectedSize == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('please select the size first !!')),
      );
    } else {
      Provider.of<CartProvider>(context, listen: false).addProduct({
        'id': widget.product['id'],
        'title': widget.product['title'],
        'price': widget.product['price'],
        'image_url': widget.product['image_url'],
        'company': widget.product['company'],
        'sizes': widget.product['sizes'],
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('item added successfully !!')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Shoe Details',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              widget.product['title'],
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Spacer(flex: 1),
            Image(image: AssetImage(widget.product['image_url']), height: 250),
            Spacer(flex: 2),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromARGB(255, 198, 224, 236),
              ),
              height: 200,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    '\$${widget.product['price']}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _sizesFrom(widget.product['sizes']).length,
                      itemBuilder: (context, index) {
                        var size = _sizesFrom(widget.product['sizes'])[index];
                        return Padding(
                          padding: const EdgeInsets.all(5),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedSize = size;
                              });
                            },
                            child: Chip(
                              backgroundColor: selectedSize == size
                                  ? Color.fromRGBO(249, 231, 39, 1)
                                  : Color.fromRGBO(245, 247, 249, 1),
                              label: Text(size.toString()),
                              labelStyle: Theme.of(
                                context,
                              ).textTheme.titleSmall,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      onTap();
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(300, 50),
                      iconColor: Colors.grey,
                      backgroundColor: Color.fromRGBO(249, 231, 39, 1),
                      iconSize: 25,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.shopping_bag),
                        Text(
                          'add to shopping cart',
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
