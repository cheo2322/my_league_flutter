import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MyLeagueIcon extends StatelessWidget {
  final bool selected;
  final Color selectedColor;

  const MyLeagueIcon({super.key, required this.selected, required this.selectedColor});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/logo_mi_futbol_v5.svg',
      width: 24,
      height: 24,
      colorFilter: ColorFilter.mode(selected ? selectedColor : Colors.grey[600]!, BlendMode.srcIn),
    );
  }
}
