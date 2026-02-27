import 'package:flutter/material.dart';
import 'package:flutter_application_1/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class registerScreen extends StatefulWidget {
  const registerScreen({super.key});

  @override
  State<registerScreen> createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  bool _obscurePassword = true;
  final _auth = FirebaseAuth.instance;
  //controller
  final _emailController = TextEditingController();
  final _PasswordController = TextEditingController();

  //register user k liy functon
  Future<void> register() async {
    try {
      //create user in firebase authentication
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _PasswordController.text.trim(),
          );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Register succesful..")));
      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "register failed..")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text("create an Account"),
      ),
      drawer: navbarscreen(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            children: [
              SizedBox(height: 20),
              Center(child: Text("Register Form")),
              SizedBox(height: 20),
              //  TextFormField(
              //   decoration: InputDecoration(labelText: 'Full Name',
              //   suffixIcon: Icon(Icons.verified_user),
              //   ),
              //   validator: (value)=> value!.isEmpty ? 'plz enter your full name' : null,
              // ),
              // SizedBox(height: 20,),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  suffixIcon: Icon(Icons.email),
                ),
                validator:
                    (value) => value!.isEmpty ? 'plz enter your Email' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _PasswordController,
                obscureText: _obscurePassword,
                obscuringCharacter: '*',
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
                validator:
                    (value) =>
                        value!.isEmpty
                            ? 'plz enter your correct Password'
                            : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  register(); //call funtion
                },
                child: Text('Register..'),
              ),
              // OutlinedButton(onPressed: (){}, child: Text('Register..')),
              // TextButton(onPressed: (){}, child: Text('Register..')),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: Text('Already have an Account Login Now..'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
