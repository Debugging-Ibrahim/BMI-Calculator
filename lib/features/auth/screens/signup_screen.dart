import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_khata/features/auth/screens/login_screen.dart';
import 'package:digital_khata/features/auth/widgets/auth_button.dart';
import 'package:digital_khata/features/auth/widgets/auth_header.dart';
import 'package:digital_khata/features/auth/widgets/auth_text_field.dart';
import 'package:digital_khata/core/screens/home_screen.dart';
import 'package:digital_khata/core/providers/connectivity_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _ageController = TextEditingController();
  bool _obscurePassword = true;
  String _selectedGender = 'Male';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _signup() async {
    if (_formKey.currentState!.validate()) {
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
      setState(() => _isLoading = true);
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Update the display name with the full name entered
        await userCredential.user?.updateDisplayName(_nameController.text.trim());

        // Save profile to Cloud Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'gender': _selectedGender,
          'age': int.tryParse(_ageController.text.trim()) ?? 0,
          'createdAt': FieldValue.serverTimestamp(),
        });

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
          );
        }
      } on FirebaseAuthException catch (e) {
        String message = 'An error occurred. Please try again.';
        if (e.code == 'weak-password') {
          message = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          message = 'The account already exists for that email.';
        } else if (e.code == 'invalid-email') {
          message = 'Invalid email address.';
        } else {
          message = e.message ?? message;
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthHeader(
                title: "Create Account",
                subtitle: "Fill in the details below to get started",
                showBackButton: true,
              ),

              const SizedBox(height: 35),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Full Name
                    AuthTextField(
                      controller: _nameController,
                      label: "Full Name",
                      hint: "John Doe",
                      icon: Icons.person_outline_rounded,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        if (value.trim().length < 2) {
                          return 'Name must be at least 2 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Email
                    AuthTextField(
                      controller: _emailController,
                      label: "Email",
                      hint: "you@example.com",
                      icon: Icons.mail_outline_rounded,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password
                    AuthTextField(
                      controller: _passwordController,
                      label: "Password",
                      hint: "••••••••",
                      icon: Icons.lock_outline_rounded,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: isDark ? Colors.white38 : Colors.black38,
                          size: 20,
                        ),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Age + Gender row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Age
                        Expanded(
                          child: AuthTextField(
                            controller: _ageController,
                            label: "Age",
                            hint: "25",
                            icon: Icons.cake_outlined,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Required';
                              }
                              final age = int.tryParse(value);
                              if (age == null) return 'Invalid age';
                              if (age < 5 || age > 120) {
                                return 'Enter valid age';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Gender
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Gender",
                                style: TextStyle(
                                  color: isDark ? Colors.white70 : Colors.black54,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: theme.cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedGender,
                                    isExpanded: true,
                                    dropdownColor: theme.cardColor,
                                    iconEnabledColor: isDark ? Colors.white38 : Colors.black38,
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface,
                                      fontSize: 14,
                                    ),
                                    items: const [
                                      DropdownMenuItem(
                                        value: 'Male',
                                        child: Text('Male'),
                                      ),
                                      DropdownMenuItem(
                                        value: 'Female',
                                        child: Text('Female'),
                                      ),
                                    ],
                                    onChanged: (val) {
                                      if (val != null) {
                                        setState(
                                            () => _selectedGender = val);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 35),

                    // Sign Up Button
                    AuthButton(
                      text: "Create Account",
                      onTap: _signup,
                      isLoading: _isLoading,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Login prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(color: isDark ? Colors.white54 : Colors.black54, fontSize: 14),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
