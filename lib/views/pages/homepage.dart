import 'package:fasionrecommender/controllers/homepage_controller.dart';
import 'package:fasionrecommender/data/notifiers.dart';
import 'package:fasionrecommender/services/authenticate/login_page.dart';
import 'package:fasionrecommender/views/pages/closet.dart';
import 'package:fasionrecommender/views/pages/outfit_creation.dart';
import 'package:fasionrecommender/views/pages/searchpage.dart';
import 'package:fasionrecommender/views/widget/homepage%20widgets/homepage_widget.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> body = const [
    HomeWidget(),
    Searchpage(),
    VirtualClosetPage(),
    OutfitCreationPage(),
  ];
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: Image(
            image: const AssetImage('assets/images/app_logo.png'),
            height: screenSize.height * 0.07, // Logo height responsive
          ),
          leading: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirmed = await showDialog<bool>( 
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm Logout'),
                  content: const Text('Are you sure you want to log out?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
              if (confirmed == true) {
                signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                isDarkModeNotifier.value = !isDarkModeNotifier.value;
              },
              icon: ValueListenableBuilder(
                valueListenable: isDarkModeNotifier,
                builder: (context, isDarkmode, child) {
                  return Icon(isDarkmode ? Icons.dark_mode : Icons.light_mode);
                },
              ),
            ),
          ],
        ),

        // Body now uses PageView for swipe functionality
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: body,
        ),


        bottomNavigationBar: _currentIndex == 3
            ? null
            : BottomAppBar(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                  ), // more consistent padding
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly, // even spacing across the width
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _currentIndex = 0;
                          });
                          _pageController.jumpToPage(0); // Sync PageView
                        },
                        icon: const Icon(Icons.home),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _currentIndex = 1;
                          });
                          _pageController.jumpToPage(1); // Sync PageView
                        },
                        icon: const Icon(Icons.search),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _currentIndex = 2;
                          });
                          _pageController.jumpToPage(2); // Sync PageView
                        },
                        icon: const Icon(Icons.checkroom),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _currentIndex = 3;
                          });
                          _pageController.jumpToPage(3); // Sync PageView
                        },
                        icon: const Icon(Icons.question_mark_rounded),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
