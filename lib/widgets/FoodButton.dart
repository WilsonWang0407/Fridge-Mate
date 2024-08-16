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
    Widget daysMessageWidget = expDate != null ? _buildDaysMessage(expDate) : Text('Invalid date', style: centerBarInputTextStyle);

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
                  daysMessageWidget,
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

  Widget _buildDaysMessage(DateTime expDate) {
    // 将当前日期和过期日期都设置为当天的00:00时间
    DateTime currentDate = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    DateTime expirationDateAtMidnight = DateTime(expDate.year, expDate.month, expDate.day);

    // 计算日期差异
    int days = expirationDateAtMidnight.difference(currentDate).inDays;

    // 处理不同的情况
    if (days == 0) {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: 'Expire today', style: centerBarInputTextStyle),
          ],
        ),
      );
    } else if (days > 0 && days <= 10) {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(text: 'Expire in ', style: centerBarInputTextStyle),
            TextSpan(text: '$days', style: centerBarInputTextStyle.copyWith(color: sunset, fontWeight: FontWeight.w900)),
            TextSpan(text: ' day(s)', style: centerBarInputTextStyle),
          ],
        ),
      );
    } else if (days > 10) {
      return Text('Expire in $days day(s)', style: centerBarInputTextStyle);
    } else {
      return Text('Expired', style: centerBarInputTextStyle);
    }
  }
}
