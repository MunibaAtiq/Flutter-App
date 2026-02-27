import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/AdminDrawer.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_application_1/Editcategory.dart';

class Listfetchcrud extends StatefulWidget {
  const Listfetchcrud({super.key});

  @override
  State<Listfetchcrud> createState() => _ListfetchcrudState();
}

class _ListfetchcrudState extends State<Listfetchcrud> {
  final DatabaseReference ref = FirebaseDatabase.instance.ref("categories");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Of Crud"),
        backgroundColor: Colors.amberAccent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/AddCrud");
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: AdminDrawer(),
      body: StreamBuilder(
        stream: ref.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
            final data = Map<String, dynamic>.from(
              snapshot.data!.snapshot.value as Map,
            );
            final categories = data.values.toList();
            final keys = data.keys.toList();
            return ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final cat = Map<String, dynamic>.from(categories[index]);
                final id = keys[index];
                return ListTile(
                  leading:
                      cat["ImageBase64"] != null
                          ? Image.memory(
                            base64Decode(cat["ImageBase64"]),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                          : const Icon(Icons.image),
                  title: Text(cat["name"]),
                  subtitle: Text(cat["description"]),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: Text("Delete category"),
                                  content: Text(
                                    "Are you sure you want be Delete category ?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      child: Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                          );
                          if (confirm == true) {
                            await ref.child(cat["id"]).remove();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Category Delete successfully"),
                              ),
                            );
                          }
                        },
                        icon: Icon(Icons.delete, color: Colors.red),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => EditCategoryScreen(
                                    id: id,
                                    name: cat["name"],
                                    description: cat["description"],
                                    ImageBase64: cat["ImageBase64"] ?? "",
                                  ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit, color: Colors.blue),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return Center(child: Text("No Category Found...."));
        },
      ),
    );
  }
}
