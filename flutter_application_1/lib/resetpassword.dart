import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class forgotpasswordscreen extends StatefulWidget {
  const forgotpasswordscreen({super.key});

  @override
  State<forgotpasswordscreen> createState() => _forgotpasswordscreenState();
}

class _forgotpasswordscreenState extends State<forgotpasswordscreen> {
   final _auth = FirebaseAuth.instance;
 //controller
  final _emailController = TextEditingController();
//function
Future<void> _resetpassword() async{
    try {
    await _auth.sendPasswordResetEmail(email: _emailController.text.trim());

   ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text("Password resend link sent check your email to rest your password")),
  );
  Navigator.pushReplacementNamed(context, '/login');
  } on FirebaseAuthException catch(e) {
    ScaffoldMessenger.of(context,
    ).showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
    
  }
  }
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reset Password"),
        backgroundColor: Colors.amberAccent,
      ),
      body: Padding(
        
        padding: const EdgeInsets.all(8.0),
        child: Form(child: Column(
          children: [
          SizedBox(height: 20,),  
          Text("Enter your email and we will send you the password"),
          SizedBox(height: 20,),
          Center(child: Text("Login Form")),
          SizedBox(height: 20,),
           TextFormField(
             controller: _emailController,
            decoration: InputDecoration(labelText: 'Email',
            suffixIcon: Icon(Icons.email),  
            ),
            validator: (value)=> value!.isEmpty ? 'plz enter your Email' : null,
          ),
           
          SizedBox(height: 20,),
          ElevatedButton(onPressed: (){
           _resetpassword();
          }, 
          child: Text('RESET..')),
          
        ],)),
      ),
    );
  }
}