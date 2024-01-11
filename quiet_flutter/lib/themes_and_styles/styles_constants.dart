import 'dart:ui';

import 'package:flutter/material.dart';

class PrayerTimeTextStyle extends ThemeExtension<PrayerTimeTextStyle>{
  final fontSize;
  final textStyle;
  const PrayerTimeTextStyle({required this.fontSize, required this.textStyle});

  @override
  ThemeExtension<PrayerTimeTextStyle> copyWith({
    double? fontSize,

  }) => PrayerTimeTextStyle(fontSize: fontSize ?? this.fontSize, textStyle: textStyle ?? this.textStyle );

  @override
  ThemeExtension<PrayerTimeTextStyle> lerp(covariant ThemeExtension<PrayerTimeTextStyle>? other, double t) {
    if (other is! PrayerTimeTextStyle){
      return this;
    }else {
      return PrayerTimeTextStyle(fontSize: lerpDouble(fontSize,  other.fontSize,t), textStyle: TextStyle.lerp(textStyle, other.textStyle, t));
    }

  }
}