import 'Constants.dart';
import 'package:flutter/material.dart';

class FoodBar extends StatelessWidget {
  final String imageUrl;
  final String foodName;
  final String quantity;
  final bool isOpened;
  final String expirationDate;

  const FoodItemWidget({
    super.key,
    required this.imageUrl,
    required this.foodName,
    required this.quantity,
    required this.isOpened,
    required this.expirationDate,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Image.network(
          imageUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  foodName,
                  style: Theme.of(context).textTheme.titleLarge
                ),
                Text(
                  'Quantity: $quantity',
                  style: Theme.of(context).textTheme.bodyMedium
                ),
                Text(
                  isOpened
                    ? 'Is Opened: Yes'
                    : 'Is Opened: No',
                  style: Theme.of(context).textTheme.bodyMedium
                ),
                Text(
                  expirationDate,
                  style: Theme.of(context).textTheme.bodyMedium.copyWith(color: Colors.red)
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}