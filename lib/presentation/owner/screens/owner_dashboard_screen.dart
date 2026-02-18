import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/routes.dart';
import '../../../config/theme.dart';
import '../../auth/providers/auth_provider.dart';

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await context.read<AuthProvider>().signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.roleSelection,
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Restaurant status toggle
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Restaurant Status',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Toggle to open or close',
                          style: TextStyle(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                    Switch(
                      value: true, // TODO: Bind to restaurant.isOpen
                      onChanged: (value) {
                        // TODO: Update Firestore
                      },
                      activeColor: AppTheme.successColor,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Quick stats
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildDashboardCard(
                    context,
                    icon: Icons.receipt_long,
                    title: 'Live Orders',
                    subtitle: 'View & manage',
                    color: AppTheme.primaryColor,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.liveOrders),
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.restaurant_menu,
                    title: 'Menu',
                    subtitle: 'Add & edit items',
                    color: AppTheme.accentColor,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.menuManagement),
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.currency_rupee,
                    title: 'Revenue',
                    subtitle: 'Today\'s earnings',
                    color: AppTheme.successColor,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.revenue),
                  ),
                  _buildDashboardCard(
                    context,
                    icon: Icons.notifications_active,
                    title: 'Notifications',
                    subtitle: 'Order alerts',
                    color: const Color(0xFF6C5CE7),
                    onTap: () {
                      // TODO: Notification settings
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
