import 'package:fasionrecommender/services/openweathermap.dart';
import 'package:fasionrecommender/data/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';


class Ootd extends StatefulWidget {
  const Ootd({super.key});
  @override
  State<Ootd> createState() => _OotdState();
}

class _OotdState extends State<Ootd> {
  String location = 'Loading...';
  String temp = '--';
  String imageDirect = 'assets/images/onboard-bg.jpg';
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchWeatherAndLocation();
  }

  Future<void> _fetchWeatherAndLocation() async {
    try {
      final position = await getCurrentLocation(); // uses your utility method
      final fetchedTemp = await getTemperature(position.latitude, position.longitude); // uses your utility method

      final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      final place = placemarks.first;
      final loc = '${place.locality}, ${place.country}';

      setState(() {
        location = loc;
        temp = fetchedTemp;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error getting location or weather: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: ValueListenableBuilder(
        valueListenable: isDarkModeNotifier,
        builder: (context, value, child) {
          return Container(
            decoration: BoxDecoration(
              color: value ? Colors.black38 : Colors.white70,
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
              height: screenSize.height * 0.3,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * 0.05,
                        vertical: screenSize.height * 0.03,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Today, ${DateFormat('MMM').format(now)} ${now.day}',
                            style: TextStyle(
                              fontSize: screenSize.width * 0.045,
                              fontWeight: FontWeight.w500,
                              color: value ? Colors.white : Colors.black,
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.01),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: screenSize.width * 0.04,
                                color: value ? Colors.grey : Colors.black,
                              ),
                              SizedBox(width: 4),
                              Text(
                                location,
                                style: TextStyle(
                                  fontSize: screenSize.width * 0.045,
                                  color: value ? Colors.grey : Colors.black,
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
                                  fontSize: screenSize.width * 0.06,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.wb_sunny, color: Colors.orange, size: screenSize.width * 0.06),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: screenSize.height * 0.02,
                        right: screenSize.width * 0.05,
                        bottom: screenSize.height * 0.02,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage(imageDirect),
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