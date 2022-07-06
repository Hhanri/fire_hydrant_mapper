import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormFieldWidget extends StatelessWidget {
  final TextFormParameters parameters;
  const TextFormFieldWidget({Key? key, required this.parameters}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: parameters.controller,
      decoration: InputDecoration(
        label: Text(parameters.label),
        //hintText: parameters.hint,
      ),
      keyboardType: parameters.keyboardType,
      inputFormatters: parameters.inputFormatters,
      validator: parameters.validator,
    );
  }
}

class TextFormParameters {
  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final String? Function(String?) validator;
  List<TextInputFormatter> inputFormatters;

  TextFormParameters({
    required this.controller,
    required this.label,
    required this.hint,
    required this.validator,
    required this.keyboardType,
    required this.inputFormatters
  });
}

class WaterLevelParameters extends TextFormParameters{
  WaterLevelParameters({
    required TextEditingController controller
  }) : super(
    controller: controller,
    hint: "458974",
    label: "Water Level",
    validator: (value) {
      if (double.tryParse(value ?? "") != null) {
        return null;
      }
      return "Not a number";
    },
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp(r'[/\\]')),
      FilteringTextInputFormatter.singleLineFormatter,
      FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
    ]
  );
}

class LatitudeParameters extends TextFormParameters{
  LatitudeParameters({
    required TextEditingController controller
  }) : super(
    controller: controller,
    hint: "48.974",
    label: "Latitude",
    validator: (value) {
      if (double.tryParse(value ?? "") != null) {
        return null;
      }
      return "Not a number";
    },
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)')),
      FilteringTextInputFormatter.deny(RegExp(r'[/\\]')),
      FilteringTextInputFormatter.singleLineFormatter,
    ]
  );
}

class LongitudeParameters extends TextFormParameters{
  LongitudeParameters({
    required TextEditingController controller
  }) : super(
    controller: controller,
    hint: "48.974",
    label: "Longitude",
    validator: (value) {
      if (double.tryParse(value ?? "") != null) {
        return null;
      }
      return "Not a number";
    },
    keyboardType: TextInputType.number,
    inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp(r'[/\\]')),
      FilteringTextInputFormatter.singleLineFormatter,
      FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
    ]
  );
}

class StreetNameParameters extends TextFormParameters{
  StreetNameParameters({
    required TextEditingController controller
  }) : super(
    controller: controller,
    hint: "89 rue du Pont",
    label: "Street Name",
    validator: (value) => null,
    keyboardType: TextInputType.text,
    inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp(r'[/\\]')),
      FilteringTextInputFormatter.singleLineFormatter,
    ]

  );
}

class NoteParameters extends TextFormParameters {
  NoteParameters({
    required TextEditingController controller
  }) : super(
    controller: controller,
    hint: "something to jot down",
    label: "Note",
    validator: (value) => null,
    keyboardType: TextInputType.text,
    inputFormatters: [
      FilteringTextInputFormatter.deny(RegExp(r'[/\\]')),
      FilteringTextInputFormatter.singleLineFormatter,
    ]
  );
}