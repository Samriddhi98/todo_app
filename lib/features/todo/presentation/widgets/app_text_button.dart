import 'package:flutter/material.dart';

/// A minimal, configurable text-only button with a border.
///
/// - Shows ripple on tap
/// - Handles disabled state when [onPressed] is null
/// - Customizable colors, border width, radius & padding
class AppTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? textColor;
  final Color? borderColor;
  final double borderWidth;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final bool upperCase;
  final String? semanticLabel;
  final TextStyle? textStyle;
  final double minHeight;
  final double minWidth;
  final Color? buttonColor;

  const AppTextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.borderRadius = 8.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
    this.upperCase = false,
    this.semanticLabel,
    this.textStyle,
    this.buttonColor,
    this.minHeight = 44.0,
    this.minWidth = 64.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool enabled = onPressed != null;

    final Color resolvedBorderColor =
        borderColor ??
        (enabled
            ? theme.colorScheme.primary
            : theme.disabledColor.withOpacity(0.6));
    final Color resolvedTextColor =
        textColor ??
        (enabled
            ? theme.colorScheme.primary
            : theme.disabledColor.withOpacity(0.8));

    return Material(
      color: buttonColor ?? Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(borderRadius),
        splashFactory: InkRipple.splashFactory,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: minHeight, minWidth: minWidth),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              border: Border.all(
                color: resolvedBorderColor,
                width: borderWidth,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            alignment: Alignment.center,
            child: Text(
              upperCase ? text.toUpperCase() : text,
              style:
                  textStyle ??
                  theme.textTheme.labelLarge?.copyWith(
                    color: resolvedTextColor,
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
