import 'Constants.dart';
import 'package:flutter/material.dart';

class FridgeButton extends StatelessWidget {

  int fridgeNum;
  FridgeButton({required this.fridgeNum});

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
      'Users: ',
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
        onPressed: null,
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