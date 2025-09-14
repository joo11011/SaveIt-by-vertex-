import 'dart:async';
import 'package:flutter/material.dart';
import 'package:savelt_app/view/Home_screen/Home_screen.dart';
import 'package:savelt_app/view/Log_in_screen/Log_in_screen.dart';
import '../Forget_password_screen/forgot_password_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late AnimationController _buttonController;
  late AnimationController _disappearController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _buttonAnimation;
  late Animation<double> _disappearAnimation;

  bool _isDisappearing = false;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _disappearController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
    _buttonAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
    _disappearAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _disappearController, curve: Curves.easeInOut),
    );

    _startAnimations();
  }

  void _startAnimations() async {
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _scaleController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _slideController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _buttonController.forward();
  }

  void _startDisappearAnimations() async {
    setState(() {
      _isDisappearing = true;
    });
    _disappearController.forward();
    await Future.delayed(const Duration(milliseconds: 1200));
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
             LoginPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    _buttonController.dispose();
    _disappearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),

          // اللوجو والكلام متوسطي العرض ومترفعين لفوق
          Align(
            alignment: const Alignment(0, -0.7),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _isDisappearing
                      ? _disappearAnimation
                      : _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _isDisappearing
                          ? _disappearAnimation.value
                          : _scaleAnimation.value,
                      child: Opacity(
                        opacity: _isDisappearing
                            ? _disappearAnimation.value
                            : 1.0,
                        child: Image.asset(
                          'assets/images/logo.png',
                          width: 250,
                          height: 250,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 5),
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _isDisappearing
                        ? _disappearAnimation
                        : _fadeAnimation,
                    child: const Column(
                      children: [
                        Text(
                          'Track your spending.',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Save smarter.',
                          style: TextStyle(
                            color: Color.fromARGB(255, 28, 75, 30),
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // الجزء اللي تحت بالـ wave والزرار
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                color: Colors.white,
                height: 200,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 35,
                    vertical: 24,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'B Y   V E R T E X',
                        style: TextStyle(
                          color: Color(0xFF2E7D32),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 3,
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                      const SizedBox(height: 12),
                      AnimatedBuilder(
                        animation: _isDisappearing
                            ? _disappearAnimation
                            : _buttonAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _isDisappearing
                                ? _disappearAnimation.value
                                : _buttonAnimation.value,
                            child: SizedBox(
                              width: double.infinity,
                              height: 59,
                              child: ElevatedButton(
                                onPressed: _isDisappearing
                                    ? null
                                    : _startDisappearAnimations,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF2E7D32),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 8,
                                  shadowColor: Colors.black.withOpacity(0.3),
                                ),
                                child: const Text(
                                  'GET STARTED',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                    fontFamily: 'SF Pro Display',
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.3);

    var firstControlPoint = Offset(size.width / 4, size.height * 0.1);
    var firstEndPoint = Offset(size.width / 2, size.height * 0.3);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width * 3 / 4, size.height * 0.5);
    var secondEndPoint = Offset(size.width, size.height * 0.3);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
