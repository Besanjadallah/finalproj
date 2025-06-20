import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../providers/cart_provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String selectedPayment = 'card';
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _couponController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _paypalEmailController = TextEditingController();

  Future<void> placeOrder() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final items = cartProvider.getCartItemsAsJson();
    double totalPrice = cartProvider.totalPrice;

    print("📦 Sending items to backend: $items");

    final couponCode = _couponController.text.trim();
    double discount = 0.0;

    if (couponCode == "DISCOUNT10") {
      discount = totalPrice * 0.10;
      totalPrice -= discount;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("🔴 User not logged in")),
      );
      return;
    }

    final url = Uri.parse('http://192.168.1.18:8080/api/orders'); // عدلي ال-IP حسب جهازك

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'items': items,
          'totalPrice': totalPrice,
          'paymentMethod': selectedPayment,
          'address': _addressController.text.trim(),
        }),
      );

      if (response.statusCode == 201) {
        cartProvider.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Order placed successfully!")),
        );
        Navigator.pop(context);
      } else {
        print("❌ Order failed: ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Failed to place order: ${response.body}")),
        );
      }
    } catch (e) {
      print("🔥 Error sending order: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("🚨 Network error occurred")),
      );
    }
  }

  Widget paymentOption(String method, IconData icon) {
    final isSelected = selectedPayment == method;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = method;
        });
      },
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isSelected ? const Color(0xFFE0F0FF) : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 28),
            const SizedBox(height: 6),
            Text(method[0].toUpperCase() + method.substring(1)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final totalBeforeDiscount = cartProvider.totalPrice;
    final couponCode = _couponController.text.trim();
    final isCouponValid = couponCode == "DISCOUNT10";
    final totalAfterDiscount =
        isCouponValid ? totalBeforeDiscount * 0.90 : totalBeforeDiscount;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FFF6),
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: const Color(0xFF8DBF67),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Coupon",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _couponController,
              decoration: const InputDecoration(
                labelText: "Enter coupon code",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Payment Method",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                paymentOption("card", Icons.credit_card),
                paymentOption("paypal", Icons.account_balance_wallet_outlined),
                paymentOption("cash", Icons.money),
              ],
            ),
            const SizedBox(height: 20),
            if (selectedPayment == "card") ...[
              const Text(
                "Card Number",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  hintText: "Enter card number",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              const Text(
                "Expiry Date (MM/YY)",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(
                  hintText: "MM/YY",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 16),
              const Text(
                "CVV",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(
                  hintText: "Enter CVV",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
              const SizedBox(height: 20),
            ],
            if (selectedPayment == "paypal") ...[
              const Text(
                "PayPal Email",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _paypalEmailController,
                decoration: const InputDecoration(
                  hintText: "Enter PayPal email",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
            ],
            const Text(
              "Shipping Address",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                hintText: "Enter your address",
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 30),
            Text(
              "Total: \$${totalAfterDiscount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: placeOrder,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  backgroundColor: const Color(0xFF8DBF67),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child:
                    const Text("Place Order", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
