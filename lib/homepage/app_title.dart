import 'package:flutter/material.dart';

class ShopTitle extends StatelessWidget{
  const ShopTitle({super.key});

  static const String title='Case Shop';

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}