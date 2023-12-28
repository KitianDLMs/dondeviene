import 'package:flutter/material.dart';

import 'package:google_nav_bar/google_nav_bar.dart';

class ButtomNavBarEch extends StatefulWidget {
  final Function currentIndex;

  const ButtomNavBarEch({Key? key, required this.currentIndex})
      : super(key: key);

  @override
  State<ButtomNavBarEch> createState() => _ButtomNavBarEchState();
}

@override
void initState() {}

class _ButtomNavBarEchState extends State<ButtomNavBarEch> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Container(
          child: GNav(
              selectedIndex: 0,
              backgroundColor: Colors.black,
              tabBackgroundColor: Colors.yellow.shade800,
              activeColor: Colors.white,
              color: Colors.white,
              onTabChange: (int i) {
                setState(() {
                  index = i;
                  widget.currentIndex(i);
                });
              },
              gap: 10,
              padding: EdgeInsets.all(16),
              tabs: [
                GButton(
                  icon: Icons.home_outlined,
                  text: 'home',
                ),
                GButton(
                  icon: Icons.info_outline,
                  text: 'terminal',
                ),
                GButton(
                  icon: Icons.location_on_outlined,
                  text: 'mapa',
                ),
                GButton(
                  icon: Icons.map_rounded,
                  text: 'tutorial',
                ),
                GButton(
                  icon: Icons.person_outline,
                  text: 'sesión',
                ),
              ]),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
              color: Colors.black),
        ),
      ),
    );
  }
}
