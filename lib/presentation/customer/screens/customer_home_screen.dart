import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/routes.dart';
import '../../../config/theme.dart';
import '../../../presentation/auth/providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../../../core/services/update_service.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _checkUpdate());
  }

  void _checkUpdate() async {
    final update = await UpdateService.checkForUpdate();

    if (update != null && mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text("Update Available"),
          content: const Text("A new version is available. Please update."),
          actions: [
            TextButton(
              onPressed: () {
                UpdateService.downloadAndInstall(update["apk_url"]);
              },
              child: const Text("Update"),
            ),
          ],
        ),
      );
    }
  }

@override
Widget build(BuildContext context) {
  final authProvider = context.watch<AuthProvider>();
  final cartProvider = context.watch<CartProvider>();

  return Scaffold(
    appBar: AppBar(
      title: const Text('Vedamithra'),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.cart),
            ),
            if (cartProvider.totalQuantity > 0)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${cartProvider.totalQuantity}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ],
    ),

    drawer: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [ 
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryColor, Color(0xFFFF8A5C)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person,
                      size: 30,
                      color: AppTheme.primaryColor),
                ),
                const SizedBox(height: 12),
                Text(
                  authProvider.currentUserModel?.name.isNotEmpty ==
                          true
                      ? authProvider.currentUserModel!.name
                      : 'Customer',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  authProvider.currentUserModel?.phone ?? '',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.restaurant_menu),
            title: const Text('Menu'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Order History'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                  context, AppRoutes.orderHistory);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout,
                color: AppTheme.errorColor),
            title: const Text(
              'Logout',
              style:
                  TextStyle(color: AppTheme.errorColor),
            ),
            onTap: () async {
              await authProvider.signOut();
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
    ),

    body: const Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu,
              size: 80,
              color: AppTheme.primaryColor),
          SizedBox(height: 16),
          Text(
            'Menu coming soon!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Connect Firebase to load menu items',
            style: TextStyle(
                color: AppTheme.textSecondary),
          ),
        ],
      ),
    ),
  );
}
}
