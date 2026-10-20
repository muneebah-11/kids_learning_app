import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const WonderKidsApp());
}

class WonderKidsApp extends StatelessWidget {
  const WonderKidsApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WonderKids - Shapes & Colors',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFBF9F3),
        fontFamily: 'Rubik',
      ),
      home: const ShapesAndColorsScreen(),
    );
  }
}

class PaletteItem {
  final String nameEn;
  final String nameUr;
  final String hintEn;
  final String hintUr;
  final String iconEmoji;
  final String descriptionEn;
  final String descriptionUr;
  final Color cardBgColor;
  final Color cardBorderColor;

  PaletteItem({
    required this.nameEn,
    required this.nameUr,
    required this.hintEn,
    required this.hintUr,
    required this.iconEmoji,
    required this.descriptionEn,
    required this.descriptionUr,
    required this.cardBgColor,
    required this.cardBorderColor,
  });
}

class ShapesAndColorsScreen extends StatefulWidget {
  const ShapesAndColorsScreen({Key? key}) : super(key: key);

  @override
  State<ShapesAndColorsScreen> createState() => _ShapesAndColorsScreenState();
}

class _ShapesAndColorsScreenState extends State<ShapesAndColorsScreen> {
  final FlutterTts flutterTts = FlutterTts();
  bool isPlayGroup = true;
  bool isUrduLanguage = false;
  int totalStars = 143;

