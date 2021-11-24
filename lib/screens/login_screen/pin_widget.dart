import 'package:flutter/material.dart';
import '../../widgets/number_pad.dart';

class PinWidget extends StatefulWidget {
  const PinWidget({
    Key? key,
    required this.pin,
    required this.setPin,
    required this.isSetPin,
    this.hasBorder: true,
  }) : super(key: key);

  final String pin;
  final bool isSetPin;
  final bool hasBorder;

  final Function setPin;
  @override
  _PinWidgetState createState() => _PinWidgetState();
}

class _PinWidgetState extends State<PinWidget> {
  late String pin;
  late bool isInit;
  bool isError = false;
  int currentLocation = 0;
  late String displayPin;
  Widget pinWidget(String num) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(3),
      ),
      height: 50,
      width: 50,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (num == '*') SizedBox(height: 8),
          Text(
            num,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: num == '*' ? 25 : 16,
            ),
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }

  void updatePin(String keyName) {
    if (isInit) {
      isInit = false;
      if (keyName != '<-') {
        pin = '';
        displayPin = pin;
      }
    }
    switch (keyName) {
      case 'Clear':
        for (int i = 0; i < 4; i++) {
          pin = '';
          displayPin = pin;
        }

        break;
      case '<-':
        if (pin.length > 0) {
          pin = '';
          displayPin = pin;
        }
        break;
      default:
        if (pin.length < 4) {
          pin += keyName;
          displayPin = pin;
        }
        break;
    }

    currentLocation = pin.length;
    if (!widget.isSetPin) {
      widget.setPin('clearError');
      if (displayPin.length > 1) {
        String temp = displayPin[displayPin.length - 1];
        displayPin = '';
        for (int i = 0; i < pin.length - 1; i++) {
          displayPin += '*';
        }
        displayPin += temp;
      }
    }
    isError = false;
    setState(() {});
  }

  void validatePin() {
    if (pin.length != 4) {
      isError = true;
      setState(() {});
    } else {
      widget.setPin(pin);
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    isInit = true;
    pin = widget.pin;
    displayPin = pin;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 420,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              pinWidget(pin.length > 0 ? displayPin[0] : ''),
              pinWidget(pin.length > 1 ? displayPin[1] : ''),
              pinWidget(pin.length > 2 ? displayPin[2] : ''),
              pinWidget(pin.length > 3 ? displayPin[3] : ''),
            ],
          ),
          NumberPad(
            keyOnPressed: updatePin,
            keys: [
              ['7', '8', '9'],
              ['4', '5', '6'],
              ['1', '2', '3'],
              [' ', '0', '<-'],
            ],
            size: 'normal',
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  if (widget.isSetPin) {
                    Navigator.pop(context);
                  } else {
                    widget.setPin('cancel');
                  }
                },
                child: Card(
                  elevation: 2,
                  child: Container(
                    alignment: Alignment.center,
                    width: 80,
                    height: 30,
                    child: Text(
                      '取消',
                      style: TextStyle(
                        color: Colors.red[200],
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  if (widget.isSetPin) {
                    validatePin();
                  } else {
                    widget.setPin('confirm', pin: pin);
                  }
                },
                child: Card(
                  elevation: 2,
                  child: Container(
                    alignment: Alignment.center,
                    width: 80,
                    height: 30,
                    child: Text(
                      '確定',
                      style: TextStyle(
                        color: Colors.green[200],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
