import 'Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IngredientBar extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController quantityController;

  IngredientBar({
    String initialName = '',
    String initialQuantity = '',
  })  : nameController = TextEditingController(text: initialName),
        quantityController = TextEditingController(text: initialQuantity);


  @override
  Widget build(BuildContext context) {
    final titleRow = SizedBox(
      width: 310,
      height: 30,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: sunset,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: 2),
          child: Text(
            '   Ingredient',
            maxLines: 1,
            style: ingredientTextStyle,
          ),
        ),
      ),
    );

    final foodNameRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          'Name:',
          style: ingredientTextStyle,
        ),
        SizedBox(
          width: 195,
          height: 25,
          child: TextField(
            controller: nameController,
            keyboardType: TextInputType.text,
            style: centerBarInputTextStyle,
            maxLines: 1,
            inputFormatters: [LengthLimitingTextInputFormatter(175)],
            decoration: centerBarInputDecoration,
          ),
        )
      ],
    );

    final quantityRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          'Quantity:',
          style: ingredientTextStyle,
        ),
        SizedBox(
          width: 170,
          height: 25,
          child: TextField(
            controller: quantityController,
            keyboardType: TextInputType.text,
            style: centerBarInputTextStyle,
            maxLines: 1,
            inputFormatters: [LengthLimitingTextInputFormatter(24)],
            decoration: centerBarInputDecoration,
          ),
        )
      ],
    );

    return Container(
      width: 300,
      height: 120,
      decoration: BoxDecoration(
        color: burstSienna,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: <Widget>[
          titleRow,
          SizedBox(height: 15),
          foodNameRow,
          SizedBox(height: 10),
          quantityRow,
        ],
      ),
    );
  }
}