  String currentWordEn = "Rainbow Palette";
  String currentWordUr = "رنگ اور اشکال";
  String currentHintEn = "Tap any shape or color below to hear its magical name! 🌈✨";
  String currentHintUr = "اسکرین پر کسی بھی شکل یا رنگ کو چھو کر اس کا نام سنیں! 🌈✨";

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() async {
    try {
      await flutterTts.setSpeechRate(0.45);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.1);
    } catch (_) {}
  }

  Future<void> _speakText(String text, bool isUrdu) async {
    try {
      if (isUrdu) {
        await flutterTts.setLanguage("ur-PK");
      } else {
        await flutterTts.setLanguage("en-US");
      }
      await flutterTts.stop();
      await flutterTts.speak(text);
    } catch (_) {}
  }

  final List<PaletteItem> pgColors = [
    PaletteItem(
      nameEn: 'Red',
      nameUr: 'لال',
      hintEn: 'Like a sweet, juicy strawberry!',
      hintUr: 'میٹھی اور مزیدار اسٹرابیری کی طرح!',
      iconEmoji: '🍓',
      descriptionEn: 'Juicy Strawberry',
      descriptionUr: 'مزیدار اسٹرابیری',
      cardBgColor: const Color(0xFFFFEBE9),
      cardBorderColor: const Color(0xFFFFB4AB),
    ),
    PaletteItem(
      nameEn: 'Blue',
      nameUr: 'نیلا',
      hintEn: 'Like the clear blue sky and ocean!',
      hintUr: 'صاف نیلی رنگت کے آسمان کی طرح!',
      iconEmoji: '🎈',
      descriptionEn: 'Sky Balloon',
      descriptionUr: 'آسمانی غبارہ',
      cardBgColor: const Color(0xFFE1F5FE),
      cardBorderColor: const Color(0xFF81D4FA),
    ),
    PaletteItem(
      nameEn: 'Yellow',
      nameUr: 'پیلا',
      hintEn: 'Like a smiling warm sunny star!',
      hintUr: 'چمکتے ہوئے سورج اور ستارے کی طرح!',
      iconEmoji: '⭐',
      descriptionEn: 'Shining Sun',
      descriptionUr: 'چمکتا سورج',
      cardBgColor: const Color(0xFFFFF8E1),
      cardBorderColor: const Color(0xFFFFE082),
    ),
    PaletteItem(
      nameEn: 'Green',
      nameUr: 'سبز',
      hintEn: 'Like a happy little hopping frog!',
      hintUr: 'سرسبز پودوں اور مینڈک کی طرح!',
      iconEmoji: '🐸',
      descriptionEn: 'Leafy Frog',
      descriptionUr: 'ہرے پتے',
      cardBgColor: const Color(0xFFE8F5E9),
      cardBorderColor: const Color(0xFFA5D6A7),
    ),
    PaletteItem(
      nameEn: 'Orange',
      nameUr: 'نارنجی',
      hintEn: 'Like a sweet round orange fruit!',
      hintUr: 'میٹھے اور گول مالٹے کی طرح!',
      iconEmoji: '🍊',
      descriptionEn: 'Citrus Fruit',
      descriptionUr: 'رس دار مالٹا',
      cardBgColor: const Color(0xFFFFF3E0),
      cardBorderColor: const Color(0xFFFFCC80),
    ),
    PaletteItem(
      nameEn: 'Pink',
      nameUr: 'گلابی',
      hintEn: 'Like a gentle blooming flower petal!',
      hintUr: 'نرم و نازک گلاب کے پھول کی طرح!',
      iconEmoji: '🌸',
      descriptionEn: 'Flower Bloom',
      descriptionUr: 'گلابی پھول',
      cardBgColor: const Color(0xFFFCE4EC),
      cardBorderColor: const Color(0xFFF48FB1),
    ),
  ];

  final List<PaletteItem> pgShapes = [
    PaletteItem(
      nameEn: 'Circle',
      nameUr: 'دائرہ',
      hintEn: 'Round and round like a bouncing ball!',
      hintUr: 'گول مٹول گیند کی طرح!',
      iconEmoji: '🔴',
      descriptionEn: 'Round & Rolls',
      descriptionUr: 'گول مٹول',
      cardBgColor: const Color(0xFFFFEBE9),
      cardBorderColor: const Color(0xFFFFB4AB),
    ),
    PaletteItem(
      nameEn: 'Square',
      nameUr: 'مربع',
      hintEn: 'Four equal sides like a building block!',
      hintUr: 'چار برابر کونوں والا ڈبہ!',
      iconEmoji: '🟦',
      descriptionEn: '4 Equal Sides',
      descriptionUr: '۴ برابر کونے',
      cardBgColor: const Color(0xFFE1F5FE),
      cardBorderColor: const Color(0xFF81D4FA),
    ),
    PaletteItem(
      nameEn: 'Triangle',
      nameUr: 'مثلث',
      hintEn: 'Three pointy corners like a slice of pizza!',
      hintUr: 'پیزا کی سلائس کی طرح ۳ نوک دار کونے!',
      iconEmoji: '🔺',
      descriptionEn: '3 Pointy Corners',
      descriptionUr: '۳ نوک دار کونے',
      cardBgColor: const Color(0xFFFFF8E1),
      cardBorderColor: const Color(0xFFFFE082),
    ),
    PaletteItem(
      nameEn: 'Star',
      nameUr: 'ستارہ',
      hintEn: 'Twinkle twinkle little star, shining bright!',
      hintUr: 'آسمان پر چمکتا ہوا پیارا ستارہ!',
      iconEmoji: '⭐',
      descriptionEn: '5 Bright Points',
      descriptionUr: '۵ چمکدار نوکیں',
      cardBgColor: const Color(0xFFFFF8E1),
      cardBorderColor: const Color(0xFFFFE082),
    ),
    PaletteItem(
      nameEn: 'Rectangle',
      nameUr: 'مستطیل',
      hintEn: 'Long and tall like a storybook or door!',
      hintUr: 'لمبا کھلونا یا کتاب کی شکل!',
      iconEmoji: '🔲',
      descriptionEn: 'Long Toy Box',
      descriptionUr: 'لمبا صندوق',
      cardBgColor: const Color(0xFFE8F5E9),
      cardBorderColor: const Color(0xFFA5D6A7),
    ),
    PaletteItem(
      nameEn: 'Heart',
      nameUr: 'دل',
      hintEn: 'Full of warmth, kindness, and love!',
      hintUr: 'محبت اور پیار سے بھرا دل!',
      iconEmoji: '💖',
      descriptionEn: 'Kind & Warm',
      descriptionUr: 'پیار اور محبت',
      cardBgColor: const Color(0xFFFCE4EC),
      cardBorderColor: const Color(0xFFF48FB1),
    ),
  ];

  final List<PaletteItem> kgColors = [
    PaletteItem(
      nameEn: 'Purple',
      nameUr: 'جامنی',
      hintEn: 'Like sweet sweet grapes on a vine!',
      hintUr: 'میٹھے اور رسیلے انگوروں کی طرح!',
      iconEmoji: '🍇',
      descriptionEn: 'Royal Grapes',
      descriptionUr: 'شاہی انگور',
      cardBgColor: const Color(0xFFF3E5F5),
      cardBorderColor: const Color(0xFFCE93D8),
    ),
    PaletteItem(
      nameEn: 'Brown',
      nameUr: 'بھورا',
      hintEn: 'Warm and snuggly like a teddy bear!',
      hintUr: 'پیارے بھالو کی نرم اون کی طرح!',
      iconEmoji: '🧸',
      descriptionEn: 'Teddy Bear Fur',
      descriptionUr: 'بھالو کا رنگ',
      cardBgColor: const Color(0xFFEFEBE9),
      cardBorderColor: const Color(0xFFBCAAA4),
    ),
    PaletteItem(
      nameEn: 'Black',
      nameUr: 'سیاہ',
      hintEn: 'Like a friendly penguin walking in snow!',
      hintUr: 'برف پر چلنے والے پینگوئن کی طرح!',
      iconEmoji: '🐧',
      descriptionEn: 'Night Penguin',
      descriptionUr: 'رات کی رنگت',
      cardBgColor: const Color(0xFFECEFF1),
      cardBorderColor: const Color(0xFFB0BEC5),
    ),
    PaletteItem(
      nameEn: 'White',
      nameUr: 'سفید',
      hintEn: 'Soft and puffy like a summer cloud!',
      hintUr: 'آسمان پر اڑتے نرم بادل کی طرح!',
      iconEmoji: '☁️',
      descriptionEn: 'Fluffy Cloud',
      descriptionUr: 'نرم بادل',
      cardBgColor: const Color(0xFFFAFAFA),
      cardBorderColor: const Color(0xFFE0E0E0),
    ),
    PaletteItem(
      nameEn: 'Gray',
      nameUr: 'سرمئی',
      hintEn: 'Strong and kind like a gentle elephant!',
      hintUr: 'طاقتور اور پیارے ہاتھی کی طرح!',
      iconEmoji: '🐘',
      descriptionEn: 'Kind Elephant',
      descriptionUr: 'ہاتھی کی رنگت',
      cardBgColor: const Color(0xFFECEFF1),
      cardBorderColor: const Color(0xFFB0BEC5),
    ),
    PaletteItem(
      nameEn: 'Gold',
      nameUr: 'سنہرا',
      hintEn: 'Gleaming bright like a champion trophy!',
      hintUr: 'جیتے ہوئے شاندار ٹرافی کی طرح!',
      iconEmoji: '🏆',
      descriptionEn: 'Shining Trophy',
      descriptionUr: 'چمکتی ٹرافی',
      cardBgColor: const Color(0xFFFFF8E1),
      cardBorderColor: const Color(0xFFFFE082),
    ),
  ];

  final List<PaletteItem> kgShapes = [
    PaletteItem(
      nameEn: 'Oval',
      nameUr: 'بیضوی',
      hintEn: 'Curved and stretched like a bird egg!',
      hintUr: 'انڈے کی طرح گول اور لمبا!',
      iconEmoji: '🥚',
      descriptionEn: 'Egg Shape',
      descriptionUr: 'انڈے کی شکل',
      cardBgColor: const Color(0xFFE1F5FE),
      cardBorderColor: const Color(0xFF81D4FA),
    ),
    PaletteItem(
      nameEn: 'Diamond',
      nameUr: 'ہیرا',
      hintEn: 'Sparkly like a kite high in the sky!',
      hintUr: 'آسمان پر اڑتی پتنگ کی طرح!',
      iconEmoji: '🪁',
      descriptionEn: 'Flying Kite',
      descriptionUr: 'اڑتی پتنگ',
      cardBgColor: const Color(0xFFFFF8E1),
      cardBorderColor: const Color(0xFFFFE082),
    ),
    PaletteItem(
      nameEn: 'Pentagon',
      nameUr: 'مخمس',
      hintEn: 'Five strong sides like a playhouse roof!',
      hintUr: 'پنج گوشہ - ۵ مضبوط کونوں والی شکل!',
      iconEmoji: '⬟',
      descriptionEn: '5 Equal Sides',
      descriptionUr: '۵ برابر کونے',
      cardBgColor: const Color(0xFFE8F5E9),
      cardBorderColor: const Color(0xFFA5D6A7),
    ),
    PaletteItem(
      nameEn: 'Hexagon',
      nameUr: 'مسدس',
      hintEn: 'Six sides like sweet honey in a beehive!',
      hintUr: 'شہد کے چھتے کے ۶ کونے!',
      iconEmoji: '⬢',
      descriptionEn: '6 Honey Sides',
      descriptionUr: '۶ کونے',
      cardBgColor: const Color(0xFFFFF3E0),
      cardBorderColor: const Color(0xFFFFCC80),
    ),
    PaletteItem(
      nameEn: 'Crescent',
      nameUr: 'ہلال',
      hintEn: 'Curved in the night sky like the young moon!',
      hintUr: 'آسمان پر چمکتا نیا چاند!',
      iconEmoji: '🌙',
      descriptionEn: 'Moon Silhouette',
      descriptionUr: 'چاند کی شکل',
      cardBgColor: const Color(0xFFE1F5FE),
      cardBorderColor: const Color(0xFF81D4FA),
    ),
    PaletteItem(
      nameEn: 'Cross',
      nameUr: 'جمع',
      hintEn: 'Plus shape for helpers and first-aid kits!',
      hintUr: 'مددگار فرسٹ ایڈ باکس کا نشان!',
      iconEmoji: '➕',
      descriptionEn: 'Helper Plus',
      descriptionUr: 'جمع کا نشان',
      cardBgColor: const Color(0xFFFFEBE9),
      cardBorderColor: const Color(0xFFFFB4AB),
    ),
  ];

  void _announceItem(PaletteItem item) {
    setState(() {
      currentWordEn = item.nameEn;
      currentWordUr = item.nameUr;
      currentHintEn = item.hintEn;
      currentHintUr = item.hintUr;
    });

    String speechText = isUrduLanguage ? "${item.nameUr}. ${item.hintUr}" : "${item.nameEn}. ${item.hintEn}";
    _speakText(speechText, isUrduLanguage);
  }

  void _speakCurrentVoice() {
    String speechText = isUrduLanguage ? "$currentWordUr. $currentHintUr" : "$currentWordEn. $currentHintEn";
    _speakText(speechText, isUrduLanguage);
  }

  @override
  Widget build(BuildContext context) {
    final List<PaletteItem> activeColors = isPlayGroup ? pgColors : kgColors;
    final List<PaletteItem> activeShapes = isPlayGroup ? pgShapes : kgShapes;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F3),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Scaffold(
            backgroundColor: const Color(0xFFFBF9F3),
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: const Color(0xFFFBF9F3).withOpacity(0.85),
                elevation: 0,
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
                                  boxShadow: [BoxShadow(color: Color(0xFFEAE8E2), offset: Offset(0, 3), blurRadius: 0)],
                                ),
                                child: const Icon(Icons.arrow_back, color: Color(0xFF1B1C19), size: 22),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'WONDERKIDS',
                                  style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.w800, color: Color(0xFF845400), letterSpacing: 1),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      isUrduLanguage ? 'اشکال اور رنگ 🎨' : 'Shapes & Colors 🎨',
                                      style: const TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                                    ),
                                  ],
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
                                color: const Color(0xFFFFDDB6),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [BoxShadow(color: Color(0xFFFFB958), offset: Offset(0, 2), blurRadius: 0)],
                              ),
                              child: Row(
                                children: [
                                  const Text('⭐', style: TextStyle(fontSize: 13)),
                                  const SizedBox(width: 4),
                                  Text('$totalStars', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2A1800))),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () => setState(() => isUrduLanguage = !isUrduLanguage),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0EEE8),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: const [BoxShadow(color: Color(0xFFE4E2DD), offset: Offset(0, 2), blurRadius: 0)],
                                ),
                                child: Row(
                                  children: [
                                    Text('ENG', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.w800, color: !isUrduLanguage ? const Color(0xFF006689) : const Color(0xFF6E7980))),
                                    const Text(' | ', style: TextStyle(color: Color(0xFFBDC8D0), fontSize: 11)),
                                    Text('اردو', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.w800, color: isUrduLanguage ? const Color(0xFF006689) : const Color(0xFF6E7980))),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAE8E2),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isPlayGroup = true;
                                currentWordEn = "Rainbow Palette";
                                currentWordUr = "رنگ اور اشکال";
                                currentHintEn = "Welcome to Play Group! Let's touch the primary rainbow!";
                                currentHintUr = "پلے گروپ میں خوش آمدید! رنگوں اور اشکال کو چھوئں!";
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isPlayGroup ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(22),
                                boxShadow: isPlayGroup ? const [BoxShadow(color: Color(0xFFBDC8D0), offset: Offset(0, 3), blurRadius: 0)] : null,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('🧸', style: TextStyle(fontSize: 15)),
                                      const SizedBox(width: 6),
                                      Text(
                                        isUrduLanguage ? 'پلے گروپ' : 'Play Group',
                                        style: TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: isPlayGroup ? const Color(0xFF006689) : const Color(0xFF3E484F)),
                                      ),
                                      if (isPlayGroup) ...[
                                        const SizedBox(width: 4),
                                        const Icon(Icons.check_circle, size: 14, color: Color(0xFF006D39)),
                                      ],
                                    ],
                                  ),
                                  Text(
                                    isUrduLanguage ? 'عمر ۳-۴ سال • آڈیو' : 'Ages 3–4 • Guided Audio',
                                    style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6E7980)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                isPlayGroup = false;
                                currentWordEn = "Kindergarten";
                                currentWordUr = "کنڈرگارٹن";
                                currentHintEn = "Welcome to Kindergarten! Ready for tricky shapes & puzzle building?";
                                currentHintUr = "کنڈرگارٹن میں خوش آمدید! پزلز اور اشکال حل کرنے کے لیے تیار ہیں؟";
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: !isPlayGroup ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(22),
                                boxShadow: !isPlayGroup ? const [BoxShadow(color: Color(0xFFBDC8D0), offset: Offset(0, 3), blurRadius: 0)] : null,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text('🎒', style: TextStyle(fontSize: 15)),
                                      const SizedBox(width: 6),
                                      Text(
                                        isUrduLanguage ? 'کنڈرگارٹن' : 'Kindergarten',
                                        style: TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: !isPlayGroup ? const Color(0xFF006689) : const Color(0xFF3E484F)),
                                      ),
                                      if (!isPlayGroup) ...[
                                        const SizedBox(width: 4),
                                        const Icon(Icons.check_circle, size: 14, color: Color(0xFF006D39)),
                                      ],
                                    ],
                                  ),
                                  Text(
                                    isUrduLanguage ? 'عمر ۴-۵ سال • پزلز' : 'Ages 4–5 • Puzzles',
                                    style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6E7980)),
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

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [BoxShadow(color: Color(0x102A1800), offset: Offset(0, 6), blurRadius: 16)],
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 58,
                              height: 58,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF0EE),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFFFCC80)),
                              ),
                              alignment: Alignment.center,
                              child: const Text('🎨', style: TextStyle(fontSize: 32)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Pip the Paintbrush 🎨',
                                        style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF006689)),
                                      ),
                                      InkWell(
                                        onTap: _speakCurrentVoice,
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: const BoxDecoration(color: Color(0xFFF0EEE8), shape: BoxShape.circle),
                                          child: const Icon(Icons.replay, size: 16, color: Color(0xFF3E484F)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F3EE),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      isUrduLanguage
                                          ? '$currentWordUr - $currentHintUr'
                                          : '$currentWordEn - $currentHintEn',
                                      style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Divider(color: Color(0xFFE4E2DD), height: 1),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text('🔊 ', style: TextStyle(fontSize: 12)),
                                Text(
                                  isUrduLanguage ? 'تلفظ: انگریزی اور اردو' : 'Pronunciation: English & اردو',
                                  style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFAA1D),
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              ),
                              onPressed: _speakCurrentVoice,
                              icon: const Icon(Icons.volume_up, size: 16, color: Color(0xFF6A4300)),
                              label: Text(
                                isUrduLanguage ? 'بولو!' : 'SPEAK!',
                                style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6A4300)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isPlayGroup ? '🌈 Rainbow Colors' : '🎨 Advanced Colors',
                        style: const TextStyle(fontFamily: 'Rubik', fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF006689)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFFFFDDB6), borderRadius: BorderRadius.circular(14)),
                        child: Text(
                          isPlayGroup ? '6 Colors' : 'Stage 2',
                          style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF845400)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.25,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: activeColors.length,
                    itemBuilder: (context, index) {
                      final item = activeColors[index];
                      return InkWell(
                        onTap: () => _announceItem(item),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: item.cardBgColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: item.cardBorderColor, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: item.cardBorderColor.withOpacity(0.4),
                                offset: const Offset(0, 4),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(item.iconEmoji, style: const TextStyle(fontSize: 30)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                    child: const Icon(Icons.volume_up, size: 16, color: Color(0xFF006689)),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(item.nameEn, style: const TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                                      Text(item.nameUr, style: const TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
                                    ],
                                  ),
                                  Text(isUrduLanguage ? item.descriptionUr : item.descriptionEn, style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF5E6870))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isPlayGroup ? '🔺 Easy Shapes' : '🔷 Advanced Shapes',
                        style: const TextStyle(fontFamily: 'Rubik', fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF006689)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: const Color(0xFF73FDA3).withOpacity(0.5), borderRadius: BorderRadius.circular(14)),
                        child: Text(
                          isPlayGroup ? 'Tactile Blocks' : 'Geometry Play',
                          style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF004422)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.25,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: activeShapes.length,
                    itemBuilder: (context, index) {
                      final item = activeShapes[index];
                      return InkWell(
                        onTap: () => _announceItem(item),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: item.cardBgColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: item.cardBorderColor, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: item.cardBorderColor.withOpacity(0.4),
                                offset: const Offset(0, 4),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 4),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(item.iconEmoji, style: const TextStyle(fontSize: 30)),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                                    child: const Icon(Icons.volume_up, size: 16, color: Color(0xFF006689)),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(item.nameEn, style: const TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                                      Text(item.nameUr, style: const TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
                                    ],
                                  ),
                                  Text(isUrduLanguage ? item.descriptionUr : item.descriptionEn, style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF5E6870))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  if (isPlayGroup) ...[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MatchChallengeScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: const [BoxShadow(color: Color(0xFFEAE8E2), offset: Offset(0, 6), blurRadius: 0)],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(color: const Color(0xFFC2E8FF), borderRadius: BorderRadius.circular(12)),
                                  child: const Text('Mini-Game • 2 Min', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF003F57))),
                                ),
                                const Text('⭐ +3 Stars', style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF845400))),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              isUrduLanguage ? '🎯 پیلا ستارہ تلاش کریں!' : '🎯 Find the Yellow Star!',
                              style: const TextStyle(fontFamily: 'Rubik', fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isUrduLanguage ? 'اپنے کارڈز دیکھیں: کیا آپ چمکتے پیلے ستارے پر ٹیپ کر سکتے ہیں؟' : 'Look at your cards: can you tap the smiling yellow star to fill your magic jar?',
                              style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 12, color: Color(0xFF3E484F)),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: const Color(0xFFF5F3EE), borderRadius: BorderRadius.circular(18)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: const [
                                  Text('🔴', style: TextStyle(fontSize: 22)),
                                  Text('⭐', style: TextStyle(fontSize: 28)),
                                  Text('🟦', style: TextStyle(fontSize: 22)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFFAA1D),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MatchChallengeScreen(),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      isUrduLanguage ? 'میچ چیلنج شروع کریں' : 'START MATCH CHALLENGE',
                                      style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF6A4300)),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.arrow_forward, color: Color(0xFF6A4300), size: 18),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FeedTheMonsterScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: const [BoxShadow(color: Color(0xFFEAE8E2), offset: Offset(0, 6), blurRadius: 0)],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(color: const Color(0xFF73FDA3).withOpacity(0.5), borderRadius: BorderRadius.circular(12)),
                                  child: const Text('Puzzle Builder • 6 Slots', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF004422))),
                                ),
                                const Text('⭐ +5 Stars', style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF845400))),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              isUrduLanguage ? '🧩 قلعے کا ٹاور مکمل کریں!' : '🧩 Assemble the Castle Tower!',
                              style: const TextStyle(fontFamily: 'Rubik', fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isUrduLanguage ? 'قلعے کو مکمل کرنے کے لیے ۶ جادوئی بلاکس کو آپس میں جوڑیں!' : 'Match the 6 advanced geometric clay blocks to complete the magical fortress!',
                              style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 12, color: Color(0xFF3E484F)),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: const Color(0xFFF5F3EE), borderRadius: BorderRadius.circular(18)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: const [
                                  Text('⬟', style: TextStyle(fontSize: 22, color: Color(0xFF6E7980))),
                                  Text('🔷', style: TextStyle(fontSize: 26)),
                                  Text('🌙', style: TextStyle(fontSize: 22, color: Color(0xFF6E7980))),
                                  Text('⬢', style: TextStyle(fontSize: 22, color: Color(0xFF006D39))),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF006D39),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const FeedTheMonsterScreen(),
                                    ),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      isUrduLanguage ? 'قلعے کا پزل حل کریں' : 'SOLVE CASTLE PUZZLE',
                                      style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.extension, color: Colors.white, size: 18),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),

                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('💖', style: TextStyle(fontSize: 12)),
                        SizedBox(width: 4),
                        Text('WonderKids Early Explorers • Child Safe • Ad-Free', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6E7980))),
                      ],
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
}

