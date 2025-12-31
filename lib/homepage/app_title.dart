import 'package:flutter/material.dart';

class ShopTitle extends StatelessWidget{
  const ShopTitle({super.key});

  static const String title='CASE SHOP';

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Permanent_Marker',
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}