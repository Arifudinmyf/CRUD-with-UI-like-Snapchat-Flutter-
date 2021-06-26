import 'package:flutter/material.dart';

class InputFieldForScreen extends StatelessWidget {
  final String label;
  final String initialValue;
  final String Function(String) validator;
  final Function(String) onChange;
  final TextInputType txtType;
  final TextEditingController controller;
  final Widget prefix;
  final Widget suffixIcon;
  final bool obscure;

  InputFieldForScreen(
      {this.label,
      this.initialValue,
      this.onChange,
      this.txtType,
      this.validator,
      this.controller,
      this.prefix,
      this.obscure = false,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 35,
        right: 35,
      ),
      child: TextFormField(
        //for keyboard activation
        autofocus: true,
        controller: controller,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: txtType,
        obscureText: obscure,
        validator: validator,
        initialValue: initialValue,
        onChanged: onChange,
        decoration: InputDecoration(
            suffixIcon: suffixIcon,
            prefix: prefix,
            labelText: label,
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey))),
      ),
    );
  }
}
