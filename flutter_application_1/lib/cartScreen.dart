import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ Update Quantity
  Future<void> updateQuantity(String productId, int change) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final itemRef = _firestore
        .collection('Carts')
        .doc(user.uid)
        .collection('Items')
        .doc(productId);

    final snapshot = await itemRef.get();
    if (!snapshot.exists) return;

    int currentQty = snapshot['qunatity'];
    int newQty = currentQty + change;

    if (newQty <= 0) {
      await itemRef.delete();
    } else {
      await itemRef.update({'qunatity': newQty});
    }
  }

  // ✅ Remove Item
  Future<void> removeItem(String productId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore
        .collection('Carts')
        .doc(user.uid)
        .collection('Items')
        .doc(productId)
        .delete();
  }

  // ✅ Calculate total price
  double calculateTotal(QuerySnapshot snapshot) {
    double total = 0.0;
    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      total += (data['price'] ?? 0) * (data['qunatity'] ?? 1);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Your Cart")),
        body: Center(child: Text("Please login to view your cart.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart"),
        backgroundColor: Colors.amber,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('Carts')
            .doc(user.uid)
            .collection('Items')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Your cart is empty."));
          }

          final docs = snapshot.data!.docs;
          double totalPrice = calculateTotal(snapshot.data!);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    final productId = docs[index].id;
                    final imageBase64 = data['image'];
                    final name = data['name'] ?? 'No Name';
                    final price = data['price'] ?? 0.0;
                    final quantity = data['qunatity'] ?? 1;

                    // Decode image safely
                    late ImageProvider imageProvider;
                    try {
                      imageProvider = MemoryImage(base64Decode(imageBase64));
                    } catch (e) {
                      imageProvider = const AssetImage('assets/default.jpg');
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image(
                            image: imageProvider,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("\$$price x $quantity"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove_circle_outline),
                              onPressed: () => updateQuantity(productId, -1),
                            ),
                            Text(
                              '$quantity',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: Icon(Icons.add_circle_outline),
                              onPressed: () => updateQuantity(productId, 1),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => removeItem(productId),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ✅ Total and Checkout
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total: \$${totalPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text("Checkout functionality coming soon!"),
                          ),
                        );
                      },
                      child: const Text("Checkout"),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
