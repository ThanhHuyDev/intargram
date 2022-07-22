import 'package:flutter/material.dart';

import '../untils/untils.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       backgroundColor: mobileBackgroundColor,
        title: const Text('Bài đã thả tim'),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}