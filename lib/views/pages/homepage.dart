import 'package:fasionrecommender/controllers/homepage_controller.dart';
import 'package:fasionrecommender/data/notifiers.dart';
import 'package:fasionrecommender/views/pages/login_page.dart';
import 'package:fasionrecommender/views/pages/closet.dart';
import 'package:fasionrecommender/views/widgets/global%20widgets/theme_button.dart';
import 'package:fasionrecommender/views/widgets/homepage%20widgets/profile_setup_page.dart';
import 'package:fasionrecommender/views/pages/searchpage.dart';
import 'package:fasionrecommender/views/widgets/homepage%20widgets/homepage_widget.dart';
import 'package:fasionrecommender/views/widgets/object%20widgets/outfit_creationpage.dart';
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
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = theme.iconTheme.color;
    final appBarTextColor = theme.colorScheme.onSurface;
    final appBarBackgroundColor = theme.colorScheme.surface;

    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appBarBackgroundColor,
          centerTitle: true,
          title: Image(
            image: const AssetImage('assets/images/app_logo.png'),
            height: screenSize.height * 0.07,
          ),
          leading: IconButton(
            icon: Icon(Icons.logout, color: appBarTextColor),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: Text('Confirm Logout', style: TextStyle(color: appBarTextColor)),
                      content: Text('Are you sure you want to log out?', style: TextStyle(color: appBarTextColor)),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text('Cancel', style: TextStyle(color: appBarTextColor)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: Text('Logout', style: TextStyle(color: appBarTextColor)),
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
            themeButton(),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              icon: Icon(Icons.person, color: appBarTextColor),
            ),
          ],
        ),

        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          children: body,
        ),
        bottomNavigationBar: BottomAppBar(
          color: theme.colorScheme.background,
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
                    _pageController.jumpToPage(0);
                  },
                  icon: Icon(
                    Icons.home,
                    color: _currentIndex == 0 ? activeColor : inactiveColor,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 1;
                    });
                    _pageController.jumpToPage(1);
                  },
                  icon: Icon(
                    Icons.search,
                    color: _currentIndex == 1 ? activeColor : inactiveColor,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 2;
                    });
                    _pageController.jumpToPage(2);
                  },
                  icon: Icon(
                    Icons.checkroom,
                    color: _currentIndex == 2 ? activeColor : inactiveColor,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 3;
                    });
                    _pageController.jumpToPage(3);
                  },
                  icon: ValueListenableBuilder<bool>(
                    valueListenable: isDarkModeNotifier,
                    builder: (context, isDarkMode, child) {
                      return Image.asset(
                        isDarkMode
                            ? 'assets/images/icons/wardrobe_darkmode_icon.png'
                            : 'assets/images/icons/wardrobe_icon.png',
                        color: _currentIndex == 3 ? activeColor : inactiveColor,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
