import 'package:flutter/material.dart';
import '../../../config/theme.dart';
import '../../../core/constants/firebase_constants.dart';

class LiveOrdersScreen extends StatelessWidget {
  const LiveOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Use StreamBuilder with FirestoreService.getLiveOrders()

    return Scaffold(
      appBar: AppBar(title: const Text('Live Orders')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined,
                size: 80, color: AppTheme.dividerColor),
            SizedBox(height: 16),
            Text(
              'No active orders',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'New orders will appear here in real time',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for use in StreamBuilder
  Widget buildOrderCard(Map<String, dynamic> order) {
    final status = order['status'] as String;
    final nextStatus = _getNextStatus(status);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${(order['id'] as String).substring(0, 8).toUpperCase()}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                _buildStatusChip(status),
              ],
            ),
            const SizedBox(height: 8),
            Text('Customer: ${order['customerName']}'),
            Text('Phone: ${order['customerPhone']}'),
            Text('Total: ₹${order['totalAmount']}'),
            const SizedBox(height: 12),
            if (nextStatus != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: FirestoreService.updateOrderStatus(order['id'], nextStatus)
                  },
                  child: Text('Mark as ${_formatStatus(nextStatus)}'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case FirebaseConstants.statusPlaced:
        color = Colors.blue;
        break;
      case FirebaseConstants.statusAccepted:
        color = Colors.orange;
        break;
      case FirebaseConstants.statusPreparing:
        color = Colors.amber;
        break;
      case FirebaseConstants.statusOutForDelivery:
        color = AppTheme.accentColor;
        break;
      case FirebaseConstants.statusDelivered:
        color = AppTheme.successColor;
        break;
      default:
        color = AppTheme.textSecondary;
    }

    return Chip(
      label: Text(
        _formatStatus(status),
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
      padding: EdgeInsets.zero,
    );
  }

  String? _getNextStatus(String current) {
    switch (current) {
      case FirebaseConstants.statusPlaced:
        return FirebaseConstants.statusAccepted;
      case FirebaseConstants.statusAccepted:
        return FirebaseConstants.statusPreparing;
      case FirebaseConstants.statusPreparing:
        return FirebaseConstants.statusOutForDelivery;
      case FirebaseConstants.statusOutForDelivery:
        return FirebaseConstants.statusDelivered;
      default:
        return null;
    }
  }

  String _formatStatus(String status) {
    return status
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
