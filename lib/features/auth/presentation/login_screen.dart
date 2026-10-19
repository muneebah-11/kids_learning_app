import 'package:flutter/material.dart';
import '../../../../core/database/database_helper.dart';
import 'parent_dashboard_screen.dart';

class WonderKidsLoginScreen extends StatefulWidget {
  const WonderKidsLoginScreen({Key? key}) : super(key: key);

  @override
  State<WonderKidsLoginScreen> createState() => _WonderKidsLoginScreenState();
}

class _WonderKidsLoginScreenState extends State<WonderKidsLoginScreen> with TickerProviderStateMixin {
  bool _obscurePassword = true;
  String _selectedLang = 'en'; // 'en' ya 'ur'
  bool _isMascotScaled = false;
  bool _isLoginPressed = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _jiggleMascot() {
    setState(() {
      _isMascotScaled = true;
    });
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isMascotScaled = false;
        });
      }
    });
  }

  // Forgot Password Dialog Function (Database Connected)
  void _showForgotPasswordDialog() {
    final TextEditingController _forgotEmailController = TextEditingController();
    bool isUrdu = _selectedLang == 'ur';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isUrdu ? 'پاس ورڈ دوبارہ حاصل کریں' : 'Recover Password',
          style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isUrdu 
                ? 'اپنا رجسٹرڈ ای میل ایڈریس درج کریں تاکہ ہم آپ کا پاس ورڈ حاصل کر سکیں۔' 
                : 'Enter your registered email address below, and we will retrieve your password from the database.',
              style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 13, color: Color(0xFF64748B)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _forgotEmailController,
              decoration: InputDecoration(
                hintText: 'parent@example.com',
                prefixIcon: const Icon(Icons.mail_outline, color: Color(0xFF94A3B8), size: 20),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isUrdu ? 'منسوخ کریں' : 'Cancel', style: const TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFB8500),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              String recoveryEmail = _forgotEmailController.text.trim();
              if (recoveryEmail.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isUrdu ? 'برائے مہربانی ای میل درج کریں!' : 'Please enter your email address!')),
                );
                return;
              }

              String? retrievedPassword = await DatabaseHelper.instance.getPasswordByEmail(recoveryEmail);
              Navigator.pop(context);

              if (retrievedPassword != null) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    title: Text(isUrdu ? 'پاس ورڈ مل گیا! 🔑' : 'Password Found! 🔑', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
                    content: Text(isUrdu ? 'آپ کا پاس ورڈ ہے: $retrievedPassword' : 'Your password is: $retrievedPassword', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF006689)),
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(isUrdu ? 'اس ای میل کا کوئی اکاؤنٹ نہیں ملا!' : 'No account found with this email address!')),
                );
              }
            },
            child: Text(isUrdu ? 'ارسال کریں' : 'Submit', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // Database Login Logic
  Future<void> _handleLogin() async {
    bool isUrdu = _selectedLang == 'ur';
    setState(() {
      _isLoginPressed = true;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isUrdu ? 'برائے مہربانی ای میل اور پاس ورڈ دونوں درج کریں!' : 'Please enter both email and password!')),
      );
      setState(() { _isLoginPressed = false; });
      return;
    }

    try {
      final db = await DatabaseHelper.instance.database;
      final parentResult = await db.query(
        'parents',
        where: 'email = ? AND password = ?',
        whereArgs: [email, password],
      );

     if (parentResult.isNotEmpty) {
  List<Map<String, dynamic>> childrenProfiles = await DatabaseHelper.instance.getChildrenForParent(email);

  if (mounted) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ParentDashboardScreen(
          parentEmail: email,
          children: childrenProfiles,
        ),
      ),
    );
  }
}
      else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(isUrdu ? 'ای میل یا پاس ورڈ غلط ہے۔ دوبارہ کوشش کریں۔' : 'Invalid Email or Password. Please try again!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _isLoginPressed = false;
        });
        _jiggleMascot();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isUrdu = _selectedLang == 'ur';

    return Scaffold(
      backgroundColor: const Color(0xFFFCFAF5),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -64,
              left: -64,
              child: Container(
                width: 224,
                height: 224,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF2BB0E6).withOpacity(0.15),
                ),
              ),
            ),
            Positioned(
              top: 112,
              right: -64,
              child: Container(
                width: 208,
                height: 208,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFD447).withOpacity(0.25),
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              left: -48,
              child: Container(
                width: 192,
                height: 192,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFEC4899).withOpacity(0.15),
                ),
              ),
            ),

            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top Navigation Bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.chevron_left, color: Color(0xFF334155), size: 24),
                              constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                              padding: EdgeInsets.zero,
                            ),
                          ),

                          // Language Toggle Pill
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () => setState(() => _selectedLang = 'en'),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _selectedLang == 'en' ? Colors.white : Colors.transparent,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: const Row(
                                      children: [
                                        Text('🇬🇧', style: TextStyle(fontSize: 12)),
                                        SizedBox(width: 4),
                                        Text('EN', style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => setState(() => _selectedLang = 'ur'),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: _selectedLang == 'ur' ? Colors.white : Colors.transparent,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      'اردو',
                                      style: TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: _selectedLang == 'ur' ? const Color(0xFF1E293B) : const Color(0xFF64748B),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Header Section
                      Column(
                        children: [
                          GestureDetector(
                            onTap: _jiggleMascot,
                            child: AnimatedScale(
                              scale: _isMascotScaled ? 1.1 : 1.0,
                              duration: const Duration(milliseconds: 300),
                              child: Container(
                                width: 100,
                                height: 100,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.12),
                                      blurRadius: 16,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                  border: Border.all(color: const Color(0xFFBAE6FD), width: 4),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isUrdu ? 'وانڈر کڈز' : 'WonderKids',
                                style: const TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text('✨', style: TextStyle(fontSize: 22)),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            isUrdu ? 'اپنے تعلیمی سفر کو جاری رکھنے کے لیے سائن ان کریں!' : 'Sign in to continue your learning adventure!',
                            style: const TextStyle(
                              fontFamily: 'Nunito Sans',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Main Login Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(color: const Color(0xFFFEF3C7), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 30,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isUrdu ? 'ای میل یا صارف کا نام' : 'Email or Username',
                              style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: TextField(
                                controller: _emailController,
                                style: const TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                                decoration: const InputDecoration(
                                  hintText: 'parent@example.com',
                                  hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                                  prefixIcon: Icon(Icons.mail_outline, color: Color(0xFF94A3B8), size: 20),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  isUrdu ? 'پاس ورڈ' : 'Password',
                                  style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                                ),
                                GestureDetector(
                                  onTap: _showForgotPasswordDialog,
                                  child: Text(
                                    isUrdu ? 'پاس ورڈ بھول گئے؟' : 'Forgot Password?',
                                    style: const TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF006689),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                style: const TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                                decoration: InputDecoration(
                                  hintText: '••••••••',
                                  hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                                  prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF94A3B8), size: 20),
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: const Color(0xFF94A3B8), size: 20),
                                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Login Button
                            GestureDetector(
                              onTap: _handleLogin,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(colors: [Color(0xFFFB8500), Color(0xFFFFAF1A)]),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFD97706),
                                      offset: Offset(0, _isLoginPressed ? 1 : 5),
                                      blurRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      isUrdu ? 'وانڈر کڈز لاگ ان کریں' : 'Login to WonderKids', 
                                      style: const TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)
                                    ),
                                    const SizedBox(width: 8),
                                    const Text('🚀', style: TextStyle(fontSize: 16)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Bottom Navigation Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isUrdu ? 'کیا آپ نئے ہیں؟' : 'New to WonderKids?', 
                            style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF475569))
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Row(
                              children: [
                                Text(
                                  isUrdu ? 'مفت اکاؤنٹ بنائیں' : 'Create Free Account', 
                                  style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF006689))
                                ),
                                const SizedBox(width: 2),
                                const Icon(Icons.arrow_forward, size: 15, color: Color(0xFF006689)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}