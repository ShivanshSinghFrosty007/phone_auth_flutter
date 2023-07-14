import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:phone_auth_flutter/OtpPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  static String verifyId = "";

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String countryCode = "+91";
  TextEditingController numberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
                'https://static.vecteezy.com/system/resources/thumbnails/011/605/975/small/hand-dialing-phone-number-linear-icon-thin-line-illustration-smartphone-keypad-contour-symbol-isolated-outline-drawing-vector.jpg'),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 30),
              child: Row(
                children: [
                  CountryCodePicker(
                    initialSelection: 'IN',
                    onChanged: print,
                  ),
                  Expanded(
                    child: TextField(
                      controller: numberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Phone',
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(56), primary: Colors.green),
                  onPressed: () async {
                    print(countryCode+" "+phoneNumberFormate(numberController.text));
                    if(numberController.text.length == 10) {
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: countryCode+" "+phoneNumberFormate(numberController.text),
                        verificationCompleted:
                            (PhoneAuthCredential credential) {},
                        verificationFailed: (FirebaseAuthException e) {},
                        codeSent: (String verificationId, int? resendToken) {
                          MyHomePage.verifyId = verificationId;
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => OtpPage()));
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {},
                      );
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter 10 digit number")));
                    }
                  },
                  child: Text("GO")),
            ),
          ],
        ),
      ),
    );
  }

  String phoneNumberFormate(String number){
    return number.substring(0, 4)+" "+number.substring(4, 7)+" "+number.substring(7, 10);
  }

}