import 'package:fasionrecommender/views/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:fasionrecommender/controllers/onboarding_page_controller.dart';
import 'package:fasionrecommender/data/responsive_utils.dart'; // Import the utility file

class OnboardingPage extends StatefulWidget {
  final VoidCallback onFinish;
  const OnboardingPage({super.key, required this.onFinish});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int _currentIndex = 0;
  final controller = OnboardingPageController();

  final List<String> titles = [
    'Create your own style now',
    'Style Smarter, Slay Everyday',
    'Customize. Plan.\nOwn Your Look.',
  ];

  final List<String> subtitles = [
    'Mix it. Match it. Slay it.',
    'Upload your wardrobe, get daily outfit inspiration,\nand slay every occasion with confidence.\nMix & Slay helps you style smart — based on weather, events, and your own aesthetic.',
    'Get personalized recommendations for any event — from casual to chic, we’ve got you covered!',
  ];

  void _updateState(int newIndex, int newCounter) {
    setState(() {
      _currentIndex = newIndex;
    });
  }

  void _navigateToSignIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()), // Replace with SignInPage
    );
    widget.onFinish();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 600;

    // Use responsive utils for sizing
    double titleSize = ResponsiveUtils.titleSize(context, isTablet: isTablet);
    double subtitleSize = ResponsiveUtils.subtitleSize(context, isTablet: isTablet);
    double buttonPadding = ResponsiveUtils.buttonPadding(context, isTablet: isTablet);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Welcome'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: controller.isFirstPage()
              ? null
              : () {
                  if (controller.moveToPreviousPage(
                    totalPages: titles.length,
                    updateState: _updateState,
                  )) {
                    // Successfully moved back, no additional navigation needed
                  } else {
                    Navigator.pop(context); // Handle edge case (shouldn't occur)
                  }
                },
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboard-bg.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Adjust title size for different screen sizes
                      Text(
                        titles[_currentIndex],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: titleSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Adjust subtitle size for different screen sizes
                      Text(
                        subtitles[_currentIndex],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: subtitleSize,
                          fontStyle: FontStyle.normal,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {
                          if (controller.moveToNextPage(
                            totalPages: titles.length,
                            updateState: _updateState,
                          )) {
                            // Successfully moved to next page
                          } else {
                            _navigateToSignIn(); // Reached the end, go to SignIn
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: buttonPadding * 5,
                            vertical: buttonPadding,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Continue'),
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
