
import 'package:flutter/material.dart';

class MergeInputDecoration {
  final InputDecoration input1;
  final InputDecoration input2;

  MergeInputDecoration({
    required this.input1,
    required this.input2,
  });

  InputDecoration merge() {
    return input1.copyWith(
      alignLabelWithHint: input2.alignLabelWithHint,
      border: input2.border,
      constraints: input2.constraints,
      contentPadding: input2.contentPadding,
      counter: input2.counter,
      counterStyle: input2.counterStyle,
      counterText: input2.counterText,
      disabledBorder: input2.disabledBorder,
      enabled: input2.enabled,
      enabledBorder: input2.enabledBorder,
      errorBorder: input2.errorBorder,
      errorMaxLines: input2.errorMaxLines,
      errorStyle: input2.errorStyle,
      errorText: input2.errorText,
      fillColor: input2.fillColor,
      filled: input2.filled,
      floatingLabelBehavior: input2.floatingLabelBehavior,
      floatingLabelStyle: input2.floatingLabelStyle,
      focusColor: input2.focusColor,
      focusedBorder: input2.focusedBorder,
      focusedErrorBorder: input2.focusedErrorBorder,
      helperMaxLines: input2.helperMaxLines,
      helperStyle: input2.helperStyle,
      helperText: input2.helperText,
      hintMaxLines: input2.hintMaxLines,
      hintStyle: input2.hintStyle,
      hintText: input2.hintText,
      hintTextDirection: input2.hintTextDirection,
      hoverColor: input2.hoverColor,
      icon: input2.icon,
      iconColor: input2.iconColor,
      isCollapsed: input2.isCollapsed,
      isDense: input2.isDense,
      label: input2.label,
      labelStyle: input2.labelStyle,
      labelText: input2.labelText,
      prefix: input2.prefix,
      prefixIcon: input2.prefixIcon,
      prefixIconColor: input2.prefixIconColor,
      prefixIconConstraints: input2.prefixIconConstraints,
      prefixStyle: input2.prefixStyle,
      prefixText: input2.prefixText,
      semanticCounterText: input2.semanticCounterText,
      suffix: input2.suffix,
      suffixIcon: input2.suffixIcon,
      suffixIconColor: input2.suffixIconColor,
      suffixIconConstraints: input2.suffixIconConstraints,
      suffixStyle: input2.suffixStyle,
      suffixText: input2.suffixText,
    );
  }
}
