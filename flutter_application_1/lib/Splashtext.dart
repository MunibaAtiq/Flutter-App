import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Splashtextfunction extends StatefulWidget {
  const Splashtextfunction({super.key});

  @override
  State<Splashtextfunction> createState() => _SplashtextfunctionState();
}

class _SplashtextfunctionState extends State<Splashtextfunction> {
 final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      title: Text("Flutter--Splash--screen",
      style: TextStyle(color: Colors.pink,
      fontSize: 25,
      letterSpacing: 5,
      fontWeight: FontWeight.bold
      ),
      ),
      centerTitle: true,
      backgroundColor: Colors.deepPurple,
       actions: [
    IconButton(
      onPressed: () async{
      await FirebaseAuth.instance.signOut();
      //after logout redirect to login page 
       Navigator.pushReplacementNamed(context, '/login');
    },
     icon: Icon(Icons.logout),
     ),
   ],
      ),
      body: Center(child: Container(
        height: 200,
        width: 200,
        color: Colors.blueGrey,
        child: Center( child: Text("Hello My name is sajjal")),
        ),
        ),  
        );
  }
}