class ChallengeQuestion {
  final String questionEn;
  final String questionUr;
  final String phonics;
  final String targetTitle;
  final String targetSub;
  final IconData targetIcon;
  final Color targetColor;
  final int correctOptionIndex;
  final List<OptionCardData> options;

  ChallengeQuestion({
    required this.questionEn,
    required this.questionUr,
    required this.phonics,
    required this.targetTitle,
    required this.targetSub,
    required this.targetIcon,
    required this.targetColor,
    required this.correctOptionIndex,
    required this.options,
  });
}

class OptionCardData {
  final String shapeLabel;
  final String nameEn;
  final String nameUr;
  final IconData icon;
  final Color color;

  OptionCardData({
    required this.shapeLabel,
    required this.nameEn,
    required this.nameUr,
    required this.icon,
    required this.color,
  });
}

class MatchChallengeScreen extends StatefulWidget {
  const MatchChallengeScreen({Key? key}) : super(key: key);

  @override
  State<MatchChallengeScreen> createState() => _MatchChallengeScreenState();
}

class _MatchChallengeScreenState extends State<MatchChallengeScreen> {
  final FlutterTts flutterTts = FlutterTts();
  int totalStars = 158;
  int currentRound = 1;
  int? selectedOptionIndex;
  bool isCorrectSelected = false;
  bool isUrduLanguage = false;

