import 'Constants.dart';
import 'package:flutter/material.dart';

class FridgeButton extends StatelessWidget {
  final int fridgeNum;
  final String fridgeName;
  final String userName;
  final String fridgeId;
  final List<Map<String, String>> foodItems;
  final VoidCallback onPressed;

  FridgeButton({
    required this.fridgeNum,
    required this.fridgeName,
    required this.userName,
    required this.fridgeId,
    required this.foodItems,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {

    final fridgeNameRow = Text(
      fridgeName,
      maxLines: 1,
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
    );

    final usersRow = Text(
      'User: $userName',
      maxLines: 1,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: delftBlue,
      ),
    );

    final sortedFoodItems = List<Map<String, String>>.from(foodItems);
    sortedFoodItems.sort((a, b) {
      final nameA = a['name'] ?? '';
      final nameB = b['name'] ?? '';
      return nameA.compareTo(nameB);
    });

    final visibleFoodItems = sortedFoodItems.take(10).toList();
    final hasMoreItems = sortedFoodItems.length > 10;

     final itemRows = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var item in visibleFoodItems)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item['name'] ?? '',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              Text(
                item['quantity'] ?? '',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        if (hasMoreItems)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
              '...',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
      ],
    );

    return SizedBox(
      width: 400,
      height: 500,
      child: OutlinedButton(
       onPressed: onPressed,
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
              Text(
                'Items:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              itemRows,
            ],
          ),
        ),
      ),
    );
  }
}