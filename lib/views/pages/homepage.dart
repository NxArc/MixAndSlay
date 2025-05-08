import 'package:fasionrecommender/controllers/homepage_controller.dart';
import 'package:fasionrecommender/data/notifiers.dart';
import 'package:fasionrecommender/views/pages/login_page.dart';
import 'package:fasionrecommender/views/pages/closet.dart';
import 'package:fasionrecommender/views/pages/outfit_creation_page.dart';
import 'package:fasionrecommender/views/widgets/global%20widgets/theme_button.dart';
import 'package:fasionrecommender/views/widgets/homepage%20widgets/homepage_widget.dart';
import 'package:fasionrecommender/views/widgets/homepage%20widgets/profile_setup_page.dart';
import 'package:fasionrecommender/views/pages/searchpage.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = const [
    HomeWidget(),
    Searchpage(),
    VirtualClosetPage(),
    OutfitCreationPage(),
  ];

  final List<IconData> _icons = [
    Icons.home,
    Icons.search,
    Icons.checkroom,
    Icons.edit,
  ];

  final List<String> _labels = [
    'Home',
    'Search',
    'Closet',
    'Outfit',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = theme.iconTheme.color;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth >= 600;

        return DefaultTabController(
          length: 6,
          child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: ValueListenableBuilder<ThemeMode>(
                valueListenable: themeModeNotifier,
                builder: (context, themeMode, _) {
                  final brightness = MediaQuery.of(context).platformBrightness;
                  final isDark = themeMode == ThemeMode.dark ||
                      (themeMode == ThemeMode.system &&
                          brightness == Brightness.dark);

                  final appBarTextColor =
                      Theme.of(context).colorScheme.onSurface;
                  final appBarBackgroundColor =
                      Theme.of(context).colorScheme.surface;

                  return AppBar(
                    backgroundColor: appBarBackgroundColor,
                    centerTitle: true,
                    title: Image.asset(
                      isDark
                          ? 'assets/images/logoDark.png'
                          : 'assets/images/logoLight.png',
                      height: MediaQuery.of(context).size.height * 0.07,
                    ),
                    leading: IconButton(
                      icon: Icon(Icons.logout, color: appBarTextColor),
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              'Confirm Logout',
                              style: TextStyle(color: appBarTextColor),
                            ),
                            content: Text(
                              'Are you sure you want to log out?',
                              style: TextStyle(color: appBarTextColor),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, false),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(color: appBarTextColor),
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, true),
                                child: Text(
                                  'Logout',
                                  style: TextStyle(color: appBarTextColor),
                                ),
                              ),
                            ],
                          ),
                        );
                        if (confirmed == true) {
                          signOut();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        }
                      },
                    ),
                    actions: [
                      const themeButton(),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(),
                            ),
                          );
                        },
                        icon: Icon(Icons.person, color: appBarTextColor),
                      ),
                    ],
                  );
                },
              ),
            ),

            body: Row(
              children: [
                if (isWideScreen)
                  NavigationRail(
                    selectedIndex: _currentIndex,
                    onDestinationSelected: (int index) {
                      setState(() {
                        _currentIndex = index;
                      });
                      _pageController.jumpToPage(index);
                    },
                    labelType: NavigationRailLabelType.all,
                    selectedIconTheme: IconThemeData(color: activeColor),
                    unselectedIconTheme: IconThemeData(color: inactiveColor),
                    destinations: List.generate(
                      _icons.length,
                      (index) => NavigationRailDestination(
                        icon: Icon(_icons[index]),
                        label: Text(_labels[index]),
                      ),
                    ),
                  ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    children: _pages,
                  ),
                ),
              ],
            ),

            bottomNavigationBar: isWideScreen
                ? null
                : BottomAppBar(
                    color: theme.colorScheme.background,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(_icons.length, (index) {
                          return IconButton(
                            onPressed: () {
                              setState(() {
                                _currentIndex = index;
                              });
                              _pageController.jumpToPage(index);
                            },
                            icon: Icon(
                              _icons[index],
                              color: _currentIndex == index
                                  ? activeColor
                                  : inactiveColor,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}