  final List<ChallengeQuestion> roundsData = [
    ChallengeQuestion(
      questionEn: "Where is the Red Circle? 🔴",
      questionUr: "سرخ دائرہ کہاں ہے؟ 🔴",
      phonics: "Phonics: /r/ /r/",
      targetTitle: "Red Circle",
      targetSub: "سرخ دائرہ",
      targetIcon: Icons.circle,
      targetColor: const Color(0xFFBA1A1A),
      correctOptionIndex: 0,
      options: [
        OptionCardData(shapeLabel: "SHAPE 1", nameEn: "Red Circle", nameUr: "سرخ دائرہ", icon: Icons.circle, color: const Color(0xFFBA1A1A)),
        OptionCardData(shapeLabel: "SHAPE 2", nameEn: "Blue Square", nameUr: "نیلا مربع", icon: Icons.square, color: const Color(0xFF006689)),
        OptionCardData(shapeLabel: "SHAPE 3", nameEn: "Yellow Star", nameUr: "پیلا ستارہ", icon: Icons.star, color: const Color(0xFFFFAA1D)),
      ],
    ),
    ChallengeQuestion(
      questionEn: "Where is the Blue Square? 🟦",
      questionUr: "نیلا مربع کہاں ہے؟ 🟦",
      phonics: "Phonics: /b/ /b/",
      targetTitle: "Blue Square",
      targetSub: "نیلا مربع",
      targetIcon: Icons.square,
      targetColor: const Color(0xFF006689),
      correctOptionIndex: 1,
      options: [
        OptionCardData(shapeLabel: "SHAPE 1", nameEn: "Green Triangle", nameUr: "سبز مثلث", icon: Icons.change_history, color: const Color(0xFF006D39)),
        OptionCardData(shapeLabel: "SHAPE 2", nameEn: "Blue Square", nameUr: "نیلا مربع", icon: Icons.square, color: const Color(0xFF006689)),
        OptionCardData(shapeLabel: "SHAPE 3", nameEn: "Red Circle", nameUr: "سرخ دائرہ", icon: Icons.circle, color: const Color(0xFFBA1A1A)),
      ],
    ),
    ChallengeQuestion(
      questionEn: "Where is the Yellow Star? ⭐",
      questionUr: "پیلا ستارہ کہاں ہے؟ ⭐",
      phonics: "Phonics: /y/ /y/",
      targetTitle: "Yellow Star",
      targetSub: "پیلا ستارہ",
      targetIcon: Icons.star,
      targetColor: const Color(0xFFFFAA1D),
      correctOptionIndex: 1,
      options: [
        OptionCardData(shapeLabel: "SHAPE 1", nameEn: "Red Circle", nameUr: "سرخ دائرہ", icon: Icons.circle, color: const Color(0xFFBA1A1A)),
        OptionCardData(shapeLabel: "SHAPE 2", nameEn: "Yellow Star", nameUr: "پیلا ستارہ", icon: Icons.star, color: const Color(0xFFFFAA1D)),
        OptionCardData(shapeLabel: "SHAPE 3", nameEn: "Blue Square", nameUr: "نیلا مربع", icon: Icons.square, color: const Color(0xFF006689)),
      ],
    ),
    ChallengeQuestion(
      questionEn: "Where is the Green Triangle? 🔺",
      questionUr: "سبز مثلث کہاں ہے؟ 🔺",
      phonics: "Phonics: /g/ /g/",
      targetTitle: "Green Triangle",
      targetSub: "سبز مثلث",
      targetIcon: Icons.change_history,
      targetColor: const Color(0xFF006D39),
      correctOptionIndex: 2,
      options: [
        OptionCardData(shapeLabel: "SHAPE 1", nameEn: "Yellow Star", nameUr: "پیلا ستارہ", icon: Icons.star, color: const Color(0xFFFFAA1D)),
        OptionCardData(shapeLabel: "SHAPE 2", nameEn: "Red Circle", nameUr: "سرخ دائرہ", icon: Icons.circle, color: const Color(0xFFBA1A1A)),
        OptionCardData(shapeLabel: "SHAPE 3", nameEn: "Green Triangle", nameUr: "سبز مثلث", icon: Icons.change_history, color: const Color(0xFF006D39)),
      ],
    ),
    ChallengeQuestion(
      questionEn: "Where is the Pink Heart? 💖",
      questionUr: "گلابی دل کہاں ہے؟ 💖",
      phonics: "Phonics: /p/ /p/",
      targetTitle: "Pink Heart",
      targetSub: "گلابی دل",
      targetIcon: Icons.favorite,
      targetColor: const Color(0xFFD81B60),
      correctOptionIndex: 0,
      options: [
        OptionCardData(shapeLabel: "SHAPE 1", nameEn: "Pink Heart", nameUr: "گلابی دل", icon: Icons.favorite, color: const Color(0xFFD81B60)),
        OptionCardData(shapeLabel: "SHAPE 2", nameEn: "Blue Square", nameUr: "نیلا مربع", icon: Icons.square, color: const Color(0xFF006689)),
        OptionCardData(shapeLabel: "SHAPE 3", nameEn: "Green Triangle", nameUr: "سبز مثلث", icon: Icons.change_history, color: const Color(0xFF006D39)),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() async {
    try {
      await flutterTts.setSpeechRate(0.45);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.1);
    } catch (_) {}
  }

  Future<void> _speakText(String text, bool isUrdu) async {
    try {
      if (isUrdu) {
        await flutterTts.setLanguage("ur-PK");
      } else {
        await flutterTts.setLanguage("en-US");
      }
      await flutterTts.stop();
      await flutterTts.speak(text);
    } catch (_) {}
  }

  void _speakQuestion() {
    ChallengeQuestion q = roundsData[currentRound - 1];
    String speechText = isUrduLanguage ? q.questionUr : q.questionEn;
    _speakText(speechText, isUrduLanguage);
  }

  void _handleCardTap(int index) {
    ChallengeQuestion q = roundsData[currentRound - 1];
    bool isCorrect = (index == q.correctOptionIndex);

    setState(() {
      selectedOptionIndex = index;
      if (isCorrect) {
        if (!isCorrectSelected) {
          totalStars += 3;
        }
        isCorrectSelected = true;
      } else {
        isCorrectSelected = false;
      }
    });

    if (isCorrect) {
      _speakText(
        isUrduLanguage ? "شاباش! آپ نے درست جواب دیا!" : "Woohoo! You found the correct shape!",
        isUrduLanguage,
      );
    } else {
      _speakText(
        isUrduLanguage ? "دوبارہ کوشش کریں!" : "Try again, little explorer!",
        isUrduLanguage,
      );
    }
  }

  void _nextQuestion() {
    setState(() {
      if (currentRound < 5) {
        currentRound++;
      } else {
        currentRound = 1;
      }
      selectedOptionIndex = null;
      isCorrectSelected = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ChallengeQuestion q = roundsData[currentRound - 1];

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F3),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Scaffold(
            backgroundColor: const Color(0xFFFBF9F3),
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: const Color(0xFFFBF9F3).withOpacity(0.85),
                elevation: 0,
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
                                  boxShadow: [BoxShadow(color: Color(0xFFEAE8E2), offset: Offset(0, 3), blurRadius: 0)],
                                ),
                                child: const Icon(Icons.arrow_back, color: Color(0xFF1B1C19), size: 22),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  isUrduLanguage ? 'کلر اینڈ شیپ میچ 🎯' : 'Color & Shape Match 🎯',
                                  style: const TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                                ),
                                const Text('WONDERKIDS', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6E7980))),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFDDB6),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [BoxShadow(color: Color(0xFFFFB958), offset: Offset(0, 2), blurRadius: 0)],
                              ),
                              child: Row(
                                children: [
                                  const Text('⭐', style: TextStyle(fontSize: 13)),
                                  const SizedBox(width: 4),
                                  Text('$totalStars', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2A1800))),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () => setState(() => isUrduLanguage = !isUrduLanguage),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0EEE8),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: const [BoxShadow(color: Color(0xFFE4E2DD), offset: Offset(0, 2), blurRadius: 0)],
                                ),
                                child: Row(
                                  children: [
                                    Text('ENG', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: !isUrduLanguage ? const Color(0xFF006689) : const Color(0xFF6E7980))),
                                    const Text(' | ', style: TextStyle(color: Color(0xFFBDC8D0), fontSize: 11)),
                                    Text('اردو', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: isUrduLanguage ? const Color(0xFF006689) : const Color(0xFF6E7980))),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFDDB6),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [BoxShadow(color: Color(0xFFFFB958), offset: Offset(0, 2), blurRadius: 0)],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🧸', style: TextStyle(fontSize: 14)),
                          const SizedBox(width: 6),
                          Text(
                            isUrduLanguage ? 'پلے گروپ موڈ • زیرو ٹائمرز • لامحدود کوششیں' : 'Play Group Mode • Zero Timers • Unlimited Tries',
                            style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2A1800)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [BoxShadow(color: Color(0xFFEAE8E2), offset: Offset(0, 6), blurRadius: 0)],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(color: Color(0xFFC2E8FF), shape: BoxShape.circle),
                                  alignment: Alignment.center,
                                  child: Text('$currentRound', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold, color: Color(0xFF006689))),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  isUrduLanguage ? 'راؤنڈ $currentRound از ۵' : 'Round $currentRound of 5',
                                  style: const TextStyle(fontFamily: 'Rubik', fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                                ),
                              ],
                            ),
                            const Text('🎨 Color & Shape Hunt', style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6E7980))),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Container(
                          width: double.infinity,
                          height: 14,
                          decoration: BoxDecoration(color: const Color(0xFFF0EEE8), borderRadius: BorderRadius.circular(7)),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: currentRound / 5.0,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [Color(0xFF24BC6B), Color(0xFFFFAA1D), Color(0xFFFFB958)]),
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  GestureDetector(
                    onTap: _speakQuestion,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC2E8FF).withOpacity(0.4),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [BoxShadow(color: Color(0xFFC2E8FF), offset: Offset(0, 6), blurRadius: 0)],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 58,
                                height: 58,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: const [BoxShadow(color: Color(0xFFEAE8E2), offset: Offset(0, 4), blurRadius: 0)],
                                ),
                                alignment: Alignment.center,
                                child: const Text('🎨', style: TextStyle(fontSize: 32)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text('Pip says:', style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(color: const Color(0xFFF0EEE8), borderRadius: BorderRadius.circular(10)),
                                          child: Text(q.phonics, style: const TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF3E484F))),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      isUrduLanguage ? q.questionUr : q.questionEn,
                                      style: const TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                                    ),
                                    Text(
                                      isUrduLanguage ? 'اسے چھوئیں!' : 'Tap it to check!',
                                      style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF845400)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Tap shape to check your answer!', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF3E484F))),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF006689),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                ),
                                onPressed: _speakQuestion,
                                icon: const Icon(Icons.volume_up, size: 16, color: Colors.white),
                                label: const Text('TAP TO HEAR', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Column(
                    children: List.generate(q.options.length, (index) {
                      final opt = q.options[index];
                      final isSelected = selectedOptionIndex == index;
                      final isTarget = index == q.correctOptionIndex;

                      return InkWell(
                        onTap: () => _handleCardTap(index),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: (isSelected && isTarget)
                                ? Border.all(color: const Color(0xFFFFAA1D), width: 2)
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: (isSelected && isTarget) ? const Color(0xFFFFAA1D) : const Color(0xFFEAE8E2),
                                offset: const Offset(0, 6),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 66,
                                    height: 66,
                                    decoration: BoxDecoration(
                                      color: opt.color.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    alignment: Alignment.center,
                                    child: Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(color: opt.color, shape: BoxShape.circle),
                                      child: Icon(opt.icon, color: Colors.white, size: 26),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            (isTarget && isSelected) ? 'TARGET MATCH • ' : '${opt.shapeLabel} • ',
                                            style: TextStyle(
                                              fontFamily: 'Rubik',
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: (isTarget && isSelected) ? const Color(0xFF845400) : opt.color,
                                            ),
                                          ),
                                          if (isTarget && isSelected)
                                            const Icon(Icons.stars, size: 14, color: Color(0xFFFFAA1D)),
                                        ],
                                      ),
                                      Text(opt.nameEn, style: const TextStyle(fontFamily: 'Rubik', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19))),
                                      Text(
                                        isUrduLanguage ? opt.nameUr : opt.nameEn,
                                        style: TextStyle(
                                          fontFamily: 'Nunito Sans',
                                          fontSize: 13,
                                          fontWeight: (isTarget && isSelected) ? FontWeight.bold : FontWeight.normal,
                                          color: (isTarget && isSelected) ? const Color(0xFF845400) : const Color(0xFF3E484F),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Icon(
                                (isTarget && isSelected) ? Icons.star : Icons.touch_app,
                                color: (isTarget && isSelected) ? const Color(0xFFFFAA1D) : const Color(0xFF6E7980),
                                size: 26,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 10),

                  if (isCorrectSelected) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF73FDA3).withOpacity(0.4),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [BoxShadow(color: Color(0xFF53DF8A), offset: Offset(0, 6), blurRadius: 0)],
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(color: Color(0xFF006D39), shape: BoxShape.circle),
                                child: const Icon(Icons.sentiment_very_satisfied, color: Colors.white, size: 28),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          isUrduLanguage ? 'واہ! زبردست!' : 'Woohoo! Super Star!',
                                          style: const TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF00210D)),
                                        ),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(color: const Color(0xFFFFB958), borderRadius: BorderRadius.circular(10)),
                                          child: const Text('⭐ +3 Stars', style: TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2A1800))),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      isUrduLanguage ? 'شاباش! آپ نے درست جواب کا انتخاب کیا!' : 'You spotted the correct shape! Great job!',
                                      style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 12, color: Color(0xFF3E484F)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFAA1D),
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                              ),
                              onPressed: _nextQuestion,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    currentRound == 5
                                        ? (isUrduLanguage ? 'دوبارہ شروع کریں' : 'PLAY AGAIN 🔄')
                                        : (isUrduLanguage ? 'اگلا سوال' : 'NEXT QUESTION'),
                                    style: const TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF2A1800)),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(Icons.arrow_forward, color: Color(0xFF2A1800), size: 20),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              ),
                              onPressed: _speakQuestion,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.replay, color: Color(0xFF006689), size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    isUrduLanguage ? 'سوال دوبارہ سنیں' : 'Hear Prompt Again',
                                    style: const TextStyle(fontFamily: 'Rubik', fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF006689)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MonsterQuest {
  final String id;
  final String nameEn;
  final String nameUr;
  final String emoji;
  final Color color;

  MonsterQuest({
    required this.id,
    required this.nameEn,
    required this.nameUr,
    required this.emoji,
    required this.color,
  });
}

