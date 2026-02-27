import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ManagerDashboardScreen extends StatefulWidget {
  const ManagerDashboardScreen({super.key});

  @override
  State<ManagerDashboardScreen> createState() => _ManagerDashboardScreenState();
}

class _ManagerDashboardScreenState extends State<ManagerDashboardScreen> {
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/loginuser');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Manager"),
        backgroundColor: const Color.fromARGB(255, 96, 94, 221),
        actions: [
          IconButton(onPressed: () => logout(), icon: Icon(Icons.logout)),
        ],
      ),
      body: Center(
        child: Text("Welcome Manager", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
