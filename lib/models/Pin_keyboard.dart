// ignore_for_file: file_names

import 'package:flutter/material.dart';

class PinKeyboardController {
  VoidCallback? _resetCallback;

  void addResetListener(VoidCallback listener) {
    _resetCallback = listener;
  }

  void reset() {
    if (_resetCallback != null) {
      _resetCallback!();
    }
  }
}

class PinKeyboard extends StatefulWidget {
  final double space;
  final int length;
  final double maxWidth;
  final void Function(String)? onChange;
  final void Function(String)? onConfirm;
  final VoidCallback? onBiometric;
  final bool enableBiometric;
  final Widget? iconBiometric;
  final Widget? iconBackspace;
  final Color? iconBackspaceColor;
  final Color? iconBiometricColor;
  final Color? textColor;
  final double fontSize;
  final FontWeight fontWeight;
  final PinKeyboardController? controller;

  const PinKeyboard({
    Key? key,
    this.space = 63,
    required this.length,
    required this.onChange,
    this.onConfirm,
    this.onBiometric,
    this.enableBiometric = false,
    this.iconBiometric,
    this.maxWidth = 350,
    this.iconBackspaceColor,
    this.iconBiometricColor,
    this.textColor,
    this.fontSize = 30,
    this.fontWeight = FontWeight.bold,
    this.iconBackspace,
    this.controller,
  }) : super(key: key);

  @override
  _PinKeyboardState createState() => _PinKeyboardState();
}

class _PinKeyboardState extends State<PinKeyboard> {
  String _pinCode = '';

  @override
  void initState() {
    super.initState();
    _restListener();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: widget.maxWidth),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Column(
          children: [
            Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [_createNumber('1', _handleTabNumber), const Spacer(), _createNumber('2', _handleTabNumber), const Spacer(), _createNumber('3', _handleTabNumber)]),
            Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [_createNumber('4', _handleTabNumber), const Spacer(), _createNumber('5', _handleTabNumber), const Spacer(), _createNumber('6', _handleTabNumber)]),
            Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [_createNumber('7', _handleTabNumber), const Spacer(), _createNumber('8', _handleTabNumber), const Spacer(), _createNumber('9', _handleTabNumber)]),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [_createBiometricIcon(), const Spacer(), _createNumber('0', _handleTabNumber), const Spacer(), _createBackspaceIcon()],
            ),
          ],
        ),
      ),
    );
  }

  Widget _createNumber(String number, void Function(String) onPress) => InkWell(
        customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(widget.space)),
        splashColor: Colors.white,
        onTap: () {
          onPress(number);
        },
        child: Container(
          height: widget.space,
          width: widget.space,
          child: Center(child: Padding(padding: const EdgeInsets.all(3.0), child: Image.asset('assets/pin/$number.png', height: 150))
              // Text(
              //   number,
              //   style: TextStyle(
              //     fontSize: widget.fontSize,
              //     color: widget.textColor ?? const Color(0xff6f6f6f),
              //     fontWeight: widget.fontWeight,
              //   ),
              // ),
              ),
        ),
      );

  Widget _createImage(Widget icon, void Function() onPress) => InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.space),
        ),
        child: Container(height: widget.space, width: widget.space, child: Center(child: icon)),
        onTap: () {
          onPress();
        },
      );

  void _handleTabNumber(String number) {
    if (_pinCode.length < widget.length) {
      _pinCode += number;
      if (widget.onChange != null) {
        widget.onChange!(_pinCode);
      }
      if (_pinCode.length == widget.length) {
        if (widget.onConfirm != null) {
          widget.onConfirm!(_pinCode);
        }
        if (widget.controller == null) {
          _pinCode = '';
        }
      }
    }
    // print(_pinCode);
    // print(widget.length);
  }

  void _handleTabBiometric() {
    if (widget.onBiometric != null) {
      widget.onBiometric!();
    }
  }

  void _handleTabBackspace() {
    if (_pinCode.length > 0) {
      _pinCode = _pinCode.substring(0, _pinCode.length - 1);
      if (widget.onChange != null) {
        widget.onChange!(_pinCode);
      }
    }
  }

  Widget _createBiometricIcon() {
    if (widget.enableBiometric) {
      return _createImage(widget.iconBiometric ?? Image.asset('assets/pin/biometric.png'), _handleTabBiometric);
    } else {
      return SizedBox(height: widget.space, width: widget.space);
    }
  }

  Widget _createBackspaceIcon() => _createImage(widget.iconBackspace ?? Image.asset('assets/pin/back-space.png'), _handleTabBackspace);

  void _restListener() {
    widget.controller?.addResetListener(() {
      _pinCode = '';
      if (widget.onChange != null) {
        widget.onChange!('');
      }
    });
  }
}