class FeedTheMonsterScreen extends StatefulWidget {
  const FeedTheMonsterScreen({Key? key}) : super(key: key);

  @override
  State<FeedTheMonsterScreen> createState() => _FeedTheMonsterScreenState();
}

class _FeedTheMonsterScreenState extends State<FeedTheMonsterScreen> {
  final FlutterTts flutterTts = FlutterTts();
  int totalStars = 165;
  int questIndex = 0;
  bool isFedSuccess = false;
  bool isUrduLanguage = false;
  String? droppedShapeId;

  final List<MonsterQuest> quests = [
    MonsterQuest(id: 'red_circle', nameEn: 'Red Circle', nameUr: 'سرخ دائرہ', emoji: '🔴', color: const Color(0xFFBA1A1A)),
    MonsterQuest(id: 'blue_square', nameEn: 'Blue Square', nameUr: 'نیلا مربع', emoji: '🟦', color: const Color(0xFF006689)),
    MonsterQuest(id: 'yellow_star', nameEn: 'Yellow Star', nameUr: 'پیلا ستارہ', emoji: '⭐', color: const Color(0xFFFFB958)),
    MonsterQuest(id: 'green_triangle', nameEn: 'Green Triangle', nameUr: 'سبز مثلث', emoji: '🔺', color: const Color(0xFF006D39)),
    MonsterQuest(id: 'pink_heart', nameEn: 'Pink Heart', nameUr: 'گلابی دل', emoji: '💖', color: const Color(0xFFD81B60)),
    MonsterQuest(id: 'purple_oval', nameEn: 'Purple Oval', nameUr: 'جامنی بیضوی', emoji: '🟣', color: const Color(0xFF7B1FA2)),
  ];

