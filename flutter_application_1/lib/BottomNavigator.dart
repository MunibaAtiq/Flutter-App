// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class BottomNavigationScreen extends StatefulWidget {
//   const BottomNavigationScreen({super.key});

//   @override
//   State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
// }

// class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
//   int _selectedIndex = 0;
//   final _auth = FirebaseAuth.instance;

//   //list of screen
//   final List<Widget> _pages = [
//     const Center(child: Text("Home screen", style: TextStyle(fontSize: 25))),
//     const Center(child: Text("search screen", style: TextStyle(fontSize: 25))),
//     const Center(child: Text("Profile screen", style: TextStyle(fontSize: 25))),
//     const Center(child: Text("setting screen", style: TextStyle(fontSize: 25))),
//   ];
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   Future<void> logout() async {
//     await FirebaseAuth.instance.signOut();
//     //after logout redirect to login page
//     Navigator.pushReplacementNamed(context, '/login');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bottom navigation bar'),
//         backgroundColor: const Color.fromARGB(255, 83, 188, 192),
//         actions: [
//           IconButton(
//             onPressed: () async {
//               await FirebaseAuth.instance.signOut();
//               //after logout redirect to login page
//               Navigator.pushReplacementNamed(context, '/login');
//             },
//             icon: Icon(Icons.logout),
//           ),
//         ],
//       ),
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped, //when user tab
//         //styling icons pr
//         backgroundColor: const Color.fromARGB(255, 171, 217, 143),
//         unselectedItemColor: Colors.black,
//         selectedItemColor: const Color.fromARGB(255, 28, 113, 2),
//         items: [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.file_copy),
//             label: "Profile",
//           ),
//           BottomNavigationBarItem(icon: Icon(Icons.settings), label: "LogOut"),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_application_1/FrontScreen.dart';
import 'package:flutter_application_1/screens/add_category_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int currentIndex = 0;

  final List<Widget> screens = const [Frontscreen(), AddCategoryScreen()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: screens[currentIndex],
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(12),
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [Color(0xFF6A5AE0), Color(0xFF8F72F2)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.deepPurple.withOpacity(0.4),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          currentIndex: currentIndex,
          selectedItemColor: Colors.white,
          unselectedItemColor: const Color.fromARGB(179, 51, 177, 1),
          showUnselectedLabels: false,
          selectedFontSize: 13,
          onTap: (index) {
            setState(() => currentIndex = index);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, color: Colors.red),
              label: "Home",
              backgroundColor: Colors.amberAccent,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "Categories",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: "Products"),
          ],
        ),
      ),
    );
  }
}
