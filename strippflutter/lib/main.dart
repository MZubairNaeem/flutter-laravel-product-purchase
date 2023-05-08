import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:striplaravel/auth/loginscreen.dart';
import 'getProducts/get_products.dart';
import 'home/colors.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
        theme: myTheme,
      home: LoginScreen(),
        initialBinding: BindingsBuilder(() {
      Get.put(CartController());
    }),
    );
  }
}



