import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
/* ================= SPLASH ================= */

class PlaymixoSplash extends StatefulWidget {
  const PlaymixoSplash({super.key});

  @override
  State<PlaymixoSplash> createState() => _PlaymixoSplashState();
}

class _PlaymixoSplashState extends State<PlaymixoSplash> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const AuthPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: darkGold,
                boxShadow: [
                  BoxShadow(
                    color: darkGold.withOpacity(0.35),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'P',
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'PLAYMIXO',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                letterSpacing: 5,
                color: darkGold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'PLAY • CONNECT • ENJOY',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 2,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const PlaymixoApp());
}

/* ================= COLORS ================= */

const gold = Color(0xFFD4AF37);
const darkGold = Color(0xFFB28A18);
const black = Color(0xFF111111);
const bg = Color(0xFFF6F6F4);

/* ================= APP ================= */

class PlaymixoApp extends StatelessWidget {
  const PlaymixoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Playmixo',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: bg,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(
          seedColor: gold,
          brightness: Brightness.light,
        ),
      ),
      home: const PlaymixoSplash(),
    );
  }
}

/* ================= AUTH PAGE ================= */

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  bool otpSent = false;
  bool isLoading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? verificationId;
  int? resendToken;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  String getPhoneNumber() {
    String phone = phoneController.text.trim();

    // Remove spaces, dashes and brackets.
    phone = phone.replaceAll(' ', '');
    phone = phone.replaceAll('-', '');
    phone = phone.replaceAll('(', '');
    phone = phone.replaceAll(')', '');

    return phone;
  }

  Future<void> sendOtp() async {
    final phoneNumber = getPhoneNumber();

    if (phoneNumber.isEmpty) {
      showMessage('Please enter your phone number');
      return;
    }

    if (!phoneNumber.startsWith('+')) {
      showMessage(
        'Please enter your phone number with country code, e.g. +971501234567',
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      isLoading = true;
    });

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,

        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential);

            if (!mounted) return;

            setState(() {
              isLoading = false;
              otpSent = true;
            });

            showMessage('Phone number verified successfully');

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const MainScreen(),
              ),
            );
          } on FirebaseAuthException catch (e) {
            if (!mounted) return;

            setState(() {
              isLoading = false;
            });

            showMessage(
              e.message ?? 'Authentication failed',
            );
          }
        },

        verificationFailed: (FirebaseAuthException e) {
          if (!mounted) return;

          setState(() {
            isLoading = false;
          });

          if (e.code == 'invalid-phone-number') {
            showMessage('The phone number is invalid');
          } else if (e.code == 'too-many-requests') {
            showMessage(
              'Too many requests. Please try again later.',
            );
          } else {
            showMessage(
              e.message ?? 'Failed to send OTP',
            );
          }
        },

        codeSent: (
          String verificationIdValue,
          int? resendTokenValue,
        ) {
          if (!mounted) return;

          setState(() {
            verificationId = verificationIdValue;
            resendToken = resendTokenValue;
            otpSent = true;
            isLoading = false;
          });

          showMessage('OTP sent successfully');
        },

        codeAutoRetrievalTimeout: (String verificationIdValue) {
          verificationId = verificationIdValue;
        },

        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      showMessage('Something went wrong. Please try again.');
    }
  }

  Future<void> continueToApp() async {
  final smsCode = otpController.text.trim();

  if (smsCode.isEmpty) {
    showMessage('Please enter OTP');
    return;
  }

  if (smsCode.length != 6) {
    showMessage('Please enter the 6-digit OTP');
    return;
  }

  if (verificationId == null) {
    showMessage('Please request a new OTP');
    return;
  }

  FocusScope.of(context).unfocus();

  setState(() {
    isLoading = true;
  });

  try {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: smsCode,
    );

    final userCredential =
        await _auth.signInWithCredential(credential);

    final user = userCredential.user;

    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'phone': user.phoneNumber ?? '',
        'name': nameController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MainScreen(),
      ),
    );
  } on FirebaseAuthException catch (e) {
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (e.code == 'invalid-verification-code') {
      showMessage('Invalid OTP. Please check the code.');
    } else if (e.code == 'session-expired') {
      showMessage('OTP expired. Please request a new OTP.');
    } else {
      showMessage(
        e.message ?? 'Verification failed',
      );
    }
  } catch (e) {
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    showMessage('Verification failed. Please try again.');
  }
}

void demoSocialLogin(String provider) {
  showMessage(
    '$provider authentication will be connected next.',
  );
}

