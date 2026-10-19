import 'package:flutter/material.dart';
import '../../../../core/database/database_helper.dart';
import 'login_screen.dart';
import 'parent_dashboard_screen.dart'; // Import Parent Dashboard

class WonderKidsSignupScreen extends StatefulWidget {
  const WonderKidsSignupScreen({Key? key}) : super(key: key);

  @override
  State<WonderKidsSignupScreen> createState() => _WonderKidsSignupScreenState();
}

class _WonderKidsSignupScreenState extends State<WonderKidsSignupScreen> {
  bool _obscurePassword = true;
  String _selectedLang = 'en';
  bool _isMascotScaled = false;
  bool _isLoginPressed = false;

  String _selectedAge = '4';
  String _selectedClass = 'Kindergarten (KG)';

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

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

  void _clearFields() {
    _emailController.clear();
    _passwordController.clear();
    _nameController.clear();
    setState(() {
      _selectedAge = '4';
      _selectedClass = 'Kindergarten (KG)';
    });
  }

  Future<void> _handleSignup() async {
    bool isUrdu = _selectedLang == 'ur';
    setState(() {
      _isLoginPressed = true;
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String childName = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty || childName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isUrdu ? 'برائے مہربانی تمام خانے پُر کریں!' : 'Please fill all the fields!',
          ),
        ),
      );
      setState(() {
        _isLoginPressed = false;
      });
      return;
    }

    try {
      // Database mein Parent aur Child register karein
      await DatabaseHelper.instance.registerParentAndChild(
        email: email,
        password: password,
        childName: childName,
        age: _selectedAge,
        classProgram: _selectedClass,
        language: _selectedLang,
      );

      // Bache ki profile fetch karein dashboard ke liye
      List<Map<String, dynamic>> childrenProfiles =
          await DatabaseHelper.instance.getChildrenForParent(email);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isUrdu
                  ? 'اکاؤنٹ اور بچے کا پروفائل کامیابی سے بن گیا! 🎉'
                  : 'Account & Child Profile Created Successfully! 🎉',
            ),
          ),
        );

        // Fields clear karein
        _clearFields();

        // Direct Parent Dashboard par navigate karein
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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
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
              top: -40,
              right: -32,
              child: Container(
                width: 144,
                height: 144,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFD447).withOpacity(0.2),
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              right: 0,
              child: Container(
                width: 112,
                height: 112,
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
                                  color: Colors.black.withOpacity(0.06),
                                  blurRadius: 16,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back, color: Color(0xFF006689)),
                              constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
                              padding: EdgeInsets.zero,
                            ),
                          ),

                          // Language Selector Pill
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
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
                                        Text('EN', style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold)),
                                        SizedBox(width: 4),
                                        Text('🇬🇧', style: TextStyle(fontSize: 12)),
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
                      const SizedBox(height: 12),

                      // Mascot & Header
                      Column(
                        children: [
                          GestureDetector(
                            onTap: _jiggleMascot,
                            child: AnimatedScale(
                              scale: _isMascotScaled ? 1.1 : 1.0,
                              duration: const Duration(milliseconds: 300),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 110,
                                    height: 110,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [Color(0xFFFFAF1A), Color(0xFFFFD447), Color(0xFF2BB0E6)],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 104,
                                    height: 104,
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF2BB0E6).withOpacity(0.25),
                                          blurRadius: 20,
                                          offset: const Offset(0, 12),
                                        ),
                                      ],
                                    ),
                                    child: ClipOval(
                                      child: Image.asset(
                                        'assets/images/logo.png',
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  const Positioned(top: 0, right: 0, child: Text('✨', style: TextStyle(fontSize: 16))),
                                  const Positioned(bottom: 0, left: 0, child: Text('🌟', style: TextStyle(fontSize: 16))),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isUrdu ? 'نیا اکاؤنٹ بنائیں' : 'Create Account',
                                style: const TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Text('✨', style: TextStyle(fontSize: 20)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isUrdu ? 'اس مہم میں شامل ہوں اور اپنے بچے کی نمو دیکھیں!' : 'Join the adventure and watch your little one grow!',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Nunito Sans',
                              fontSize: 14,
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Main Form Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFF0EEE8)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 30,
                              offset: const Offset(0, 16),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(isUrdu ? 'والدین کا ای میل' : "Parent's Email", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF64748B))),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                hintText: 'parent@example.com',
                                prefixIcon: Icon(Icons.mail_outline, color: Color(0xFF94A3B8), size: 20),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(isUrdu ? 'پاس ورڈ بنائیں' : 'Create Password', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF64748B))),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                hintText: '••••••••••••',
                                prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF94A3B8), size: 20),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                ),
                                border: const OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(isUrdu ? 'بچے کا نام' : "Child's Name", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF64748B))),
                            const SizedBox(height: 6),
                            TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                hintText: 'Sara Ahmed',
                                prefixIcon: Icon(Icons.sentiment_satisfied_outlined, color: Color(0xFF94A3B8), size: 20),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(isUrdu ? 'بچے کی عمر (سال)' : "Child's Age (Years)", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF64748B))),
                            const SizedBox(height: 8),
                            Row(
                              children: ['3', '3.5', '4', '4.5', '5'].map((age) {
                                bool isSelected = _selectedAge == age;
                                return Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 3),
                                    child: GestureDetector(
                                      onTap: () => setState(() => _selectedAge = age),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                          color: isSelected ? const Color(0xFF2BB0E6) : const Color(0xFFF8FAFC),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(age, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.black)),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 16),

                            Text(isUrdu ? 'کلاس / پروگرام منتخب کریں' : 'Select Class / Program', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF64748B))),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => _selectedClass = 'Playgroup (PG)'),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: _selectedClass == 'Playgroup (PG)' ? const Color(0xFF2BB0E6).withOpacity(0.2) : const Color(0xFFF8FAFC),
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(color: _selectedClass == 'Playgroup (PG)' ? const Color(0xFF2BB0E6) : Colors.transparent, width: 2),
                                      ),
                                      child: Column(
                                        children: [
                                          const Text('🎨', style: TextStyle(fontSize: 22)),
                                          const SizedBox(height: 4),
                                          Text(isUrdu ? 'پلے گروپ' : 'Playgroup (PG)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                          Text(isUrdu ? '(عمر 3-4)' : '(Ages 3-4)', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => _selectedClass = 'Kindergarten (KG)'),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: _selectedClass == 'Kindergarten (KG)' ? const Color(0xFF2BB0E6).withOpacity(0.2) : const Color(0xFFF8FAFC),
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(color: _selectedClass == 'Kindergarten (KG)' ? const Color(0xFF2BB0E6) : Colors.transparent, width: 2),
                                      ),
                                      child: Column(
                                        children: [
                                          const Text('🚀', style: TextStyle(fontSize: 22)),
                                          const SizedBox(height: 4),
                                          Text(isUrdu ? 'کنڈرگارٹن' : 'Kindergarten (KG)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                          Text(isUrdu ? '(عمر 4-5)' : '(Ages 4-5)', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Primary CTA Button
                      GestureDetector(
                        onTap: _handleSignup,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFFFB8500), Color(0xFFFFAF1A)]),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Center(
                            child: Text(
                              isUrdu ? 'اکاؤنٹ بنائیں اور سیکھنا شروع کریں 🚀' : 'Create Account & Start Learning 🚀',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isUrdu ? 'پہلے سے اکاؤنٹ ہے؟ ' : 'Already have an account? ',
                            style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 13, color: Color(0xFF64748B)),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const WonderKidsLoginScreen()),
                              );
                            },
                            child: Row(
                              children: [
                                Text(
                                  isUrdu ? 'سائن ان کریں' : 'Sign In',
                                  style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF006689)),
                                ),
                                const SizedBox(width: 2),
                                const Icon(Icons.arrow_forward, size: 14, color: Color(0xFF006689)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
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