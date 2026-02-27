import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/AdminDrawer.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:firebase_database/firebase_database.dart';

class CrudScreen extends StatefulWidget {
  const CrudScreen({super.key});

  @override
  State<CrudScreen> createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  //controller add
  final _nameController = TextEditingController();
  final _desController = TextEditingController();
  String? _base64Image;

  //upload img work
  Future<void> _pickimg() async {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement();
    uploadInput.accept =
        "image/*"; //jitny bhi formate hongy usko accept kr legaa (jpj,png) etc
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files?.first;
      if (file != null) {
        final reader = html.FileReader();
        reader.readAsDataUrl(file);
        reader.onLoadEnd.listen((event) {
          setState(() {
            _base64Image = reader.result.toString().split(',').last;
          });
        });
      }
    });
  }

  //insert data work
  Future<void> _insertData() async {
    //validation
    if (_nameController.text.isEmpty || _base64Image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("plz enter name and select image")),
      );
      return;
    }
    //insert data work
    final ref = FirebaseDatabase.instance.ref("categories").push();
    await ref.set({
      "id": ref.key,
      "name": _nameController.text,
      "description": _desController.text,
      "ImageBase64": _base64Image,
    });
    Navigator.pushReplacementNamed(context, "/ListCrud");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ADD NEW CRUD"),
        backgroundColor: Colors.amberAccent,
      ),
      drawer: AdminDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Text("Add new Crud"),
            SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              style: TextStyle(color: Colors.amber),
              decoration: InputDecoration(
                labelText: 'Category Name',
                labelStyle: TextStyle(
                  color: const Color.fromRGBO(195, 114, 114, 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _desController,
              style: TextStyle(color: Colors.amber),
              decoration: InputDecoration(
                labelText: 'Category Description',
                labelStyle: TextStyle(
                  color: const Color.fromRGBO(195, 114, 114, 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                ),
              ),
            ),
            SizedBox(height: 20),
            OutlinedButton.icon(
              icon: Icon(Icons.image),
              onPressed: () {
                _pickimg();
              },
              label: Text('Upload img'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _insertData();
              },
              child: Text("Add Category"),
            ),
          ],
        ),
      ),
    );
  }
}
