import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_application_1/drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Frontscreen extends StatefulWidget {
  const Frontscreen({super.key});

  @override
  State<Frontscreen> createState() => _FrontscreenState();
}

class _FrontscreenState extends State<Frontscreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final List<String> imageList = [
    'assets/img1.jpg',
    'assets/img.jpg',
    'assets/img3.jpg',
  ];
  //function Add to cart
  Future<void> addToCart(Map<String, dynamic> product, String productId) async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please Login First to add items to cart.")),
        );
        Navigator.pushReplacementNamed(context, '/loginuser');
        return;
      }

      final cartRef = _firestore
          .collection('Carts')
          .doc(user.uid)
          .collection('Items')
          .doc(productId);

      final existing = await cartRef.get();
      if (existing.exists) {
        //increment quantity if product already exists
        await cartRef.update({'qunatity': FieldValue.increment(1)});
      } else {
        //Add new Item
        await cartRef.set({
          'productId': productId,
          'name': product['name'],
          'price': product['price'],
          'image': product['image'],
          'category': product['Category'],
          'qunatity': 1,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Added to cart sucessfully.!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error adding to cart: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Screen size and responsive helpers
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isTablet = screenWidth >= 600 && screenWidth < 1024;
    final bool isDesktop = screenWidth >= 1024;

    return Scaffold(
      appBar: AppBar(
        title: const Text("APP1"),
        backgroundColor: Colors.amber,
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream:
                _auth.currentUser != null
                    ? _firestore
                        .collection('Carts')
                        .doc(_auth.currentUser!.uid)
                        .collection('Items')
                        .snapshots()
                    : Stream.empty(),
            builder: (context, snapshot) {
              int itemCount = snapshot.hasData ? snapshot.data!.docs.length : 0;
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart, color: Colors.white),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/cartScreen');
                    },
                  ),

                  if (itemCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          itemCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/loginuser');
            },
          ),
        ],
      ),
      drawer: navbarscreen(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🖼 Carousel Section
            CarouselSlider(
              items:
                  imageList.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(item, fit: BoxFit.cover),
                        );
                      },
                    );
                  }).toList(),
              options: CarouselOptions(
                height:
                    isDesktop
                        ? 350
                        : isTablet
                        ? 280
                        : 220,
                viewportFraction: 1.0,
                enlargeCenterPage: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
              ),
            ),

            const SizedBox(height: 20),

            // 🏷 Welcome Text
            Text(
              "Welcome to My Flutter App",
              style: TextStyle(
                fontSize:
                    isDesktop
                        ? 28
                        : isTablet
                        ? 24
                        : 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            // 🛍 Product Grid (Firestore)
            StreamBuilder<QuerySnapshot>(
              stream:
                  _firestore
                      .collection('Products')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading products."));
                }

                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Center(child: Text("No products found."));
                }

                // 🧱 Responsive Grid
                int crossAxisCount = 2;
                double aspectRatio = 0.75;

                if (isTablet) {
                  crossAxisCount = 3;
                  aspectRatio = 0.8;
                } else if (isDesktop) {
                  crossAxisCount = 4;
                  aspectRatio = 0.85;
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: GridView.builder(
                    itemCount: docs.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: aspectRatio,
                    ),
                    itemBuilder: (context, index) {
                      final doc = docs[index];
                      final product =
                          docs[index].data() as Map<String, dynamic>;
                      final productId = doc.id;

                      final title = product['name'] ?? 'No Title';
                      final description =
                          product['description'] ?? 'No Description';
                      final category = product['Category'] ?? 'No Category';
                      final imageBase64 = product['image'];
                      final price = product['price'] ?? 0;

                      // Decode Base64 image safely
                      late ImageProvider imageProvider;
                      try {
                        imageProvider = MemoryImage(base64Decode(imageBase64));
                      } catch (e) {
                        imageProvider = const AssetImage('assets/default.jpg');
                      }

                      return GestureDetector(
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 🖼 Product Image
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                                child: Image(
                                  image: imageProvider,
                                  height:
                                      isDesktop
                                          ? 220
                                          : isTablet
                                          ? 180
                                          : 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              // 🧾 Product Info
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: TextStyle(
                                        fontSize:
                                            isDesktop
                                                ? 18
                                                : isTablet
                                                ? 16
                                                : 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      description,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize:
                                            isDesktop
                                                ? 14
                                                : isTablet
                                                ? 13
                                                : 12,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Category: $category',
                                      style: TextStyle(
                                        color: Colors.blueGrey[700],
                                        fontSize: isTablet ? 13 : 12,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '\$$price',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[700],
                                        fontSize:
                                            isDesktop
                                                ? 16
                                                : isTablet
                                                ? 15
                                                : 14,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    ElevatedButton(
                                      onPressed:
                                          () => addToCart(product, productId),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        minimumSize: Size(
                                          double.infinity,
                                          isDesktop
                                              ? 42
                                              : isTablet
                                              ? 38
                                              : 36,
                                        ),
                                      ),
                                      child: const Text('Add to Cart'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
