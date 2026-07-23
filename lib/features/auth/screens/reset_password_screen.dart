import 'package:digital_khata/features/auth/widgets/auth_button.dart';
import 'package:digital_khata/core/providers/connectivity_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _isResending = false;

  void _resendEmail() async {
    final connectivity = Provider.of<ConnectivityProvider>(context, listen: false);
    if (connectivity.isOffline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No internet connection. Please verify your connection and try again."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isResending = true);
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: widget.email);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Reset email resent successfully!"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to resend: ${e.toString()}"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  void _goBackToLogin() {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _goBackToLogin,
            icon: Icon(
              CupertinoIcons.clear,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Lottie Animation File
              Center(
                child: SizedBox(
                  height: 220,
                  width: screenWidth * 0.6,
                  child: Lottie.asset(
                    'assets/message_sent_professional_theme.json',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Title and Subtitle
              Text(
                "Password Reset Sent",
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                "We have sent a secure password reset link to:\n${widget.email}\n\nPlease check your inbox and follow the instructions to reset your password.",
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                  fontSize: 14,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Done Button
              AuthButton(
                text: "Done",
                onTap: _goBackToLogin,
              ),
              const SizedBox(height: 16),

              // Resend Email Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  onPressed: _isResending ? null : _resendEmail,
                  child: _isResending
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                          ),
                        )
                      : Text(
                          "Resend Email",
                          style: TextStyle(
                            color: theme.primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
