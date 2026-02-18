import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/routes.dart';
import '../../../config/theme.dart';
import '../../../core/utils/validators.dart';
import '../providers/auth_provider.dart';

class CustomerLoginScreen extends StatefulWidget {
  const CustomerLoginScreen({super.key});

  @override
  State<CustomerLoginScreen> createState() => _CustomerLoginScreenState();
}

class _CustomerLoginScreenState extends State<CustomerLoginScreen> {

  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    await authProvider.sendOtp(_phoneController.text.trim());

    if (!mounted) return;

    if (authProvider.status == AuthStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Failed to send OTP'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    } else {
      Navigator.pushNamed(
        context,
        AppRoutes.otpVerification,
        arguments: _phoneController.text.trim(),
      );
    }
  }
  Future<void> _handleGoogleLogin() async {
    try {
      final googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result =
          await fb.FirebaseAuth.instance.signInWithCredential(credential);

      final user = result.user;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .set({
        'uid': user.uid,
        'email': user.email,
        'role': 'customer',
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (!mounted) return;

      Navigator.pushReplacementNamed(context, AppRoutes.customerHome);

    } catch (e) {
      print("Google Sign-In Error: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Login'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                const Text(
                  'Enter your\nphone number',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'We\'ll send you a verification code',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  validator: Validators.validatePhone,
                  decoration: const InputDecoration(
                    labelText: 'Phone Number',
                    hintText: '9876543210',
                    prefixText: '+91  ',
                    prefixIcon: Icon(Icons.phone_outlined),
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 32),
ElevatedButton(
  onPressed: authProvider.status == AuthStatus.loading
      ? null
      : _sendOtp,
  child: authProvider.status == AuthStatus.loading
      ? const SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
      : const Text('Send OTP'),
),

const SizedBox(height: 20),

ElevatedButton.icon(
  onPressed: _handleGoogleLogin,
  icon: const Icon(Icons.login),
  label: const Text("Continue with Google"),
),

                const Spacer(),
                Center(
                  child: Text(
                    'By continuing, you agree to our Terms of Service',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
