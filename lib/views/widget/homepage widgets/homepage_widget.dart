import 'package:fasionrecommender/views/widget/homepage%20widgets/homepage_gridview.dart';
import 'package:fasionrecommender/views/widget/homepage%20widgets/ootd.dart';
import 'package:flutter/material.dart';
import 'package:fasionrecommender/data/responsive_utils.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
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

    return NestedScrollView(
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
                        'Suggested Outfits',
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
                child: TabBar(
                  indicator: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.blue, // Brighter color for the indicator
                        width: 2.0, // Thicker border for visibility
                      ),
                    ),
                  ),
                  tabAlignment: TabAlignment.start,
                  isScrollable: true,
                  labelStyle: TextStyle(fontSize: tabFontSize),
                  unselectedLabelStyle: TextStyle(fontSize: tabFontSize * 0.9),
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
          ],

      body: TabBarView(
        children: [
          SingleChildScrollView(child: OutfitGrid(category: 'Tops')),

          SingleChildScrollView(child: OutfitGrid(category: 'Bottoms')),

          SingleChildScrollView(child: Center(child: Text('INSERT IMAGES'))),

          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Center(child: Text('INSERT IMAGES')),
            ),
          ),

          SingleChildScrollView(child: Center(child: Text('INSERT IMAGES'))),

          SingleChildScrollView(child: Center(child: Text('INSERT IMAGES'))),
        ],
      ),
    );
  }
}
