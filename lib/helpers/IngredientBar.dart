import 'Constants.dart';
import 'package:flutter/material.dart';

class IngredientBar extends StatelessWidget {

  int ingredientNum;
  IngredientBar({required this.ingredientNum});

  @override
  Widget build(BuildContext context) {

    final titleRow = SizedBox(
      width: 300,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: sunset,
        ),
        child: Text(
          'Ingredient $ingredientNum '.substring(0, 12),
          maxLines: 1,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
    );

    return Container(
      child: Column(
        children: <Widget>[
          titleRow,
        ]
      ),
    );
  }
}