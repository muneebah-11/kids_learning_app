import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'counting_objects_screen.dart';
import 'find_numbers_screen.dart';
import 'tracing_write_screen.dart';
void main() {
  runApp(const NumbersMathApp());
}

class NumbersMathApp extends StatelessWidget {
  const NumbersMathApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Numbers & Math - WonderKids',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFBF9F3),
        fontFamily: 'Rubik',
      ),
      home: const NumbersMathScreen(),
    );
  }
}

// ==========================================
// LOCAL DATABASE HELPER FOR NUMBERS MODULE
// ==========================================
class NumbersDatabaseHelper {
  static final NumbersDatabaseHelper instance = NumbersDatabaseHelper._init();
  static Database? _database;

  NumbersDatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('wonderkids_numbers.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        activity_name TEXT NOT NULL,
        stars_earned INTEGER NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertProgress(String activityName, int stars) async {
    final db = await instance.database;
    return await db.insert('user_progress', {
      'activity_name': activityName,
      'stars_earned': stars,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  Future<int> getTotalStars() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT SUM(stars_earned) as total FROM user_progress');
    if (result.isNotEmpty && result.first['total'] != null) {
      return Sqflite.firstIntValue(result) ?? 0;
    }
    return 0; // Default set to 0
  }
}

class NumbersMathScreen extends StatefulWidget {
  const NumbersMathScreen({Key? key}) : super(key: key);

  @override
  State<NumbersMathScreen> createState() => _NumbersMathScreenState();
}

class _NumbersMathScreenState extends State<NumbersMathScreen> {
  final FlutterTts flutterTts = FlutterTts();
  int starCount = 0; // Initialized to 0 as requested
  int basketCount = 0;
  String? toastMessage;
  bool showToastFlag = false;
  
  final List<bool> packedItems = [false, false, false, false, false];

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadUserProgressFromDB();
  }

  void _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.1);
    await flutterTts.setSpeechRate(0.45);
    await flutterTts.setVolume(1.0);
  }

  Future<void> _loadUserProgressFromDB() async {
    try {
      int total = await NumbersDatabaseHelper.instance.getTotalStars();
      if (mounted) {
        setState(() {
          starCount = total;
        });
      }
    } catch (e) {
      // Fallback
    }
  }

  Future<void> _saveProgressToDB(String activity, int stars) async {
    try {
      await NumbersDatabaseHelper.instance.insertProgress(activity, stars);
    } catch (e) {
      // Handle DB error quietly
    }
  }

