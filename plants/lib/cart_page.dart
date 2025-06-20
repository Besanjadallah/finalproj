// ✅ كود CartPage محدث بالكامل مع الكوبون وخصم صحيح وربط للشيك أوت
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final TextEditingController _couponController = TextEditingController();
  double discount = 0;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final items = cart.items.values.toList();
    final double subtotal = cart.totalPrice;
    final double taxes = 10.0;
    final double total = subtotal + taxes - discount;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FFF6),
      appBar: AppBar(
        title: const Text('My Cart'),
        backgroundColor: const Color(0xFF8DBF67),
        elevation: 0,
      ),
      body: items.isEmpty
          ? const Center(child: Text("Your cart is empty 🛒", style: TextStyle(fontSize: 18)))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (ctx, i) {
                      final item = items[i];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE7F3DF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(item.image, width: 60, height: 60, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.name,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  const SizedBox(height: 4),
                                  Text("₪${item.price.toStringAsFixed(2)}"),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => cart.decreaseQuantity(item.id),
                                ),
                                Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => cart.addItem(item.id, item.name, item.price, item.image),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.grey.shade200, blurRadius: 10, offset: const Offset(0, -1))
                    ],
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.local_offer, color: Color(0xFF8DBF67)),
                          SizedBox(width: 8),
                          Text("Apply Coupon", style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _couponController,
                              decoration: const InputDecoration(
                                hintText: "Enter coupon code",
                                filled: true,
                                fillColor: Color(0xFFF0F0F0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  if (_couponController.text.trim().toUpperCase() == "PLANT10") {
                                    discount = 10.0;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Coupon applied successfully!")),
                                    );
                                  } else {
                                    discount = 0;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Invalid coupon code.")),
                                    );
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8DBF67),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                              child: const Text("Apply"),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 12),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        const Text("Subtotal"),
                        Text("₪${subtotal.toStringAsFixed(2)}"),
                      ]),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        const Text("Taxes and Charges"),
                        Text("₪${taxes.toStringAsFixed(2)}"),
                      ]),
                      if (discount > 0)
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          const Text("Discount"),
                          Text("-₪${discount.toStringAsFixed(2)}"),
                        ]),
                      const SizedBox(height: 10),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        const Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("₪${total.toStringAsFixed(2)}",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      ]),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (items.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (_) => const CheckoutPage(),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8DBF67),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text("Checkout"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}