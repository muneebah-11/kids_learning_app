import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class WordModel {
  final String titleUrdu;
  final String titleEng;
  final String subtitle;
  final String letterInfo;
  final String cardChar;
  final List<String> torrLetters;
  final String emoji;
  final Color pastelBg;
  final Color pastelFg;

  const WordModel({
    required this.titleUrdu,
    required this.titleEng,
    required this.subtitle,
    required this.letterInfo,
    required this.cardChar,
    required this.torrLetters,
    required this.emoji,
    required this.pastelBg,
    required this.pastelFg,
  });
}

class WordExplorerScreen extends StatefulWidget {
  const WordExplorerScreen({Key? key}) : super(key: key);

  @override
  State<WordExplorerScreen> createState() => _WordExplorerScreenState();
}

class _WordExplorerScreenState extends State<WordExplorerScreen> {
  String currentGrade = 'pg'; // 'pg' (Alif to Seen) | 'kg' (Sheen to Yeh)
  int selectedIndex = 0;
  late FlutterTts flutterTts;

  final Map<String, String> letterPronounciation = const {
    'ا': 'الف',
    'آ': 'الف مدہ',
    'ب': 'بے',
    'پ': 'پے',
    'ت': 'تے',
    'ٹ': 'ٹے',
    'ث': 'سے',
    'ج': 'جیم',
    'چ': 'چے',
    'ح': 'حے',
    'خ': 'خے',
    'د': 'دال',
    'ڈ': 'ڈال',
    'ذ': 'ذال',
    'ر': 'رے',
    'ڑ': 'ڑے',
    'ز': 'زے',
    'ژ': 'ژے',
    'س': 'سین',
    'ش': 'شین',
    'ص': 'صاد',
    'ض': 'ضاد',
    'ط': 'توئیں',
    'ظ': 'زوئیں',
    'ع': 'عین',
    'غ': 'غین',
    'ف': 'فے',
    'ق': 'قاف',
    'ک': 'کاف',
    'گ': 'گاف',
    'ل': 'لام',
    'م': 'میم',
    'ن': 'نون',
    'و': 'واؤ',
    'ہ': 'ہے',
    'ھ': 'دو چشمی ہے',
    'ء': 'حمزہ',
    'ئ': 'حمزہ',
    'ی': 'چھوٹی یے',
    'ے': 'بڑی یے',
  };

