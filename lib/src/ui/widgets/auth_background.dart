import 'dart:io';

import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;

  const AuthBackground({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffF2F2F2),
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [_HeaderImage(), this.child],
      ),
    );
  }
}

class _HeaderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SafeArea(
        child: Container(
            width: double.infinity,
            height: 100,
            child: Image(
              image: AssetImage('assets/dv-logo.png'),
              fit: BoxFit.contain,
            )),
      ),
      SizedBox(height: 100),
      SafeArea(
          child: Container(
              // margin: EdgeInsets.all(100),
              margin: Platform.isIOS
                  ? EdgeInsets.all(100)
                  : EdgeInsets.only(top: 100),
              width: double.infinity,
              height: 100,
              child: Image(
                image: AssetImage('assets/dv-logo-black.png'),
                fit: BoxFit.none,
              ))),
    ]);
  }
}
