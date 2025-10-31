import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/product_details_page.dart';
import 'product_card.dart';

class HomepageBody extends StatefulWidget {
  const HomepageBody({super.key});

  @override
  State<HomepageBody> createState() => _HomepageBodyState();
}

class _HomepageBodyState extends State<HomepageBody> {
  var border = OutlineInputBorder(
    borderRadius: BorderRadius.horizontal(left: Radius.circular(50)),
    borderSide: BorderSide(color: Colors.grey),
  );
  List<String> filters = ['all', 'nike', 'addidas', 'puma', 'bata'];
  late String selectedFilter;
  @override
  void initState() {
    super.initState();
    selectedFilter = filters[0];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Shoes\nCollection',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'search',
                  prefixIcon: Icon(Icons.search),
                  prefixIconColor: Colors.grey,
                  enabledBorder: border,
                  focusedBorder: border,
                  hintStyle: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            itemBuilder: (context, index) {
              String filter = filters[index];
              return Padding(
                padding: const EdgeInsets.all(5),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFilter = filter;
                    });
                  },
                  child: Chip(
                    label: Text(filter),
                    backgroundColor: selectedFilter == filter
                        ? Color.fromRGBO(249, 231, 39, 1)
                        : Color.fromRGBO(245, 247, 249, 1),
                    labelStyle: Theme.of(context).textTheme.titleSmall,
                    padding: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 10),
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("products")
              .where( 
                'creatorId',
                isEqualTo: FirebaseAuth.instance.currentUser!.uid,
              )
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator.adaptive();
            }
            if (!snapshot.hasData) {
              return Text("no data found in storage");
            }
            return Expanded(
              child: size.width < 1080
                  ? ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var product = snapshot.data!.docs[index];

                        return Dismissible(
                          key: ValueKey(product.id),
                          onDismissed: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              await FirebaseFirestore.instance
                                  .collection("products")
                                  .doc(product.id)
                                  .delete();
                            }
                          },
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ProductDetailsPage(
                                      product: product.data(),
                                    );
                                  },
                                ),
                              );
                            },
                            child: ProductCard(
                              title: product.data()['title'] as String,
                              price: product.data()['price'] as double,
                              imageUrl: product.data()['image_url'] as String,
                              backgroundColor: index.isEven
                                  ? const Color.fromARGB(255, 202, 231, 244)
                                  : const Color.fromARGB(255, 152, 213, 242),
                            ),
                          ),
                        );
                      },
                    )
                  : GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1.3,
                        crossAxisCount: 2,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var product = snapshot.data!.docs[index];

                        return Dismissible(
                          key: ValueKey(product.id),
                          onDismissed: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              await FirebaseFirestore.instance
                                  .collection("products")
                                  .doc(product.id)
                                  .delete();
                            }
                          },
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return ProductDetailsPage(
                                      product: product.data(),
                                    );
                                  },
                                ),
                              );
                            },
                            child: ProductCard(
                              title: product.data()['title'] as String,
                              price: product.data()['price'] as double,
                              imageUrl: product.data()['image_url'] as String,
                              backgroundColor: index.isEven
                                  ? const Color.fromARGB(255, 202, 231, 244)
                                  : const Color.fromARGB(255, 152, 213, 242),
                            ),
                          ),
                        );
                      },
                    ),
            );
          },
        ),
      ],
    );
  }
}
