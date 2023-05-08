import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'dart:convert';

import 'package:striplaravel/auth/loginscreen.dart';
import 'package:striplaravel/widget/snackbar.dart';

import '../home/colors.dart';
import '../home/strings.dart';
import '../widget/heading_32.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  SignupScreenState createState() => SignupScreenState();
}

class SignupScreenState extends State<SignupScreen> {
  String? _responseMessage;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;
  Future<void> _signup() async {

    try{
      setState(() {
        isLoading = true;
      });
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/signup'),
        body: {
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );
      log('$response');
      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final authToken = responseData['authToken'];
        _responseMessage = responseData['message'];
        setState(() {
          isLoading = false;
        });
        print(responseData.toString());
        showSnackBar(context, _responseMessage!);
        // Save authToken to local storage here
        Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
      } else {
        print("object");
        setState(() {
          isLoading = false;
        });
        showSnackBar(context, "Something Wrong...!!!");
      }
    }catch(e){
      print(e.toString());

      ;
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
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
        resizeToAvoidBottomInset: true,
        // key: _formKey,
        backgroundColor: AppColors().primaryColor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColors().lightText),
          backgroundColor: AppColors().primaryColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  children: [
                    Heading(
                      text: Strings().hello,
                      fontWeight: FontWeight.bold,
                    ),
                    Heading(
                      text: Strings().signUp,
                      fontWeight: FontWeight.normal,
                    ),
                    Heading(
                      text: Strings().like,
                      fontWeight: FontWeight.normal,
                    ),
                    SizedBox(height: screenHeight * 0.1),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      style: TextStyle(color: AppColors().lightText),
                      cursorColor: AppColors().lightColor,
                      cursorWidth: 5,
                      //cursorHeight: 25,
                      controller: _nameController,
                      decoration: InputDecoration (
                          focusColor: AppColors().secondaryColor,
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
                          hintText: 'Name',
                          hintStyle: TextStyle(
                              color: AppColors().lightText, fontSize: 18)),
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value){
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
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
                      validator: (value){
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password should be at least 6 characters long';
                        }
                        return null;
                      },
                      obscureText: true,
                      style: TextStyle(color: AppColors().lightText),
                      cursorColor: AppColors().lightColor,
                      cursorWidth: 5,
                      //cursorHeight: 25,
                      controller: _passwordController,
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

                    SizedBox(
                      height: screenHeight * 0.1,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Already have an account? ",
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
                                  child: const LoginScreen())),
                          child: Text(
                            "Sign In.",
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
                      onTap: ()  {
                        if (_formKey.currentState!.validate()) {
                          _signup();
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
                            "Register",
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
      ),
    );
  }
}
