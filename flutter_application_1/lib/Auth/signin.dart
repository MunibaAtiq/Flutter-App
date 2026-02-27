import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> loginUser() async {
    setState(() => isLoading = true);
    try {
      final usersCred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      // fetch user data + role from firestore
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(usersCred.user!.uid)
              .get();

      //checkk roles
      if (doc.exists) {
        final role = doc['role'];
        if (role == 'admin') {
          Navigator.pushReplacementNamed(context, '/AdminDash');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Admin Loggedin Successfully..")),
          );
        } else if (role == 'manager') {
          Navigator.pushReplacementNamed(context, '/ManagerDash');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Manager Loggedin Successfully..")),
          );
        } else {
          Navigator.pushReplacementNamed(context, '/UserDash');
          SnackBar(content: Text("User Loggedin Successfully.."));
        }
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login Failed : $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SignIn"), backgroundColor: Colors.amber),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // mainAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome Back..",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: "EMail",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: loginUser,
                child: Text("Signin"),
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/registeruser');
              },
              child: Text("Don't have an account? signup"),
            ),
          ],
        ),
      ),
    );
  }
}
