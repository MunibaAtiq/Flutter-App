import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/drawer.dart';

class tabsViewScreen extends StatelessWidget {
  const tabsViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          title: Text("Tabs View"),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.home), text: "Home"),
              Tab(icon: Icon(Icons.home), text: "Data"),
              Tab(icon: Icon(Icons.home), text: "Profile"),
            ],
          ),
        ),
        //navbar drawer screen ko add krny k liy ya lines add krni hongi
        drawer: navbarscreen(),
        body: TabBarView(
          children: [
            //tab 1 view
            Center(child: Text("Wellcome to home screen")),
            //tab 2 view list ki form mai
            ListView(
              children: [
                //list no 1
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    //simple icon esy add hoga
                    // leading: Icon(Icons.star),
                    //or image is trha add hogi
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(50), //round shape
                      child: Image.asset(
                        'assets/images/github.jpg',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text("List item no : 1"),
                    subtitle: Text("this is list no 1"),
                    trailing: Icon(Icons.edit),
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.blueGrey, width: 2),
                    ),
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
                //list no 2
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: Icon(Icons.star),
                    title: Text("List item no : 2"),
                    subtitle: Text("this is list no 2"),
                    trailing: Icon(Icons.edit),
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.blueGrey, width: 2),
                    ),
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
                //list no 3
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: Icon(Icons.star),
                    title: Text("List item no : 3"),
                    subtitle: Text("this is list no 3"),
                    trailing: Icon(Icons.edit),
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.blueGrey, width: 2),
                    ),
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
                //list no 4
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: Icon(Icons.star),
                    title: Text("List item no : 4"),
                    subtitle: Text("this is list no 4"),
                    trailing: Icon(Icons.edit),
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.blueGrey, width: 2),
                    ),
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
                //list no 5
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    leading: Icon(Icons.star),
                    title: Text("List item no : 5"),
                    subtitle: Text("this is list no 5"),
                    trailing: Icon(Icons.edit),
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.blueGrey, width: 2),
                    ),
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ],
            ),

            //tab 3 view
            Center(child: Text("Wellcome to Profile tab 3 ")),
          ],
        ),
      ),
    );
  }
}
