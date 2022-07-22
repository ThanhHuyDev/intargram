import 'package:flutter/material.dart';

class Line extends StatelessWidget {
  const Line({Key? key, required this.height}) : super(key: key);
  final double height;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      color: Theme.of(context).bottomAppBarColor,
    );
  }
}