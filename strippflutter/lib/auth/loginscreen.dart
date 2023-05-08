import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:striplaravel/auth/signupscreen.dart';
import 'package:striplaravel/home/home.dart';
import 'package:striplaravel/widget/snackbar.dart';

import '../home/colors.dart';
import '../home/fogert_pass.dart';
import '../home/strings.dart';
import '../widget/heading_32.dart';
import 'package:get/get.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  // String? userId;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> _login() async {
    try{
      setState(() {
        isLoading = true;
      });
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/login'),
        body: {
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );
      log('$response');
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final authToken = responseData['authToken'];
        final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString('email11', _emailController.text);
        setState(() {
          isLoading = false;
          print(authToken);
        });
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const Home()));
      } else {
        // Show error message to the user here
        print("object");
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, "Something Wrong...!!!");
      }
    }catch(e){
      print("object");
      setState(() {
        isLoading = false;
      });
      showSnackBar(context, "Something Wrong...");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors().primaryColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColors().lightText),
          backgroundColor: AppColors().primaryColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.all(screenWidth * 0.05),
            child: Form(
              key: _formKey,
              child: Column(
                // mainAxisSize: MainAxisSize.min,

                children: [
                  Heading(text: Strings().welcome, fontWeight: FontWeight.bold,),
                  Heading(text: Strings().signIn,  fontWeight: FontWeight.normal,),
                  Heading(text: Strings().missed, fontWeight: FontWeight.normal,),
                  SizedBox(height: screenHeight * 0.1),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    style: TextStyle(color: AppColors().lightText),
                    cursorColor: AppColors().lightColor,
                    cursorWidth: 5,
                    //cursorHeight: 25,
                    controller: _emailController,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors().secondaryColor,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors().secondaryColor,
                            width: 2.0,
                          ),
                        ),
                        border: const OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10))),
                        hintText: 'Email',
                        hintStyle: TextStyle(
                            color: AppColors().lightText, fontSize: 18)),
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },

                    style: TextStyle(color: AppColors().lightText),
                    cursorColor: AppColors().lightColor,
                    cursorWidth: 5,
                    //cursorHeight: 25,
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors().secondaryColor,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors().secondaryColor,
                            width: 2.0,
                          ),
                        ),
                        border: const OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10))),
                        hintText: 'Password',
                        hintStyle: TextStyle(
                            color: AppColors().lightText, fontSize: 18)),
                  ),
                  // GestureDetector(
                  //   onTap: (){
                  //     showSnackBar(context, "content");
                  //   },
                  //   // => Navigator.push(
                  //   //     context,
                  //   //     PageTransition(
                  //   //         type: PageTransitionType.fade,
                  //   //         duration: const Duration(milliseconds: 600),
                  //   //         child: const ForgetPass())),
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(top: 10.0,right: 10.0),
                  //     child: Align(
                  //       alignment: Alignment.centerRight,
                  //       child: Text('Forget Password',style: TextStyle(
                  //           color: AppColors().lightText,
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.bold
                  //       ),),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: screenHeight * 0.1,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                            color: AppColors().greyText,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                duration: const Duration(milliseconds: 600),
                                child: const SignupScreen())),
                        child: Text(
                          "Register.",
                          style: TextStyle(
                              color: AppColors().lightColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.02,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        _login();
                      }
                    },
                    child: Container(
                      width: double.maxFinite,
                      height: 55,
                      decoration: BoxDecoration(
                          color: AppColors().secondaryColor,
                          borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                      child: isLoading? Center(child: CircularProgressIndicator(
                        color: AppColors().greyText,
                      )):Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors().greyText),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
