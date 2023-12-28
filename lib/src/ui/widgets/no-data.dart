import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  String? text;

  NoData({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [Image.asset('assets/no_items.png'), Text(text!)],
      ),
    );
  }
}
