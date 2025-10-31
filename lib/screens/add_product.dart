import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Simple screen: enter product fields and submit to Firestore
class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final idCtrl = TextEditingController();
  final titleCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final imageCtrl = TextEditingController();
  final companyCtrl = TextEditingController();
  final sizesCtrl = TextEditingController();

  @override
  void dispose() {
    idCtrl.dispose();
    titleCtrl.dispose();
    priceCtrl.dispose();
    imageCtrl.dispose();
    companyCtrl.dispose();
    sizesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // Read raw values from text fields
    final creatorId=FirebaseAuth.instance.currentUser!.uid;
    final id = idCtrl.text.trim();
    final title = titleCtrl.text.trim();
    final price = double.tryParse(priceCtrl.text.trim()) ?? 0.0;
    final imageUrl = imageCtrl.text.trim();
    final company = companyCtrl.text.trim();
    // sizes: comma or space separated numbers, e.g. "7, 8, 9"
    final sizes = sizesCtrl.text
        .split(RegExp(r'[\s,]+'))
        .where((s) => s.isNotEmpty)
        .map((s) => int.tryParse(s))
        .whereType<int>()
        .toList();

    final data = {
      'id': id,
      'title': title,
      'price': price,
      'image_url': imageUrl,
      'company': company,
      'sizes': sizes,
      'creatorId':creatorId
    };

    try {
      final docRef = await FirebaseFirestore.instance.collection('products').add(data);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added: ${docRef.id}')));
      // clear fields
      idCtrl.clear();
      titleCtrl.clear();
      priceCtrl.clear();
      imageCtrl.clear();
      companyCtrl.clear();
      sizesCtrl.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  InputDecoration _dec(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product', style: TextStyle(fontSize: 30),)),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.2),
            Expanded(
              child: ListView(
                children: [
                  TextField(controller: titleCtrl, decoration: _dec('title')),
                  const SizedBox(height: 8),
                  TextField(controller: priceCtrl, decoration: _dec('price'), keyboardType: TextInputType.number),
                  const SizedBox(height: 8),
                  TextField(controller: imageCtrl, decoration: _dec('image_url')),
                  const SizedBox(height: 8),
                  TextField(controller: companyCtrl, decoration: _dec('company')),
                  const SizedBox(height: 8),
                  TextField(controller: sizesCtrl, decoration: _dec('sizes (e.g. 7,8,9)')),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: _submit,
                   style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    fixedSize: Size(MediaQuery.of(context).size.width * 1, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    )
                   ),
                   child: const Text('Submit', style: TextStyle(color: Colors.white),)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
