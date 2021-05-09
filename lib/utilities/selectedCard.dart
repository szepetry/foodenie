import 'package:flutter/material.dart';
import 'constants.dart';
class GenderCard extends StatelessWidget {
 final String gender;
 final IconData label;
 GenderCard({@required this.gender,@required this.label});
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
          gender,
          style: labelTextStyle,
        ),
      ],
    );
  }
}
