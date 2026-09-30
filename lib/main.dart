import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

    final user = FirebaseAuth.instance.currentUser;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => user != null
            ? const MainScreen()
            : const AuthPage(),
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

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

bool obscurePassword = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
void initState() {
  super.initState();
  _initializeGoogleSignIn();
}

Future<void> _initializeGoogleSignIn() async {
  await GoogleSignIn.instance.initialize(
    serverClientId:
        '249099517156-74c82t7gorpot3fdd6dhtv7apk893ral.apps.googleusercontent.com',
  );
}

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

Future<void> createAccount() async {
  final name = nameController.text.trim();
  final email = emailController.text.trim();
  final password = passwordController.text;

  if (name.isEmpty) {
    showMessage('Please enter your name');
    return;
  }

  if (email.isEmpty) {
    showMessage('Please enter your Gmail');
    return;
  }

  if (password.isEmpty) {
    showMessage('Please enter your password');
    return;
  }

  if (password.length < 6) {
    showMessage('Password must be at least 6 characters');
    return;
  }

  FocusScope.of(context).unfocus();

  setState(() {
    isLoading = true;
  });

  try {
    final userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;

    if (user == null) {
      throw Exception('User creation failed');
    }

    await user.updateDisplayName(name);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({
      'uid': user.uid,
      'name': name,
      'email': email,
      'phone': '',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

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

    if (e.code == 'email-already-in-use') {
      showMessage('This email is already registered');
    } else if (e.code == 'invalid-email') {
      showMessage('Please enter a valid Gmail');
    } else if (e.code == 'weak-password') {
      showMessage('Password is too weak');
    } else {
      showMessage(e.message ?? 'Account creation failed');
    }
  } catch (e) {
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    showMessage('Account creation failed. Please try again.');
  }
}


Future<void> loginUser() async {
  if (isLoading) return;

  final email = emailController.text.trim();
  final password = passwordController.text;

  if (email.isEmpty || password.isEmpty) {
    showMessage('Email and password are required.');
    return;
  }

  setState(() {
    isLoading = true;
  });

  try {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;

    if (user == null) {
      throw Exception('Login failed');
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

    String message;

    switch (e.code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        message = 'Email or password is incorrect.';
        break;
      case 'invalid-email':
        message = 'Please enter a valid email.';
        break;
      case 'user-disabled':
        message = 'This account has been disabled.';
        break;
      case 'too-many-requests':
        message = 'Too many attempts. Please try again later.';
        break;
      default:
        message = e.message ?? 'Login failed. Please try again.';
    }

    showMessage(message);
  } catch (e) {
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    showMessage('Login failed. Please try again.');
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

Future<void> demoSocialLogin(String provider) async {
  if (provider != 'Google') {
    showMessage(
      '$provider authentication will be connected next.',
    );
    return;
  }

  if (isLoading) return;

  setState(() {
    isLoading = true;
  });

  try {
    final googleSignIn = GoogleSignIn.instance;
    await _initializeGoogleSignIn();

    // Do NOT sign out before authentication.
    // This can trigger Account reauth failed [16].
    final googleUser = await googleSignIn.authenticate();

    final googleAuth = googleUser.authentication;

    final idToken = googleAuth.idToken;

    if (idToken == null || idToken.isEmpty) {
      throw Exception('Google ID token was not returned');
    }

    final credential = GoogleAuthProvider.credential(
      idToken: idToken,
    );

    final userCredential =
        await _auth.signInWithCredential(credential);

    final user = userCredential.user;

    if (user == null) {
      throw Exception('Firebase Google sign-in failed');
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .set({
      'uid': user.uid,
      'name': user.displayName ?? '',
      'email': user.email ?? '',
      'phone': user.phoneNumber ?? '',
      'photoURL': user.photoURL ?? '',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

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

    showMessage(
      e.message ?? 'Google sign-in failed',
    );
  } on GoogleSignInException catch (e) {
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    debugPrint('GOOGLE ERROR CODE: ${e.code}');
    debugPrint('GOOGLE ERROR DESCRIPTION: ${e.description}');

    showMessage(
      'Google Error: ${e.code}\n${e.description ?? 'Unknown error'}',
    );
  } catch (e) {
    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    debugPrint('GOOGLE SIGN-IN ERROR: $e');

    showMessage(
      'Google sign-in failed. Please try again.',
    );
  }
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

              /* SIGN UP FIELDS */

if (!isLogin) ...[
  TextField(
    controller: nameController,
    textInputAction: TextInputAction.next,
    decoration: fieldDecoration(
      hint: 'Name',
      icon: Icons.person_outline,
    ),
  ),

  const SizedBox(height: 14),

  TextField(
    controller: emailController,
    keyboardType: TextInputType.emailAddress,
    textInputAction: TextInputAction.next,
    decoration: fieldDecoration(
      hint: 'Gmail',
      icon: Icons.email_outlined,
    ),
  ),

  const SizedBox(height: 14),

  TextField(
    controller: passwordController,
    obscureText: obscurePassword,
    textInputAction: TextInputAction.done,
    decoration: fieldDecoration(
      hint: 'Password',
      icon: Icons.lock_outline,
    ).copyWith(
      suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            obscurePassword = !obscurePassword;
          });
        },
        icon: Icon(
          obscurePassword
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: darkGold,
        ),
      ),
    ),
  ),

  const SizedBox(height: 20),

  SizedBox(
    height: 54,
    child: ElevatedButton(
      onPressed: isLoading ? null : createAccount,
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
                valueColor: AlwaysStoppedAnimation<Color>(
                  darkGold,
                ),
              ),
            )
          : const Text(
              'Create Account',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
    ),
  ),
],

/* PHONE LOGIN */

if (isLogin) ...[
  TextField(
    controller: emailController,
    keyboardType: TextInputType.emailAddress,
    textInputAction: TextInputAction.next,
    decoration: fieldDecoration(
      hint: 'Gmail',
      icon: Icons.email_outlined,
    ),
  ),

  const SizedBox(height: 14),

  TextField(
    controller: passwordController,
    obscureText: obscurePassword,
    textInputAction: TextInputAction.done,
    decoration: fieldDecoration(
      hint: 'Password',
      icon: Icons.lock_outline,
    ).copyWith(
      suffixIcon: IconButton(
        onPressed: () {
          setState(() {
            obscurePassword = !obscurePassword;
          });
        },
        icon: Icon(
          obscurePassword
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: darkGold,
        ),
      ),
    ),
  ),

  const SizedBox(height: 20),

  SizedBox(
    height: 54,
    child: ElevatedButton(
      onPressed: isLoading ? null : loginUser,
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
                valueColor: AlwaysStoppedAnimation<Color>(
                  darkGold,
                ),
              ),
            )
          : const Text(
              'Log In',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
              ),
            ),
    ),
  ),
],

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
          const HomeWideBox(
            title: 'New Event',
            subtitle: 'Special rewards and events are waiting!',
            visual: EventBoxVisual(),
            buttonText: 'Join Now',
          ),

          const SizedBox(height: 12),

          /* NEW BOARD */
          const HomeWideBox(
            title: 'New Board',
            subtitle: 'Playmixo Tash Board',
            visual: TashBoardVisual(),
            buttonText: 'Explore',
          ),

          const SizedBox(height: 12),

          /* NEW CARD */
          const HomeWideBox(
            title: 'New Card',
            subtitle: 'Realistic Tash Playing Cards',
            visual: TashCardsVisual(),
            buttonText: 'View Cards',
          ),

          const SizedBox(height: 12),

          /* NEW CARD BOX */
          const HomeWideBox(
            title: 'New Card Box',
            subtitle: 'Premium Tash Card Collection',
            visual: TashCardBoxVisual(),
            buttonText: 'Open Box',
          ),

          const SizedBox(height: 12),

          /* FREE REWARD */
          const HomeWideBox(
            title: 'Free Reward',
            subtitle: 'Open your free reward box',
            visual: RewardBoxVisual(),
            buttonText: 'Claim',
          ),

          const SizedBox(height: 12),

          /* DAILY TASK */
          const HomeWideBox(
            title: 'Daily Task',
            subtitle: 'Complete tasks and collect rewards',
            visual: DailyTaskBoxVisual(),
            buttonText: 'View Task',
          ),

          const SizedBox(height: 12),

          /* UPDATE */
          const HomeWideBox(
            title: 'Update',
            subtitle: 'Discover the latest Playmixo updates',
            visual: UpdateBoxVisual(),
            buttonText: 'View',
          ),

          const SizedBox(height: 16),

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

/* ================= FULL WIDTH HOME BOX ================= */

class HomeWideBox extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget visual;
  final String buttonText;

  const HomeWideBox({
    super.key,
    required this.title,
    required this.subtitle,
    required this.visual,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 124,
      padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: const Color(0xFFD8D0B8),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 7),
                SmallGoldButton(text: buttonText),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 115,
            height: 100,
            child: visual,
          ),
        ],
      ),
    );
  }
}

