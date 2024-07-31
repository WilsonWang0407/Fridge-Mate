import 'helpers/Constants.dart';
import 'helpers/FridgeButton.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

@override
  _HomeScreenState createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {

  List<Widget> fridgeButtonList = [];
  int fridgeNumCounter = 1;

  @override
  void initState() {
    fridgeButtonList = [fridgeList()];
    super.initState();
  }

  Widget addNewFridge() {
    return SizedBox(
      width: 300,
      height: 60,
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            fridgeButtonList.add(FridgeButton(fridgeNum: fridgeNumCounter));
            fridgeButtonList.add(space10);
            fridgeNumCounter++;
          });
        },
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
          '+  Add New Fridge',
          style: bigButtonTextStyle,
        ),
      ),
    );
  }

  Widget fridgeList() {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.only(left:40, right: 40),
      children: <Widget>[
        ...fridgeButtonList,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    final topBar = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        TextButton(
          onPressed: () {
              Navigator.of(context).pushNamed(recipesScreenTag);
          },
          child: Text(
            'Recipes',
            style: bigButtonTextStyle,
          ),
        ),
        Text(
          '|',
          style: bigButtonTextStyle,
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(myRecipesScreenTag);
          },
          child: Text(
            'My Recipes',
            style: bigButtonTextStyle,
          ),
        ),
        Text(
          '|',
          style: bigButtonTextStyle,
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pushNamed(profileScreenTag);
          },
          child: Text(
            'Profile',
            style: bigButtonTextStyle,
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
        'List of Fridges',
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
          addNewFridge(),
          space80,
          listTitle,
          space10,
          Expanded(
            child: fridgeList(),
          ),
        ],
      ),
    );
  }
}