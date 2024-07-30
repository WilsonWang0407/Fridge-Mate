import 'package:flutter/widgets.dart';

import 'helpers/IngredientBar.dart';
import 'helpers/Constants.dart';
import 'package:flutter/material.dart';

class EditRecipeScreen extends StatefulWidget {
  const EditRecipeScreen({super.key});

  @override
  _EditRecipeScreenState createState() {
    return _EditRecipeScreenState();
  }
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {

  List<Widget> ingredientBarList = [];
  int ingredientNumCounter = 1;

  void initState() {
    ingredientBarList = [
      ingredientList(),
      addNewIngredient(), 
    ];
    super.initState();
  }

  Widget addNewIngredient() {
    return SizedBox(
      height: 35,
      child: OutlinedButton(
        onPressed: () {
          setState(() {
             ingredientBarList.insert(ingredientBarList.length - 2, IngredientBar(ingredientNum: ingredientNumCounter));
            ingredientBarList.insert(ingredientBarList.length - 2, space10);
            ingredientNumCounter++;
          });
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: cambridgeBlue,
          shape: CircleBorder(),
          side: BorderSide(
            width: 2.5,
            color: Colors.black,
          ),
        ),
        child:Align(
          alignment: Alignment.center,
          child: Text(
          '+',
          style: listTitleTextStyle,
        ),
        ),
      ),
    );
  }

  Widget ingredientList() {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.only(left:40, right: 40),
      children: <Widget>[
        ...ingredientBarList,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

     final topBar = Stack(
      children: <Widget>[
        Positioned(
          left: 0,
          top: 5,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(myRecipesScreenTag);
            },
            child: Text(
              '<Back',
              style: backButtonTextStyle,
            ),
          ),
        ),
        Center(
          child: TextButton(
            onPressed: null,
            child: Text(
              'Recipe Name',
              style: bigButtonTextStyle,
            ),
          ),
        ),
      ],
    );

    final underline = Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 2.5, color: Colors.black),
        ),
      ),
    );

    final takePictureButton = SizedBox(
      width: 250,
      height: 60,
      child: OutlinedButton(
        onPressed: null,
        style: OutlinedButton.styleFrom(
          backgroundColor: delftBlue,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
        child: Text(
          'Take Picture',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );

    final ingredientTitle = Padding(
      padding: const EdgeInsets.only(right: 150),
      child: Text(
        'Ingredients',
        style: listTitleTextStyle,
      ),
    );

    final descriptionTitle = Padding(
      padding: const EdgeInsets.only(right: 150),
      child: Text(
        'Description',
        style: listTitleTextStyle,
      ),
    );

    final descriptionField =  Container(
      width: 300,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 2,
          color: Colors.black,
        ),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: TextField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        style: centerBarInputTextStyle,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );

    final saveButton = SizedBox(
      width: 100,
      height: 40,
      child: OutlinedButton(
        onPressed: null,
        style: OutlinedButton.styleFrom(
          backgroundColor: delftBlue,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(1)),
          ),
        ),
        child: Text(
          'Save',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: eggShell,
      body: Column(
        children: <Widget>[
          space80,
          topBar,
          underline,
          space50,
          takePictureButton,
          space50,
          ingredientTitle,
          space5,
          SizedBox(
            height: 220,
            child: ingredientList(),
          ),
          space30,
          descriptionTitle,
          space5,
          descriptionField,
          space30,
          saveButton,
        ]
      )
    );
  }
}