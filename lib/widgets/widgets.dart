import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PositionedCancelBtn extends StatelessWidget {
  const PositionedCancelBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return InkWell(
        enableFeedback: false,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => {Navigator.of(context).pop()},
        child: Image.asset('assets/home/btn-cancel.png', height: height * 0.045));
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
        bottom: height * 0.1,
        left: width * 0.28,
        // height: height * 0.08,
        child: SizedBox(
            width: width * 0.5,
            child: Stack(alignment: AlignmentDirectional.centerStart, children: [
              Image.asset('assets/settings/note-field-bg.png', height: height * .04),
              Padding(
                  padding: const EdgeInsets.only(left: 9.0),
                  child: TextField(
                    inputFormatters: [LengthLimitingTextInputFormatter(15)],
                    style: TextStyle(fontFamily: 'lapsus', color: Colors.white, fontSize: width * .038),
                    decoration: InputDecoration(
                        hintStyle: TextStyle(fontFamily: 'lapsus', color: Colors.white54, fontSize: width * .038),
                        labelStyle: TextStyle(fontFamily: 'lapsus', fontSize: width * .038),
                        border: InputBorder.none,
                        hintText: 'Enter your note'),
                    controller: controller,
                  ))
            ])));
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
        bottom: height * 0.12,
        left: width * 0.28,
        // height: height * 0.075,
        child: SizedBox(
            width: width * 0.24,
            child: Stack(alignment: AlignmentDirectional.centerStart, children: [
              Image.asset('assets/settings/number-field-bg.png', height: height * .12, width: width * .25),
              Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextFormField(
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
                    style: const TextStyle(fontFamily: 'lapsus', color: Colors.white),
                    decoration: InputDecoration(
                        prefixIcon: Text("\$ ", style: TextStyle(fontFamily: 'lapsus', color: Colors.white, fontSize: width * .04)),
                        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 14),
                        hintStyle: TextStyle(fontFamily: 'lapsus', color: Colors.white54, fontSize: width * .035),
                        labelStyle: TextStyle(fontFamily: 'lapsus', fontSize: width * .035),
                        border: InputBorder.none,
                        hintText: '0'),
                    controller: controller,
                  ))
            ])));
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
        bottom: height * 0.1,
        // left: width * 0.15,
        width: width * 0.5,
        child: SizedBox(
            width: width * 0.5,
            child: Stack(alignment: AlignmentDirectional.center, children: [
              Image.asset('assets/settings/field-bg.png', height: height * .15, width: width * .5),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: TextField(
                  autofocus: true,
                  style: const TextStyle(fontFamily: 'lapsus', color: Colors.white),
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(fontFamily: 'lapsus', color: Colors.white),
                    labelStyle: const TextStyle(fontFamily: 'lapsus'),
                    border: InputBorder.none,
                    hintText: hintText,
                  ),
                  controller: controller,
                ),
              ),
            ])));
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
        bottom: height * 0.1,
        // left: width * 0.15,
        width: width * 0.5,
        child: Center(
            child: SizedBox(
                width: width * 0.5,
                child: Stack(alignment: AlignmentDirectional.center, children: [
                  Image.asset('assets/settings/field-bg.png', height: height * .15, width: width * .5),
                  Padding(
                      padding: const EdgeInsets.only(left: 8.0),
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
                      ))
                ]))));
  }
}

class BackHomeBtn extends StatelessWidget {
  const BackHomeBtn({
    Key? key,
    required this.width,
    required this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: TextButton.icon(
          label: const Text(''),
          onPressed: () => Navigator.of(context).pop(),
          icon: Image.asset('assets/home/btn-try-again-home.png', height: height * 0.075),
        ));
  }
}

class AttentionText extends StatelessWidget {
  const AttentionText({
    Key? key,
    required this.height,
    required this.width,
    required this.selectedChildName,
  }) : super(key: key);

  final double height;
  final double width;
  final String selectedChildName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height * 0.6,
        child: Padding(
            padding: EdgeInsets.fromLTRB(width * 0.14, height * 0.05, width * 0.14, 5),
            child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.max, children: [
              Text('Attention!\n', style: TextStyle(fontFamily: 'lapsus', fontSize: 30, color: Colors.blueGrey.shade800), textAlign: TextAlign.center),
              Text(
                textAlign: TextAlign.justify,
                'Dear Parent at this point please hand your phone to $selectedChildName to precede. $selectedChildName needs to tab the phone to the magic gold coin tag on top the Jooj Bank. $selectedChildName have 10 seconds to do this action. Are you ready? If you are then please press ok to start the 10 seconds timer.',
                style: const TextStyle(fontSize: 15, color: Colors.black54),
              )
            ]))));
  }
}
