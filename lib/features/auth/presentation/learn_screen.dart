import 'package:flutter/material.dart';
// Yahan apni English sub modules screen ko import kar lein ge jab ban jayegi:
import '../../modules/english_sub_modules_screen.dart';
import '../../modules/body_parts_screen.dart';
class LearnScreen extends StatelessWidget {
  const LearnScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F3),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: const Color(0xFFFBF9F3),
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo and App Name
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB800).withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.star_rounded, color: Color(0xFFFFB800), size: 26),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'WonderKids',
                        style: TextStyle(
                          fontFamily: 'Rubik',
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF006689),
                        ),
                      ),
                    ],
                  ),
                  // Stars and Profile
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.stars, color: Color(0xFFFFAA1D), size: 18),
                            SizedBox(width: 4),
                            Text(
                              '140',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontWeight: FontWeight.w900,
                                fontSize: 13,
                                color: Color(0xFF1B1C19),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.face, color: Color(0xFF006689), size: 22),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Title Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Row(
                          children: [
                            Text(
                              'Explore & Play!',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF006689),
                              ),
                            ),
                            SizedBox(width: 4),
                            Text('✨', style: TextStyle(fontSize: 20)),
                          ],
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Tap any world to begin 🎈',
                          style: TextStyle(
                            fontFamily: 'Nunito Sans',
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF3E484F),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Modules Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.68,
                  children: [
                    // 1. English ABC (Clickable to open sub-modules)
                    GestureDetector(
                      onTap: () {
                         {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const EnglishLearningDashboard(),
    ),
  );
};
                      },
                      child: _buildModuleCard(
                        bgColor: const Color(0xFFC2E8FF).withOpacity(0.45),
                        shadowColor: const Color(0xFF2BB0E6),
                        topBadgeText: 'Aa',
                        title: 'English ABC',
                        subtitle: 'A-Z Sounds & Words',
                        imagePath: 'assets/images/abc_mod.jpg',
                        iconColor: const Color(0xFF006689),
                        buttonColor: const Color(0xFF006689),
                        onAudioTap: () {},
                      ),
                    ),

                    // 2. Urdu Haroof
                    _buildModuleCard(
                      bgColor: const Color(0xFF73FDA3).withOpacity(0.35),
                      shadowColor: const Color(0xFF24BC6B),
                      topBadgeText: 'ا ب',
                      title: 'اردو حروف',
                      subtitle: 'الف ب پ Tracing',
                      imagePath: 'assets/images/urdu_mod.jpg',
                      iconColor: const Color(0xFF006D39),
                      buttonColor: const Color(0xFF006D39),
                      isRtl: true,
                      onAudioTap: () {},
                    ),

                    // 3. Numbers
                    _buildModuleCard(
                      bgColor: const Color(0xFFFFDDB6).withOpacity(0.6),
                      shadowColor: const Color(0xFFFFAA1D),
                      topBadgeText: '123',
                      title: 'Numbers',
                      subtitle: 'Math & Counting',
                      imagePath: 'assets/images/numbers_mod.jpg',
                      iconColor: const Color(0xFF845400),
                      buttonColor: const Color(0xFFFFAA1D),
                      onAudioTap: () {},
                    ),

                    // 4. Body Parts
                    // 4. Body Parts
// 4. Body Parts
GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BodyPartsHomeScreen(),
      ),
    );
  },
  child: _buildModuleCard(
    bgColor: const Color(0xFF78D1FF).withOpacity(0.35),
    shadowColor: const Color(0xFF2BB0E6),
    topBadgeWidget: const Icon(Icons.mood, color: Color(0xFF006689), size: 24),
    title: 'Body Parts',
    subtitle: 'Learn Anatomy',
    imagePath: 'assets/images/body_mod.jpg',
    iconColor: const Color(0xFF006689),
    buttonColor: const Color(0xFF006689),
    onAudioTap: () {
      // Yahan speaker icon par click ka code agar rakhna ho toh rakhein
    },
  ),
),

                    // 5. Shapes & Colors
                    _buildModuleCard(
                      bgColor: const Color(0xFFFFDAD6).withOpacity(0.5),
                      shadowColor: const Color(0xFFBA1A1A),
                      topBadgeWidget: const Icon(Icons.category, color: Color(0xFFBA1A1A), size: 22),
                      title: 'Shapes & Colors',
                      subtitle: 'Rainbow Palette',
                      imagePath: 'assets/images/shapes_mod.jpg',
                      iconColor: const Color(0xFFBA1A1A),
                      buttonColor: const Color(0xFFBA1A1A),
                      onAudioTap: () {},
                    ),

                    // 6. Islamic Learning
                    _buildModuleCard(
                      bgColor: const Color(0xFF53DF8A).withOpacity(0.25),
                      shadowColor: const Color(0xFF006D39),
                      topBadgeWidget: const Icon(Icons.nightlight, color: Color(0xFF006D39), size: 22),
                      title: 'Islamic Learning',
                      subtitle: 'Bismillah, Duas & Kalma',
                      imagePath: 'assets/images/islamic_mod.jpg',
                      iconColor: const Color(0xFF006D39),
                      buttonColor: const Color(0xFF006D39),
                      onAudioTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // 7. Stories & Rhymes Banner Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFB958).withOpacity(0.35),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFF845400),
                        offset: Offset(0, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/kids_playroom_bg.jpg',
                          width: 60,
                          height: 55,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Stories & Rhymes',
                              style: TextStyle(
                                fontFamily: 'Rubik',
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1B1C19),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Magical Tales & Audio',
                              style: TextStyle(
                                fontFamily: 'Nunito Sans',
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF845400),
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xFF845400),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.volume_up, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      // Bottom Navigation Bar with ONLY Home Button
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.98),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildNavItem(Icons.cottage, 'Home', true, () => Navigator.pop(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModuleCard({
    required Color bgColor,
    required Color shadowColor,
    String? topBadgeText,
    Widget? topBadgeWidget,
    required String title,
    required String subtitle,
    required String imagePath,
    required Color iconColor,
    required Color buttonColor,
    bool isRtl = false,
    required VoidCallback onAudioTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: const Offset(0, 5),
            blurRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 4,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: topBadgeWidget ??
                    Text(
                      topBadgeText ?? '',
                      style: TextStyle(
                        fontFamily: 'Rubik',
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: iconColor,
                      ),
                    ),
              ),
              InkWell(
                onTap: onAudioTap,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: buttonColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.volume_up, color: Colors.white, size: 15),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Center(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      imagepath_or_placeholder(imagePath),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Directionality(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Rubik',
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1B1C19),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Nunito Sans',
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: iconColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String imagepath_or_placeholder(String path) => path;

  Widget _buildNavItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: isActive
            ? BoxDecoration(
                color: const Color(0xFFC2E8FF),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF2BB0E6),
                    offset: Offset(0, 2),
                    blurRadius: 0,
                  ),
                ],
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive ? const Color(0xFF006689) : const Color(0xFF3E484F),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Rubik',
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w900 : FontWeight.w700,
                color: isActive ? const Color(0xFF006689) : const Color(0xFF3E484F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}