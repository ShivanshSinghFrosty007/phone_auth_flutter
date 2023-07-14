import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth_flutter/main.dart';
import 'package:pinput/pinput.dart';

class OtpPage extends StatefulWidget {
  _OtpPage createState() => _OtpPage();
}

class _OtpPage extends State<OtpPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController codeControler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 50),
              child: Image.network(
                'https://i.pinimg.com/736x/40/78/f9/4078f9f1cb24f4020bed0062957a54ff.jpg',
                height: 200,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
              child: Pinput(
                controller: codeControler,
                onChanged: (text) {
                  setState(() {});
                },
                length: 6,
                defaultPinTheme: PinTheme(
                  width: 56,
                  height: 56,
                  textStyle: const TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.w600),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      primary: Colors.green),
                  onPressed: () async {
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                            verificationId: MyHomePage.verifyId,
                            smsCode: codeControler.text.toString());
                    await auth.signInWithCredential(credential).catchError((e){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("wrong Otp")));
                    }).whenComplete((){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("correct Otp")));
                    });
                  },
                  child: const Text("CONFIRM")),
            ),
          ],
        ),
      ),
    );
  }
}
