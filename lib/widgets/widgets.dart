import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PositionedCancelBtn extends StatelessWidget {
  const PositionedCancelBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Positioned(
        bottom: 10,
        right: width * 0.046,
        height: height * 0.075,
        child: Material(
            color: Colors.transparent,
            child: TextButton.icon(label: const Text(''), onPressed: () => {Navigator.of(context).pop()}, icon: Image.asset('assets/home/btn-cancel.png', width: width * 0.28))));
  }
}

class NoteField extends StatelessWidget {
  const NoteField({
    Key? key,
    required this.height,
    required this.width,
    required this.controller,
  }) : super(key: key);

  final double height;
  final double width;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: height * 0.0825,
        left: width * 0.3,
        height: height * 0.08,
        child: SizedBox(
            width: width * 0.37,
            child: TextField(
              inputFormatters: [LengthLimitingTextInputFormatter(15)],
              style: const TextStyle(fontFamily: 'waytosun', color: Colors.white),
              decoration: const InputDecoration(
                  hintStyle: TextStyle(fontFamily: 'waytosun', color: Colors.white54), labelStyle: TextStyle(fontFamily: 'waytosun'), border: InputBorder.none, hintText: 'Enter your note'),
              controller: controller,
            )));
  }
}

class NumberField extends StatelessWidget {
  const NumberField({
    Key? key,
    required this.height,
    required this.width,
    required this.controller,
  }) : super(key: key);

  final double height;
  final double width;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: height * 0.140,
        left: width * 0.3,
        height: height * 0.075,
        child: SizedBox(
            width: width * 0.37,
            child: TextFormField(
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
              style: const TextStyle(fontFamily: 'waytosun', color: Colors.white),
              decoration: const InputDecoration(
                  prefixIcon: Text("\$ ", style: TextStyle(fontFamily: 'waytosun', color: Colors.white)),
                  prefixIconConstraints: BoxConstraints(minWidth: 0, minHeight: 14),
                  hintStyle: TextStyle(fontFamily: 'waytosun', color: Colors.white54),
                  labelStyle: TextStyle(fontFamily: 'waytosun'),
                  border: InputBorder.none,
                  hintText: '0'),
              controller: controller,
            )));
  }
}

class SettingsField extends StatelessWidget {
  const SettingsField({
    Key? key,
    required this.height,
    required this.width,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

  final double height;
  final double width;
  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: height * 0.155,
        left: width * 0.15,
        width: width * 0.5,
        child: Center(
            child: SizedBox(
                width: width * 0.37,
                child: TextField(
                  autofocus: true,
                  style: const TextStyle(fontFamily: 'waytosun', color: Colors.white),
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(fontFamily: 'waytosun', color: Colors.white),
                    labelStyle: const TextStyle(fontFamily: 'waytosun'),
                    border: InputBorder.none,
                    hintText: hintText,
                  ),
                  controller: controller,
                ))));
  }
}

class PassField extends StatelessWidget {
  const PassField({
    Key? key,
    required this.height,
    required this.width,
    required this.controller,
  }) : super(key: key);

  final double height;
  final double width;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: height * 0.145,
        left: width * 0.15,
        width: width * 0.5,
        child: Center(
            child: SizedBox(
                width: width * 0.372,
                child: TextField(
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  autofocus: true,
                  style: const TextStyle(fontFamily: 'lapsus', color: Colors.white),
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(fontFamily: 'lapsus', color: Colors.white),
                    border: InputBorder.none,
                    hintText: 'min 8 charecters',
                  ),
                  controller: controller,
                ))));
  }
}
