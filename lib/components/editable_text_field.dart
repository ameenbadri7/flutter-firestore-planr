import 'package:flutter/material.dart';

class EditableTextField extends StatefulWidget {
  EditableTextField(
      {this.initialValue,
      this.isFocused = false,
      this.style,
      this.textInputAction,
      this.onChanged,
      this.onSubmit});

  final String initialValue;
  final bool isFocused;
  final TextStyle style;
  final TextInputAction textInputAction;
  final Function onChanged;
  final Function onSubmit;

  @override
  _EditableTextFieldState createState() => _EditableTextFieldState();
}

class _EditableTextFieldState extends State<EditableTextField> {
  final textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    textEditingController.text = widget.initialValue;
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EditableText(
      focusNode: focusNode,
      autofocus: widget.isFocused,
      expands: true,
      minLines: null,
      maxLines: null,
      textInputAction: widget.textInputAction ?? TextInputAction.done,
      keyboardAppearance: Brightness.dark,
      onChanged: (text) {
        if (widget.onChanged != null) widget.onChanged(text);
      },
      onSubmitted: (text) {
        if (widget.onSubmit != null) widget.onSubmit(text);
      },
      cursorColor: Colors.black,
      backgroundCursorColor: Colors.black,
      style: widget.style ?? TextStyle(),
      controller: textEditingController,
    );
  }
}
