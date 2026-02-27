import 'package:flutter/material.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(child:
      ListView(children: 
      [
        DrawerHeader(child: Text("App no 1")),
        ListTile(
          leading: Icon(Icons.desktop_access_disabled_outlined),
          title: Text("Add Category"),
          onTap: (){
            Navigator.pushReplacementNamed(context, '/addCategory');
          },
        ),
         ListTile(
          leading: Icon(Icons.desktop_access_disabled_outlined),
          title: Text("Add Crud"),
          onTap: (){
            Navigator.pushReplacementNamed(context, '/AddCrud');
          },
        ),
         ListTile(
          leading: Icon(Icons.desktop_access_disabled_outlined),
          title: Text("View realtime"),
          onTap: (){
            Navigator.pushReplacementNamed(context, '/ListCrud');
          },
        ),
         ListTile(
          leading: Icon(Icons.desktop_access_disabled_outlined),
          title: Text("View Firestore crud"),
          onTap: (){
            Navigator.pushReplacementNamed(context, '/listCategory');
          },
        ),
         ListTile(
          leading: Icon(Icons.desktop_access_disabled_outlined),
          title: Text("Add firestore crud"),
          onTap: (){
            Navigator.pushReplacementNamed(context, '/addCategory');
          },
        ),

      ],
      ));
  }
}