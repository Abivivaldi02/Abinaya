import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:orapay_prokit/screens/op_user_detail.dart';
import 'package:orapay_prokit/utils/Colors.dart';
import 'package:orapay_prokit/utils/OPWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OPLoginScreen extends StatefulWidget {
  @override
  _OPLoginScreenState createState() => _OPLoginScreenState();
}

class _OPLoginScreenState extends State<OPLoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> loginUser() async {
    setState(() => isLoading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      toast("Login Successful",length: Toast.LENGTH_LONG);
      OPUserDetailsScreen().launch(context, isNewTask: true);
    } on FirebaseAuthException catch (e) {
      toast(e.message ?? "Login failed",length: Toast.LENGTH_LONG);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(height: 100),
                  applogo(),
                  24.height,
                  Text("Login", style: boldTextStyle(size: 24, letterSpacing: 0.2)),
                  24.height,
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: primaryTextStyle(),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: secondaryTextStyle(size: 16),
                      suffixIcon: Icon(Icons.person_outline, color: Colors.grey, size: 24),
                    ),
                  ),
                  16.height,
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    style: primaryTextStyle(),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: secondaryTextStyle(size: 16),
                      suffixIcon: Icon(Icons.lock_outline, color: Colors.grey, size: 24),
                    ),
                  ),
                ],
              ).paddingOnly(bottom: 100),
              AppButton(
                width: context.width() - 32,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Login", textAlign: TextAlign.center, style: primaryTextStyle(size: 16, color: Colors.white)),
                color: opPrimaryColor,
                onTap: () {
                  if (emailController.text.trim().isEmpty || passwordController.text.isEmpty) {
                    toast("Please enter email and password");
                  } else {
                    loginUser();
                  }
                },
              ).cornerRadiusWithClipRRect(16),
            ],
          ).paddingOnly(left: 16, right: 16, bottom: 24),
        ),
      ),
    );
  }
}
