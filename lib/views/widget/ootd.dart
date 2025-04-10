import 'package:fasionrecommender/data/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Ootd extends StatefulWidget {
  const Ootd({super.key});

  @override
  State<Ootd> createState() => _OotdState();
}

class _OotdState extends State<Ootd> {
  String location = 'Batangas City';
  String date = 'Today, Jan 1';
  int temp = 38;
  String imageDirect = 'assets/images/onboard-bg.jpg';
  DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // Get the screen size for responsive design
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ValueListenableBuilder(
        valueListenable: isDarkModeNotifier,
        builder: (context, value, child) {
          return Container(
            decoration: BoxDecoration(
              color: value ? Colors.white : Colors.white70,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: SizedBox(
              height: screenSize.height * 0.3, // Adjust height based on screen size
              child: Row(
                children: [
                  // Left side
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.05, // Responsive horizontal padding
                        vertical: screenSize.height * 0.03, // Responsive vertical padding
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Today, ${DateFormat('MMM').format(now)} ${now.day}',
                            style: TextStyle(
                              fontSize: screenSize.width * 0.045, // Responsive font size
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.01), // Responsive space
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: screenSize.width * 0.05, // Responsive icon size
                                color: Colors.black54,
                              ),
                              SizedBox(width: 4),
                              Text(
                                location,
                                style: TextStyle(
                                  fontSize: screenSize.width * 0.045, // Responsive text size
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenSize.height * 0.01),
                          Text(
                            'Weather',
                            style: TextStyle(fontSize: screenSize.width * 0.035, color: Colors.grey[600]),
                          ),
                          Row(
                            children: [
                              Text(
                                '$temp°C',
                                style: TextStyle(
                                  fontSize: screenSize.width * 0.06, // Responsive font size
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.wb_sunny, color: Colors.orange, size: screenSize.width * 0.06), // Responsive icon
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Right side: outfit image
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: screenSize.height * 0.02, // Responsive padding
                        right: screenSize.width * 0.05, // Responsive padding
                        bottom: screenSize.height * 0.02, // Responsive padding
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20), // Adjust the radius for rounded corners
                          image: DecorationImage(
                            image: AssetImage(imageDirect), // Use the uploaded image
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
