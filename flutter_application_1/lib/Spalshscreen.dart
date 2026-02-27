import 'dart:async';

import 'package:flutter/material.dart';

class splashscreentimer extends StatefulWidget {
  const splashscreentimer({super.key});

  @override
  State<splashscreentimer> createState() => _splashscreentimerState();
}

class _splashscreentimerState extends State<splashscreentimer> {
  //logic(On page load) here
  @override
  void initState(){
    super.initState();
    //3 seconds duration 
    Timer(Duration(seconds: 1), (){
      Navigator.pushReplacementNamed(context,'/Tabview'); //load k bad kha redirect krna hai vo yha pass kryngy 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  body: Center(child: Text("Wellcome Flutter Application")),
       body: Center(child: Image.asset('assets/images/img-logo.jpg'
       ,width: 150,
        height: 150,
        ),
        ),
        );

    
  }
}