import 'package:get/get.dart';

class CartController extends GetxController {
  RxList<Product> cartItems = RxList<Product>([]);

  void addToCart(Product product) {
    cartItems.add(product);
  }
  double get totalPrice {
    double sum = 0;
    for (Product product in cartItems) {
      sum += double.parse(product.price);
    }
    return sum;
  }
}

class Product {
  final String name;
  final String price;

  Product({required this.name, required this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'],
      price: json['price'],
    );

  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
    };
  }
}

