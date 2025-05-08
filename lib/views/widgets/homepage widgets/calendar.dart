import 'package:fasionrecommender/services/storage/outfits_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarDialog extends StatefulWidget {
  final DateTime selectedDay;

  const CalendarDialog({super.key, required this.selectedDay});

  @override
  State<CalendarDialog> createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  List<Map<String, dynamic>> userOutfits = [];
  Set<DateTime> ootdDates = {};
  Map<DateTime, Map<String, dynamic>> ootdMap = {};

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.selectedDay;
    _selectedDay = widget.selectedDay;
    _initializeData();
  }

  Future<void> _initializeData() async {
    final outfitService = Provider.of<OutfitService>(context, listen: false);
    final outfits = await outfitService.retrieveOutfits();
    final ootds = await outfitService.retrieveOutfitsOfTheDay();

    final Set<DateTime> ootdDays = {};
    final Map<DateTime, Map<String, dynamic>> ootdMapping = {};

    for (var entry in ootds) {
      final date = DateTime.parse(entry['date']);
      final normalized = DateTime(date.year, date.month, date.day);
      ootdDays.add(normalized);
      ootdMapping[normalized] = entry;
    }

    setState(() {
      userOutfits = outfits;
      ootdDates = ootdDays;
      ootdMap = ootdMapping;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium ?? const TextStyle();
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return AlertDialog(
      contentPadding: const EdgeInsets.all(16),
      content: SizedBox(
        width: screenWidth * 0.9,
        height: screenHeight * 0.45,
        child: Column(
          children: [
            Flexible(
              flex: 4,
              child: TableCalendar(
                calendarFormat: CalendarFormat.month,
                availableCalendarFormats: const {CalendarFormat.month: 'Month'},
                firstDay: DateTime.utc(2025, 1, 1),
                lastDay: DateTime.utc(2050, 12, 25),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                headerStyle: const HeaderStyle(titleCentered: true),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });

                  final normalized = DateTime(selectedDay.year, selectedDay.month, selectedDay.day);

                  if (ootdMap.containsKey(normalized)) {
                    _showOOTDDialog(context, normalized);
                  } else {
                    _showOutfitSelectionDialog(context, normalized);
                  }
                },
                calendarStyle: CalendarStyle(
                  weekendTextStyle: textStyle,
                  todayDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  selectedDecoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: Colors.greenAccent,
                    shape: BoxShape.circle,
                  ),
                ),
                eventLoader: (day) {
                  final normalized = DateTime(day.year, day.month, day.day);
                  return ootdDates.contains(normalized) ? [true] : [];
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOOTDDialog(BuildContext context, DateTime selectedDay) {
    final outfit = ootdMap[selectedDay];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("OOTD for ${DateFormat.yMMMMd().format(selectedDay)}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.checkroom),
                title: Text(outfit?['outfit_name'] ?? 'Unknown Outfit'),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.delete),
                    label: const Text("Remove"),
                    onPressed: () async {
                      try {
                        await Provider.of<OutfitService>(context, listen: false)
                            .deleteOutfitOfTheDay(selectedDay);

                        setState(() {
                          ootdDates.remove(selectedDay);
                          ootdMap.remove(selectedDay);
                        });

                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Outfit of the Day removed')),
                        );
                      } catch (e) {
                        print('Error deleting OOTD: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to remove OOTD: $e')),
                        );
                      }
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.change_circle),
                    label: const Text("Change"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showOutfitSelectionDialog(context, selectedDay);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showOutfitSelectionDialog(BuildContext context, DateTime selectedDay) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.calendar_today, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Choose your OOTD for\n${DateFormat.yMMMMd().format(selectedDay)}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: screenWidth * 0.8,
            height: screenHeight * 0.4,
            child: userOutfits.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: userOutfits.length,
                    itemBuilder: (context, index) {
                      final outfit = userOutfits[index];
                      return ListTile(
                        leading: const Icon(Icons.checkroom),
                        title: Text(outfit['outfit_name']),
                        onTap: () async {
                          final outfitId = outfit['outfit_id'];
                          try {
                            await Provider.of<OutfitService>(
                              context,
                              listen: false,
                            ).setOutfitOfTheDay(
                              outfitId: outfitId,
                              date: selectedDay,
                            );

                            setState(() {
                              ootdDates.add(selectedDay);
                              ootdMap[selectedDay] = outfit;
                            });

                            Navigator.of(context).pop();
                          } catch (e) {
                            print('Error setting OOTD: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to set OOTD: $e'),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