  final List<MonsterQuest> allPoolShapes = [
    MonsterQuest(id: 'red_circle', nameEn: 'Red Circle', nameUr: 'سرخ دائرہ', emoji: '🔴', color: const Color(0xFFBA1A1A)),
    MonsterQuest(id: 'blue_square', nameEn: 'Blue Square', nameUr: 'نیلا مربع', emoji: '🟦', color: const Color(0xFF006689)),
    MonsterQuest(id: 'yellow_star', nameEn: 'Yellow Star', nameUr: 'پیلا ستارہ', emoji: '⭐', color: const Color(0xFFFFB958)),
    MonsterQuest(id: 'green_triangle', nameEn: 'Green Triangle', nameUr: 'سبز مثلث', emoji: '🔺', color: const Color(0xFF006D39)),
    MonsterQuest(id: 'pink_heart', nameEn: 'Pink Heart', nameUr: 'گلابی دل', emoji: '💖', color: const Color(0xFFD81B60)),
    MonsterQuest(id: 'purple_oval', nameEn: 'Purple Oval', nameUr: 'جامنی بیضوی', emoji: '🟣', color: const Color(0xFF7B1FA2)),
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() async {
    try {
      await flutterTts.setSpeechRate(0.45);
      await flutterTts.setVolume(1.0);
      await flutterTts.setPitch(1.1);
    } catch (_) {}
  }

  Future<void> _speakText(String text, bool isUrdu) async {
    try {
      if (isUrdu) {
        await flutterTts.setLanguage("ur-PK");
      } else {
        await flutterTts.setLanguage("en-US");
      }
      await flutterTts.stop();
      await flutterTts.speak(text);
    } catch (_) {}
  }

  void _speakMonsterPrompt() {
    MonsterQuest current = quests[questIndex];
    String text = isUrduLanguage
        ? "مجھے ایک ${current.nameUr} کھلائیں! بڑا مزیدار!"
        : "Feed me a ${current.nameEn}! Yummy!";
    _speakText(text, isUrduLanguage);
  }

  void _feedMonster(String shapeId) {
    MonsterQuest current = quests[questIndex];
    bool isCorrect = (shapeId == current.id);

    setState(() {
      droppedShapeId = shapeId;
      if (isCorrect) {
        isFedSuccess = true;
        totalStars += 5;
      } else {
        isFedSuccess = false;
      }
    });

    _speakText(
      isCorrect
          ? (isUrduLanguage ? "شاباش! ${current.nameUr} کھلا دیا!" : "Great Job! You fed the ${current.nameEn}!")
          : (isUrduLanguage ? "دوبارہ کوشش کریں!" : "Try again! Grumble wants ${current.nameEn}"),
      isUrduLanguage,
    );
  }

  void _nextShapeQuest() {
    setState(() {
      isFedSuccess = false;
      droppedShapeId = null;
      if (questIndex < quests.length - 1) {
        questIndex++;
      } else {
        questIndex = 0;
      }
    });
  }

  List<MonsterQuest> _getCurrentDockOptions() {
    MonsterQuest currentTarget = quests[questIndex];
    List<MonsterQuest> options = [currentTarget];

    for (var shape in allPoolShapes) {
      if (options.length >= 3) break;
      if (shape.id != currentTarget.id) {
        options.add(shape);
      }
    }
    return options;
  }

  @override
  Widget build(BuildContext context) {
    MonsterQuest currentQuest = quests[questIndex];
    List<MonsterQuest> currentDock = _getCurrentDockOptions();
    MonsterQuest? droppedItem = droppedShapeId != null
        ? allPoolShapes.firstWhere((s) => s.id == droppedShapeId, orElse: () => currentQuest)
        : null;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F3),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Scaffold(
            backgroundColor: const Color(0xFFFBF9F3),
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: const Color(0xFFFBF9F3).withOpacity(0.85),
                elevation: 0,
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
                                  boxShadow: [BoxShadow(color: Color(0xFFEAE8E2), offset: Offset(0, 3), blurRadius: 0)],
                                ),
                                child: const Icon(Icons.arrow_back, color: Color(0xFF1B1C19), size: 22),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Feed The Monster',
                              style: TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1B1C19)),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFDDB6),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [BoxShadow(color: Color(0xFFFFB958), offset: Offset(0, 2), blurRadius: 0)],
                              ),
                              child: Row(
                                children: [
                                  const Text('⭐', style: TextStyle(fontSize: 13)),
                                  const SizedBox(width: 4),
                                  Text('$totalStars', style: const TextStyle(fontFamily: 'Rubik', fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF2A1800))),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () => setState(() => isUrduLanguage = !isUrduLanguage),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0EEE8),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: const [BoxShadow(color: Color(0xFFE4E2DD), offset: Offset(0, 2), blurRadius: 0)],
                                ),
                                child: Row(
                                  children: [
                                    Text('ENG', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: !isUrduLanguage ? const Color(0xFF006689) : const Color(0xFF6E7980))),
                                    const Text(' | ', style: TextStyle(color: Color(0xFFBDC8D0), fontSize: 11)),
                                    Text('اردو', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: isUrduLanguage ? const Color(0xFF006689) : const Color(0xFF6E7980))),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F3EE),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [BoxShadow(color: Color(0xFFEAE8E2), offset: Offset(0, 2), blurRadius: 0)],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('🎒', style: TextStyle(fontSize: 16)),
                            const SizedBox(width: 8),
                            Text(
                              isUrduLanguage ? 'کنڈرگارٹن موڈ (عمر ۴-۵) • زیرو ٹائمرز' : 'Kindergarten Mode (Ages 4–5) • Zero Timers',
                              style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [BoxShadow(color: Color(0x1040352C), offset: Offset(0, 6), blurRadius: 20)],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text('🍉', style: TextStyle(fontSize: 22)),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isUrduLanguage ? 'گرامبل کا پیٹ' : 'Monster Belly Fullness',
                                      style: const TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF006689)),
                                    ),
                                    Text(
                                      isUrduLanguage ? '${questIndex + 1} از ۶ ٹریٹس کھلائے' : '${questIndex + 1} of 6 Treats Fed',
                                      style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 12, color: Color(0xFF3E484F)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFDDB6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text('🌟 Quest ${questIndex + 1} of 6', style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2A1800))),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 28,
                          decoration: BoxDecoration(color: const Color(0xFFF0EEE8), borderRadius: BorderRadius.circular(14)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Stack(
                              children: [
                                FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: (questIndex + 1) / 6,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(colors: [Color(0xFF53DF8A), Color(0xFF24BC6B), Color(0xFFFFAA1D)]),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    '${(((questIndex + 1) / 6) * 100).toInt()}%',
                                    style: const TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC2E8FF).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2BB0E6),
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text('🖌️', style: TextStyle(fontSize: 22)),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Pip the Paintbrush', style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF001E2C))),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                      child: Text('${currentQuest.nameEn} ${currentQuest.emoji}', style: const TextStyle(fontFamily: 'Rubik', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF006689),
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              ),
                              onPressed: _speakMonsterPrompt,
                              icon: const Icon(Icons.volume_up, size: 18, color: Colors.white),
                              label: const Text('HEAR VOICE', style: TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '"Feed me a ${currentQuest.nameEn}! ${currentQuest.emoji} Yummy!"',
                                style: const TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF006689)),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '"مجھے ایک ${currentQuest.nameUr} کھلائیں! بڑا مزیدار!"',
                                style: const TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)),
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFF5F3EE), Colors.white, Color(0xFFF5F3EE)]),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [BoxShadow(color: Color(0x1440352C), offset: Offset(0, 8), blurRadius: 24)],
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 150,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuB37TBdDznYO6uva9ggm6IJJMsWpNqs3kEEb0zAmYqFlLUanRbZROdU8TdXZJxpTpP-igpFj3y0sUzdnYg_9VyegTBYg4PeI6njIroBfWPyDk-Hf5NV3ZkDfzYbFl8d4CZred2Fk9lJRz64paC7dVaZEL7sR1c6pfqw1vhVTchGM-kpcKlp4XQeLra_5yOzfIx0KmOumv5S1jmNXNDa0X8Qfzg6ys9lthNxYPnfTgRsq-5AV5F3tIA',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        DragTarget<String>(
                          onAcceptWithDetails: (details) {
                            _feedMonster(details.data);
                          },
                          builder: (context, candidateData, rejectedData) {
                            bool isHovered = candidateData.isNotEmpty;
                            return InkWell(
                              onTap: () => _feedMonster(currentQuest.id),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: isHovered ? const Color(0xFF73FDA3) : const Color(0xFFEAE8E2),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(color: isHovered ? const Color(0xFF006D39) : Colors.transparent, width: 2),
                                ),
                                child: Column(
                                  children: [
                                    droppedItem != null
                                        ? Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(color: droppedItem.color, shape: BoxShape.circle),
                                            alignment: Alignment.center,
                                            child: Text(droppedItem.emoji, style: const TextStyle(fontSize: 26)),
                                          )
                                        : Container(
                                            width: 64,
                                            height: 64,
                                            decoration: const BoxDecoration(color: Color(0xFF30312D), shape: BoxShape.circle),
                                            alignment: Alignment.center,
                                            child: const Icon(Icons.download, color: Colors.white, size: 28),
                                          ),
                                    const SizedBox(height: 6),
                                    Text(
                                      droppedItem != null
                                          ? '🎉 DROPPED ${droppedItem.nameEn.toUpperCase()}!'
                                          : '👇 DROP OR TAP ${currentQuest.nameEn.toUpperCase()} HERE! 👄',
                                      style: const TextStyle(fontFamily: 'Rubik', fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF006689)),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🥣 Tummy Treats Dock (Drag or Tap)', style: TextStyle(fontFamily: 'Rubik', fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF006689))),
                      const SizedBox(height: 10),
                      Row(
                        children: currentDock.map((displayItem) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4.0),
                              child: Draggable<String>(
                                data: displayItem.id,
                                feedback: Material(
                                  color: Colors.transparent,
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(color: displayItem.color, shape: BoxShape.circle),
                                    alignment: Alignment.center,
                                    child: Text(displayItem.emoji, style: const TextStyle(fontSize: 30)),
                                  ),
                                ),
                                childWhenDragging: Opacity(
                                  opacity: 0.4,
                                  child: _buildTreatCard(displayItem),
                                ),
                                child: InkWell(
                                  onTap: () => _feedMonster(displayItem.id),
                                  child: _buildTreatCard(displayItem),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (isFedSuccess) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF73FDA3).withOpacity(0.35),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: const BoxDecoration(color: Color(0xFF006D39), shape: BoxShape.circle),
                                alignment: Alignment.center,
                                child: const Text('🎉', style: TextStyle(fontSize: 24)),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      isUrduLanguage ? 'بہت خوب! گرامبل خوش ہو گیا! 👾' : 'Great Job! Grumble is Happy! 👾',
                                      style: const TextStyle(fontFamily: 'Rubik', fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF00210D)),
                                    ),
                                    Text(
                                      isUrduLanguage ? 'شاباش! آپ نے ${currentQuest.nameUr} کھلایا! +۵ ستارے!' : 'Super Job! You fed the ${currentQuest.nameEn}! +5 Stars!',
                                      style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 12, color: Color(0xFF3E484F)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFAA1D),
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                              ),
                              onPressed: _nextShapeQuest,
                              child: Text(
                                isUrduLanguage ? 'اگلی شکل کھلائیں' : 'FEED NEXT SHAPE',
                                style: const TextStyle(fontFamily: 'Rubik', fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF2A1800)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTreatCard(MonsterQuest item) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFE4E2DD),
            offset: Offset(0, 5),
            blurRadius: 0,
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFF0EEE8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Shape',
              style: TextStyle(
                fontFamily: 'Rubik',
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3E484F),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(color: item.color.withOpacity(0.2), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(item.emoji, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(height: 8),
          Text(item.nameEn, style: TextStyle(fontFamily: 'Rubik', fontSize: 12, fontWeight: FontWeight.bold, color: item.color), overflow: TextOverflow.ellipsis),
          Text(item.nameUr, style: const TextStyle(fontFamily: 'Nunito Sans', fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF3E484F)), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}