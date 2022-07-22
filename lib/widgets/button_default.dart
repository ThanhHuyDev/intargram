import 'package:flutter/material.dart';

import '../untils/colors.dart';

class ButtonDefault extends StatelessWidget {
  const ButtonDefault({
    Key? key,
    this.press,
    this.title,
  }) : super(key: key);
  final VoidCallback? press;
  final String? title;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(13),
      splashColor: Colors.grey,
      onTap: press!,
      child: Container(
        decoration: BoxDecoration(
            gradient: kPrimaryGradientLeftToRightColor,
            border: Border.all(color: Colors.black12, width: 1),
            borderRadius: BorderRadius.circular(13)),
        width: double.infinity,
        height: 50,
        child: Center(
            child: Text(
          title!,
          style: const TextStyle(fontSize: 17, color: Colors.white),
        )),
      ),
    );
  }
}