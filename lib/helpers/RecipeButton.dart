import 'Constants.dart';
import 'package:flutter/material.dart';

class RecipeButton extends StatelessWidget {

  int recipeNum;
  RecipeButton({required this.recipeNum});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: 300,
      height: 40,
      child: OutlinedButton(
        onPressed: null,
        style: OutlinedButton.styleFrom(
          backgroundColor: sunset,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32)),
          ),
          side: BorderSide(
            width: 2.5,
            color: Colors.black,
          )
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 180),
          child: Text(
            'Recipe $recipeNum '.substring(0, 9),
            maxLines: 1,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}