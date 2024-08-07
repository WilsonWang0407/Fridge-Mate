import 'Constants.dart';
import 'package:flutter/material.dart';

class RecipeButton extends StatelessWidget {

  int recipeNum;
  RecipeButton({required this.recipeNum});

  @override
  Widget build(BuildContext context) {

    final recipeName = Text(
      'Recipe $recipeNum',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );

    final byUserNameRow = Text(
      'by User Name',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black54,
      ),
    );

    final ingredientsRow = Text(
      'Ingredients:',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );

    return SizedBox(
      width: 300,
      height: 95,
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
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              space5,
              recipeName,
              byUserNameRow,
              ingredientsRow
            ],
          ),
        ),
      ),
    );
  }
}