import 'package:flutter/material.dart';

class navbarscreen extends StatelessWidget {
  const navbarscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Text("App no 1")),
          ListTile(
            leading: Icon(Icons.desktop_access_disabled_outlined),
            title: Text("About"),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          ListTile(
            leading: Icon(Icons.app_registration_rounded),
            title: Text("Sign Up"),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/signUp');
            },
          ),
          ListTile(
            leading: Icon(Icons.app_registration_rounded),
            title: Text("login"),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
          ListTile(
            leading: Icon(Icons.app_registration_rounded),
            title: Text("SignupScreen"),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/registeruser');
            },
          ),
        ],
      ),
    );
  }
}
