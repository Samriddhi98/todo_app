import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/core/theme/light_theme.dart';
import 'package:todo_app/injection_container.dart';

/// A text field with underline-only style, focus-color behavior,
/// character limit, and expandable lines.
class ExpandingUnderlineTextField extends StatefulWidget {
  final String hintText;
  final int maxChars;
  final int minLines;
  final int maxLines;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final bool showCounter;
  final ValueChanged<String>? onChanged;
  final EdgeInsets? contentPadding;
  final FormFieldValidator<String>? validator;

  const ExpandingUnderlineTextField({
    super.key,
    required this.hintText,
    this.maxChars = 200,
    this.minLines = 1,
    this.maxLines = 5,
    this.controller,
    this.focusNode,
    this.showCounter = true,
    this.onChanged,
    this.contentPadding,
    this.validator,
  });

  @override
  State<ExpandingUnderlineTextField> createState() =>
      _ExpandingUnderlineTextFieldState();
}

class _ExpandingUnderlineTextFieldState
    extends State<ExpandingUnderlineTextField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _isFocused = _focusNode.hasFocus;

    _focusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    if (_isFocused != _focusNode.hasFocus) {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      inputFormatters: [LengthLimitingTextInputFormatter(widget.maxChars)],
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        contentPadding: widget.contentPadding ?? EdgeInsets.zero,
        hintText: widget.hintText,
        hintStyle: TextStyle(color: sl<LightTheme>().titleTextColor),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: sl<LightTheme>().titleTextColor,
            width: 1.2,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: sl<LightTheme>().quatenaryColor.withAlpha(100),
            width: 2.0,
          ),
        ),
        // show counter only if requested, else hide it
        counterText: widget.showCounter ? null : '',
      ),
      cursorColor: sl<LightTheme>().quatenaryColor.withAlpha(100),
      style: TextStyle(color: Colors.black),
      validator: widget.validator,
    );
  }
}
