import 'package:flutter/material.dart';

import 'pin_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final themeColor = Colors.red[300];
  late Size screenSize;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Container(
      child: Stack(
        children: [
          // background
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: screenSize.width,
                height: 300,
                color: themeColor,
              ),
            ],
          ),
          // content
          Column(
            children: [
              // header
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sign Up !',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                  ],
                ),
              ),

              // field
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  width: screenSize.width,
                  child: Card(
                    elevation: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Enter Mobile Number',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 18,
                          ),
                        ),
                        Container(
                          width: screenSize.width * 0.6,
                          child: TextField(
                            keyboardType: TextInputType.numberWithOptions(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // child: PinWidget(
                //   pin: '',
                //   isSetPin: false,
                //   setPin: () {},
                // ),
              ),

              // login option
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account?',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // submit / register
              Container(
                alignment: Alignment.center,
                width: 250,
                height: 60,
                padding: EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                decoration: BoxDecoration(
                  color: themeColor,
                  borderRadius: BorderRadius.circular(
                    40,
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),

              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
