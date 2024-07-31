import 'helpers/Constants.dart';
import 'helpers/RecipeButton.dart';
import 'package:flutter/material.dart';

class MyRecipesScreen extends StatefulWidget {
  const MyRecipesScreen({super.key});

@override
  _MyRecipesScreenState createState() {
    return _MyRecipesScreenState();
  }
}

class _MyRecipesScreenState extends State<MyRecipesScreen> {

  List<Widget> recipeButtonList = [];
  int recipeNumCounter = 1;

  @override
  void initState() {
    recipeButtonList = [recipeList()];
    super.initState();
  }

  Widget addNewRecipe() {
    return SizedBox(
      width: 300,
      height: 60,
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            recipeButtonList.add(RecipeButton(recipeNum: recipeNumCounter));
            recipeButtonList.add(space10);
            recipeNumCounter++;
          });
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: burstSienna,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32)),
          ),
          side: BorderSide(
            width: 2.5,
            color: Colors.black,
          ),
        ),
        child: Text(
          '+  Add New Recipe',
          style: bigButtonTextStyle,
        ),
      ),
    );
  }

  Widget recipeList() {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.only(left:40, right: 40),
      children: <Widget>[
        ...recipeButtonList,
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
              Navigator.of(context).pushNamed(homeScreenTag);
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
              'My Recipes',
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

    final listTitle = Padding(
      padding: const EdgeInsets.only(right: 150),
      child: Text(
        'List of Recipes',
        style: listTitleTextStyle,
      ),
    );

    return Scaffold(
      backgroundColor: eggShell,
      body: Column(
        children: <Widget>[
          space80,
          topBar,
          underline,
          space80,
          addNewRecipe(),
          space80,
          listTitle,
          space10,
          Expanded(
            child: recipeList(),
          ),
        ],
      ),
    );
  }
}