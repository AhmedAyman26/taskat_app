
import 'package:flutter/material.dart';

class Dimensions {
  Dimensions._();

  static late bool isMobile;

  static double get xSmall => isMobile ? 6 : 14;

  static double get small => isMobile ? 8 : 16;

  static double get normal => isMobile ? 10 : 18;

  static double get large => isMobile ? 12 : 20;

  static double get xLarge => isMobile ? 14 : 22;

  static double get xxLarge => isMobile ? 16 : 24;

  static double get xxxLarge => isMobile ? 18 : 26;

  static double get xxxxLarge => isMobile ? 20 : 28;

  static double get xxxxxLarge => isMobile ? 22 : 30;

  static double get buttonHeight => isMobile ? 48 : 68;

  static double get buttonMiniHeight => isMobile ? 40 : 56;
  static const double actionButtonHeight = 100;
  static final double pickerItemHeight = isMobile ? 30 : 60;

  static double get leadingWidth => IconDimensions.medium + pageMargins;

  static double get toolbarHeight => isMobile ? 50 :72;

  static const double buttonCornerRadius = 24;
  static EdgeInsets pageSmallMargins =
      EdgeInsets.symmetric(horizontal: pageMargins);

  static double pageMargins = PaddingDimensions.large;

  static EdgeInsets get formMargins =>
      EdgeInsets.symmetric(horizontal: isMobile ? 32 : 128);

  static double setSize(double size) => isMobile ? size : size + size * 0.7;
}

class IconDimensions {
  IconDimensions._();

  static double get xxSmall =>
      Dimensions.isMobile ? 12 : Dimensions.setSize(12);

  static double get xSmall => Dimensions.isMobile ? 16 : Dimensions.setSize(16);

  static double get small => Dimensions.isMobile ? 24 : Dimensions.setSize(24);

  static double get normal => Dimensions.isMobile ? 26 : Dimensions.setSize(26);

  static double get medium => Dimensions.isMobile ? 32 : Dimensions.setSize(32);

  static double get large => Dimensions.isMobile ? 40 : Dimensions.setSize(40);
}

class PaddingDimensions {
  PaddingDimensions._();

  static double get small => Dimensions.isMobile ? 4 : Dimensions.setSize(4);

  static double get normal => Dimensions.isMobile ? 8 : Dimensions.setSize(8);

  static double get medium => Dimensions.isMobile ? 12 : Dimensions.setSize(12);

  static double get large => Dimensions.isMobile ? 16 : Dimensions.setSize(16);

  static double get xLarge => Dimensions.isMobile ? 24 : Dimensions.setSize(24);

  static double get xxLarge =>
      Dimensions.isMobile ? 32 : Dimensions.setSize(32);

  static double get xxxLarge =>
      Dimensions.isMobile ? 40 : Dimensions.setSize(40);

  static double get xxxxLarge =>
      Dimensions.isMobile ? 48 : Dimensions.setSize(48);
}

class CustomAppDimensions {
  CustomAppDimensions._();

  static double get calenderRowHeight => Dimensions.isMobile ? 60 : 76;

  static double get productDetailsHeight => Dimensions.isMobile ? 83 :Dimensions.setSize(83);

  static double get mainProductDetailsHeight => Dimensions.isMobile ? 98 :Dimensions.setSize(98);

  static double get bottomAppBarSize => Dimensions.isMobile ? 100 : 110;

  static double get mainProductImageSize => Dimensions.isMobile ? 182 : 148;

  static double get categoryProductImageSize => Dimensions.isMobile ? 134 : 200;
}
