import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:striplaravel/home/colors.dart';
import 'package:get/get.dart';
import 'package:striplaravel/home/strings.dart';

import '../getProducts/get_products.dart';
import '../widget/snackbar.dart';

class PaymentScreen extends StatefulWidget {
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final CartController cartController = Get.find();

  int? userId;

  var priceToPay = "";

  final _number = TextEditingController();
  final _expYear = TextEditingController();

  final _expMonth = TextEditingController();

  final _cvv = TextEditingController();

  final _price = TextEditingController();

  final _description = TextEditingController();

  bool _isLoading = false;

  Future<void> buyProduct(dynamic number, String priceToPay, dynamic cvv,
      dynamic expMonth, dynamic expYear) async {
    try {
      setState(() {
        _isLoading = true;
      });
      const String apiUrl = "http://10.0.2.2:8000/api/stripe";
      final response = await http.post(Uri.parse(apiUrl), body: {
        "number": number,
        "exp_month": expMonth,
        "exp_year": expYear,
        "cvc": cvv,
        "amount": priceToPay,
        "description": "description"
      });
      if (response.statusCode == 201) {
        print("Product purchase successfully");
        showSnackBar(context, 'Product purchase successfully');
        setState(() {
          _isLoading = false;
        });
        _cvv.clear();
        _description.clear();
        _expMonth.clear();
        _expYear.clear();
        _cvv.clear();
        _number.clear();
        _price.clear();
        Navigator.of(context).pop();
      } else {
        final responseBody = json.decode(response.body);
        print("Error: ${responseBody['message']}");
        print("object");
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, responseBody);
        _cvv.clear();
        _description.clear();
        _expMonth.clear();
        _expYear.clear();
        _cvv.clear();
        _number.clear();
        _price.clear();
        Navigator.of(context).pop();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void _paymentDialogBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                      color: AppColors().greyText,
                    ))
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        GetBuilder<CartController>(
                          builder: (controller) {
                            String price =
                                controller.totalPrice.toStringAsFixed(2);
                            String valueString = price;
                            String intValueString = valueString.replaceAll('.', '');
                            priceToPay = intValueString;
                            return Padding(
                              padding: const EdgeInsets.only(right: 28.0),
                              child: Center(
                                child: Text('Total: $price',
                                    style: TextStyle(
                                        color: AppColors().blackLight)),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 8.0),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.grey[200],
                          ),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _number,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'xxxx-xxxx-xxxx-xxxx',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 14.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.grey[200],
                          ),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _expMonth,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'exp-month',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 14.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.grey[200],
                          ),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _expYear,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'exp-year',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 14.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: Colors.grey[200],
                          ),
                          child: TextField(
                            controller: _cvv,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'cvv',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 14.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        ElevatedButton(
                          onPressed: () {
                            buyProduct(_number.text, priceToPay, _cvv.text,
                                _expMonth.text, _expYear.text);
                            print(priceToPay);
                            // cartController.addToCart(product);
                          },
                          child: const Text('Submit'),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          // GetBuilder<CartController>(
          //   builder: (controller) {
          //     return Padding(
          //       padding: const EdgeInsets.only(right: 28.0),
          //       child: Center(child: Text('Total: ${controller.totalPrice.toStringAsFixed(2)}',style: TextStyle(color: AppColors().secondaryColor, fontSize: 24),)),
          //     );
          //   },
          // ),
          Padding(
            padding: const EdgeInsets.only(right: 28.0),
            child: GestureDetector(
              onTap: () {
                _paymentDialogBox();
              },
              child: Icon(
                Icons.paypal,
                size: 34,
              ),
            ),
          )
        ],
      ),
      body: Obx(() => ListView.builder(
            itemCount: cartController.cartItems.length,
            itemBuilder: (context, index) {
              final product = cartController.cartItems[index];
              return Container(
                margin: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  // image: DecorationImage(image: )
                  color: AppColors().secondaryColor,
                  border: Border.all(width: 1, color: AppColors().lightColor),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text('Product: ${product.name}',
                              style: TextStyle(color: AppColors().greyText)),
                          Text('Price: ${product.price}',
                              style: TextStyle(color: AppColors().greyText)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          )),
    );
  }
}
