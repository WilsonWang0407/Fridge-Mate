import 'package:fridge_mate/helpers/Constants.dart';
import 'package:flutter/material.dart';

class FoodButton extends StatelessWidget {
  final String imageUrl;
  final String foodName;
  final String quantity;
  final bool isOpened;
  final String expirationDate;
  final VoidCallback onPressed;

  FoodButton({
    super.key,
    required this.imageUrl,
    required this.foodName,
    required this.quantity,
    required this.isOpened,
    required this.expirationDate,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    DateTime? expDate = _parseDateString(expirationDate);
    String daysMessage = expDate != null ? _calculateDaysUntilExpiration(expDate) : 'Invalid date';

    return GestureDetector(
      onTap: onPressed,
      child: Row(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
            ),
            child: Image.network(
              imageUrl,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(width: 5),
          Container(
            width: 220,
            height: 120,
            decoration: BoxDecoration(
              color: burstSienna,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    foodName,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      decorationThickness: 0.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Quantity: $quantity',
                    style: centerBarInputTextStyle,
                  ),
                  Text(
                    isOpened ? 'Is Opened: Yes' : 'Is Opened: No',
                    style: centerBarInputTextStyle,
                  ),
                  Text(
                    daysMessage,
                    style: centerBarInputTextStyle,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  DateTime? _parseDateString(String isoDate) {
    try {
      return DateTime.parse(isoDate);
    } catch (e) {
      print('Error parsing date: $e');
      return null;
    }
  }

  String _calculateDaysUntilExpiration(DateTime expDate) {
    int days = expDate.difference(DateTime.now()).inDays + 1;
    return days >= 0 ? 'Expire in $days day(s)' : 'Expired';
  }
}