  void _showJoyToast(String message) async {
    await flutterTts.speak(message);
    setState(() {
      toastMessage = message;
      showToastFlag = true;
    });
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        setState(() {
          showToastFlag = false;
        });
      }
    });
  }

  void _handleActivityClick(String title, String emoji, int reward) {
    setState(() {
      starCount += reward;
    });
    _saveProgressToDB(title, reward);
    _showJoyToast('Launching $title! Plus $reward stars');
  }

  void _packItem(int index, String emoji) {
    if (packedItems[index]) return;

    setState(() {
      packedItems[index] = true;
      basketCount++;
    });

    _showJoyToast('Packed 1 item');

    if (basketCount >= 5) {
      _showJoyToast('You earned 10 Stars!');
      setState(() {
        starCount += 10;
      });
      _saveProgressToDB('Drag & Drop Basket', 10);

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            basketCount = 0;
            for (int i = 0; i < packedItems.length; i++) {
              packedItems[i] = false;
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFECE6),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFBF9F3),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 15)],
            ),
            child: Scaffold(
              backgroundColor: const Color(0xFFFBF9F3),
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(80),
                child: AppBar(
                  backgroundColor: const Color(0xFFFBF9F3).withOpacity(0.85),
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  flexibleSpace: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () => Navigator.maybePop(context),
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [BoxShadow(color: Color(0xFFE4E2DD), offset: Offset(0, 3))],
                                  ),
                                  child: const Icon(Icons.arrow_back, color: Color(0xFF1B1C19), size: 22),
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Numbers & Math 🔢',
                                    style: TextStyle(
                                      fontFamily: 'Rubik',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1B1C19),
                                    ),
                                  ),
                                  Text(
                                    'Explore & Play with Numbers!',
                                    style: TextStyle(
                                      fontFamily: 'Nunito Sans',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF3E484F),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [BoxShadow(color: Color(0xFFEAE8E2), offset: Offset(0, 2))],
                                ),
                                child: Row(
                                  children: [
                                    const Text('⭐', style: TextStyle(fontSize: 13)),
                                    const SizedBox(width: 4),
                                    Text(
                                      '$starCount',
                                      style: const TextStyle(
                                        fontFamily: 'Rubik',
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF845400),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF006689),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: const Icon(Icons.person, color: Colors.white, size: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
                    child: Column(
                      children: [
                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 0.72,
                          children: [
                            // Card 1: Counting Objects
                            // Card 1: Counting Objects
_buildActivityCard(
  cardBgColor: const Color(0xFFE2F6EC),
  badgeText: '1–30 Range',
  badgeColor: const Color(0xFF73FDA3),
  badgeTextColor: const Color(0xFF00210D),
  topEmoji: '🍎',
  visualContent: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      _buildNumBlock('1', const Color(0xFF2BB0E6), const Color(0xFF006689)),
      const SizedBox(width: 4),
      _buildNumBlock('2', const Color(0xFFFFAA1D), const Color(0xFF6A4300)),
      const SizedBox(width: 4),
      _buildNumBlock('3', const Color(0xFF24BC6B), const Color(0xFF004422)),
    ],
  ),
  title: 'Counting Objects',
  subtitle: 'Touch & count fruits',
  buttonText: 'Start',
  buttonIcon: Icons.play_arrow,
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CountingObjectsScreen(),
      ),
    );
  },
),
                            // Card 2: Find Numbers
                            // Card 2: Find Numbers
_buildActivityCard(
  cardBgColor: const Color(0xFFDCEBFA),
  badgeText: 'Fun Quiz',
  badgeColor: const Color(0xFFC2E8FF),
  badgeTextColor: const Color(0xFF001E2C),
  topEmoji: '🔢',
  visualContent: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF006689),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Color(0xFF004D68), offset: Offset(0, 3))],
        ),
        alignment: Alignment.center,
        child: const Text('7', style: TextStyle(fontFamily: 'Rubik', fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    ],
  ),
  title: 'Find Numbers',
  subtitle: 'Identify & match',
  buttonText: 'Play',
  buttonIcon: Icons.sports_esports,
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FindNumbersQuizScreen()),
    );
  },
),
                            // Card 3: Tracing & Write (Light Pink)
