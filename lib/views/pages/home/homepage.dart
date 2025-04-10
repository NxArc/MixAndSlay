import 'package:fasionrecommender/controllers/homepage_controller.dart';
import 'package:fasionrecommender/data/notifiers.dart';
import 'package:fasionrecommender/views/pages/authenticate/login_page.dart';
import 'package:fasionrecommender/views/widget/category_grid.dart';
import 'package:fasionrecommender/views/widget/ootd.dart';
import 'package:fasionrecommender/data/responsive_utils.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final paddingH = ResponsiveUtils.paddingH(context);
    final paddingV = ResponsiveUtils.paddingV(context);
    final titleSize = ResponsiveUtils.titleSize(context);
    final tabTextSize = ResponsiveUtils.inputFontSize(context);
    final buttonWidth = ResponsiveUtils.buttonWidth(context);

    // Make sizes more responsive using screen dimensions
    double textSizeCategory = screenSize.width * 0.06;
    double tabFontSize = screenSize.width * 0.04;

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
                builder:
                    (context) => AlertDialog(
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
        body: NestedScrollView(
          headerSliverBuilder:
              (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: paddingH,
                      vertical: paddingV,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Ootd(),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            'Category',
                            style: TextStyle(
                              fontSize: textSizeCategory,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TabBar(
                        indicator: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color:
                                  Colors
                                      .blue, // Brighter color for the indicator
                              width: 2.0, // Thicker border for visibility
                            ),
                          ),
                        ),
                        tabAlignment: TabAlignment.start,
                        isScrollable: true,
                        labelStyle: TextStyle(fontSize: tabFontSize),
                        unselectedLabelStyle: TextStyle(
                          fontSize: tabFontSize * 0.9,
                        ),
                        labelColor: Colors.blue, // Selected tab text color
                        unselectedLabelColor: Colors.grey,
                        tabs: const [
                          Tab(text: 'Casual'),
                          Tab(text: 'Formal'),
                          Tab(text: 'Sporty'),
                          Tab(text: 'Summer'),
                          Tab(text: 'Winter'),
                          Tab(text: 'Party'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: OutfitGrid(),
                ),
              ),


              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Center(child: Text('Formal content')),
                ),
              ),


              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Center(child: Text('Sporty content')),
                ),
              ),


              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Center(child: Text('Summer content')),
                ),
              ),


              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Center(child: Text('Winter content')),
                ),
              ),


              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Center(child: Text('Party content')),
                ),
              ),

              
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Padding(
            padding: EdgeInsets.all(
              screenSize.width * 0.05,
            ), // Responsive padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: const Icon(Icons.home), onPressed: () {}),
                IconButton(icon: const Icon(Icons.search), onPressed: () {}),
                IconButton(
                  icon: const Icon(Icons.question_mark_rounded),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.question_mark_rounded),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
