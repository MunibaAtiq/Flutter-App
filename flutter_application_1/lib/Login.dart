import 'package:flutter/material.dart';
import 'package:flutter_application_1/drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final _auth = FirebaseAuth.instance;
  //controller
  final _emailController = TextEditingController();
  final _PasswordController = TextEditingController();
  Future<void> _login() async {
    try {
      //create user in firebase authentication
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _PasswordController.text.trim(),
      );

      String email = userCredential.user!.email ?? '';
      if (email == 'admin@gmail.com') {
        //redirect to admin dashboard
        Navigator.pushReplacementNamed(context, '/admindashboard');
      } else {
        //login succeful redirect to  home page
        Navigator.pushReplacementNamed(context, '/home');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Welcome:  ${userCredential.user!.email}")),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(" Wellcome: ${userCredential.user!.email}")),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "login failed..")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.brown, title: Text("Login ")),
      drawer: navbarscreen(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            children: [
              SizedBox(height: 20),
              Center(child: Text("Login Form")),
              SizedBox(height: 20),
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
                  _login();
                },
                child: Text('Login..'),
              ),
              // OutlinedButton(onPressed: (){}, child: Text('Register..')),
              // TextButton(onPressed: (){}, child: Text('Register..')),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/resetpassword');
                },
                child: Text('RESET PASSWORD.'),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/signUp');
                },
                child: Text('Dont have an Account Register Now..'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
