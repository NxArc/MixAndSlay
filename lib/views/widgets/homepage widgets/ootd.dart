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

      outfits = (response as List)
          .map((item) => {
                'name': item['name'] as String,
                'image_url': item['image_url'] as String,
              })
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxWidth < 600;

            return Row(
              children: [
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.04,
                      vertical: screenSize.height * 0.015,
                    ),
                    child: _buildInfoSection(textTheme, colorScheme, screenSize, isCompact),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SizedBox(
                    width: isCompact ? 120 : 180,
                    height: isCompact ? 160 : 220,
                    child: _buildImageSection(currentOutfit),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoSection(TextTheme textTheme, ColorScheme colorScheme, Size screenSize, bool isCompact) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today, ${DateFormat('MMM').format(now)} ${now.day}',
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: colorScheme.onSurface,
            fontSize: isCompact ? 18 : screenSize.width * 0.045,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.location_on, size: isCompact ? 16 : 18, color: colorScheme.primary.withOpacity(0.8)),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                location,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: isCompact ? 16 : screenSize.width * 0.045,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Weather',
          style: textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.6),
            fontSize: isCompact ? 11 : screenSize.width * 0.035,
          ),
        ),
        Row(
          children: [
            Text(
              '$temp°C',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: isCompact ? 24 : screenSize.width * 0.06,
                color: colorScheme.onSurface,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(width: 8),
            if (double.tryParse(temp) != null) _getTemperatureIcon(double.parse(temp)),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
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
    );
  }

  Widget _buildImageSection(Map<String, String>? currentOutfit) {
    return GestureDetector(
      onTap: () {
        if (currentOutfit != null) {
          showSystemOutfitDialog(context, currentOutfit['name']!);
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: currentOutfit != null
            ? CachedNetworkImage(
                imageUrl: currentOutfit['image_url']!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                  ),
                ),
              )
            : Container(
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              ),
      ),
    );
  }
}
