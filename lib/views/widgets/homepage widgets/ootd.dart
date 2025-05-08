import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fasionrecommender/services/api/openweathermap.dart';

import 'package:fasionrecommender/views/widgets/closetwidgets.dart/popups/system_outfit_display.dart';
import 'package:fasionrecommender/views/widgets/homepage%20widgets/calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Ootd extends StatefulWidget {
  const Ootd({super.key});

  @override
  State<Ootd> createState() => _OotdState();
}

class _OotdState extends State<Ootd> {
  String location = 'Loading...';
  String temp = '--';
  DateTime now = DateTime.now();

  List<Map<String, String>> outfits = [];
  int currentIndex = 0;
  Timer? timer;

  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _fetchWeatherAndLocation();
    _loadOutfitImages();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Icon _getTemperatureIcon(double temp) {
    if (temp >= 30) {
      return const Icon(Icons.wb_sunny, color: Colors.orange);
    } else if (temp >= 20) {
      return const Icon(Icons.wb_cloudy, color: Colors.lightBlue);
    } else if (temp >= 10) {
      return const Icon(Icons.ac_unit, color: Colors.blue);
    } else {
      return const Icon(Icons.cloud, color: Colors.grey);
    }
  }

  void _openCalendar(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CalendarDialog(selectedDay: DateTime.now());
      },
    );
  }

  Future<void> _fetchWeatherAndLocation() async {
    try {
      final position = await getCurrentLocation();
      final fetchedTemp = await getTemperature(
        position.latitude,
        position.longitude,
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
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

  Future<void> _loadOutfitImages() async {
    try {
      final response = await supabase
          .from('system_outfits')
          .select('name, image_url');

      outfits =
          (response as List)
              .map(
                (item) => {
                  'name': item['name'] as String,
                  'image_url': item['image_url'] as String,
                },
              )
              .where((item) => item['image_url']!.isNotEmpty)
              .toList();

      if (outfits.isNotEmpty) {
        setState(() {});
        timer = Timer.periodic(const Duration(seconds: 5), (Timer t) {
          setState(() {
            currentIndex = (currentIndex + 1) % outfits.length;
          });
        });
      }
    } catch (e) {
      print('Error loading outfit images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final screenSize = MediaQuery.of(context).size;

    final currentOutfit = outfits.isNotEmpty ? outfits[currentIndex] : null;

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SizedBox(
          height: screenSize.height * 0.25,
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
                        overflow:
                            TextOverflow
                                .ellipsis, // Added overflow for long text
                      ),
                      SizedBox(height: screenSize.height * 0.01),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: screenSize.width * 0.04,
                            color: colorScheme.primary.withOpacity(0.8),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              overflow: TextOverflow.ellipsis, // Already added
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
                          color: colorScheme.onSurface.withOpacity(0.6),
                          fontSize: screenSize.width * 0.035,
                        ),
                        overflow:
                            TextOverflow
                                .ellipsis, // Added overflow for long text
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
                            overflow:
                                TextOverflow
                                    .ellipsis, // Added overflow for long text
                          ),
                          const SizedBox(width: 8),
                          if (double.tryParse(temp) != null)
                            _getTemperatureIcon(double.parse(temp)),
                        ],
                      ),
                      SizedBox(height: screenSize.height * 0.015),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.transparent, // Transparent background
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              4,
                            ), // Rectangular with slight rounding
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () => _openCalendar(context),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.calendar_today),
                            SizedBox(width: 8),
                            Text("Schedule your OOTD!"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: screenSize.height * 0.01,
                    right: screenSize.width * 0.02,
                    bottom: screenSize.height * 0.01,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      showSystemOutfitDialog(context, currentOutfit!['name']!);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child:
                          currentOutfit != null
                              ? CachedNetworkImage(
                                imageUrl: currentOutfit['image_url']!,
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) => Container(
                                      color: Colors.grey[200],
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                errorWidget:
                                    (context, url, error) => Container(
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                              )
                              : Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
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
