import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:striplaravel/auth/loginscreen.dart';
import 'package:striplaravel/home/colors.dart';
import 'package:striplaravel/home/payment.dart';
import 'package:striplaravel/home/strings.dart';
import 'package:get/get.dart';

import '../getProducts/get_products.dart';
import '../widget/snackbar.dart';

class Home extends StatefulWidget {

  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final CartController cartController = Get.find();
  int? userId;
  String? finalToken;
  Future<List<dynamic>> getProducts() async {
    const String apiUrl = "http://10.0.2.2:8000/api/get/products";

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final products = responseBody['data'];
      return products;
    } else {
      throw Exception("Failed to load products");
    }
  }
  Future<int> getUserID(String authToken) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/api/get/user'),
      headers: <String, String>{
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final userID = jsonResponse['id'];
      setState(() {
        userId = userID;
      });
      return userID;
    } else {
      throw Exception('Failed to get user ID');
    }
  }
  Future getValidationKey() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var obtainedKey = sharedPreferences.getString('email11');
    // var obtainedEmail = sharedPreferences.getString('email');

    setState(() {
      finalToken = obtainedKey;
      // finalEmail = obtainedEmail!;
      print(finalToken);
      print("object");
    });
  }

@override
  void initState()  {
    super.initState();
    getValidationKey();
    // getUserID(finalToken!);

}
  final _textFieldController1 = TextEditingController();
  final _textFieldController2 = TextEditingController();
  final _textFieldController3 = TextEditingController();
  final _number = TextEditingController();
  final _expYear = TextEditingController();
  final _expMonth = TextEditingController();
  final _cvv = TextEditingController();
  final _price = TextEditingController();
  final _description = TextEditingController();
  bool _isLoading = false;


  Future<void> addProduct(
      String name, String description, String price) async {
    try {
      setState(() {
        _isLoading = true;
      });
      const String apiUrl = "http://10.0.2.2:8000/api/add/products";
      final response = await http.post(Uri.parse(apiUrl), body: {
        "name": name,
        "description": description,
        "price": price,
      });
      if (response.statusCode == 201) {
        print("Product added successfully.");
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, "Product added successfully.");
        _textFieldController3.clear();
        _textFieldController1.clear();
        _textFieldController2.clear();
        Navigator.of(context).pop();
      } else {
        final responseBody = json.decode(response.body);
        print("Error: ${responseBody['message']}");
      }
    } catch (e) {
      print(e.toString());
    }
  }
  Future<void> buyProduct(
      dynamic number, String description, String price,dynamic cvv, dynamic expMonth,dynamic expYear) async {
    try {
      setState(() {
        _isLoading = true;
      });
      const String apiUrl = "http://10.0.2.2:8000/api/stripe";
      final response = await http.post(Uri.parse(apiUrl), body: {
        "number": number,
        "exp_month":expMonth,
        "exp_year":expYear,
        "cvc":cvv,
        "amount": price,
        "description": description
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
  void _showDialogBox() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                    color: AppColors().greyText,
                  ),)
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _textFieldController1,
                        decoration: const InputDecoration(
                          labelText: 'Product name',
                        ),
                      ),
                      TextField(
                        controller: _textFieldController2,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                      ),
                      TextField(
                        controller: _textFieldController3,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Price',
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {
                          addProduct(
                              _textFieldController1.text,
                              _textFieldController2.text,
                              _textFieldController3.text);
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
  void _paymentDialogBox(product, description, price) {
    final CartController cartController = Get.find();
    String aa = price;
    double bb = double.parse(aa);
    String priceInPoints = (bb / 100).toStringAsFixed(2);
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
                        Text(
                          'Product: $product',
                          style: TextStyle(color: AppColors().blackLight),
                        ),
                        Text(
                            'Description: $description',
                            style: TextStyle(color: AppColors().blackLight)),
                        Text('Price: $priceInPoints',
                            style: TextStyle(color: AppColors().blackLight)),
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
                              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
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
                              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
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
                              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
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
                              contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 14.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        ElevatedButton(
                          onPressed: () {
                            // buyProduct(_number.text, description, price, _cvv.text, _expMonth.text, _expYear.text);
                            cartController.addToCart(product);
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
  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
    });
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try{

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/logout'),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        Get.snackbar(responseData, "Successfully logout");
        final authToken = responseData['authToken'];
        // Save authToken to local storage here

        setState(() async {
          _isLoading = false;
          // sharedPreferences.remove('email11');
        });
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const LoginScreen()),(Route<dynamic> route) => false,);
      } else {
        print("object");
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, "Something Wrong...!!!");
      }
    }catch(e){
      print(e.toString());
    }
  }

  void logoutDialogue(){
    showDialog(context: context, builder: (BuildContext context){
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
                Text("Are you sure?",style: TextStyle(fontSize: 20),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(onPressed: (){
                      Navigator.of(context).pop();
                    }, child: Text("Cacnel")),
                    ElevatedButton(onPressed: (){
                      Navigator.of(context).pop();
                      _logout();
                    }, child: Text("Logout")),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textFieldController3.dispose();
    _textFieldController1.dispose();
    _textFieldController2.dispose();
     _number .dispose();
     _expYear.dispose();
     _expMonth .dispose();
     _cvv .dispose();
     _price .dispose();
     _description .dispose();
  }



  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors().primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors().secondaryColor,
        centerTitle: true,
        title: const Text(
          'Products',
          style: TextStyle(color: Colors.white),
        ),
        leading: GestureDetector(
          onTap: (){

            logoutDialogue();
          },
          child: const Icon(
            Icons.logout,
            color: Colors.white,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PaymentScreen()));
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 28.0),
              child: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body:  _isLoading
          ? Center(
          child: CircularProgressIndicator(
            color: AppColors().greyText,
          ))
          :FutureBuilder(
        future: getProducts(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final products = snapshot.data;
            return ListView.builder(
              itemCount: snapshot.data.length,

              itemBuilder: (BuildContext context, int index) {
                // final product = products[index];
                String aa = products[index]['price'];
                double bb = double.parse(aa);
                String priceInPoints = (bb / 100).toStringAsFixed(2);
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Product: ${products[index]['name']}',
                              style: TextStyle(color: AppColors().greyText),
                            ),
                            Text(
                                'Description: ${products[index]['description']}',
                                style: TextStyle(color: AppColors().greyText)),
                            Text('Price: $priceInPoints',
                                style: TextStyle(color: AppColors().greyText)),
                          ],
                        ),
                        Image.network(
                          Strings().imgLink,
                          width: 100,
                          height: 100,
                        ),
                        GestureDetector(
                          onTap: (){
                            // _paymentDialogBox(products[index]['name'],products[index]['description'],products[index]['price']);
                            final Map<String, dynamic> productJson = {'name': products[index]['name'], 'price': priceInPoints};

                            final product = Product.fromJson(productJson);

                            cartController.addToCart(product);
                            showSnackBar(context, "1 ${products[index]['name']} added to cart");
                          },
                          child: Icon(
                            Icons.add_shopping_cart_rounded,
                            color: AppColors().greyText,
                            size: 40,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: finalToken == "admin@gmail.com"? FloatingActionButton(
        backgroundColor: AppColors().secondaryColor,
        onPressed: _showDialogBox,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ):null,
    );
  }
}

class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}
