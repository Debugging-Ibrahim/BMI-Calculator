import 'package:flutter/material.dart';

class InputFieldBMI extends StatelessWidget {
  const InputFieldBMI({
    super.key,
    required this.text,
    required this.controller,
    this.isheight = true,
  });

  final String text;
  final TextEditingController controller;
  final bool isheight;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(text, style: TextStyle(color: Colors.black, fontSize: 22)),
        const SizedBox(height: 10),
        TextFormField(
          autovalidateMode: .onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Field Cannot be Empty";
            }

            final current = double.tryParse(value);
            if (isheight) {
              if (current == null || current < 60) {
                return "Height must be greater than 60";
              }
            }
            if (isheight == false) {
              if (current == null || current < 20) {
                return "Weight must be greater than 20";
              }
            }
            return null;
          },
          controller: controller,
          decoration: InputDecoration(
            suffixIcon: Icon(isheight ? Icons.height : Icons.line_weight),
            border: OutlineInputBorder(borderRadius: .circular(50)),

            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: .circular(50),
            ),
          ),

          cursorColor: Colors.amber,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
      ],
    );
  }
}
