import 'package:flutter/material.dart';
import '../../../../core/database/database_helper.dart';
import 'signup_screen.dart';
import 'kids_home_screen.dart';

class ParentDashboardScreen extends StatefulWidget {
  final String parentEmail;
  final List<Map<String, dynamic>> children;

  const ParentDashboardScreen({
    Key? key,
    required this.parentEmail,
    required this.children,
  }) : super(key: key);

  @override
  State<ParentDashboardScreen> createState() => _ParentDashboardScreenState();
}

class _ParentDashboardScreenState extends State<ParentDashboardScreen> {
  int _currentIndex = 0;
  String _selectedLang = 'en';

  late List<Map<String, dynamic>> _childrenList;
  int _selectedChildIndex = 0;

  @override
  void initState() {
    super.initState();
    _childrenList = List.from(widget.children);
  }

  Future<void> _refreshChildrenList() async {
    List<Map<String, dynamic>> updatedList =
        await DatabaseHelper.instance.getChildrenForParent(widget.parentEmail);
    setState(() {
      _childrenList = updatedList;
      if (_selectedChildIndex >= _childrenList.length) {
        _selectedChildIndex = _childrenList.isNotEmpty ? 0 : 0;
      }
    });
  }

  Future<void> _confirmDeleteChild(int childId, String childName) async {
    bool isUrdu = _selectedLang == 'ur';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isUrdu ? 'پروفائل حذف کریں؟' : 'Delete Profile?',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(
          isUrdu
              ? 'کیا آپ واقعی $childName کی پروفائل کو حذف کرنا چاہتے ہیں؟'
              : 'Are you sure you want to delete the profile for $childName?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isUrdu ? 'منسوخ کریں' : 'Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFBA1A1A)),
            onPressed: () async {
              await DatabaseHelper.instance.deleteChild(childId);
              Navigator.pop(context);
              await _refreshChildrenList();
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isUrdu ? 'پروفائل کامیابی سے حذف کر دی گئی!' : 'Profile deleted successfully!',
                    ),
                  ),
                );
              }
            },
            child: Text(isUrdu ? 'حذف کریں' : 'Delete', style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isUrdu = _selectedLang == 'ur';

    Map<String, dynamic>? activeChild =
        _childrenList.isNotEmpty && _selectedChildIndex < _childrenList.length
            ? _childrenList[_selectedChildIndex]
            : null;

    String activeName = activeChild?['name'] ?? (isUrdu ? 'کوئی بچہ نہیں' : 'No Child');
    String activeAge = activeChild?['age']?.toString() ?? '0';
    String activeClass = activeChild?['class_program'] ?? 'N/A';
    int? activeChildId = activeChild?['id'];

    String appBarTitle = '';
    if (_currentIndex == 0) {
      appBarTitle = isUrdu ? 'ڈیش بورڈ' : 'Dashboard';
    } else if (_currentIndex == 1) {
      appBarTitle = isUrdu ? 'بچوں کی فہرست' : 'Children Management';
    } else if (_currentIndex == 2) {
      appBarTitle = isUrdu ? 'تعلیمی رپورٹس' : 'Learning Reports';
    } else {
      appBarTitle = isUrdu ? 'حفاظت اور ترتیبات' : 'Safety Settings';
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F3),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: AppBar(
          backgroundColor: const Color(0xFFFBF9F3).withOpacity(0.85),
          elevation: 0,
          titleSpacing: 16,
          title: Row(
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFF2BB0E6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.star, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'WonderKids Parent Hub',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF006689),
                    ),
                  ),
                  Text(
                    appBarTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B1C19),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Container(
              height: 36,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEAE8E2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _selectedLang = 'en'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _selectedLang == 'en' ? const Color(0xFF2BB0E6) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'EN',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _selectedLang == 'en' ? Colors.white : const Color(0xFF3E484F),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                  GestureDetector(
                    onTap: () => setState(() => _selectedLang = 'ur'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _selectedLang == 'ur' ? const Color(0xFF2BB0E6) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'اردو',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: _selectedLang == 'ur' ? Colors.white : const Color(0xFF3E484F),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Color(0xFF3E484F)),
              onPressed: () {},
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFF006689),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
      body: _currentIndex == 0
          ? _buildDashboardContent(isUrdu, activeName, activeAge, activeClass, activeChildId)
          : _currentIndex == 1
              ? _buildChildrenManagementTab(isUrdu)
              : _currentIndex == 2
                  ? _buildReportsTab(isUrdu, activeName, activeAge, activeClass)
                  : _buildSafetyTab(isUrdu),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white.withOpacity(0.9),
        selectedItemColor: const Color(0xFF006689),
        unselectedItemColor: const Color(0xFF6E7980),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard_outlined),
            label: isUrdu ? 'ڈیش بورڈ' : 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.face),
            label: isUrdu ? 'بچے' : 'Children',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.insights),
            label: isUrdu ? 'رپورٹس' : 'Reports',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.verified_user_outlined),
            label: isUrdu ? 'حفاظت' : 'Safety',
          ),
        ],
      ),
    );
  }

  // --- 1. Dashboard Tab ---
  Widget _buildDashboardContent(bool isUrdu, String activeName, String activeAge, String activeClass, int? activeChildId) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            isUrdu
                                ? 'خوش آمدید، ${widget.parentEmail.split('@')[0]}!'
                                : 'Welcome back, ${widget.parentEmail.split('@')[0]}!',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text('✨', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      isUrdu ? 'پری اسکول سیکھنے کا سفر اور خاندانی مینیجر' : 'Preschool learning journey & family manager',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF3E484F)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF73FDA3).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.sync, size: 14, color: Color(0xFF006D39)),
                    const SizedBox(width: 4),
                    Text(
                      '${_childrenList.length} ${isUrdu ? 'منسلک' : 'Synced'}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF00210D)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Enrolled Children Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.family_restroom, color: Color(0xFF006689), size: 20),
                  const SizedBox(width: 6),
                  Text(
                    isUrdu ? 'رجسٹرڈ بچے' : 'Enrolled Children',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WonderKidsSignupScreen()),
                  );
                  _refreshChildrenList();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEAE8E2),
                  foregroundColor: const Color(0xFF006689),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                icon: const Icon(Icons.add, size: 16),
                label: Text(
                  isUrdu ? 'بچہ شامل کریں' : 'Add Child',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Children Slider
          SizedBox(
            height: 115,
            child: _childrenList.isEmpty
                ? Center(
                    child: Text(
                      isUrdu ? 'کوئی بچہ رجسٹرڈ نہیں ہے۔' : 'No children enrolled yet.',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _childrenList.length,
                    itemBuilder: (context, index) {
                      var child = _childrenList[index];
                      bool isActive = _selectedChildIndex == index;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedChildIndex = index),
                        child: Container(
                          width: 230,
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isActive ? Colors.white : const Color(0xFFF5F3EE),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isActive ? const Color(0xFF2BB0E6) : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  if (isActive)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2BB0E6),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        isUrdu ? 'فعال' : 'Active',
                                        style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () => _confirmDeleteChild(child['id'], child['name'] ?? ''),
                                    child: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                                  ),
                                ],
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundColor: isActive ? const Color(0xFFC2E8FF) : const Color(0xFFFFDDB6),
                                      child: Icon(
                                        Icons.person,
                                        size: 20,
                                        color: isActive ? const Color(0xFF006689) : const Color(0xFF845400),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            child['name'] ?? '',
                                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${child['age']} yrs • ${child['class_program']}',
                                            style: const TextStyle(fontSize: 11, color: Color(0xFF3E484F)),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 16),

          // Active Child Spotlight Card with Launch Button
          if (_childrenList.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 28,
                            backgroundColor: Color(0xFFC2E8FF),
                            child: Icon(Icons.person, size: 32, color: Color(0xFF006689)),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    activeName,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.verified, size: 16, color: Color(0xFF2BB0E6)),
                                ],
                              ),
                              Text(
                                '${isUrdu ? 'عمر' : 'Ages'} $activeAge • $activeClass',
                                style: const TextStyle(fontSize: 12, color: Color(0xFF3E484F)),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEAE8E2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  isUrdu ? 'دو زبانیں (انگریزی اور اردو)' : 'Bilingual (English & اردو)',
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (activeChildId != null)
                        IconButton(
                          onPressed: () => _confirmDeleteChild(activeChildId, activeName),
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Launch Kids Home Screen Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2BB0E6),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => KidsHomeScreen(
        childName: activeName,
        childClass: activeClass,
        parentEmail: widget.parentEmail,
      ),
    ),
  );
},
                      icon: const Icon(Icons.rocket_launch, size: 20),
                      label: Text(
                        isUrdu
                            ? '$activeName کے لیے ہوم اسکرین کھولیں 🚀'
                            : 'Launch Learning Portal for $activeName 🚀',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // --- 2. Children Management Tab ---
  Widget _buildChildrenManagementTab(bool isUrdu) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isUrdu ? 'آپ کے رجسٹرڈ بچے' : 'Your Enrolled Children',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WonderKidsSignupScreen()),
                  );
                  _refreshChildrenList();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2BB0E6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                icon: const Icon(Icons.add, size: 16),
                label: Text(isUrdu ? 'نیا بچہ جوڑیں' : 'Add Child'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _childrenList.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Text(
                      isUrdu ? 'اس اکاؤنٹ میں کوئی بچہ رجسٹرڈ نہیں ہے۔' : 'No children registered under this account.',
                      style: const TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _childrenList.length,
                  itemBuilder: (context, index) {
                    var child = _childrenList[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))],
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 26,
                            backgroundColor: Color(0xFFC2E8FF),
                            child: Icon(Icons.person, color: Color(0xFF006689), size: 28),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  child['name'] ?? '',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${isUrdu ? 'عمر' : 'Age'}: ${child['age']} yrs • ${child['class_program']}',
                                  style: const TextStyle(fontSize: 13, color: Color(0xFF3E484F)),
                                ),
                                Text(
                                  '${isUrdu ? 'والدین کی ای میل' : 'Parent'}: ${widget.parentEmail}',
                                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () => _confirmDeleteChild(child['id'], child['name'] ?? ''),
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  // --- 3. Reports Tab (Shifted Milestone, Stats & Subject Mastery Here) ---
  Widget _buildReportsTab(bool isUrdu, String activeName, String activeAge, String activeClass) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 24,
                      backgroundColor: Color(0xFFC2E8FF),
                      child: Icon(Icons.insights, color: Color(0xFF006689)),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$activeName ${isUrdu ? 'کی کارکردگی کی رپورٹ' : 'Learning Report'}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                        ),
                        Text(
                          '${isUrdu ? 'عمر' : 'Ages'} $activeAge • $activeClass',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF3E484F)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Milestone Gauge
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F3EE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isUrdu ? 'نصاب میں پیش رفت' : 'Curriculum Milestone',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF006D39)),
                          ),
                          const Text('0%', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF006D39))),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: const LinearProgressIndicator(
                          value: 0.0,
                          backgroundColor: Color(0xFFEAE8E2),
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF24BC6B)),
                          minHeight: 10,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isUrdu ? 'سیکھنا شروع کریں!' : 'Ready to Start Learning!',
                            style: const TextStyle(fontSize: 11, color: Color(0xFF3E484F)),
                          ),
                          Text(
                            isUrdu ? '0 / 22 ماڈیولز مکمل' : '0 / 22 Modules Cleared',
                            style: const TextStyle(fontSize: 11, color: Color(0xFF3E484F)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // 3 Metric Tiles
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFDDB6).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.star, color: Color(0xFF845400), size: 18),
                            const Text('0', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2A1800))),
                            Text(
                              isUrdu ? 'ستارے جیتے' : 'Stars Earned',
                              style: const TextStyle(fontSize: 10, color: Color(0xFF845400), fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF73FDA3).withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.military_tech, color: Color(0xFF006D39), size: 18),
                            const Text('0', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF00210D))),
                            Text(
                              isUrdu ? 'بیجز ملے' : 'Badges Won',
                              style: const TextStyle(fontSize: 10, color: Color(0xFF006D39), fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC2E8FF).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.timer, color: Color(0xFF006689), size: 18),
                            const Text('0m', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF001E2C))),
                            Text(
                              isUrdu ? 'حد: 45m' : 'Cap: 45m',
                              style: const TextStyle(fontSize: 10, color: Color(0xFF006689), fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Subject Mastery Title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isUrdu ? 'مضامین پر مہارت (7 ٹریکس)' : 'Subject Mastery (7 Tracks)',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
              ),
              Text(
                isUrdu ? 'نیا سفر' : 'New Journey',
                style: const TextStyle(fontSize: 12, color: Color(0xFF3E484F)),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 7 Core Subjects Progress List
          _buildSubjectCard('🔤', isUrdu ? 'انگریزی فونکس اور حروف' : 'English Phonics & ABCs', isUrdu ? 'حروف کی آوازیں' : 'A-Z Sounds & Alphabets', 0.0, '0%', const Color(0xFFC2E8FF), const Color(0xFF2BB0E6)),
          _buildSubjectCard('🌙', isUrdu ? 'اردو حروف (الف، ب، پ)' : 'Urdu Haroof (الف، ب، پ)', isUrdu ? 'حروف تہجی' : 'Haroof-e-Tahaji', 0.0, '0%', const Color(0xFF73FDA3), const Color(0xFF24BC6B)),
          _buildSubjectCard('🔢', isUrdu ? 'اعداد اور گنتی' : 'Numbers & Counting', isUrdu ? 'اعداد 1-20' : 'Numbers 1–20', 0.0, '0%', const Color(0xFFFFDDB6), const Color(0xFFFFAA1D)),
          _buildSubjectCard('✏️', isUrdu ? 'انگلیوں سے لکیریں بنانا' : 'Finger Tracing & Strokes', isUrdu ? 'حروف اور لکیریں' : 'Letters & Curves', 0.0, '0%', const Color(0xFFFFDAD6), const Color(0xFFBA1A1A)),
          _buildSubjectCard('🎵', isUrdu ? 'بچوں کے نغمے اور نظمیں' : 'Nursery Rhymes & Songs', isUrdu ? 'شاعری اور دُھنیں' : 'Poetry & Melodies', 0.0, '0%', const Color(0xFFE4E2DD), const Color(0xFF006689)),
          _buildSubjectCard('🧸', isUrdu ? 'چھوٹے کھیل اور سرگرمیاں' : 'Mini Games & Activities', isUrdu ? 'اشکال کا کھیل' : 'Geometric Shapes & Sorting', 0.0, '0%', const Color(0xFFFFB958), const Color(0xFF845400)),
          _buildSubjectCard('🤲', isUrdu ? 'اسلامی دعائیں اور آداب' : 'Islamic Duas & Manners', isUrdu ? 'دعائیں اور آداب' : 'Bedtime Dua & Table Etiquette', 0.0, '0%', const Color(0xFF53DF8a), const Color(0xFF006D39)),

          const SizedBox(height: 16),

          // Download PDF Report Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0EEE8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: const Color(0xFF006689), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.picture_as_pdf, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isUrdu ? 'ہفتہ وار تعلیمی رپورٹ (PDF)' : 'Weekly Learning Report (PDF)',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                          ),
                          Text(
                            isUrdu ? 'تفصیلی رپورٹ اور خلاصہ' : 'Detailed phonics & screen duration summary',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF3E484F)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF006689),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                    ),
                    icon: const Icon(Icons.download, size: 18),
                    label: Text(
                      isUrdu ? 'PDF ڈاؤن لوڈ کریں' : 'Download PDF',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // --- 4. Safety Tab ---
  Widget _buildSafetyTab(bool isUrdu) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isUrdu ? 'والدین کی حفاظتی ترتیبات' : 'Parental Safety & Screen Time',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
          ),
          const SizedBox(height: 10),
          Text(
            isUrdu
                ? 'یہاں سے آپ اپنے بچے کا یومیہ اسکرین ٹائم اور پن (PIN) محفوظ کر سکتے ہیں۔'
                : 'Manage daily screen time limits and secure your app with a parent PIN.',
            style: const TextStyle(color: Color(0xFF3E484F), fontSize: 13),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.lock_outline, color: Color(0xFF006689)),
                    const SizedBox(width: 12),
                    Text(
                      isUrdu ? 'پیرنٹ پن سیٹ کریں' : 'Set Parent PIN',
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(
    String emoji,
    String title,
    String subtitle,
    double progress,
    String percent,
    Color iconBg,
    Color progressColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
                    alignment: Alignment.center,
                    child: Text(emoji, style: const TextStyle(fontSize: 18)),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                      Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF3E484F))),
                    ],
                  ),
                ],
              ),
              Text(percent, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: progressColor)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFEAE8E2),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}