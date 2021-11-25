import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:synpulse_challenge/models/user.dart';
import 'package:synpulse_challenge/widgets/loading_widget.dart';

import 'pin_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final themeColor = Colors.red[300];
  late Size screenSize;

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  late String _verificationId;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  Future signInWithPhoneNumber() async {
    showLoadingBoxTransparent(context);
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text,
      );
      user.id = _verificationId;
      print(_verificationId);

      await _auth.signInWithCredential(credential);
      showSnackbar("Successfully signed");
    } catch (e) {
      print(e);
      showSnackbar("Failed to sign in: $e");
    }
    Navigator.pop(context);
  }

  Future _verifyPhoneNumber() async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+852${_phoneNumberController.text}',
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await _auth.signInWithCredential(phoneAuthCredential);
          showSnackbar(
            "Phone number automatically verified and user signed in: ${_auth.currentUser!.uid}",
          );
        },
        verificationFailed: (FirebaseAuthException authException) {
          showSnackbar(
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}',
          );
        },
        codeSent: (String verificationId, int? resendToken) async {
          showSnackbar(
            'Please check your phone for the verification code.',
          );
          _verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          showSnackbar(
            "verification code: $verificationId",
          );
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      showSnackbar(
        "Failed to Verify Phone Number: $e",
      );
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
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
                            controller: _phoneNumberController,
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
              InkWell(
                onTap: () {
                  _verifyPhoneNumber();
                },
                child: Container(
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
              ),

              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
