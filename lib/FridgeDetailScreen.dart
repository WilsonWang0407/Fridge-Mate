import 'package:flutter/material.dart';
import 'helpers/Constants.dart';

class FridgeDetailScreen extends StatelessWidget {
  const FridgeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final topBar = Stack(
      children: <Widget>[
        Positioned(
          left: 0,
          top: 5,
          child: TextButton(
            onPressed: null,
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
              'Fridge Name',
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

    final addNewFoodButton = SizedBox(
      width: 300,
      height: 60,
      child: OutlinedButton(
        onPressed: null,
        style: OutlinedButton.styleFrom(
          backgroundColor: cambridgeBlue,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32)),
          ),
          side: BorderSide(
            width: 2.5,
            color: Colors.black,
          ),
        ),
        child: Text(
          '+  Add New Food',
          style: bigButtonTextStyle,
        ),
      ),
    );

    final listTitle = Padding(
      padding: const EdgeInsets.only(right: 150),
      child: Text(
        'List of Food',
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
          addNewFoodButton,
          space80,
          listTitle,
        ]
      )
    );
  }
}