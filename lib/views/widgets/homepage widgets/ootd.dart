import 'package:fasionrecommender/services/api/openweathermap.dart';
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
      final position = await getCurrentLocation();
      final fetchedTemp = await getTemperature(position.latitude, position.longitude);

      final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      final place = placemarks.first;
      final loc = '${place.locality}, ${place.country}';

      setState(() {
        location = loc;
        temp = fetchedTemp;
      });
    } catch (e) {
      print('Error getting location or weather: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final screenSize = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: colorScheme.shadow.withOpacity(0.1),
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
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                          fontSize: screenSize.width * 0.045,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.01),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: screenSize.width * 0.04,
                            // ignore: deprecated_member_use
                            color: colorScheme.primary.withOpacity(0.8),
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface,
                                fontSize: screenSize.width * 0.045,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenSize.height * 0.01),
                      Text(
                        'Weather',
                        style: textTheme.labelMedium?.copyWith(
                          // ignore: deprecated_member_use
                          color: colorScheme.onSurface.withOpacity(0.6),
                          fontSize: screenSize.width * 0.035,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '$temp°C',
                            style: textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: screenSize.width * 0.06,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.wb_sunny,
                            color: Colors.orange,
                            size: screenSize.width * 0.06,
                          ),
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
      ),
    );
  }
}
