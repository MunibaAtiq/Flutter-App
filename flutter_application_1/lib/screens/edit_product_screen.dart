import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class EditProductScreen extends StatefulWidget {
  final String productId;
  final Map<String, dynamic> productData;

  const EditProductScreen({
    super.key,
    required this.productId,
    required this.productData,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;

  final List<String> _categories = [
    "Electronics",
    "Clothing",
    "Shoes",
    "Books",
    "Other",
  ];
  String? _selectedCategory;

  String? _base64Image;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.productData['name']);
    _priceController = TextEditingController(text: widget.productData['price']);
    _descriptionController = TextEditingController(
      text: widget.productData['description'],
    );
    _selectedCategory = widget.productData['Category'];
    _base64Image = widget.productData['image'];
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _base64Image = base64Encode(bytes);
      });
    }
  }

  Future<void> _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseFirestore.instance
          .collection("Products")
          .doc(widget.productId)
          .update({
            "name": _nameController.text.trim(),
            "price": _priceController.text.trim(),
            "description": _descriptionController.text.trim(),
            "Category": _selectedCategory,
            "image": _base64Image,
          });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Product Updated Successfully")));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? imgBytes;
    if (_base64Image != null) {
      try {
        imgBytes = base64Decode(_base64Image!);
      } catch (_) {}
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Product Name"),
                validator: (v) => v!.isEmpty ? "Enter name" : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Enter price" : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Description"),
                maxLines: 2,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Select Category"),
                value: _selectedCategory,
                items:
                    _categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v),
                validator: (v) => v == null ? "Please select a category" : null,
              ),
              SizedBox(height: 16),
              imgBytes != null
                  ? Image.memory(imgBytes, height: 100, width: 100)
                  : Text("No image selected"),
              ElevatedButton(onPressed: _pickImage, child: Text("Pick Image")),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateProduct,
                child: Text("Update Product"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
