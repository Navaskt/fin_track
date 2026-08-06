import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// An extension on `num` to provide convenient and **responsive** spacing shortcuts.
extension SpacingExtension on num {
  /// Returns a responsive `SizedBox` with the current number as its height.
  Widget get hBox => SizedBox(height: toDouble().h);

  /// Returns a responsive `SizedBox` with the current number as its width.
  Widget get wBox => SizedBox(width: toDouble().w);

  /// Returns a responsive `EdgeInsets` with all sides padded by the current number.
  EdgeInsets get allPadding => EdgeInsets.all(toDouble().r);

  /// Returns a responsive `EdgeInsets` with the vertical padded by the current number.
  EdgeInsets get padV => EdgeInsets.symmetric(vertical: toDouble().h);

  /// Returns a responsive `EdgeInsets` with the horizontal padded by the current number.
  EdgeInsets get padH => EdgeInsets.symmetric(horizontal: toDouble().w);

  /// Returns a responsive `EdgeInsets` with the top padded by the current number.
  EdgeInsets get padT => EdgeInsets.only(top: toDouble().h);

  /// Returns a responsive `EdgeInsets` with the bottom padded by the current number.
  EdgeInsets get padB => EdgeInsets.only(bottom: toDouble().h);

  /// Returns a responsive `EdgeInsets` with the left padded by the current number.
  EdgeInsets get padL => EdgeInsets.only(left: toDouble().w);

  /// Returns a responsive `EdgeInsets` with the right padded by the current number.
  EdgeInsets get padR => EdgeInsets.only(right: toDouble().w);
}