// Card 3: Tracing & Write (Light Pink)
_buildActivityCard(
  cardBgColor: const Color(0xFFFDE8EE),
  badgeText: 'PG & KG',
  badgeColor: const Color(0xFFFFDDB6),
  badgeTextColor: const Color(0xFF2A1800),
  topEmoji: '✍️',
  visualContent: Stack(
    alignment: Alignment.center,
    children: [
      const Text(
        '3',
        style: TextStyle(fontFamily: 'Rubik', fontSize: 44, fontWeight: FontWeight.w900, color: Color(0xFFBDC8D0)),
      ),
      Positioned(
        right: 12,
        top: 14,
        child: Container(
          width: 26,
          height: 26,
          decoration: const BoxDecoration(
            color: Color(0xFF845400),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.edit, color: Colors.white, size: 14),
        ),
      ),
    ],
  ),
  title: 'Tracing & Write',
  subtitle: 'Dotted line guides',
  buttonText: 'Trace',
  buttonIcon: Icons.brush,
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TracingWriteScreen()),
    );
  },
),
                            // Card 4: Match Puzzle
                            _buildActivityCard(
                              cardBgColor: const Color(0xFFEFECEF),
                              badgeText: 'Puzzles',
                              badgeColor: const Color(0xFFE4E2DD),
                              badgeTextColor: const Color(0xFF3E484F),
                              topEmoji: '🎯',
                              visualContent: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF006D39),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text('4', style: TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward, color: Color(0xFF6E7980), size: 16),
                                  const SizedBox(width: 8),
                                  const Text('🎈🎈', style: TextStyle(fontSize: 14)),
                                ],
                              ),
                              title: 'Match Puzzle',
                              subtitle: 'Group & numbers',
                              buttonText: 'Match',
                              buttonIcon: Icons.extension,
                              onPressed: () => _handleActivityClick('Match Puzzle', '🎯', 5),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Card 5: Drag & Drop Counting
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAF3DC),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: const [BoxShadow(color: Color(0x1040352C), offset: Offset(0, 6), blurRadius: 18)],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Row(
                                    children: [
                                      const Text('🎈', style: TextStyle(fontSize: 22)),
                                      const SizedBox(width: 8),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            'Drag & Drop Counting',
                                            style: TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                                          ),
                                          Text(
                                            'Tap or drop items into the basket!',
                                            style: TextStyle(fontFamily: 'Nunito Sans', fontSize: 13, color: Color(0xFF3E484F)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFDDB6),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Text(
                                      'Interactive',
                                      style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2A1800)),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5F3EE),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Row(
                                          children: const [
                                            Icon(Icons.touch_app, size: 16, color: Color(0xFF006689)),
                                            SizedBox(width: 4),
                                            Text('Tap items to pack:', style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF3E484F))),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Row(
                                            children: [
                                              const Text('Basket: ', style: TextStyle(fontFamily: 'Rubik', fontSize: 12, color: Color(0xFF845400))),
                                              Text('$basketCount', style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF845400))),
                                              const Text(' / 5', style: TextStyle(fontFamily: 'Rubik', fontSize: 12, color: Color(0xFF6E7980))),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildDropItemBtn(0, '⭐'),
                                        _buildDropItemBtn(1, '🎈'),
                                        _buildDropItemBtn(2, '🍎'),
                                        _buildDropItemBtn(3, '🍓'),
                                        _buildDropItemBtn(4, '🚀'),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 14),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFFAA1D),
                                  foregroundColor: const Color(0xFF2A1800),
                                  minimumSize: const Size(double.infinity, 54),
                                  elevation: 3,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                                ),
                                onPressed: () => _handleActivityClick('Drop & Learn Adventure', '🧺', 10),
                                child:const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text('Drop & Learn Adventure', style: TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.bold)),
                                    SizedBox(width: 8),
                                    Icon(Icons.rocket_launch, size: 20),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (showToastFlag)
                    Positioned(
                      top: 70,
                      left: 20,
                      right: 20,
                      child: Center(
                        child: Material(
                          color: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFAA1D),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
                            ),
                            child: Text(
                              toastMessage ?? '',
                              style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold, color: Color(0xFF2A1800), fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityCard({
    required Color cardBgColor,
    required String badgeText,
    required Color badgeColor,
    required Color badgeTextColor,
    required String topEmoji,
    required Widget visualContent,
    required String title,
    required String subtitle,
    required String buttonText,
    required IconData buttonIcon,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Color(0x1040352C), offset: Offset(0, 6), blurRadius: 16)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(12)),
                child: Text(badgeText, style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: badgeTextColor)),
              ),
              Text(topEmoji, style: const TextStyle(fontSize: 16)),
            ],
          ),
          Container(
            height: 72,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.7), borderRadius: BorderRadius.circular(16)),
            alignment: Alignment.center,
            child: visualContent,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)), maxLines: 1),
              const SizedBox(height: 2),
              Text(subtitle, style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, color: Color(0xFF3E484F)), maxLines: 1),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFAA1D),
              foregroundColor: const Color(0xFF2A1800),
              minimumSize: const Size(double.infinity, 42),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
            ),
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(buttonText, style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(width: 4),
                Icon(buttonIcon, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumBlock(String text, Color bgColor, Color shadowColor) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: shadowColor, offset: const Offset(0, 2))],
      ),
      alignment: Alignment.center,
      child: Text(text, style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
    );
  }

  Widget _buildDropItemBtn(int index, String emoji) {
    bool isPacked = packedItems[index];
    return InkWell(
      onTap: () => _packItem(index, emoji),
      child: Opacity(
        opacity: isPacked ? 0.3 : 1.0,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(color: Color(0xFFEAE8E2), offset: Offset(0, 3))],
          ),
          alignment: Alignment.center,
          child: Text(emoji, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}