import 'package:flutter/material.dart';
import 'package:jc_hk/app_export.dart';
import 'package:jc_hk/utils/size_utils.dart';
import 'package:jc_hk/utils/theme.helper.dart';

/// A collection of pre-defined text styles for customizing text appearance,
/// categorized by different font families and weights.
/// Additionally, this class includes extensions on [TextStyle] to easily apply specific font families to text.

class CustomTextStyles {
  // Body text style
  static get bodySmall10 => theme.textTheme.bodySmall!.copyWith(
        fontSize: 10.fSize,
      );
  static get bodySmall9 => theme.textTheme.bodySmall!.copyWith(
        fontSize: 9.fSize,
      );
  static get bodySmallBluegray100 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blueGray100,
      );
  static get bodySmallBluegray300 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blueGray300,
        fontSize: 10.fSize,
      );
  static get bodySmallBluegray3009 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.blueGray300,
        fontSize: 11.fSize,
      );
  static get bodySmallDeeporange300 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.deepOrange300,
        fontSize: 11.fSize,
      );
  static get bodySmallGray600 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray600,
        fontSize: 10.fSize,
      );
  static get bodySmallGray600_1 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray600,
      );
  static get bodySmallGreen600 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.green600,
        fontSize: 9.fSize,
      );
  static get bodySmallOnError => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.onError,
      );
  static get bodySmallOnPrimaryContainer => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.onPrimaryContainer,
        fontSize: 11.fSize,
      );
  static get bodySmallGray => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.gray600,
        fontSize: 12.fSize,
      );
  static get bodySmallOrange600 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.orange600,
        fontSize: 12.fSize,
      );
  static get bodySmallOrange60010 => theme.textTheme.bodySmall!.copyWith(
        color: appTheme.orange600,
        fontSize: 10.fSize,
      );
  static get bodySmallPrimary => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 10.fSize,
      );
  static get bodySmallPrimary10 => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 10.fSize,
      );
  static get bodySmallPrimaryContainer => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.primaryContainer,
      );
  static get textSuccess => theme.textTheme.bodySmall!.copyWith(
      fontWeight: FontWeight.w700,
      fontSize: 11.fSize,
      color: Color(0xFF4A9D4D));

  static get bodySmallPrimaryContainer10 => theme.textTheme.bodySmall!.copyWith(
        color: theme.colorScheme.primaryContainer,
        fontSize: 10.fSize,
      );
  // Headline text style
  static get headlineSmallPrimary => theme.textTheme.headlineSmall!.copyWith(
        color: theme.colorScheme.primary,
      );
  // Label text style
  static get labelLargeLato => theme.textTheme.labelLarge!.lato.copyWith(
        fontWeight: FontWeight.w700,
      );
  static get labelLargeLatoGray600 => theme.textTheme.labelLarge!.lato.copyWith(
        color: appTheme.gray600,
        fontWeight: FontWeight.w700,
      );
  static get labelLargeLatoOnPrimary =>
      theme.textTheme.labelLarge!.lato.copyWith(
        color: theme.colorScheme.onPrimary,
        fontWeight: FontWeight.w700,
      );
  static get labelLargeLatoPrimary => theme.textTheme.labelLarge!.lato.copyWith(
        color: theme.colorScheme.primary,
      );
  static get labelLargeBlack => theme.textTheme.labelLarge!.lato.copyWith(
        color: appTheme.black,
      );
  static get labelLargeLatoPrimaryBold =>
      theme.textTheme.labelLarge!.lato.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w700,
      );
  static get labelLargeOrange600 => theme.textTheme.labelLarge!.copyWith(
        color: appTheme.orange600,
        fontWeight: FontWeight.w700,
      );
  static get labelLargeSecondaryContainer =>
      theme.textTheme.labelLarge!.copyWith(
        color: theme.colorScheme.secondaryContainer,
      );
  static get labelMediumLatoOrange600 =>
      theme.textTheme.labelMedium!.lato.copyWith(
        color: appTheme.orange600,
        fontSize: 10.fSize,
      );
  static get labelMediumLatoPrimary =>
      theme.textTheme.labelMedium!.lato.copyWith(
        color: theme.colorScheme.primary,
        fontSize: 12.fSize,
      );
  static get labelMediumLatoPrimaryContainer =>
      theme.textTheme.labelMedium!.lato.copyWith(
        color: theme.colorScheme.primaryContainer,
        fontSize: 12.fSize,
      );
  static get labelMediumLatoGray => theme.textTheme.labelMedium!.lato.copyWith(
        color: appTheme.blueGray300,
        fontSize: 12.fSize,
      );
  static get labelMediumLatoWhite => theme.textTheme.labelMedium!.lato.copyWith(
        color: Colors.white,
        fontSize: 12.fSize,
      );
  static get labelMediumBlack => theme.textTheme.bodySmall!.lato.copyWith(
        fontSize: 12.fSize,
        color: appTheme.black,
        fontWeight: FontWeight.w100,
      );
  static get labelMediumPrimary => theme.textTheme.labelMedium!.copyWith(
        color: theme.colorScheme.primary,
      );
  static get labelSmallLatoPrimaryContainer =>
      theme.textTheme.labelMedium!.lato.copyWith(
        color: theme.colorScheme.primaryContainer,
        fontSize: 10.fSize,
      );
  static get labelSmallLatoOrange600 =>
      theme.textTheme.labelMedium!.lato.copyWith(
        color: appTheme.orange600,
        fontWeight: FontWeight.w100,
        fontSize: 10.fSize,
      );

  // Title text style
  static get titleMediumPrimaryContainer =>
      theme.textTheme.titleMedium!.copyWith(
        color: theme.colorScheme.primaryContainer,
        fontFamily: 'Urbanist',
        fontWeight: FontWeight.w600,
        fontSize: 14.fSize,
      );
  static get titleMediumGrey => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray600,
        fontFamily: 'Urbanist',
        fontWeight: FontWeight.w600,
        fontSize: 14.fSize,
      );
  static get titleMedium => theme.textTheme.titleMedium!.copyWith(
        // color: appTheme.gray300,
        fontFamily: 'Urbanist',
        fontWeight: FontWeight.w600,
        fontSize: 14.fSize,
      );
  static get titleMediumLato => theme.textTheme.titleMedium!.copyWith(
        // color: appTheme.gray300,
        fontFamily: 'Lato',
        color: appTheme.gray500,
        fontWeight: FontWeight.w400,
        fontSize: 14.fSize,
      );
  static get titleLargeGrey => theme.textTheme.titleMedium!.copyWith(
        color: appTheme.gray600,
        fontFamily: 'Lato',
        fontWeight: FontWeight.w600,
        fontSize: 16.fSize,
      );
  static get titleMediumGray600 => theme.textTheme.titleSmall!.copyWith(
        fontSize: 15.fSize,
        color: appTheme.gray600,
      );
  static get titleSmallGray600 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.gray600,
      );
  static get titleSmallOrange600 => theme.textTheme.titleSmall!.copyWith(
        color: appTheme.orange600,
      );
  static get titleSmallUrbanist => theme.textTheme.titleSmall!.urbanist;
  static get titleSmallUrbanistGray600 =>
      theme.textTheme.titleSmall!.urbanist.copyWith(
        color: appTheme.gray600,
      );
  static get titleSmallUrbanistOnPrimary =>
      theme.textTheme.titleSmall!.urbanist.copyWith(
        color: theme.colorScheme.onPrimary,
      );
  static get titleSmallUrbanistOrange600 =>
      theme.textTheme.titleSmall!.urbanist.copyWith(
        color: appTheme.orange600,
      );
}

extension on TextStyle {
  TextStyle get lato {
    return copyWith(
      fontFamily: 'Lato',
    );
  }

  TextStyle get urbanist {
    return copyWith(
      fontFamily: 'Urbanist',
    );
  }
}
