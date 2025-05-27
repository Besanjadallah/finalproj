import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _couponController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _paypalEmailController = TextEditingController();

  String _selectedPayment = 'cash';
  double discount = 0;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final double total = cart.totalPrice;
    final double finalTotal = total - discount;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: const Color(0xFF8DBF67),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text("Shipping Address", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                hintText: "Enter your address",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 24),
            const Text("Payment Method", style: TextStyle(fontWeight: FontWeight.bold)),
            RadioListTile(
              value: 'cash',
              groupValue: _selectedPayment,
              onChanged: (value) => setState(() => _selectedPayment = value!),
              title: const Text("Pay with Cash"),
              secondary: const Icon(Icons.money),
            ),
            RadioListTile(
              value: 'visa',
              groupValue: _selectedPayment,
              onChanged: (value) => setState(() => _selectedPayment = value!),
              title: const Text("Pay with Visa"),
              secondary: const Icon(Icons.credit_card),
            ),
            RadioListTile(
              value: 'paypal',
              groupValue: _selectedPayment,
              onChanged: (value) => setState(() => _selectedPayment = value!),
              title: const Text("Pay with PayPal"),
              secondary: const Icon(Icons.account_balance_wallet),
            ),

            if (_selectedPayment == 'visa') ...[
              const SizedBox(height: 16),
              const Text("Visa Details", style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _cardNumberController,
                decoration: const InputDecoration(hintText: "Card Number"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _expiryController,
                decoration: const InputDecoration(hintText: "Expiry Date (MM/YY)"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _cvvController,
                decoration: const InputDecoration(hintText: "CVV"),
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
            ] else if (_selectedPayment == 'paypal') ...[
              const SizedBox(height: 16),
              const Text("PayPal Email", style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: _paypalEmailController,
                decoration: const InputDecoration(hintText: "Email for PayPal"),
                keyboardType: TextInputType.emailAddress,
              ),
            ],

            const SizedBox(height: 24),
            const Text("Apply Coupon", style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _couponController,
                    decoration: const InputDecoration(
                      hintText: "Enter coupon code",
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (_couponController.text.trim() == "PLANT10") {
                        discount = 10.0;
                      } else {
                        discount = 0;
                      }
                    });
                  },
                  child: const Text("Apply"),
                ),
              ],
            ),

            const SizedBox(height: 30),
            Text(
              "Total: ₪${finalTotal.toStringAsFixed(2)}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_addressController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter your address")),
                  );
                  return;
                }

                if (_selectedPayment == 'visa' &&
                    (_cardNumberController.text.isEmpty ||
                     _expiryController.text.isEmpty ||
                     _cvvController.text.isEmpty)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill Visa card details")),
                  );
                  return;
                }

                if (_selectedPayment == 'paypal' && _paypalEmailController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter your PayPal email")),
                  );
                  return;
                }

                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Order Placed ✅"),
                    content: Text(
                      "Shipping to:\n${_addressController.text}\n\n"
                      "Payment Method: $_selectedPayment\n"
                      "${_selectedPayment == 'visa' ? 'Card: ${_cardNumberController.text}' : ''}"
                      "${_selectedPayment == 'paypal' ? 'PayPal Email: ${_paypalEmailController.text}' : ''}\n"
                      "Discount: ₪$discount\nTotal Paid: ₪${finalTotal.toStringAsFixed(2)}",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                        child: const Text("OK"),
                      ),
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8DBF67),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("Place Order"),
            ),
          ],
        ),
      ),
    );
  }
}
