import 'package:flutter/material.dart';
import 'package:personal_wellness/core/utils/constants/icon_path.dart';

class CategoryIcon extends StatelessWidget {
  final String category;
  final double radius;
  final double iconSize;

  const CategoryIcon({
    super.key,
    required this.category,
    this.radius = 16,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    Color? bgColor;
    String? iconPath;
    switch (category) {
      case 'Cleanser':
        bgColor = Colors.blue;
        iconPath = IconPath.cleanser;
        break;
      case 'Serum':
        bgColor = Colors.pink;
        iconPath = IconPath.serum;
        break;
      case 'Night Cream':
        bgColor = Colors.black;
        iconPath = IconPath.night;
        break;
      case 'Sun Cream':
        bgColor = Colors.yellow;
        iconPath = IconPath.sun;
        break;
      case 'Lotion':
        bgColor = Colors.purple;
        iconPath = IconPath.lotion;
        break;
      default:
        return const SizedBox.shrink();
    }
    return CircleAvatar(
      radius: radius,
      backgroundColor: bgColor,
      child: Image.asset(iconPath, color: Colors.white, width: iconSize, height: iconSize),
    );
  }
}