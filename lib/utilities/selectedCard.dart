import 'package:flutter/material.dart';
import 'constants.dart';
class ItemCard extends StatelessWidget {
 final String item;
 final IconData label;
 ItemCard({@required this.item,@required this.label});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(
        label,
          size: 50.0,
        ),
        SizedBox(
          height: 15.0,
        ),
        Text(
          item,
          style: labelTextStyle,
        ),
      ],
    );
  }
}