  // PG Words: Alif to Seen (ا سے س)
  final List<WordModel> pgWords = const [
    WordModel(
      titleUrdu: 'انگور',
      titleEng: 'Angoor',
      subtitle: 'Grapes',
      letterInfo: 'حرف ا (Alif)',
      cardChar: 'ا',
      torrLetters: ['ا', 'ن', 'گ', 'و', 'ر'],
      emoji: '🍇',
      pastelBg: Color(0xFFC2E8FF),
      pastelFg: Color(0xFF004D68),
    ),
    WordModel(
      titleUrdu: 'آم',
      titleEng: 'Aam',
      subtitle: 'Mango',
      letterInfo: 'حرف آ (Alif Madd)',
      cardChar: 'آ',
      torrLetters: ['آ', 'م'],
      emoji: '🥭',
      pastelBg: Color(0xFFFFDDB6),
      pastelFg: Color(0xFF643F00),
    ),
    WordModel(
      titleUrdu: 'بلی',
      titleEng: 'Billi',
      subtitle: 'Cat',
      letterInfo: 'حرف ب (Bay)',
      cardChar: 'ب',
      torrLetters: ['ب', 'ل', 'ی'],
      emoji: '🐱',
      pastelBg: Color(0xFFC5E8CF),
      pastelFg: Color(0xFF005229),
    ),
    WordModel(
      titleUrdu: 'پنکھا',
      titleEng: 'Pankha',
      subtitle: 'Fan',
      letterInfo: 'حرف پ (Pey)',
      cardChar: 'پ',
      torrLetters: ['پ', 'ن', 'ک', 'ھ', 'ا'],
      emoji: '🪭',
      pastelBg: Color(0xFFE7D6FF),
      pastelFg: Color(0xFF4E2B7A),
    ),
    WordModel(
      titleUrdu: 'تتلی',
      titleEng: 'Titli',
      subtitle: 'Butterfly',
      letterInfo: 'حرف ت (Tey)',
      cardChar: 'ت',
      torrLetters: ['ت', 'ت', 'ل', 'ی'],
      emoji: '🦋',
      pastelBg: Color(0xFFC2E8FF),
      pastelFg: Color(0xFF004D68),
    ),
    WordModel(
      titleUrdu: 'ٹوپی',
      titleEng: 'Topi',
      subtitle: 'Cap',
      letterInfo: 'حرف ٹ (Ttey)',
      cardChar: 'ٹ',
      torrLetters: ['ٹ', 'و', 'پ', 'ی'],
      emoji: '🧢',
      pastelBg: Color(0xFFFFDDB6),
      pastelFg: Color(0xFF643F00),
    ),
    WordModel(
      titleUrdu: 'ثمر',
      titleEng: 'Samar',
      subtitle: 'Fruit',
      letterInfo: 'حرف ث (Sey)',
      cardChar: 'ث',
      torrLetters: ['ث', 'م', 'ر'],
      emoji: '🍓',
      pastelBg: Color(0xFFC5E8CF),
      pastelFg: Color(0xFF005229),
    ),
    WordModel(
      titleUrdu: 'جہاز',
      titleEng: 'Jahaaz',
      subtitle: 'Aeroplane',
      letterInfo: 'حرف ج (Jeem)',
      cardChar: 'ج',
      torrLetters: ['ج', 'ہ', 'ا', 'ز'],
      emoji: '✈️',
      pastelBg: Color(0xFFE7D6FF),
      pastelFg: Color(0xFF4E2B7A),
    ),
    WordModel(
      titleUrdu: 'چاند',
      titleEng: 'Chaand',
      subtitle: 'Moon',
      letterInfo: 'حرف چ (Chey)',
      cardChar: 'چ',
      torrLetters: ['چ', 'ا', 'ن', 'د'],
      emoji: '🌙',
      pastelBg: Color(0xFFC2E8FF),
      pastelFg: Color(0xFF004D68),
    ),
    WordModel(
      titleUrdu: 'حلوہ',
      titleEng: 'Halwa',
      subtitle: 'Sweet Dish',
      letterInfo: 'حرف ح (Hey)',
      cardChar: 'ح',
      torrLetters: ['ح', 'ل', 'و', 'ہ'],
      emoji: '🍯',
      pastelBg: Color(0xFFFFDDB6),
      pastelFg: Color(0xFF643F00),
    ),
    WordModel(
      titleUrdu: 'خرگوش',
      titleEng: 'Khargosh',
      subtitle: 'Rabbit',
      letterInfo: 'حرف خ (Khey)',
      cardChar: 'خ',
      torrLetters: ['خ', 'ر', 'گ', 'و', 'ش'],
      emoji: '🐰',
      pastelBg: Color(0xFFC5E8CF),
      pastelFg: Color(0xFF005229),
    ),
    WordModel(
      titleUrdu: 'درخت',
      titleEng: 'Darakht',
      subtitle: 'Tree',
      letterInfo: 'حرف د (Daal)',
      cardChar: 'د',
      torrLetters: ['د', 'ر', 'خ', 'ت'],
      emoji: '🌳',
      pastelBg: Color(0xFFE7D6FF),
      pastelFg: Color(0xFF4E2B7A),
    ),
    WordModel(
      titleUrdu: 'ڈھول',
      titleEng: 'Dhol',
      subtitle: 'Drum',
      letterInfo: 'حرف ڈ (Ddaal)',
      cardChar: 'ڈ',
      torrLetters: ['ڈ', 'ھ', 'و', 'ل'],
      emoji: '🥁',
      pastelBg: Color(0xFFC2E8FF),
      pastelFg: Color(0xFF004D68),
    ),
    WordModel(
      titleUrdu: 'ذخیرہ',
      titleEng: 'Zakheera',
      subtitle: 'Treasure',
      letterInfo: 'حرف ذ (Zaal)',
      cardChar: 'ذ',
      torrLetters: ['ذ', 'خ', 'ی', 'ر', 'ہ'],
      emoji: '💎',
      pastelBg: Color(0xFFFFDDB6),
      pastelFg: Color(0xFF643F00),
    ),
    WordModel(
      titleUrdu: 'ریل گاڑی',
      titleEng: 'Rail Gaadi',
      subtitle: 'Train',
      letterInfo: 'حرف ر (Ray)',
      cardChar: 'ر',
      torrLetters: ['ر', 'ی', 'ل', 'گ', 'ا', 'ڑ', 'ی'],
      emoji: '🚂',
      pastelBg: Color(0xFFC5E8CF),
      pastelFg: Color(0xFF005229),
    ),
    WordModel(
      titleUrdu: 'پہاڑ',
      titleEng: 'Pahar',
      subtitle: 'Mountain',
      letterInfo: 'حرف ڑ (Rray)',
      cardChar: 'ڑ',
      torrLetters: ['پ', 'ہ', 'ا', 'ڑ'],
      emoji: '🏔️',
      pastelBg: Color(0xFFE7D6FF),
      pastelFg: Color(0xFF4E2B7A),
    ),
    WordModel(
      titleUrdu: 'زرافہ',
      titleEng: 'Zarrafa',
      subtitle: 'Giraffe',
      letterInfo: 'حرف ز (Zay)',
      cardChar: 'ز',
      torrLetters: ['ز', 'ر', 'ا', 'ف', 'ہ'],
      emoji: '🦒',
      pastelBg: Color(0xFFC2E8FF),
      pastelFg: Color(0xFF004D68),
    ),
    WordModel(
      titleUrdu: 'ژالہ باری',
      titleEng: 'Hailstorm',
      subtitle: 'Snow',
      letterInfo: 'حرف ژ (Zhey)',
      cardChar: 'ژ',
      torrLetters: ['ژ', 'ا', 'ل', 'ہ', 'ب', 'ا', 'ر', 'ی'],
      emoji: '🌨️',
      pastelBg: Color(0xFFFFDDB6),
      pastelFg: Color(0xFF643F00),
    ),
    WordModel(
      titleUrdu: 'سیب',
      titleEng: 'Saib',
      subtitle: 'Apple',
      letterInfo: 'حرف س (Seen)',
      cardChar: 'س',
      torrLetters: ['س', 'ی', 'ب'],
      emoji: '🍏',
      pastelBg: Color(0xFFC5E8CF),
      pastelFg: Color(0xFF005229),
    ),
  ];

