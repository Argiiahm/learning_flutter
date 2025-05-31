import 'package:flutter/material.dart';
import './home.dart';
import './signin.dart';
import './newmenu.dart';
import './profile.dart';
import './editmenu.dart';


void main(List<String> args) {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Signin(),
      routes: {
        '/signin' : (context) => Signin(),
        '/main'   : (context) => Main(),
        '/home'   : (context) => Home(),
        '/newmenu': (context) => Newmenu(),
        '/editmenu': (context) => Editmenu(),
        '/profile': (context) => Home(),
      },
    )
  );
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => MainState();
}

class MainState extends State<Main> {
  int courrentIndex = 0;

  final List<Widget> pages = [
      Home(),
      Profile()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[courrentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: courrentIndex,
        backgroundColor: Color(0xffE4EFE7),
        onTap: (index){
          setState(() {
            courrentIndex = index;
          });
        },
        selectedItemColor: Color(0xff99BC85),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}