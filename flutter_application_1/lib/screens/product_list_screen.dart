import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Admindrawer.dart';
import 'edit_product_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String _searchQuery = "";
  String _selectedCategory = "All";

  final List<String> _categories = [
    "All",
    "Electronics",
    "Clothing",
    "Shoes",
    "Books",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products List"),
        backgroundColor: Colors.amber,
      ),
      drawer: AdminDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search by name...",
              ),
              onChanged:
                  (val) => setState(() => _searchQuery = val.toLowerCase()),
            ),
          ),
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children:
                  _categories.map((cat) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: _selectedCategory == cat,
                        onSelected:
                            (_) => setState(() => _selectedCategory = cat),
                      ),
                    );
                  }).toList(),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection('Products')
                      .orderBy("createdAt", descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());

                var products =
                    snapshot.data!.docs.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final name = data['name'].toString().toLowerCase();
                      final category = data['Category'] ?? "";
                      return (name.contains(_searchQuery)) &&
                          (_selectedCategory == "All" ||
                              category == _selectedCategory);
                    }).toList();

                if (products.isEmpty)
                  return Center(child: Text("No Products Found.."));

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final doc = products[index];
                    final data = doc.data() as Map<String, dynamic>;
                    Uint8List? imgBytes;
                    if (data['image'] != null) {
                      try {
                        imgBytes = base64Decode(data['image']);
                      } catch (_) {}
                    }
                    return Card(
                      child: ListTile(
                        leading:
                            imgBytes != null
                                ? Image.memory(
                                  imgBytes,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                                : Icon(
                                  Icons.image,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                        title: Text(data['name']),
                        subtitle: Text(
                          "Price: ${data['price']} • Category: ${data['Category']}",
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) => EditProductScreen(
                                          productId: doc.id,
                                          productData: data,
                                        ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('Products')
                                    .doc(doc.id)
                                    .delete();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
