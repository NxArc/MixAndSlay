import 'package:fasionrecommender/controllers/homepage_controller.dart';
import 'package:fasionrecommender/views/pages/authenticate/login_page.dart';
import 'package:fasionrecommender/views/widget/ootd.dart';
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Image(
          image: AssetImage('assets/images/app_logo.png'),
          height: 55,
        ),
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder:
                  (context) => AlertDialog(
                    title: Text('Confirm Logout'),
                    content: Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('Logout'),
                      ),
                    ],
                  ),
            );
            if (confirmed == true) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
              signOut();
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Ootd(),
            const SizedBox(height: 0),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                children: [
                  Text(
                    'Category',
                    style: TextStyle(
                      fontSize: screenSize.width * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  DefaultTabController(
                    length: 6, // Adjust the number of tabs here
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                          ), // Optional: for spacing
                          child: TabBar(
                            indicator: BoxDecoration(),
                            tabAlignment: TabAlignment.start,
                            isScrollable: true, // Make the TabBar scrollable
                            tabs: [
                              Tab(text: 'Casual'),
                              Tab(text: 'Formal'),
                              Tab(text: 'Sporty'),
                              Tab(text: 'Summer'),
                              Tab(text: 'Winter'),
                              Tab(text: 'Party'),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 300,
                          child: TabBarView(
                            children: [
                              Center(child: Text('Casual content')),
                              Center(child: Text('Formal content')),
                              Center(child: Text('Sporty content')),
                              Center(child: Text('Summer content')),
                              Center(child: Text('Summer content')),
                              Center(child: Text('Summer content')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
    );
  }
}
