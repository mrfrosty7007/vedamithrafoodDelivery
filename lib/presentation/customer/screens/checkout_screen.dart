import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/routes.dart';
import '../../../config/theme.dart';
import '../../../core/constants/firebase_constants.dart';
import '../providers/cart_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _paymentMethod = FirebaseConstants.paymentCash;

  void _placeOrder() {
    final cartProvider = context.read<CartProvider>();
    if (cartProvider.items.isEmpty) return;

    // TODO: Create order in Firestore using OrderModel + FirestoreService
    // Then clear cart and navigate to tracking

    cartProvider.clearCart();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order placed successfully!'),
        backgroundColor: AppTheme.successColor,
      ),
    );
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.customerHome,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order summary
            const Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ...cartProvider.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${item.menuItem.name} x${item.quantity}'),
                            Text('₹${item.totalPrice.toStringAsFixed(0)}'),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '₹${cartProvider.totalAmount.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Payment method
            const Text(
              'Payment Method',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Row(
                      children: [
                        Icon(Icons.money, color: AppTheme.successColor),
                        SizedBox(width: 12),
                        Text('Cash on Delivery'),
                      ],
                    ),
                    value: FirebaseConstants.paymentCash,
                    groupValue: _paymentMethod,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      setState(() => _paymentMethod = value!);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Row(
                      children: [
                        Icon(Icons.account_balance, color: AppTheme.accentColor),
                        SizedBox(width: 12),
                        Text('UPI Payment'),
                      ],
                    ),
                    value: FirebaseConstants.paymentUpi,
                    groupValue: _paymentMethod,
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) {
                      setState(() => _paymentMethod = value!);
                    },
                  ),
                ],
              ),
            ),
            const Spacer(),

            // Place Order
            ElevatedButton(
              onPressed: _placeOrder,
              child: Text(
                'Place Order — ₹${cartProvider.totalAmount.toStringAsFixed(0)}',
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
