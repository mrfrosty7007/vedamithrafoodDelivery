import 'package:flutter/material.dart';
import '../presentation/auth/screens/role_selection_screen.dart';
import '../presentation/auth/screens/customer_login_screen.dart';
import '../presentation/auth/screens/otp_verification_screen.dart';
import '../presentation/auth/screens/owner_login_screen.dart';
import '../presentation/customer/screens/customer_home_screen.dart';
import '../presentation/customer/screens/cart_screen.dart';
import '../presentation/customer/screens/checkout_screen.dart';
import '../presentation/customer/screens/order_tracking_screen.dart';
import '../presentation/customer/screens/order_history_screen.dart';
import '../presentation/owner/screens/owner_dashboard_screen.dart';
import '../presentation/owner/screens/live_orders_screen.dart';
import '../presentation/owner/screens/menu_management_screen.dart';
import '../presentation/owner/screens/revenue_screen.dart';

class AppRoutes {
  AppRoutes._();

  // Auth routes
  static const String roleSelection = '/';
  static const String customerLogin = '/customer-login';
  static const String otpVerification = '/otp-verification';
  static const String ownerLogin = '/owner-login';

  // Customer routes
  static const String customerHome = '/customer-home';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String orderTracking = '/order-tracking';
  static const String orderHistory = '/order-history';

  // Owner routes
  static const String ownerDashboard = '/owner-dashboard';
  static const String liveOrders = '/live-orders';
  static const String menuManagement = '/menu-management';
  static const String revenue = '/revenue';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Auth
      case roleSelection:
        return _buildRoute(const RoleSelectionScreen(), settings);
      case customerLogin:
        return _buildRoute(const CustomerLoginScreen(), settings);
      case otpVerification:
        final phoneNumber = settings.arguments as String;
        return _buildRoute(
          OtpVerificationScreen(phoneNumber: phoneNumber),
          settings,
        );
      case ownerLogin:
        return _buildRoute(const OwnerLoginScreen(), settings);

      // Customer
      case customerHome:
        return _buildRoute(const CustomerHomeScreen(), settings);
      case cart:
        return _buildRoute(const CartScreen(), settings);
      case checkout:
        return _buildRoute(const CheckoutScreen(), settings);
      case orderTracking:
        final orderId = settings.arguments as String;
        return _buildRoute(
          OrderTrackingScreen(orderId: orderId),
          settings,
        );
      case orderHistory:
        return _buildRoute(const OrderHistoryScreen(), settings);

      // Owner
      case ownerDashboard:
        return _buildRoute(const OwnerDashboardScreen(), settings);
      case liveOrders:
        return _buildRoute(const LiveOrdersScreen(), settings);
      case menuManagement:
        return _buildRoute(const MenuManagementScreen(), settings);
      case revenue:
        return _buildRoute(const RevenueScreen(), settings);

      default:
        return _buildRoute(
          const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
          settings,
        );
    }
  }

  static MaterialPageRoute _buildRoute(Widget page, RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => page,
      settings: settings,
    );
  }
}