  // KG Words: Sheen to Yeh (ش سے ے)
  final List<WordModel> kgWords = const [
    WordModel(
      titleUrdu: 'شیر',
      titleEng: 'Sher',
      subtitle: 'Lion',
      letterInfo: 'حرف ش (Sheen)',
      cardChar: 'ش',
      torrLetters: ['ش', 'ی', 'ر'],
      emoji: '🦁',
      pastelBg: Color(0xFFC5E8CF),
      pastelFg: Color(0xFF005229),
    ),
    WordModel(
      titleUrdu: 'صندوق',
      titleEng: 'Sandooq',
      subtitle: 'Box',
      letterInfo: 'حرف ص (Suad)',
      cardChar: 'ص',
      torrLetters: ['ص', 'ن', 'د', 'و', 'ق'],
      emoji: '📦',
      pastelBg: Color(0xFFC2E8FF),
      pastelFg: Color(0xFF004D68),
    ),
    WordModel(
      titleUrdu: 'ضیافت',
      titleEng: 'Ziyafat',
      subtitle: 'Feast',
      letterInfo: 'حرف ض (Zuad)',
      cardChar: 'ض',
      torrLetters: ['ض', 'ی', 'ا', 'ف', 'ت'],
      emoji: '🍽️',
      pastelBg: Color(0xFFFFDDB6),
      pastelFg: Color(0xFF643F00),
    ),
    WordModel(
      titleUrdu: 'طوطا',
      titleEng: 'Tota',
      subtitle: 'Parrot',
      letterInfo: 'حرف ط (Toyen)',
      cardChar: 'ط',
      torrLetters: ['ط', 'و', 'ط', 'ا'],
      emoji: '🦜',
      pastelBg: Color(0xFFE7D6FF),
      pastelFg: Color(0xFF4E2B7A),
    ),
    WordModel(
      titleUrdu: 'ظروف',
      titleEng: 'Zuroof',
      subtitle: 'Utensils',
      letterInfo: 'حرف ظ (Zoyen)',
      cardChar: 'ظ',
      torrLetters: ['ظ', 'ر', 'و', 'ف'],
      emoji: '🏺',
      pastelBg: Color(0xFFC2E8FF),
      pastelFg: Color(0xFF004D68),
    ),
    WordModel(
      titleUrdu: 'عینک',
      titleEng: 'Ainak',
      subtitle: 'Glasses',
      letterInfo: 'حرف ع (Ain)',
      cardChar: 'ع',
      torrLetters: ['ع', 'ی', 'ن', 'ک'],
      emoji: '👓',
      pastelBg: Color(0xFFC5E8CF),
      pastelFg: Color(0xFF005229),
    ),
    WordModel(
      titleUrdu: 'غبارہ',
      titleEng: 'Ghubara',
      subtitle: 'Balloon',
      letterInfo: 'حرف غ (Ghain)',
      cardChar: 'غ',
      torrLetters: ['غ', 'ب', 'ا', 'ر', 'ہ'],
      emoji: '🎈',
      pastelBg: Color(0xFFFFDDB6),
      pastelFg: Color(0xFF643F00),
    ),
    WordModel(
      titleUrdu: 'فوارہ',
      titleEng: 'Fawwara',
      subtitle: 'Fountain',
      letterInfo: 'حرف ف (Fay)',
      cardChar: 'ف',
      torrLetters: ['ف', 'و', 'ا', 'ر', 'ہ'],
      emoji: '⛲',
      pastelBg: Color(0xFFE7D6FF),
      pastelFg: Color(0xFF4E2B7A),
    ),
    WordModel(
      titleUrdu: 'قلم',
      titleEng: 'Qalam',
      subtitle: 'Pen',
      letterInfo: 'حرف ق (Qaaf)',
      cardChar: 'ق',
      torrLetters: ['ق', 'ل', 'م'],
      emoji: '🖊️',
      pastelBg: Color(0xFFC2E8FF),
      pastelFg: Color(0xFF004D68),
    ),
    WordModel(
      titleUrdu: 'کتاب',
      titleEng: 'Kitab',
      subtitle: 'Book',
      letterInfo: 'حرف ک (Kaaf)',
      cardChar: 'ک',
      torrLetters: ['ک', 'ت', 'ا', 'ب'],
      emoji: '📖',
      pastelBg: Color(0xFFC5E8CF),
      pastelFg: Color(0xFF005229),
    ),
    WordModel(
      titleUrdu: 'گڑیا',
      titleEng: 'Guriya',
      subtitle: 'Doll',
      letterInfo: 'حرف گ (Gaaf)',
      cardChar: 'گ',
      torrLetters: ['گ', 'ڑ', 'ی', 'ا'],
      emoji: '🪆',
      pastelBg: Color(0xFFFFDDB6),
      pastelFg: Color(0xFF643F00),
    ),
    WordModel(
      titleUrdu: 'لیمو',
      titleEng: 'Leemu',
      subtitle: 'Lemon',
      letterInfo: 'حرف ل (Laam)',
      cardChar: 'ل',
      torrLetters: ['ل', 'ی', 'م', 'و'],
      emoji: '🍋',
      pastelBg: Color(0xFFE7D6FF),
      pastelFg: Color(0xFF4E2B7A),
    ),
    WordModel(
      titleUrdu: 'مور',
      titleEng: 'Mor',
      subtitle: 'Peacock',
      letterInfo: 'حرف م (Meem)',
      cardChar: 'م',
      torrLetters: ['م', 'و', 'ر'],
      emoji: '🦚',
      pastelBg: Color(0xFFC2E8FF),
      pastelFg: Color(0xFF004D68),
    ),
    WordModel(
      titleUrdu: 'نلکا',
      titleEng: 'Nalka',
      subtitle: 'Water Tap',
      letterInfo: 'حرف ن (Noon)',
      cardChar: 'ن',
      torrLetters: ['ن', 'ل', 'ک', 'ا'],
      emoji: '🚰',
      pastelBg: Color(0xFFC5E8CF),
      pastelFg: Color(0xFF005229),
    ),
    WordModel(
      titleUrdu: 'ورق',
      titleEng: 'Waraq',
      subtitle: 'Page',
      letterInfo: 'حرف و (Wao)',
      cardChar: 'و',
      torrLetters: ['و', 'ر', 'ق'],
      emoji: '📄',
      pastelBg: Color(0xFFFFDDB6),
      pastelFg: Color(0xFF643F00),
    ),
    WordModel(
      titleUrdu: 'ہاتھی',
      titleEng: 'Haathi',
      subtitle: 'Elephant',
      letterInfo: 'حرف ہ (Choti Hey)',
      cardChar: 'ہ',
      torrLetters: ['ہ', 'ا', 'ت', 'ھ', 'ی'],
      emoji: '🐘',
      pastelBg: Color(0xFFE7D6FF),
      pastelFg: Color(0xFF4E2B7A),
    ),
    WordModel(
      titleUrdu: 'چائے',
      titleEng: 'Chaye',
      subtitle: 'Tea',
      letterInfo: 'حرف ء (Hamzah)',
      cardChar: 'ء',
      torrLetters: ['چ', 'ا', 'ئ', 'ے'],
      emoji: '☕',
      pastelBg: Color(0xFFC2E8FF),
      pastelFg: Color(0xFF004D68),
    ),
    WordModel(
      titleUrdu: 'یکہ',
      titleEng: 'Yakka',
      subtitle: 'Horse Cart',
      letterInfo: 'حرف ی (Choti Yey)',
      cardChar: 'ی',
      torrLetters: ['ی', 'ک', 'ہ'],
      emoji: '🐴',
      pastelBg: Color(0xFFC5E8CF),
      pastelFg: Color(0xFF005229),
    ),
    WordModel(
      titleUrdu: 'طوطے',
      titleEng: 'Totay',
      subtitle: 'Parrots',
      letterInfo: 'حرف ے (Badi Yey)',
      cardChar: 'ے',
      torrLetters: ['ط', 'و', 'ط', 'ے'],
      emoji: '🦜',
      pastelBg: Color(0xFFFFDDB6),
      pastelFg: Color(0xFF643F00),
    ),
  ];

