import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

void main() {
  runApp(const KalmaScreenApp());
}

class KalmaScreenApp extends StatelessWidget {
  const KalmaScreenApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalmas Learning Hub - WonderKids',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFBF9F3),
        fontFamily: 'Rubik',
      ),
      home: const KalmaScreen(),
    );
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('wonderkids_kalmas.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS kalmas_progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        kalma_id INTEGER,
        stars_earned INTEGER
      )
    ''');
  }

  Future<int> saveProgress(int kalmaId, int stars) async {
    final db = await instance.database;
    return await db.insert('kalmas_progress', {
      'kalma_id': kalmaId,
      'stars_earned': stars,
    });
  }

  Future<int> getTotalStars() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT SUM(stars_earned) as total FROM kalmas_progress');
    if (result.isNotEmpty && result.first['total'] != null) {
      return int.parse(result.first['total'].toString());
    }
    return 0;
  }
}

class KalmaModel {
  final int id;
  final int num;
  final String nameEn;
  final String nameUr;
  final String subEn;
  final String subUr;
  final String arabic;
  final String engTrans;
  final String urduTrans;
  final int stars;
  final String duration;
  final String imagePath;
  final String stage; // 'pg' | 'kg'

  const KalmaModel({
    required this.id,
    required this.num,
    required this.nameEn,
    required this.nameUr,
    required this.subEn,
    required this.subUr,
    required this.arabic,
    required this.engTrans,
    required this.urduTrans,
    required this.stars,
    required this.duration,
    required this.imagePath,
    required this.stage,
  });
}

class KalmaScreen extends StatefulWidget {
  const KalmaScreen({Key? key}) : super(key: key);

  @override
  State<KalmaScreen> createState() => _KalmaScreenState();
}

class _KalmaScreenState extends State<KalmaScreen> {
  String currentStage = 'pg'; // 'pg' | 'kg'
  bool currentLangUrdu = false;
  int totalStars = 13;

  final Set<int> claimedRewards = {};
  late FlutterTts flutterTts;

  final List<KalmaModel> kalmasList = const [
    KalmaModel(
      id: 1,
      num: 1,
      nameEn: 'First Kalma (Kalma Tayyab)',
      nameUr: 'کلمہ طیب',
      subEn: 'Foundation of Faith',
      subUr: 'بنیادی ایمان',
      arabic: 'لَا إِلٰهَ إِلَّا اللّٰهُ مُحَمَّدٌ رَّسُولُ اللّٰهِ',
      engTrans: 'There is no deity except Allah; Muhammad is the Messenger of Allah.',
      urduTrans: 'اللہ کے سوا کوئی معبود نہیں، محمد صلی اللہ علیہ وسلم اللہ کے رسول ہیں۔',
      stars: 1,
      duration: '0:09',
      imagePath: 'assets/images/kalma_1.png',
      stage: 'pg',
    ),
    KalmaModel(
      id: 2,
      num: 2,
      nameEn: 'Second Kalma (Kalma Shahadat)',
      nameUr: 'کلمہ شہادت',
      subEn: 'Bearing True Witness',
      subUr: 'گواہی کا کلمہ',
      arabic: 'أَشْهَدُ أَنْ لَّا إِلٰهَ إِلَّا اللّٰهُ وَحْدَهُ لَا شَرِیکَ لَهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ',
      engTrans: 'I bear witness that there is no deity except Allah, alone without partner, and I bear witness that Muhammad is His servant and Messenger.',
      urduTrans: 'میں گواہی دیتا ہوں کہ اللہ کے سوا کوئی معبود نہیں، وہ اکیلا ہے، اور محمد اس کے بندے اور رسول ہیں۔',
      stars: 1,
      duration: '0:14',
      imagePath: 'assets/images/kalma_2.png',
      stage: 'pg',
    ),
    KalmaModel(
      id: 3,
      num: 3,
      nameEn: 'Third Kalma (Kalma Tamjeed)',
      nameUr: 'کلمہ تمجید',
      subEn: 'Glorification of Allah',
      subUr: 'بزرگی اور حمد کا کلمہ',
      arabic: 'سُبْحَانَ اللّٰهِ وَالْحَمْدُ لِلّٰهِ وَلَا إِلٰهَ إِلَّا اللّٰهُ وَاللّٰهُ أَكْبَرُ، وَلَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللّٰهِ الْعَلِيِّ الْعَظِيمِ',
      engTrans: 'Glory be to Allah, and all praise is for Allah, and there is no deity but Allah, and Allah is the Greatest...',
      urduTrans: 'اللہ پاک ہے اور سب تعریفیں اللہ کے لیے ہیں اور اللہ کے سوا کوئی معبود نہیں اور اللہ سب سے بڑا ہے۔',
      stars: 1,
      duration: '0:18',
      imagePath: 'assets/images/kalma_3.png',
      stage: 'pg',
    ),
    KalmaModel(
      id: 4,
      num: 4,
      nameEn: 'Fourth Kalma (Kalma Tauheed)',
      nameUr: 'کلمہ توحید',
      subEn: 'Oneness of the Creator',
      subUr: 'اللہ کی یکتائی',
      arabic: 'لَا إِلٰهَ إِلَّا اللّٰهُ وَحْدَهُ لَا شَرِیکَ لَہٗ، لَہُ الْمُلْکُ وَلَہُ الْحَمْدُ، یُحْیِی وَیُمِیتُ، وَھُوَ حَیٌّ لَّا یَمُوتُ أَبَدًا أَبَدًا',
      engTrans: 'There is none worthy of worship except Allah. He is only One without partner...',
      urduTrans: 'اللہ کے سوا کوئی معبود نہیں، وہ اکیلا ہے، اس کا کوئی شریک نہیں، اسی کی بادشاہی ہے...',
      stars: 2,
      duration: '0:24',
      imagePath: 'assets/images/kalma_4.png',
      stage: 'kg',
    ),
    KalmaModel(
      id: 5,
      num: 5,
      nameEn: 'Fifth Kalma (Kalma Astaghfar)',
      nameUr: 'کلمہ استغفار',
      subEn: 'Seeking Pure Forgiveness',
      subUr: 'توبہ اور بخشش',
      arabic: 'أَسْتَغْفِرُ اللّٰهَ رَبِّي مِنْ كُلِّ ذَنْبٍ أَذْنَبْتُهُ عَمْدًا أَوْ خَطَأً سِرًّا أَوْ عَلَانِيَةً',
      engTrans: 'I seek forgiveness from Allah, my Lord, from every sin I committed knowingly or unknowingly...',
      urduTrans: 'میں اللہ سے بخشش مانگتا ہوں جو میرا رب ہے، ہر گناہ سے جو میں نے جان بوجھ کر یا بھول کر کیا...',
      stars: 2,
      duration: '0:28',
      imagePath: 'assets/images/kalma_5.png',
      stage: 'kg',
    ),
    KalmaModel(
      id: 6,
      num: 6,
      nameEn: 'Sixth Kalma (Kalma Radd-e-Kufr)',
      nameUr: 'کلمہ رد کفر',
      subEn: 'Protection from Denial',
      subUr: 'حفاظت اور دینِ حق',
      arabic: 'اَللّٰهُمَّ إِنِّي أَعُوْذُ بِكَ مِنْ أَنْ أُشْرِكَ بِكَ شَيْئًا وَّأَنَا أَعْلَمُ بِهِ',
      engTrans: 'O Allah! I seek protection in You from that I should join any partner with You knowingly...',
      urduTrans: 'اے اللہ! میں تیری پناہ مانگتا ہوں اس بات سے کہ میں جانتے بوجھتے کسی چیز کو تیرا شریک ٹھہراؤں...',
      stars: 2,
      duration: '0:32',
      imagePath: 'assets/images/kalma_6.png',
      stage: 'kg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
    _loadInitialStars();
  }

  Future<void> _initTts() async {
    flutterTts = FlutterTts();
    await flutterTts.setLanguage("ar-SA");
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  Future<void> _loadInitialStars() async {
    int savedStars = await DatabaseHelper.instance.getTotalStars();
    setState(() {
      if (savedStars > 0) totalStars = 13 + savedStars;
    });
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Text('⭐', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF30312D),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(milliseconds: 2200),
      ),
    );
  }

  Future<void> _speakKalma(String arabicText) async {
    await flutterTts.stop();
    await flutterTts.setLanguage("ar-SA");
    await flutterTts.speak(arabicText);
  }

  Future<void> _stopSpeech() async {
    await flutterTts.stop();
  }

  void _openFullRecitationModal(KalmaModel kalma) {
    _speakKalma(kalma.arabic);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        bool modalUrdu = false;
        bool isPlaying = true;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.88,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color(0xFFFBF9F3),
                borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE4E2DD),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: const BoxDecoration(
                              color: Color(0xFFC2E8FF),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${kalma.num}',
                              style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold, color: Color(0xFF004D68)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                kalma.nameEn,
                                style: const TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1B1C19)),
                              ),
                              Text(
                                '${kalma.nameUr} • ${kalma.subEn}',
                                style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {
                          _stopSpeech();
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close, color: Color(0xFF1B1C19)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: const [BoxShadow(color: Color(0x0F000000), offset: Offset(0, 4), blurRadius: 12)],
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    kalma.imagePath,
                                    height: 180,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      height: 180,
                                      color: const Color(0xFFC2E8FF),
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.menu_book, size: 50, color: Color(0xFF006689)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  kalma.arabic,
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                  style: const TextStyle(
                                    fontFamily: 'Rubik',
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF006689),
                                    height: 1.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0EEE8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'TRANSLATION / ترجمہ',
                                      style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setModalState(() {
                                          modalUrdu = !modalUrdu;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          modalUrdu ? 'Show English' : 'Show Urdu',
                                          style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF006689)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  modalUrdu ? kalma.urduTrans : kalma.engTrans,
                                  textAlign: modalUrdu ? TextAlign.right : TextAlign.left,
                                  textDirection: modalUrdu ? TextDirection.rtl : TextDirection.ltr,
                                  style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19), height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF006689),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                      ),
                      onPressed: () {
                        if (isPlaying) {
                          _stopSpeech();
                          setModalState(() => isPlaying = false);
                        } else {
                          _speakKalma(kalma.arabic);
                          setModalState(() => isPlaying = true);
                        }
                      },
                      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                      label: Text(
                        isPlaying ? 'Pause Recitation' : 'Play Recitation',
                        style: const TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFAA1D),
                        foregroundColor: const Color(0xFF2A1800),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                      ),
                      onPressed: () async {
                        _stopSpeech();
                        Navigator.pop(context);
                        
                        setState(() {
                          claimedRewards.add(kalma.id);
                          totalStars += kalma.stars;
                        });

                        await DatabaseHelper.instance.saveProgress(kalma.id, kalma.stars);
                        _showToast('MashaAllah! +${kalma.stars} ⭐ Earned for Kalma ${kalma.num}!');
                      },
                      icon: const Text('⭐', style: TextStyle(fontSize: 18)),
                      label: Text(
                        'I Recited This! (+Earn ${kalma.stars} Star)',
                        style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<KalmaModel> activeList = kalmasList.where((k) => k.stage == currentStage).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F3),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Column(
            children: [
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              _stopSpeech();
                              Navigator.maybePop(context);
                            },
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(21),
                                boxShadow: const [BoxShadow(color: Color(0xFFDBDAD4), offset: Offset(0, 3))],
                              ),
                              alignment: Alignment.center,
                              child: const Icon(Icons.arrow_back, color: Color(0xFF1B1C19), size: 22),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Kalmas (کلمہ مبارک)',
                                style: TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1B1C19)),
                              ),
                              Text(
                                currentLangUrdu ? 'مقدس کلمے سنیں اور سیکھیں' : 'Learn sacred Kalmas with audio & translation',
                                style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                currentLangUrdu = !currentLangUrdu;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [BoxShadow(color: Color(0xFFBDC8D0), offset: Offset(0, 2))],
                              ),
                              child: const Text('🌐', style: TextStyle(fontSize: 16)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFDDB6),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [BoxShadow(color: Color(0xFFFFB958), offset: Offset(0, 2))],
                            ),
                            child: Text(
                              '⭐ $totalStars',
                              style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF2A1800)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Directionality(
                  textDirection: currentLangUrdu ? TextDirection.rtl : TextDirection.ltr,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [BoxShadow(color: Color(0x0F40352C), offset: Offset(0, 6), blurRadius: 16)],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFFFDDB6),
                                  shape: BoxShape.circle,
                                  boxShadow: [BoxShadow(color: Color(0xFFFFB958), offset: Offset(0, 3))],
                                ),
                                alignment: Alignment.center,
                                child: const Text('🐤', style: TextStyle(fontSize: 26)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Pip the Explorer', style: TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF006689))),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF73FDA3),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: const Text('Guide', style: TextStyle(fontFamily: 'Rubik', fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF00210D))),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      currentLangUrdu ? 'کسی بھی کلمہ کارڈ پر ٹیپ کریں اور فل سکرین پڑھیں!' : 'Tap any Kalma card to open full-screen interactive reader!',
                                      style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAE8E2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      currentStage = 'pg';
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: currentStage == 'pg' ? Colors.white : Colors.transparent,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: currentStage == 'pg'
                                          ? const [BoxShadow(color: Color(0xFF004D68), offset: Offset(0, 3))]
                                          : [],
                                    ),
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text('👶', style: TextStyle(fontSize: 14)),
                                            const SizedBox(width: 4),
                                            Text(
                                              currentLangUrdu ? 'پلے گروپ' : 'Play Group',
                                              style: TextStyle(
                                                fontFamily: 'Rubik',
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: currentStage == 'pg' ? const Color(0xFF006689) : const Color(0xFF3E484F),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          currentLangUrdu ? '۳ بنیادی دعائیں • عمر ۳-۴' : '3 Foundation • Ages 3-4',
                                          style: const TextStyle(fontFamily: 'Rubik', fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF6E7980)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      currentStage = 'kg';
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: currentStage == 'kg' ? Colors.white : Colors.transparent,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: currentStage == 'kg'
                                          ? const [BoxShadow(color: Color(0xFF004D68), offset: Offset(0, 3))]
                                          : [],
                                    ),
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const Text('🎒', style: TextStyle(fontSize: 14)),
                                            const SizedBox(width: 4),
                                            Text(
                                              currentLangUrdu ? 'کنڈرگارٹن' : 'Kindergarten',
                                              style: TextStyle(
                                                fontFamily: 'Rubik',
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: currentStage == 'kg' ? const Color(0xFF006689) : const Color(0xFF3E484F),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          currentLangUrdu ? '۳ اعلیٰ کلمے • عمر ۴-۵' : '3 Higher • Ages 4-5',
                                          style: const TextStyle(fontFamily: 'Rubik', fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF6E7980)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: activeList.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final kalma = activeList[index];
                            bool isClaimed = claimedRewards.contains(kalma.id);

                            return InkWell(
                              onTap: () => _openFullRecitationModal(kalma),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: const [BoxShadow(color: Color(0xFFDBDAD4), offset: Offset(0, 6))],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFC2E8FF),
                                                shape: BoxShape.circle,
                                              ),
                                              alignment: Alignment.center,
                                              child: Text('${kalma.num}', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold, color: Color(0xFF004D68))),
                                            ),
                                            const SizedBox(width: 8),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(kalma.nameEn, style: const TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.w900, color: Color(0xFF006689))),
                                                Text('${kalma.nameUr} • ${kalma.subEn}', style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF3E484F))),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: isClaimed ? const Color(0xFF73FDA3) : const Color(0xFFFFDDB6),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            isClaimed ? (currentLangUrdu ? 'مکمل' : 'Completed') : '⭐ +${kalma.stars} Star',
                                            style: const TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2A1800)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF5F3EE),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(14),
                                            child: Image.asset(
                                              kalma.imagePath,
                                              height: 150,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => Container(
                                                height: 150,
                                                color: const Color(0xFFC2E8FF),
                                                alignment: Alignment.center,
                                                child: const Icon(Icons.menu_book, size: 40, color: Color(0xFF006689)),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                          Text(
                                            kalma.arabic,
                                            textAlign: TextAlign.center,
                                            textDirection: TextDirection.rtl,
                                            style: const TextStyle(
                                              fontFamily: 'Rubik',
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1B1C19),
                                              height: 1.5,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            currentLangUrdu ? kalma.urduTrans : kalma.engTrans,
                                            textAlign: currentLangUrdu ? TextAlign.right : TextAlign.left,
                                            textDirection: currentLangUrdu ? TextDirection.rtl : TextDirection.ltr,
                                            style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: SizedBox(
                                            height: 44,
                                            child: ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFFF0EEE8),
                                                foregroundColor: const Color(0xFF006689),
                                                elevation: 0,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                                              ),
                                              onPressed: () => _openFullRecitationModal(kalma),
                                              icon: const Icon(Icons.play_circle, size: 20),
                                              label: Text(
                                                currentLangUrdu ? 'سنیں ▶' : 'Listen ▶',
                                                style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: SizedBox(
                                            height: 44,
                                            child: ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFFFFAA1D),
                                                foregroundColor: const Color(0xFF2A1800),
                                                elevation: 1,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                                              ),
                                              onPressed: () async {
                                                _stopSpeech();
                                                setState(() {
                                                  claimedRewards.add(kalma.id);
                                                  totalStars += kalma.stars;
                                                });
                                                await DatabaseHelper.instance.saveProgress(kalma.id, kalma.stars);
                                                _showToast('MashaAllah! +${kalma.stars} ⭐ Earned!');
                                              },
                                              icon: const Text('⭐', style: TextStyle(fontSize: 14)),
                                              label: Text(
                                                currentLangUrdu ? 'پڑھیں (+${kalma.stars})' : 'Recite (+${kalma.stars})',
                                                style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
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
      ),
    );
  }
}