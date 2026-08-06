import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digital_khata/features/auth/screens/login_screen.dart';
import 'package:digital_khata/features/auth/widgets/auth_button.dart';
import 'package:digital_khata/features/auth/widgets/auth_text_field.dart';
import 'package:digital_khata/theme/theme_provider.dart';
import 'package:digital_khata/core/providers/reminder_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  String _selectedGender = 'Male';
  String? _profileImageUrl;

  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfile() async {
    setState(() => _isLoading = true);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (doc.exists) {
          final data = doc.data()!;
          _nameController.text = data['name'] ?? '';
          _emailController.text = data['email'] ?? '';
          _ageController.text = (data['age'] ?? '').toString();
          _selectedGender = data['gender'] ?? 'Male';
          _profileImageUrl = data['profileImageUrl'];
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load profile data: $e'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: source, imageQuality: 70);
      if (pickedFile != null) {
        _uploadImage(File(pickedFile.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    setState(() => _isSaving = true);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        final ref = FirebaseStorage.instance.ref().child('profile_images').child('$uid.jpg');
        await ref.putFile(imageFile);
        final downloadUrl = await ref.getDownloadURL();

        // Save URL in Firestore
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'profileImageUrl': downloadUrl,
        });

        if (mounted) {
          setState(() {
            _profileImageUrl = downloadUrl;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile image updated successfully!'),
              backgroundColor: Color(0xffdafd87),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to upload image: $e'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    }
    if (mounted) {
      setState(() => _isSaving = false);
    }
  }

  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff1e1f1e),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "Select Profile Picture",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: Color(0xffdafd87)),
                title: const Text("Choose from Gallery", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: Color(0xffdafd87)),
                title: const Text("Take a Photo", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSaving = true);
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        try {
          await FirebaseFirestore.instance.collection('users').doc(uid).update({
            'name': _nameController.text.trim(),
            'gender': _selectedGender,
            'age': int.tryParse(_ageController.text.trim()) ?? 0,
          });

          // Also update display name in Firebase Auth
          await FirebaseAuth.instance.currentUser?.updateDisplayName(_nameController.text.trim());

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully!'),
                backgroundColor: Color(0xffdafd87),
                behavior: SnackBarBehavior.floating,
              ),
            );
            setState(() {});
          }
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to update profile: $e'),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        }
      }
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onSurface = theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: Icon(
          Icons.hourglass_bottom_rounded,
          color: theme.primaryColor,
        ),
        title: Text(
          "Profile",
          style: TextStyle(color: onSurface, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Avatar + Greeting
                      Center(
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                GestureDetector(
                                  onTap: _showImageSourceActionSheet,
                                  child: Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      color: theme.primaryColor.withValues(alpha: 0.15),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: theme.primaryColor,
                                        width: 1.5,
                                      ),
                                      image: _profileImageUrl != null && _profileImageUrl!.isNotEmpty
                                          ? DecorationImage(
                                              image: NetworkImage(_profileImageUrl!),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child: _profileImageUrl == null || _profileImageUrl!.isEmpty
                                        ? Icon(
                                            Icons.person_rounded,
                                            color: theme.primaryColor,
                                            size: 50,
                                          )
                                        : null,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: _showImageSourceActionSheet,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: theme.primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.camera_alt_rounded,
                                        color: isDark ? Colors.black : Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            Text(
                              _nameController.text.isNotEmpty ? _nameController.text : "User Profile",
                              style: TextStyle(
                                color: onSurface,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _emailController.text,
                              style: TextStyle(
                                color: isDark ? Colors.white54 : Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Name input
                      AuthTextField(
                        controller: _nameController,
                        label: "Full Name",
                        hint: "Your Name",
                        icon: Icons.person_outline_rounded,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Email (Disabled always as it is user authentication credential)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email Address",
                            style: TextStyle(
                              color: isDark ? Colors.white54 : Colors.black54,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            enabled: false,
                            style: TextStyle(color: onSurface.withValues(alpha: 0.5), fontSize: 14),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.mail_outline_rounded,
                                color: isDark ? Colors.white24 : Colors.black26,
                                size: 20,
                              ),
                              filled: true,
                              fillColor: theme.cardColor,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Age + Gender Row
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
                                if (age == null || age < 5 || age > 120) {
                                  return 'Invalid age';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Gender Dropdown
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
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
                                        color: onSurface,
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
                                          setState(() => _selectedGender = val);
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

                      const SizedBox(height: 24),

                      // Theme Toggle ListTile
                      Consumer<ThemeProvider>(
                        builder: (context, themeProvider, child) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      themeProvider.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                                      color: theme.primaryColor,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      "Dark Mode",
                                      style: TextStyle(
                                        color: onSurface,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Switch(
                                  value: themeProvider.isDarkMode,
                                  activeThumbColor: theme.primaryColor,
                                  onChanged: (bool isDarkVal) {
                                    themeProvider.toggleTheme(isDarkVal);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 12),

                      // Daily Reminder Toggle ListTile
                      Consumer<ReminderProvider>(
                        builder: (context, reminderProvider, child) {
                          final isEnabled = reminderProvider.isReminderEnabled;
                          final timeText = isEnabled
                              ? " (${reminderProvider.formattedTime})"
                              : "";
                          return Container(
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: isEnabled
                                    ? () async {
                                        final TimeOfDay? picked = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay(
                                            hour: reminderProvider.reminderHour,
                                            minute: reminderProvider.reminderMinute,
                                          ),
                                        );
                                        if (picked != null) {
                                          reminderProvider.updateReminderTime(
                                            picked.hour,
                                            picked.minute,
                                          );
                                        }
                                      }
                                    : null,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.notifications_active_outlined,
                                            color: theme.primaryColor,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            "Daily Reminder$timeText",
                                            style: TextStyle(
                                              color: onSurface,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Switch(
                                        value: isEnabled,
                                        activeThumbColor: theme.primaryColor,
                                        onChanged: (bool value) async {
                                          if (value) {
                                            final TimeOfDay? picked = await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay(
                                                hour: reminderProvider.reminderHour,
                                                minute: reminderProvider.reminderMinute,
                                              ),
                                            );
                                            if (picked != null) {
                                              await reminderProvider.toggleReminder(
                                                true,
                                                hour: picked.hour,
                                                minute: picked.minute,
                                              );
                                            }
                                          } else {
                                            await reminderProvider.toggleReminder(false);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 32),

                      // Edit/Save Button
                      AuthButton(
                        text: _isSaving ? "Saving..." : "Save Changes",
                        onTap: _saveProfile,
                        isLoading: _isSaving,
                      ),

                      const SizedBox(height: 16),

                      // Logout button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.redAccent, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _logout,
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout_rounded, color: Colors.redAccent, size: 20),
                              SizedBox(width: 8),
                              Text(
                                "Logout",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