  List<WordModel> get activeDataset => currentGrade == 'pg' ? pgWords : kgWords;

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  Future<void> _initTts() async {
    flutterTts = FlutterTts();
    try {
      await flutterTts.setLanguage("ur-PK");
      await flutterTts.setSpeechRate(0.4);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.1);
    } catch (e) {
      debugPrint("TTS initialization error: $e");
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _speakText(String text) async {
    await flutterTts.stop();
    try {
      await flutterTts.setLanguage("ur-PK");
      await flutterTts.speak(text);
    } catch (e) {
      debugPrint("TTS speak error: $e");
    }
  }

  void _triggerSpotlightPhonics(WordModel word) {
    _speakText("${word.letterInfo} سے ${word.titleUrdu}");
  }

  void _speakIndividualLetter(String letter) {
    String speakName = letterPronounciation[letter] ?? letter;
    _speakText(speakName);
  }

  @override
  Widget build(BuildContext context) {
    final dataset = activeDataset;
    final activeWord = dataset[selectedIndex.clamp(0, dataset.length - 1)];

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F3),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          decoration: BoxDecoration(
            color: const Color(0xFFFBF9F3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: AppBar(
                backgroundColor: const Color(0xFFFBF9F3).withOpacity(0.95),
                elevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => Navigator.maybePop(context),
                          child: Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0EEE8),
                              borderRadius: BorderRadius.circular(21),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(Icons.arrow_back, color: Color(0xFF004D68), size: 22),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'الفاظ کی شناخت (Word Explorer)',
                              style: TextStyle(fontFamily: 'Amiri', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF004D68)),
                            ),
                            Text(
                              'Visual Vocabulary & Phonics',
                              style: TextStyle(fontFamily: 'Nunito Sans', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF40484D)),
                            ),
                          ],
                        ),
                        // Star counter removed completely as requested
                        const SizedBox(width: 42),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Grade Level Tabs
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAE8E2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                currentGrade = 'pg';
                                selectedIndex = 0;
                              });
                            },
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: currentGrade == 'pg' ? const Color(0xFF006689) : Colors.transparent,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '👶 پلے گروپ (الف تا س)',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: currentGrade == 'pg' ? Colors.white : const Color(0xFF40484D),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                currentGrade = 'kg';
                                selectedIndex = 0;
                              });
                            },
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: currentGrade == 'kg' ? const Color(0xFFFFAA1D) : Colors.transparent,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                '🎒 کے جی (ش تا ے)',
                                style: TextStyle(
                                  fontFamily: 'Rubik',
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: currentGrade == 'kg' ? const Color(0xFF6A4300) : const Color(0xFF40484D),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Explore Header & Count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('حروف منتخب کریں (Explore Words)', style: TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF004D68))),
                      Text('${dataset.length} Words', style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF70787E))),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Horizontal Color-Coded Grid (RTL layout)
                  SizedBox(
                    height: 85,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      reverse: true,
                      itemCount: dataset.length,
                      separatorBuilder: (context, idx) => const SizedBox(width: 8),
                      itemBuilder: (context, idx) {
                        final word = dataset[idx];
                        bool isSelected = selectedIndex == idx;

                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedIndex = idx;
                            });
                          },
                          child: Container(
                            width: 75,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: word.pastelBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF004D68) : Colors.transparent,
                                width: isSelected ? 2.5 : 0,
                              ),
                              boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 4, offset: Offset(0, 2))],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      word.cardChar,
                                      style: TextStyle(fontFamily: 'Amiri', fontSize: 18, fontWeight: FontWeight.bold, color: word.pastelFg),
                                    ),
                                    const Icon(Icons.touch_app, size: 12, color: Color(0xFF70787E)),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(word.emoji, style: const TextStyle(fontSize: 24)),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Spotlight Word Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [BoxShadow(color: Color(0x10006689), offset: Offset(0, 6), blurRadius: 16)],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFDDB6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text('⭐ اسپاٹ لائٹ لفظ (Spotlight)', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6A4300))),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC2E8FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(activeWord.letterInfo, style: const TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF004D68))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Big Emoji Spotlight Area
                        Container(
                          width: double.infinity,
                          height: 160,
                          decoration: BoxDecoration(
                            color: activeWord.pastelBg.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          alignment: Alignment.center,
                          child: Text(activeWord.emoji, style: const TextStyle(fontSize: 88)),
                        ),
                        const SizedBox(height: 16),

                        // Title info
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              activeWord.titleUrdu,
                              style: TextStyle(fontFamily: 'Amiri', fontSize: 36, fontWeight: FontWeight.bold, color: activeWord.pastelFg),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(${activeWord.titleEng})',
                              style: const TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF70787E)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          activeWord.subtitle,
                          style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF40484D)),
                        ),
                        const SizedBox(height: 16),

                        // Tap to Hear Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF006689),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            ),
                            onPressed: () => _triggerSpotlightPhonics(activeWord),
                            icon: const Icon(Icons.volume_up, size: 20),
                            label: Text(
                              '🔊 سنیے "${activeWord.titleUrdu}"',
                              style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Tap blocks to spell
                        const Text(
                          'الفاظ کے توڑ جوڑ (Tap blocks to spell):',
                          style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF70787E)),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          alignment: WrapAlignment.center,
                          children: activeWord.torrLetters.reversed.map((letter) {
                            return InkWell(
                              onTap: () => _speakIndividualLetter(letter),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFDDB6),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [BoxShadow(color: Color(0x10000000), blurRadius: 4, offset: Offset(0, 2))],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  letter,
                                  style: const TextStyle(fontFamily: 'Amiri', fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF6A4300)),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Corrected RTL Urdu Buttons Layout with Fixed Arrow Directions
                  Row(
                    children: [
                      // Next Word Button (Placed on Left with Left Arrow ←)
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFFAA1D),
                              foregroundColor: const Color(0xFF2A1800),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                            ),
                            onPressed: () {
                              setState(() {
                                selectedIndex = (selectedIndex + 1) % dataset.length;
                              });
                            },
                            child: Text(
                              selectedIndex == dataset.length - 1 ? 'شروع سے شروع کریں ⟳' : '← اگلا لفظ (Next Word)',
                              style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      
                      // Previous Word Button (Placed on Right with Right Arrow →)
                      if (selectedIndex > 0) ...[
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEAE8E2),
                                foregroundColor: const Color(0xFF004D68),
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedIndex--;
                                });
                              },
                              child: const Text(
                                'پچھلا لفظ →',
                                style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}