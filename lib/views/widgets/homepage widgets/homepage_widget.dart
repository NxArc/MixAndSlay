import 'package:fasionrecommender/views/widgets/homepage%20widgets/homepage_outfitgrid.dart';
import 'package:fasionrecommender/views/widgets/homepage%20widgets/ootd.dart';
import 'package:flutter/material.dart';
import 'package:fasionrecommender/data/responsive_utils.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final paddingH = ResponsiveUtils.paddingH(context);
    final paddingV = ResponsiveUtils.paddingV(context);
    final titleFontSize = ResponsiveUtils.titleSize(context);
    double textSizeCategory = screenSize.width * 0.06;
    double tabFontSize = screenSize.width * 0.04;

    return DefaultTabController(
      length: 8, // Make sure this matches the number of tabs
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(
            'Home',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: titleFontSize,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
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
                        Ootd(),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: Text(
                            'Mix&Slay Outfits',
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
                          bottom: BorderSide(color: Colors.blue, width: 2.0),
                        ),
                      ),
                      tabAlignment: TabAlignment.start,
                      isScrollable: true,
                      labelStyle: TextStyle(fontSize: tabFontSize),
                      unselectedLabelStyle: TextStyle(
                        fontSize: tabFontSize * 0.9,
                      ),
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.grey,
                      tabs: const [
                        Tab(text: 'Formal'),
                        Tab(text: 'Casual'),
                        Tab(text: 'Sporty'),
                        Tab(text: 'Party'),
                        Tab(text: 'Outdoor'),
                        Tab(text: 'Professional'),
                        Tab(text: 'Beach'),
                        Tab(text: 'Cold Weather'),
                      ],
                    ),
                  ),
                ),
              ],
          body: TabBarView(
            children: [
              SingleChildScrollView(child: OutfitGrid(category: 'Formal')),
              SingleChildScrollView(child: OutfitGrid(category: 'Casual')),
              SingleChildScrollView(child: OutfitGrid(category: 'Sporty')),
              SingleChildScrollView(child: OutfitGrid(category: 'Party')),
              SingleChildScrollView(child: OutfitGrid(category: 'Outdoor')),
              SingleChildScrollView(
                child: OutfitGrid(category: 'Professional'),
              ),
              SingleChildScrollView(child: OutfitGrid(category: 'Beach')),
              SingleChildScrollView(
                child: OutfitGrid(category: 'Cold Weather'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
