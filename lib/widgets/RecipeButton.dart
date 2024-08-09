import 'package:fridge_mate/helpers/Constants.dart';
import 'package:flutter/material.dart';

class RecipeButton extends StatelessWidget {
  final String imageUrl;
  final int recipeNum;
  final String recipeName;
  final String userName;
  final String ingredients;
  final VoidCallback onPressed;

  RecipeButton({
    required this.imageUrl,
    required this.recipeNum,
    required this.recipeName,
    required this.userName,
    required this.ingredients,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Image.network(
              imageUrl,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(width: 5),
          Container(
            width: 225,
            height: 120,
            decoration: BoxDecoration(
              color: sunset,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipeName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      decorationThickness: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'by $userName',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  space10,
                  Text(
                    'Ingredients:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    ingredients,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