InputDecoration fieldDecoration({
  required String hint,
  required IconData icon,
}) {
  return InputDecoration(
    hintText: hint,
    prefixIcon: Icon(
      icon,
      color: darkGold,
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 18,
      vertical: 17,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: Color(0xFFE0E0E0),
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: Color(0xFFE0E0E0),
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: darkGold,
        width: 2,
      ),
    ),
  );
}
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /* LOGO */

              Center(
                child: Column(
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: black,
                        border: Border.all(
                          color: darkGold,
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'P',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w900,
                            color: darkGold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'PLAYMIXO',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                        color: black,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              Text(
                isLogin ? 'Welcome Back' : 'Create Account',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: black,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                isLogin
                    ? 'Sign in to continue to Playmixo'
                    : 'Create your Playmixo account',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 28),

              /* LOGIN / SIGNUP SWITCH */

              Container(
                height: 52,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isLogin = true;
                            otpSent = false;
                            verificationId = null;
                            otpController.clear();
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isLogin ? black : Colors.transparent,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Log In',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: isLogin ? darkGold : Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isLogin = false;
                            otpSent = false;
                            verificationId = null;
                            otpController.clear();
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: !isLogin ? black : Colors.transparent,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: !isLogin
                                  ? darkGold
                                  : Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /* NAME */

              if (!isLogin) ...[
                TextField(
                  controller: nameController,
                  textInputAction: TextInputAction.next,
                  decoration: fieldDecoration(
                    hint: 'Full Name',
                    icon: Icons.person_outline,
                  ),
                ),
                const SizedBox(height: 14),
              ],

              /* PHONE */

              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                enabled: !otpSent && !isLoading,
                decoration: fieldDecoration(
                  hint: 'Phone Number (+971...)',
                  icon: Icons.phone_outlined,
                ),
              ),

              const SizedBox(height: 14),

              /* OTP */

              if (otpSent) ...[
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  enabled: !isLoading,
                  decoration: fieldDecoration(
                    hint: 'Enter OTP',
                    icon: Icons.lock_outline,
                  ).copyWith(
                    counterText: '',
                  ),
                ),
                const SizedBox(height: 14),
              ],

              /* MAIN BUTTON */

              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : (otpSent ? continueToApp : sendOtp),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: black,
                    disabledBackgroundColor: Colors.black54,
                    foregroundColor: darkGold,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(
                              darkGold,
                            ),
                          ),
                        )
                      : Text(
                          otpSent
                              ? 'Verify & Continue'
                              : 'Send OTP',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 22),

              /* OR */

              Row(
                children: [
                  const Expanded(
                    child: Divider(
                      color: Colors.black12,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(
                      color: Colors.black12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /* GOOGLE */

              SizedBox(
                height: 52,
                child: OutlinedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          demoSocialLogin('Google');
                        },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const GoogleIcon(),
                      const SizedBox(width: 12),
                      Text(
                        isLogin
                            ? 'Continue with Google'
                            : 'Sign up with Google',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /* FACEBOOK */

              SizedBox(
                height: 52,
                child: OutlinedButton(
                  onPressed: isLoading
                      ? null
                      : () {
                          demoSocialLogin('Facebook');
                        },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.black,
                    side: const BorderSide(
                      color: Colors.black,
                      width: 1.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const FacebookIcon(),
                      const SizedBox(width: 12),
                      Text(
                        isLogin
                            ? 'Continue with Facebook'
                            : 'Sign up with Facebook',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 26),

              /* CREATE ACCOUNT / LOGIN */

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLogin
                        ? "Don't have an account?"
                        : 'Already have an account?',
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isLogin = !isLogin;
                        otpSent = false;
                        verificationId = null;
                        otpController.clear();
                      });
                    },
                    child: Text(
                      isLogin ? 'Create New Account' : 'Log In',
                      style: const TextStyle(
                        color: darkGold,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              const Text(
                'Secure phone verification powered by Firebase',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.black38,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


                        


/* ================= GOOGLE ICON ================= */

class GoogleIcon extends StatelessWidget {
  const GoogleIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 25,
      height: 25,
      child: CustomPaint(
        painter: GoogleLogoPainter(),
      ),
    );
  }
}

class GoogleLogoPainter extends CustomPainter {
  const GoogleLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.square;

    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(
      rect.deflate(3),
      -0.45,
      3.2,
      false,
      paint,
    );

    paint.color = const Color(0xFF34A853);
    canvas.drawArc(
      rect.deflate(3),
      2.75,
      1.15,
      false,
      paint,
    );

    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(
      rect.deflate(3),
      1.35,
      1.4,
      false,
      paint,
    );

    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(
      rect.deflate(3),
      -2.9,
      1.1,
      false,
      paint,
    );

    final blue = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(
        size.width * 0.50,
        size.height * 0.43,
        size.width * 0.42,
        4,
      ),
      blue,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

/* ================= FACEBOOK ICON ================= */

class FacebookIcon extends StatelessWidget {
  const FacebookIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25,
      height: 25,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF1877F2),
      ),
      alignment: Alignment.center,
      child: const Text(
        'f',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

/* ================= MAIN ================= */

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final pages = const [
    HomePage(),
    RoomsPage(),
    GamePage(),
    WalletPage(),
    ProfilePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Color(0xFFE8E8E8)),
          ),
        ),
        child: NavigationBar(
          height: 72,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedIndex: currentIndex,
          indicatorColor: const Color(0xFFF3E8B9),
          onDestinationSelected: (index) {
            setState(() => currentIndex = index);
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: black),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.meeting_room_outlined),
              selectedIcon: Icon(Icons.meeting_room, color: black),
              label: 'Room',
            ),
            NavigationDestination(
              icon: Icon(Icons.style_outlined),
              selectedIcon: Icon(Icons.style, color: black),
              label: 'Game',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_balance_wallet_outlined),
              selectedIcon:
                  Icon(Icons.account_balance_wallet, color: black),
              label: 'Wallet',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: black),
              label: 'Profile',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings, color: black),
              label: 'Setting',
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= HOME ================= */

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        children: [
          Row(
            children: [
              const Text(
                '♛',
                style: TextStyle(
                  color: gold,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 7),
              const Expanded(
                child: Text(
                  'Playmixo',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_rounded),
              ),
            ],
          ),

          const SizedBox(height: 4),

          /* WELCOME */
          Container(
            height: 82,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: black,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: gold, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 59,
                  height: 59,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                    border: Border.all(color: gold, width: 2),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: gold,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'PLAYMIXO',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: gold,
                  size: 28,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /* NEW EVENT */
          Container(
            height: 94,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: black,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF2B2B2B)),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'New Event',
                        style: TextStyle(
                          color: gold,
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Big Rewards Await You!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 7),
                      SmallGoldButton(text: 'Join Now'),
                    ],
                  ),
                ),
                const Icon(
                  Icons.card_giftcard_rounded,
                  color: gold,
                  size: 58,
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /* FIRST ROW */
          Row(
            children: const [
              Expanded(
                child: HomeVisualCard(
                  title: 'New Board',
                  visual: BoardVisual(),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: HomeVisualCard(
                  title: 'New Card',
                  visual: CardVisual(),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: HomeVisualCard(
                  title: 'New Card Box',
                  visual: BoxVisual(),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: HomeVisualCard(
                  title: 'New Event',
                  visual: GiftVisual(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          /* SECOND ROW */
          Row(
            children: const [
              Expanded(
                child: HomeIconCard(
                  title: 'Free Reward',
                  icon: Icons.card_giftcard_rounded,
                ),
              ),
              SizedBox(width: 9),
              Expanded(
                child: HomeIconCard(
                  title: 'Daily Task',
                  icon: Icons.assignment_turned_in_rounded,
                ),
              ),
              SizedBox(width: 9),
              Expanded(
                child: HomeIconCard(
                  title: 'Update',
                  icon: Icons.campaign_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: const [
              Text(
                'Featured',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Spacer(),
              Text(
                'See All ›',
                style: TextStyle(
                  color: darkGold,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /* FEATURED */
          Container(
            height: 92,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: black,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lucky Spin Event',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Spin & Win Amazing Rewards!',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                      SizedBox(height: 7),
                      SmallGoldButton(text: 'Join Now'),
                    ],
                  ),
                ),
                const Icon(
                  Icons.casino_rounded,
                  color: gold,
                  size: 60,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= HOME VISUAL CARDS ================= */

class HomeVisualCard extends StatelessWidget {
  final String title;
  final Widget visual;

  const HomeVisualCard({
    super.key,
    required this.title,
    required this.visual,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        children: [
          Expanded(child: Center(child: visual)),
          const SizedBox(height: 3),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeIconCard extends StatelessWidget {
  final String title;
  final IconData icon;

  const HomeIconCard({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 91,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: gold, size: 30),
          const SizedBox(height: 7),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= REAL-LOOKING CARD ================= */

class CardVisual extends StatelessWidget {
  const CardVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 58,
      height: 55,
      child: Stack(
        children: [
          Positioned(
            left: 8,
            top: 5,
            child: Transform.rotate(
              angle: -0.18,
              child: _PlayingCard(
                symbol: '♠',
                number: 'A',
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 1,
            child: Transform.rotate(
              angle: 0.08,
              child: _PlayingCard(
                symbol: '♠',
                number: 'A',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlayingCard extends StatelessWidget {
  final String symbol;
  final String number;

  const _PlayingCard({
    required this.symbol,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 49,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.black12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 3,
            offset: Offset(1, 2),
            color: Colors.black26,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            symbol,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= REAL-LOOKING BOARD ================= */

class BoardVisual extends StatelessWidget {
  const BoardVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: gold, width: 2),
        boxShadow: const [
          BoxShadow(
            blurRadius: 4,
            offset: Offset(1, 2),
            color: Colors.black26,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 43,
          height: 31,
          decoration: BoxDecoration(
            color: const Color(0xFF302817),
            borderRadius: BorderRadius.circular(7),
            border: Border.all(color: gold),
          ),
          child: const Center(
            child: Icon(
              Icons.star_rounded,
              color: gold,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

/* ================= REAL-LOOKING BOX ================= */

class BoxVisual extends StatelessWidget {
  const BoxVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 59,
      height: 54,
      child: Stack(
        children: [
          Positioned(
            top: 9,
            left: 5,
            child: Container(
              width: 50,
              height: 39,
              decoration: BoxDecoration(
                color: const Color(0xFF181818),
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: gold, width: 1.5),
              ),
              child: const Center(
                child: Icon(
                  Icons.workspace_premium_rounded,
                  color: gold,
                  size: 25,
                ),
              ),
            ),
          ),
          Positioned(
            top: 3,
            left: 8,
            child: Container(
              width: 44,
              height: 11,
              decoration: BoxDecoration(
                color: const Color(0xFF242424),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: gold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= GIFT ================= */

class GiftVisual extends StatelessWidget {
  const GiftVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return const Icon(
      Icons.card_giftcard_rounded,
      color: gold,
      size: 42,
    );
  }
}

/* ================= ROOMS ================= */

class RoomsPage extends StatelessWidget {
  const RoomsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: black,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: gold,
                    size: 21,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Room',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const Icon(Icons.search_rounded),
              ],
            ),
          ),

          DefaultTabController(
            length: 3,
            child: Expanded(
              child: Column(
                children: [
                  Container(
                    height: 52,
                    margin: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: const TabBar(
                      dividerColor: Colors.transparent,
                      indicator: BoxDecoration(
                        color: black,
                        borderRadius: BorderRadius.all(
                          Radius.circular(13),
                        ),
                      ),
                      labelColor: gold,
                      unselectedLabelColor: Colors.black54,
                      tabs: [
                        Tab(text: 'All'),
                        Tab(text: 'Popular'),
                        Tab(text: 'My Room'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 9),
                  const Expanded(
                    child: TabBarView(
                      children: [
                        RoomList(),
                        RoomList(popular: true),
                        RoomList(myRoom: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoomList extends StatelessWidget {
  final bool popular;
  final bool myRoom;

  const RoomList({
    super.key,
    this.popular = false,
    this.myRoom = false,
  });

  @override
  Widget build(BuildContext context) {
    final rooms = [
      ('Tash Lovers', '128 online', Icons.style_rounded),
      ('Chill Zone', '95 online', Icons.workspace_premium_rounded),
      ('Friends Room', '76 online', Icons.groups_rounded),
      ('VIP Room', '54 online', Icons.emoji_events_rounded),
      ('Fun Time', '41 online', Icons.casino_rounded),
    ];

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 20),
      itemCount: rooms.length,
      itemBuilder: (context, index) {
        final room = rooms[index];

        return Container(
          height: 80,
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: const Color(0xFFE0E0E0),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 61,
                height: 61,
                decoration: BoxDecoration(
                  color: black,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: gold,
                    width: 1,
                  ),
                ),
                child: Icon(
                  room.$3,
                  color: gold,
                  size: 31,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      myRoom
                          ? 'My ${room.$1}'
                          : room.$1,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department_rounded,
                          size: 14,
                          color: gold,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          room.$2,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.person_rounded,
                          size: 13,
                          color: Colors.black45,
                        ),
                        const SizedBox(width: 2),
                        const Text(
                          '2 - 4 Players',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (popular || index == 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 7,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3E8B9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        index == 1 ? 'Hot' : 'Popular',
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Container(
                    width: 58,
                    height: 27,
                    decoration: BoxDecoration(
                      color: black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Join',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/* ================= GAME ================= */

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 17, 18, 20),
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: black,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: gold,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Tash',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /* PLAY TASH HEADER */
          Container(
            height: 147,
            decoration: BoxDecoration(
              color: black,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: gold,
                width: 1.4,
              ),
            ),
            child: Stack(
              children: [
                const Positioned(
                  left: 22,
                  top: 18,
                  child: Icon(
                    Icons.auto_awesome,
                    color: gold,
                    size: 27,
                  ),
                ),
                const Positioned(
                  right: 22,
                  top: 18,
                  child: Icon(
                    Icons.auto_awesome,
                    color: gold,
                    size: 27,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.style_rounded,
                        color: gold,
                        size: 40,
                      ),
                      SizedBox(height: 7),
                      Text(
                        'Play Tash',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Classic • Fun • Challenge',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Players',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: const [
              Expanded(
                child: PlayerVisualCard(
                  title: '1 Player',
                  count: 1,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: PlayerVisualCard(
                  title: '2 Players',
                  count: 2,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          const PlayerVisualCard(
            title: '4 Players',
            count: 4,
          ),

          const SizedBox(height: 18),

          const Text(
            'Game Items',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 10),

          Row(
            children: const [
              Expanded(
                child: GameVisualItem(
                  title: 'Tash Card',
                  visual: CardVisual(),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: GameVisualItem(
                  title: 'Board',
                  visual: BoardVisual(),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: GameVisualItem(
                  title: 'Box',
                  visual: BoxVisual(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PlayerVisualCard extends StatelessWidget {
  final String title;
  final int count;

  const PlayerVisualCard({
    super.key,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE0D6AD),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 42,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                count,
                (index) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2),
                  child: Icon(
                    Icons.person_rounded,
                    size: 25,
                    color: black,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class GameVisualItem extends StatelessWidget {
  final String title;
  final Widget visual;

  const GameVisualItem({
    super.key,
    required this.title,
    required this.visual,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 132,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFE0D6AD),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 70,
            child: Center(child: visual),
          ),
          const SizedBox(height: 7),
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= WALLET ================= */
/* USER SAID DO NOT CHANGE */

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Wallet',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: const [
          WalletBalance(
            icon: Icons.monetization_on_rounded,
            title: 'Coins',
            value: '0',
          ),
          SizedBox(height: 14),
          WalletBalance(
            icon: Icons.diamond_rounded,
            title: 'Diamonds',
            value: '0',
          ),
        ],
      ),
    );
  }
}

class WalletBalance extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const WalletBalance({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: black,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: gold, width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 57,
            height: 57,
            decoration: BoxDecoration(
              color: gold,
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(icon, color: black, size: 30),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ================= PROFILE ================= */
/* USER SAID DO NOT CHANGE */

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Profile',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: black,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: gold, width: 1.2),
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 47,
                  backgroundColor: gold,
                  child: Icon(
                    Icons.person,
                    size: 53,
                    color: black,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Playmixo User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'UID: 000000',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  height: 1,
                  color: Colors.white24,
                ),
                const SizedBox(height: 18),
                const Row(
                  children: [
                    ProfileStat('Followers'),
                    ProfileStat('Following'),
                    ProfileStat('Gift Sent'),
                    ProfileStat('Gift Received'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileStat extends StatelessWidget {
  final String title;

  const ProfileStat(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const Text(
            '0',
            style: TextStyle(
              color: gold,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= SETTINGS ================= */

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Setting',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: const [
          SettingItem(Icons.lock_outline, 'Privacy'),
          SettingItem(Icons.person_outline, 'Account'),
          SettingItem(Icons.language, 'Language'),
          SettingItem(Icons.help_outline, 'Help Center'),
          SettingItem(Icons.logout, 'Log Out'),
          SettingItem(
            Icons.delete_outline,
            'Delete Account',
            danger: true,
          ),
        ],
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool danger;

  const SettingItem(
    this.icon,
    this.title, {
    super.key,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 17, vertical: 3),
        leading: Icon(
          icon,
          color: danger ? Colors.red : darkGold,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: danger ? Colors.red : black,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 15,
          color: Colors.black45,
        ),
      ),
    );
  }
}

/* ================= COMMON ================= */

class AppPage extends StatelessWidget {
  final String title;
  final Widget child;

  const AppPage({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(17, 18, 17, 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: black,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: gold,
                    size: 21,
                  ),
                ),
                const SizedBox(width: 11),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: black,
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/* ================= SMALL BUTTON ================= */

class SmallGoldButton extends StatelessWidget {
  final String text;

  const SmallGoldButton({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: gold,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: black,
          fontSize: 9,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
