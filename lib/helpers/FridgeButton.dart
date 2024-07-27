import 'Constants.dart';
import 'package:flutter/material.dart';

class FridgeButton extends StatelessWidget {

  int fridgeNum;
  FridgeButton({required this.fridgeNum});

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      width: 300,
      height: 40,
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
        child: Padding(
          padding: const EdgeInsets.only(right: 180),
          child: Text(
            'Fridge $fridgeNum '.substring(0, 8),
            maxLines: 1,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}