import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class CountingDatabaseHelper {
  static final CountingDatabaseHelper instance = CountingDatabaseHelper._init();
  static Database? _database;

  CountingDatabaseHelper._init();

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
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user_progress (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            activity_name TEXT NOT NULL,
            stars_earned INTEGER NOT NULL,
            timestamp TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertProgress(String activityName, int stars) async {
    final db = await instance.database;
    return await db.insert('user_progress', {
      'activity_name': activityName,
      'stars_earned': stars,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}

class CountingObjectsScreen extends StatefulWidget {
  const CountingObjectsScreen({Key? key}) : super(key: key);

  @override
  State<CountingObjectsScreen> createState() => _CountingObjectsScreenState();
}

class _CountingObjectsScreenState extends State<CountingObjectsScreen> {
  final FlutterTts flutterTts = FlutterTts();
  String currentLevel = 'PG';
  int currentNumber = 3;
  String currentTheme = 'apples';
  String currentLanguage = 'en';
  int tappedCount = 0;
  bool isAutoCounting = false;
  String? toastMessage;
  bool showToastFlag = false;

  final List<String> urduNumerals = [
    "۰", "۱", "۲", "۳", "۴", "۵", "۶", "۷", "۸", "۹", "۱۰", 
    "۱۱", "۱۲", "۱۳", "۱۴", "۱۵", "۱۶", "۱۷", "۱۸", "۱۹", "۲۰"
  ];

  final List<String> numberNamesEn = [
    "Zero", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten",
    "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen", "Twenty"
  ];

  final List<String> numberNamesUr = [
    "صفر", "ایک", "دو", "تین", "چار", "پانچ", "چھ", "سات", "آٹھ", "نو", "دس",
    "گیارہ", "بارہ", "تیرہ", "چودہ", "پندرہ", "سولہ", "سترہ", "اٹھارہ", "انیس", "بیس"
  ];

  final Map<String, Map<String, String>> themeData = {
    'apples': {'emoji': '🍎', 'en': 'Apple', 'ur': 'سیب'},
    'stars': {'emoji': '⭐', 'en': 'Star', 'ur': 'ستارہ'},
    'balloons': {'emoji': '🎈', 'en': 'Balloon', 'ur': 'غبارہ'},
    'berries': {'emoji': '🍓', 'en': 'Berry', 'ur': 'سٹرابیری'},
  };

  int get maxNumber => currentLevel == 'PG' ? 10 : 20;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.1);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future<void> _saveProgressToDB(String activity, int stars) async {
    try {
      await CountingDatabaseHelper.instance.insertProgress(activity, stars);
    } catch (e) {}
  }

  void _showToast(String message) async {
    await flutterTts.speak(message);
    setState(() {
      toastMessage = message;
      showToastFlag = true;
    });
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) setState(() => showToastFlag = false);
    });
  }

  void _handleObjectTap(int index) {
    if (index > tappedCount + 1 || isAutoCounting) return;
    setState(() {
      tappedCount = index;
    });

    String spokenText = currentLanguage == 'ur' ? numberNamesUr[index] : numberNamesEn[index];
    _showToast(spokenText);

    if (tappedCount == currentNumber) {
      _saveProgressToDB('Counting Objects Task Completed', 1);
      _showToast(currentLanguage == 'ur' ? '🎉 شاباش!' : '🎉 Great!');
    }
  }

  void _startAutoCount() async {
    if (isAutoCounting) return;
    setState(() {
      isAutoCounting = true;
      tappedCount = 0;
    });

    for (int i = 1; i <= currentNumber; i++) {
      if (!mounted || !isAutoCounting) break;
      
      setState(() {
        tappedCount = i;
      });

      String spokenText = currentLanguage == 'ur' ? numberNamesUr[i] : numberNamesEn[i];
      
      setState(() {
        toastMessage = spokenText;
        showToastFlag = true;
      });

      await flutterTts.speak(spokenText);
      
      if (mounted) setState(() => showToastFlag = false);
      await Future.delayed(const Duration(milliseconds: 350));
    }

    if (mounted && isAutoCounting) {
      setState(() {
        isAutoCounting = false;
      });
      _saveProgressToDB('Counting Objects Task Completed', 1);
    }
  }

  void _resetCount() {
    if (isAutoCounting) return;
    setState(() {
      tappedCount = 0;
    });
  }

  @override
  void dispose() {
    isAutoCounting = false;
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isUrdu = currentLanguage == 'ur';
    var th = themeData[currentTheme]!;

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
                  backgroundColor: const Color(0xFFFBF9F3).withOpacity(0.9),
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
                                onTap: () {
                                  if (!isAutoCounting) Navigator.maybePop(context);
                                },
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF0EEE8),
                                    shape: BoxShape.circle,
                                    boxShadow: [BoxShadow(color: Color(0xFFBDC8D0), offset: Offset(0, 3))],
                                  ),
                                  alignment: Alignment.center,
                                  child: const Icon(Icons.arrow_back_ios_new, size: 20, color: Color(0xFF1B1C19)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    isUrdu ? 'اشیاء کے ساتھ گنتی 🍎' : 'Counting with Objects 🍎',
                                    style: const TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                                  ),
                                  Text(
                                    isUrdu ? 'چھوئیں، گنیں اور سیکھیں!' : 'Touch, Count & Learn!',
                                    style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF006689)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          // Star counter completely removed and replaced with clean offline-friendly 🔢 emoji badge
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: const Color(0xFFC2E8FF),
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFF006689), width: 2),
                              boxShadow: const [BoxShadow(color: Color(0xFF78d1ff), offset: Offset(0, 2))],
                            ),
                            alignment: Alignment.center,
                            child: const Text('🔢', style: TextStyle(fontSize: 18)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              body: Directionality(
                textDirection: isUrdu ? TextDirection.rtl : TextDirection.ltr,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 40),
                      child: Column(
                        children: [
                          Center(
                            child: InkWell(
                              onTap: () {
                                if (!isAutoCounting) {
                                  setState(() {
                                    currentLanguage = currentLanguage == 'en' ? 'ur' : 'en';
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: const [BoxShadow(color: Color(0xFFBDC8D0), offset: Offset(0, 3))],
                                  border: Border.all(color: const Color(0xFFBDC8D0).withOpacity(0.3)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.language, size: 18, color: Color(0xFF006689)),
                                    const SizedBox(width: 6),
                                    Text(
                                      currentLanguage == 'en' ? 'English ⇄ اردو' : 'اردو ⇄ English',
                                      style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF006689)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F3EE),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      if (!isAutoCounting) {
                                        setState(() {
                                          currentLevel = 'PG';
                                          if (currentNumber > 10) currentNumber = 10;
                                          tappedCount = 0;
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                        color: currentLevel == 'PG' ? const Color(0xFFFFAA1D) : Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        isUrdu ? '👶 پی جی: ۱-۱۰' : '👶 PG: 1–10',
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: currentLevel == 'PG' ? const Color(0xFF2A1800) : const Color(0xFF3E484F),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      if (!isAutoCounting) {
                                        setState(() {
                                          currentLevel = 'KG';
                                          tappedCount = 0;
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      decoration: BoxDecoration(
                                        color: currentLevel == 'KG' ? const Color(0xFFFFAA1D) : Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        isUrdu ? '🎒 کے جی: ۱-۲۰' : '🎒 KG: 1–20',
                                        style: TextStyle(
                                          fontFamily: 'Rubik',
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: currentLevel == 'KG' ? const Color(0xFF2A1800) : const Color(0xFF3E484F),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: const [BoxShadow(color: Color(0x1440352C), offset: Offset(0, 8), blurRadius: 20)],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFFDDb6),
                                    shape: BoxShape.circle,
                                    boxShadow: [BoxShadow(color: Color(0xFFFFAA1D), offset: Offset(0, 4))],
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text('🐤', style: TextStyle(fontSize: 28)),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            isUrdu ? 'پپ دی متھ بڑی' : 'PIP THE MATH BUDDY',
                                            style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF845400)),
                                          ),
                                          const SizedBox(width: 4),
                                          const Text('✨', style: TextStyle(fontSize: 11)),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        isUrdu 
                                          ? 'آؤ مل کر ${urduNumerals[currentNumber]} ${th['ur']} گنیں! ہر ایک پر انگلی لگائیں! ${th['emoji']}✨'
                                          : 'Let\'s count ${currentNumber} ${th['en']}s together! Tap each one! ${th['emoji']}✨',
                                        style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () => _showToast(isUrdu ? 'آؤ گنیں!' : 'Let\'s count together!'),
                                  child: Container(
                                    width: 42,
                                    height: 42,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF2BB0E6),
                                      shape: BoxShape.circle,
                                      boxShadow: [BoxShadow(color: Color(0xFF004d68), offset: Offset(0, 3))],
                                    ),
                                    alignment: Alignment.center,
                                    child: const Icon(Icons.volume_up, color: Colors.white, size: 22),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: const [BoxShadow(color: Color(0x1440352C), offset: Offset(0, 8), blurRadius: 24)],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFC2E8FF),
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: Text(
                                            isUrdu ? urduNumerals[currentNumber] : '$currentNumber',
                                            style: const TextStyle(fontFamily: 'Rubik', fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF003F57)),
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              isUrdu ? numberNamesUr[currentNumber] : numberNamesEn[currentNumber],
                                              style: const TextStyle(fontFamily: 'Rubik', fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF845400)),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              isUrdu 
                                                ? 'نمبر ${urduNumerals[currentNumber]} از ${urduNumerals[maxNumber]}' 
                                                : 'Item $currentNumber of $maxNumber',
                                              style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF006689)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFFFAA1D),
                                        foregroundColor: const Color(0xFF2A1800),
                                        elevation: 2,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      ),
                                      onPressed: () => _showToast(isUrdu ? numberNamesUr[currentNumber] : numberNamesEn[currentNumber]),
                                      icon: const Icon(Icons.record_voice_over, size: 18),
                                      label: Text(isUrdu ? 'سنیں' : 'Hear', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F3EE),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  child: Row(
                                    children: [
                                      _buildThemeTab('apples', '🍎 Apples', '🍎 سیب'),
                                      _buildThemeTab('stars', '⭐ Stars', '⭐ ستارے'),
                                      _buildThemeTab('balloons', '🎈 Balloons', '🎈 غبارے'),
                                      _buildThemeTab('berries', '🍓 Berries', '🍓 سٹرابیری'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: const [BoxShadow(color: Color(0x1440352C), offset: Offset(0, 8), blurRadius: 24)],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      isUrdu ? 'ترتیب سے چھوئیں:' : 'Tap in order:',
                                      style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF73FDA3).withOpacity(0.4),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        isUrdu 
                                          ? '${urduNumerals[tappedCount]} از ${urduNumerals[currentNumber]} گن لیے'
                                          : '$tappedCount of $currentNumber tapped',
                                        style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF00522A)),
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: _resetCount,
                                      icon: const Icon(Icons.refresh, size: 16),
                                      label: Text(isUrdu ? 'دوبارہ' : 'Restart', style: const TextStyle(fontFamily: 'Rubik', fontSize: 12)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  alignment: WrapAlignment.center,
                                  children: List.generate(currentNumber, (index) {
                                    int itemNum = index + 1;
                                    bool isTapped = itemNum <= tappedCount;
                                    return InkWell(
                                      onTap: () => _handleObjectTap(itemNum),
                                      child: Container(
                                        width: 68,
                                        height: 68,
                                        decoration: BoxDecoration(
                                          color: isTapped ? const Color(0xFF73FDA3).withOpacity(0.3) : const Color(0xFFF5F3EE),
                                          borderRadius: BorderRadius.circular(18),
                                          border: Border.all(
                                            color: isTapped ? const Color(0xFF006D39) : Colors.transparent,
                                            width: 2,
                                          ),
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Text(th['emoji']!, style: const TextStyle(fontSize: 32)),
                                            Positioned(
                                              top: 4,
                                              right: 4,
                                              child: Container(
                                                width: 20,
                                                height: 20,
                                                decoration: BoxDecoration(
                                                  color: isTapped ? const Color(0xFF006D39) : const Color(0xFFFFAA1D),
                                                  shape: BoxShape.circle,
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  isUrdu ? urduNumerals[itemNum] : '$itemNum',
                                                  style: const TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: const [BoxShadow(color: Color(0x1440352C), offset: Offset(0, 8), blurRadius: 24)],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFF0EEE8),
                                        foregroundColor: const Color(0xFF1B1C19),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      ),
                                      onPressed: (currentNumber > 1 && !isAutoCounting) ? () {
                                        setState(() {
                                          currentNumber--;
                                          tappedCount = 0;
                                        });
                                      } : null,
                                      icon: const Icon(Icons.arrow_back, size: 16),
                                      label: Text(isUrdu ? 'پچھلا' : 'Prev', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFFFAA1D),
                                        foregroundColor: const Color(0xFF2A1800),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      ),
                                      onPressed: isAutoCounting ? null : _startAutoCount,
                                      child: Text(isUrdu ? 'خودکار گنتی' : 'Auto Count', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
                                    ),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF006689),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                      ),
                                      onPressed: (currentNumber < maxNumber && !isAutoCounting) ? () {
                                        setState(() {
                                          currentNumber++;
                                          tappedCount = 0;
                                        });
                                      } : null,
                                      label: Text(isUrdu ? 'اگلا' : 'Next', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold)),
                                      icon: const Icon(Icons.arrow_forward, size: 16),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 44,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: maxNumber,
                                    itemBuilder: (context, index) {
                                      int num = index + 1;
                                      bool isSelected = num == currentNumber;
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                        child: InkWell(
                                          onTap: () {
                                            if (!isAutoCounting) {
                                              setState(() {
                                                currentNumber = num;
                                                tappedCount = 0;
                                              });
                                            }
                                          },
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: isSelected ? const Color(0xFFFFAA1D) : const Color(0xFFF5F3EE),
                                              shape: BoxShape.circle,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              isUrdu ? urduNumerals[num] : '$num',
                                              style: TextStyle(
                                                fontFamily: 'Rubik',
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: isSelected ? const Color(0xFF2A1800) : const Color(0xFF1B1C19),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isUrdu ? '♡ ۱۰۰٪ محفوظ • بچوں کے لیے پرسکون ماحول • ونڈر کڈز v2.4' : '♡ 100% Safe • Ad-Free Kids Zone • WonderKids Math v2.4',
                            style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, color: Color(0xFF6E7980)),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    if (showToastFlag)
                      Positioned(
                        top: 85,
                        left: 20,
                        right: 20,
                        child: Center(
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF30312D),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10)],
                              ),
                              child: Text(
                                toastMessage ?? '',
                                style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold, color: Color(0xFFF2F1EB), fontSize: 13),
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
      ),
    );
  }

  Widget _buildThemeTab(String key, String enLabel, String urLabel) {
    bool isSelected = currentTheme == key;
    bool isUrdu = currentLanguage == 'ur';
    return Expanded(
      child: InkWell(
        onTap: () {
          if (!isAutoCounting) {
            setState(() => currentTheme = key);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            isUrdu ? urLabel : enLabel,
            style: TextStyle(
              fontFamily: 'Rubik',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isSelected ? const Color(0xFF1B1C19) : const Color(0xFF3E484F),
            ),
          ),
        ),
      ),
    );
  }
}