import 'helpers/Constants.dart';
import 'helpers/RecipeButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    super.initState();
    _loadRecipeButtons();
  }

  Future<void> _loadRecipeButtons() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final recipesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('recipes');

    final recipeDocs = await recipesCollection.get();

    setState(() {
      recipeButtonList.clear();

      for (var doc in recipeDocs.docs) {
        recipeButtonList.add(_buildRecipeButton(doc.id, doc.data()));
        recipeButtonList.add(space10);
      }

      recipeNumCounter = recipeDocs.size + 1;
    });
  }

  Widget _buildRecipeButton(String recipeId, Map<String, dynamic> recipeData) {
    return Dismissible(
      key: Key(recipeId),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await _showDeleteConfirmationDialog(context);
      },
      onDismissed: (direction) async {
        await _deleteRecipe(recipeId);
      },
      child: RecipeButton(
        recipeNum: recipeData['recipeNum'] ?? 0,
        onPressed: () {
          navigateToEditRecipe(recipeId, recipeData['recipeName'] ?? 'Unnamed Recipe');
        },
      ),
    );
  }

  Future<void> _deleteRecipe(String recipeId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('recipes')
          .doc(recipeId)
          .delete();

      setState(() {
        recipeButtonList.removeWhere((widget) {
          if (widget is Dismissible) {
            return widget.key == Key(recipeId);
          }
          return false;
        });
      });
    } catch (e) {
      print('Error deleting recipe: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete recipe: $e')),
      );
    }
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: Text('Are you sure you want to delete this recipe?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addRecipeToFirestore(int recipeNum) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final recipesCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('recipes');

    final newDocRef = recipesCollection.doc();

    await newDocRef.set({
      'recipeNum': recipeNum,
      'recipeName': 'Recipe $recipeNum',
    });

    await _loadRecipeButtons();
  }

  Widget addNewRecipe() {
    return SizedBox(
      width: 300,
      height: 60,
      child: OutlinedButton(
        onPressed: () async {
          await _addRecipeToFirestore(recipeNumCounter);
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
      padding: const EdgeInsets.only(left: 40, right: 40),
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
          space50,
          addNewRecipe(),
          space50,
          listTitle,
          space10,
          Expanded(
            child: recipeList(),
          ),
        ],
      ),
    );
  }

  void navigateToEditRecipe(String recipeId, String recipeName) async {
    final result = await Navigator.pushNamed(
      context,
      editRecipeScreenTag,
      arguments: {
        'recipeName': recipeName,
        'recipeId': recipeId,
      },
    );

    if (result == true) {
      await _loadRecipeButtons();
    }
  }
}