/* ================= REAL TASH BOARD ================= */

class TashBoardVisual extends StatelessWidget {
  const TashBoardVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 108,
        height: 82,
        decoration: BoxDecoration(
          color: const Color(0xFF17130D),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFF9C7727),
            width: 3,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(7),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF315B35),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: const Color(0xFFC5A34A),
              width: 1.5,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 8,
                top: 7,
                child: Container(
                  width: 25,
                  height: 17,
                  decoration: BoxDecoration(
                    color: const Color(0xFF234427),
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: gold),
                  ),
                ),
              ),
              Positioned(
                right: 8,
                top: 7,
                child: Container(
                  width: 25,
                  height: 17,
                  decoration: BoxDecoration(
                    color: const Color(0xFF234427),
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: gold),
                  ),
                ),
              ),
              Center(
                child: Container(
                  width: 34,
                  height: 27,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3922),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: gold),
                  ),
                  child: const Center(
                    child: Text(
                      'TASH',
                      style: TextStyle(
                        color: gold,
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
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

/* ================= REAL PLAYING CARDS ================= */

class TashCardsVisual extends StatelessWidget {
  const TashCardsVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 105,
        height: 86,
        child: Stack(
          children: [
            Positioned(
              left: 17,
              top: 8,
              child: Transform.rotate(
                angle: -0.18,
                child: const _RealCard(
                  number: 'A',
                  symbol: '♠',
                ),
              ),
            ),
            Positioned(
              left: 38,
              top: 3,
              child: Transform.rotate(
                angle: 0.02,
                child: const _RealCard(
                  number: 'K',
                  symbol: '♥',
                  red: true,
                ),
              ),
            ),
            Positioned(
              left: 59,
              top: 9,
              child: Transform.rotate(
                angle: 0.16,
                child: const _RealCard(
                  number: 'Q',
                  symbol: '♦',
                  red: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RealCard extends StatelessWidget {
  final String number;
  final String symbol;
  final bool red;

  const _RealCard({
    required this.number,
    required this.symbol,
    this.red = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 39,
      height: 59,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFA),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: const Color(0xFFBDB8AA),
        ),
        boxShadow: [
  BoxShadow(
    color: Colors.black.withValues(alpha: 0.35),
    blurRadius: 5,
    offset: Offset(2, 3),
  ),
],
      ),
      padding: const EdgeInsets.all(3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: TextStyle(
              color: red ? const Color(0xFF9D2525) : Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                symbol,
                style: TextStyle(
                  color: red ? const Color(0xFF9D2525) : Colors.black,
                  fontSize: 23,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= REAL TASH CARD BOX ================= */

class TashCardBoxVisual extends StatelessWidget {
  const TashCardBoxVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 91,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFF17130D),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFB18A32),
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 8,
                  offset: Offset(2, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'PLAYMIXO',
                  style: TextStyle(
                    color: gold,
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'TASH',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'CARD COLLECTION',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 5,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 5,
            child: Container(
              width: 68,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFC49B3A),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= REWARD BOX ================= */

class RewardBoxVisual extends StatelessWidget {
  const RewardBoxVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 82,
            height: 63,
            decoration: BoxDecoration(
              color: const Color(0xFF18130D),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: gold,
                width: 2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 8,
                  offset: Offset(2, 4),
                ),
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.card_giftcard_rounded,
                color: gold,
                size: 38,
              ),
            ),
          ),
          Positioned(
            top: 1,
            child: Container(
              width: 74,
              height: 15,
              decoration: BoxDecoration(
                color: const Color(0xFF242018),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: gold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ================= DAILY TASK BOX ================= */

class DailyTaskBoxVisual extends StatelessWidget {
  const DailyTaskBoxVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 88,
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFF181818),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: gold,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.assignment_turned_in_rounded,
              color: gold,
              size: 32,
            ),
            SizedBox(height: 3),
            Text(
              'DAILY',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= UPDATE BOX ================= */

class UpdateBoxVisual extends StatelessWidget {
  const UpdateBoxVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 90,
        height: 69,
        decoration: BoxDecoration(
          color: const Color(0xFF171717),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: gold,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.campaign_rounded,
              color: gold,
              size: 31,
            ),
            SizedBox(height: 3),
            Text(
              'UPDATE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ================= EVENT BOX ================= */

class EventBoxVisual extends StatelessWidget {
  const EventBoxVisual({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 91,
        height: 73,
        decoration: BoxDecoration(
          color: const Color(0xFF18130D),
          borderRadius: BorderRadius.circular(9),
          border: Border.all(
            color: gold,
            width: 2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 8,
              offset: Offset(2, 4),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.card_giftcard_rounded,
            color: gold,
            size: 39,
          ),
        ),
      ),
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
  children: [
    Expanded(
      child: GameVisualItem(
        title: 'Tash Card',
        visual: TashCardsVisual(),
      ),
    ),
    SizedBox(width: 10),
    Expanded(
      child: GameVisualItem(
        title: 'Board',
        visual: TashBoardVisual(),
      ),
    ),
    SizedBox(width: 10),
    Expanded(
      child: GameVisualItem(
        title: 'Box',
        visual: TashCardBoxVisual(),
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

/* ================= SETTINGS ================= */

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Setting',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        children: [
          SettingItem(
            Icons.lock_outline,
            'Privacy',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PrivacyPage(),
                ),
              );
            },
          ),

          const SettingItem(
            Icons.person_outline,
            'Account',
          ),

          const SettingItem(
            Icons.language,
            'Language',
          ),

          const SettingItem(
            Icons.help_outline,
            'Help Center',
          ),

          const SettingItem(
            Icons.logout,
            'Log Out',
          ),

          const SettingItem(
            Icons.delete_outline,
            'Delete Account',
            danger: true,
          ),
        ],
      ),
    );
  }
}


/* ================= SETTING ITEM ================= */

class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool danger;
  final VoidCallback? onTap;

  const SettingItem(
    this.icon,
    this.title, {
    super.key,
    this.danger = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: const Color(0xFFE5E5E5),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 3,
        ),
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


/* ================= PRIVACY PAGE ================= */

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  bool profileVisitors = false;
  bool privateProfile = false;
  bool doNotFollow = false;
  bool doNotSendRequest = false;
  bool onlineStatus = true;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPrivacySettings();
  }

  Future<void> _loadPrivacySettings() async {
    final user = _auth.currentUser;

    if (user == null) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      return;
    }

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .get();

      final data = snapshot.data();

      if (!mounted) return;

      setState(() {
        profileVisitors =
            data?['profileVisitors'] as bool? ?? false;

        privateProfile =
            data?['privateProfile'] as bool? ?? false;

        doNotFollow =
            data?['doNotFollow'] as bool? ?? false;

        doNotSendRequest =
            data?['doNotSendRequest'] as bool? ?? false;

        onlineStatus =
            data?['onlineStatus'] as bool? ?? true;

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Privacy settings could not be loaded.',
          ),
        ),
      );
    }
  }

  Future<void> _savePrivacySetting(
    String field,
    bool value,
  ) async {
    final user = _auth.currentUser;

    if (user == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .set(
        {
          field: value,
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not save privacy setting.',
          ),
        ),
      );
    }
  }

  Future<void> _changeSetting(
    String field,
    bool value,
  ) async {
    setState(() {
      switch (field) {
        case 'profileVisitors':
          profileVisitors = value;
          break;

        case 'privateProfile':
          privateProfile = value;
          break;

        case 'doNotFollow':
          doNotFollow = value;
          break;

        case 'doNotSendRequest':
          doNotSendRequest = value;
          break;

        case 'onlineStatus':
          onlineStatus = value;
          break;
      }
    });

    await _savePrivacySetting(
      field,
      value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: 'Privacy',
      child: isLoading
    ? const Center(
        child: CircularProgressIndicator(
          color: gold,
        ),
      )
    : Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            16,
            4,
            16,
            24,
          ),
          children: [
                PrivacyOptionBox(
                  title: 'Profile Visitors',
                  value: profileVisitors,
                  onChanged: (value) {
                    _changeSetting(
                      'profileVisitors',
                      value,
                    );
                  },
                ),

                PrivacyOptionBox(
                  title: 'Private Profile',
                  value: privateProfile,
                  onChanged: (value) {
                    _changeSetting(
                      'privateProfile',
                      value,
                    );
                  },
                ),

                PrivacyOptionBox(
                  title: 'Do Not Follow',
                  value: doNotFollow,
                  onChanged: (value) {
                    _changeSetting(
                      'doNotFollow',
                      value,
                    );
                  },
                ),

                PrivacyOptionBox(
                  title: 'Do Not Send Request',
                  value: doNotSendRequest,
                  onChanged: (value) {
                    _changeSetting(
                      'doNotSendRequest',
                      value,
                    );
                  },
                ),

PrivacyOptionBox(
  title: 'Online Status',
  value: onlineStatus,
  onChanged: (value) {
    _changeSetting(
      'onlineStatus',
      value,
    );
  },
),
              ],
            ),
          ),
    );
  }
}


/* ================= PRIVACY OPTION BOX ================= */

class PrivacyOptionBox extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const PrivacyOptionBox({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: const Color(0xFFE5E5E5),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: black,
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          PrivacySwitch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}


/* ================= CUSTOM PRIVACY SWITCH ================= */

class PrivacySwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const PrivacySwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 180,
        ),
        curve: Curves.easeOut,
        width: 106,
        height: 46,
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
        ),
        decoration: BoxDecoration(
          color: value ? black : Colors.red,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: value ? black : Colors.red,
            width: 1.5,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedAlign(
              duration: const Duration(
                milliseconds: 180,
              ),
              curve: Curves.easeOut,
              alignment: value
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),

            Align(
              alignment: value
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(
                  left: value ? 9 : 0,
                  right: value ? 0 : 9,
                ),
                child: Text(
                  value ? 'ON' : 'OFF',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
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
