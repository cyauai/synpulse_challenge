import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:synpulse_challenge/models/user.dart';
import 'package:synpulse_challenge/widgets/loading_widget.dart';

late FirebaseFirestore firestore;

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
    required this.login,
  }) : super(key: key);
  final Function login;

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
  late String screenMode;

  @override
  void initState() {
    screenMode = 'register';
    super.initState();
  }

  void login() async {
    firestore = FirebaseFirestore.instance;
    // final doc = FirebaseFirestore.instance.collection('users').doc('$testId');
    // final data = await doc.get();
    // if (data.exists) {
    //   appUser = AppUser(id: '$testId');
    //   appUser.savedTickerSymbols =
    //       data.data()!['savedTickerSymbols'].cast<String>();
    // } else {
    //   await doc.set({'savedTickerSymbols': [], 'id': testId});
    // }

    final doc =
        FirebaseFirestore.instance.collection('users').doc('${appUser.id}');
    final data = await doc.get();
    if (data.exists) {
      appUser.savedTickerSymbols =
          data.data()!['savedTickerSymbols'].cast<String>();
    } else {
      await doc.set({'savedTickerSymbols': [], 'id': appUser.id});
    }

    widget.login();
  }

  Future signInWithPhoneNumber() async {
    showLoadingBoxTransparent(context);
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text,
      );

      final user = await _auth.signInWithCredential(credential);
      showSnackbar("Successfully signed");
      appUser = AppUser(id: user.user!.uid);
      login();
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
      screenMode = 'passcode';
      setState(() {});
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

  Widget get _getVerifiyWidget {
    return Stack(
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
                    'Sign In !',
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
                          textAlign: TextAlign.center,
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
            SizedBox(
              height: 30,
            ),
            // login option
            // Expanded(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text(
            //         'Already have an account?',
            //         style: TextStyle(
            //           color: Colors.grey[600],
            //           fontSize: 16,
            //         ),
            //       ),
            //       SizedBox(
            //         height: 20,
            //       ),
            //       InkWell(
            //         onTap: () {
            //           login();
            //         },
            //         child: Text(
            //           'Sign In',
            //           style: TextStyle(
            //             color: Colors.grey[600],
            //             fontSize: 16,
            //             fontWeight: FontWeight.w700,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

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
    );
  }

  Widget get _getSignInWidget {
    return Stack(
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
                    'Sign In !',
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
                        'Enter OTP',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 18,
                        ),
                      ),
                      Container(
                        width: screenSize.width * 0.6,
                        child: TextField(
                          keyboardType: TextInputType.numberWithOptions(),
                          textAlign: TextAlign.center,
                          controller: _smsController,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // login option
            // Expanded(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Text(
            //         'Already have an account?',
            //         style: TextStyle(
            //           color: Colors.grey[600],
            //           fontSize: 16,
            //         ),
            //       ),
            //       SizedBox(
            //         height: 20,
            //       ),
            //       InkWell(
            //         onTap: () {
            //           login();
            //         },
            //         child: Text(
            //           'Sign In',
            //           style: TextStyle(
            //             color: Colors.grey[600],
            //             fontSize: 16,
            //             fontWeight: FontWeight.w700,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            SizedBox(
              height: 30,
            ),
            // submit / register
            InkWell(
              onTap: () {
                signInWithPhoneNumber();
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
    );
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size;
    return Container(
      child: screenMode == 'register' ? _getVerifiyWidget : _getSignInWidget,
    );
  }
}
