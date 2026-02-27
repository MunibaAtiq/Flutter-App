import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdmindashboardScreen extends StatefulWidget {
  const AdmindashboardScreen({super.key});

  @override
  State<AdmindashboardScreen> createState() => _AdmindashboardScreenState();
}

class _AdmindashboardScreenState extends State<AdmindashboardScreen> {
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/loginuser');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Dashboard"),
        backgroundColor: Colors.amber,
        actions: [
          IconButton(onPressed: () => logout(), icon: Icon(Icons.logout)),
        ],
      ),
      body: Center(
        child: Text("Welcome Admin", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
