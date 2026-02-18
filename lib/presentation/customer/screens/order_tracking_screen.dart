import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../core/constants/firebase_constants.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    // TODO: Use FirestoreService.getOrderStream(orderId) for real-time updates

    return Scaffold(
      appBar: AppBar(title: const Text('Track Order')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order #${orderId.substring(0, 8).toUpperCase()}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 32),
            _buildStatusStep(
              'Order Placed',
              'Your order has been received',
              FirebaseConstants.statusPlaced,
              true,
            ),
            _buildStatusStep(
              'Accepted',
              'Restaurant accepted your order',
              FirebaseConstants.statusAccepted,
              false,
            ),
            _buildStatusStep(
              'Preparing',
              'Your food is being prepared',
              FirebaseConstants.statusPreparing,
              false,
            ),
            _buildStatusStep(
              'Out for Delivery',
              'Your order is on its way',
              FirebaseConstants.statusOutForDelivery,
              false,
            ),
            _buildStatusStep(
              'Delivered',
              'Enjoy your meal!',
              FirebaseConstants.statusDelivered,
              false,
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusStep(
    String title,
    String subtitle,
    String status,
    bool isActive, {
    bool isLast = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? AppTheme.primaryColor : AppTheme.dividerColor,
              ),
              child: isActive
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 48,
                color: isActive
                    ? AppTheme.primaryColor
                    : AppTheme.dividerColor,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isActive
                        ? AppTheme.textPrimary
                        : AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
