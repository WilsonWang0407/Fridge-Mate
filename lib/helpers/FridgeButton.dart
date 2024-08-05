import 'Constants.dart';
import 'package:flutter/material.dart';

class FridgeButton extends StatelessWidget {
  final int fridgeNum;
  final String userName;
  final String fridgeId;

  FridgeButton({
    required this.fridgeNum,
    required this.userName,
    required this.fridgeId,
  });

  @override
  Widget build(BuildContext context) {

    final fridgeNameRow = Text(
      'Fridge $fridgeNum',
      maxLines: 1,
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );

    final usersRow = Text(
      'Users: $userName',
      maxLines: 1,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: delftBlue,
      ),
    );

    final itemRows = Text(
      'Items:',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );

    return SizedBox(
      width: 300,
      height: 500,
      child: OutlinedButton(
       onPressed: () {
          Navigator.pushNamed(
            context,
            fridgeDetailScreenTag,
            arguments: {
              'fridgeName': 'Fridge $fridgeNum',
              'fridgeId': fridgeId,
              },
          );
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: burstSienna,
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
              SizedBox(height: 15),
              fridgeNameRow,
              space5,
              usersRow,
              space20,
              itemRows,
            ],
          ),
        ),
      ),
    );
  }
}