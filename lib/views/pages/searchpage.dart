import 'dart:async';
import 'package:fasionrecommender/views/pages/closet.dart';
import 'package:fasionrecommender/views/widgets/closetwidgets.dart/popups/clothing_item_display.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fasionrecommender/data/responsive_utils.dart';

class Searchpage extends StatefulWidget {
  const Searchpage({super.key});

  @override
  State<Searchpage> createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      final query = _searchController.text.trim();
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in.');

      final clothingResponse = await supabase
          .from('user_clothing_items')
          .select()
          .eq('uid', userId)
          .ilike('name', '%$query%');

      final outfitResponse = await supabase
          .from('user_outfits')
          .select()
          .eq('uuid', userId)
          .ilike('outfit_name', '%$query%');

      final clothingResults =
          (clothingResponse as List)
              .cast<Map<String, dynamic>>()
              .map((item) => {...item, 'type': 'clothing'})
              .toList();

      final outfitResults =
          (outfitResponse as List)
              .cast<Map<String, dynamic>>()
              .map((item) => {...item, 'type': 'outfit'})
              .toList();

      setState(() {
        _searchResults = [...clothingResults, ...outfitResults];
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Search failed: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onItemTap(Map<String, dynamic> item) {
    if (item['type'] == 'clothing') {
      final itemID = item['item_id'];
      showClothingItemDialog(context, itemID);
    } else if (item['type'] == 'outfit') {
      final itemID = item['outfit_id'];
      showOutfitDialog(context, itemID);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final titleFontSize = ResponsiveUtils.titleSize(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Search',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: titleFontSize,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Search outfits or clothing...',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.5),
                ),
                filled: true,
                fillColor: colorScheme.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: Icon(Icons.search, color: colorScheme.primary),
              ),
            ),
          ),
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            Expanded(
              child:
                  _searchResults.isEmpty
                      ? Center(
                        child: Text(
                          'No results found.',
                          style: theme.textTheme.bodyLarge,
                        ),
                      )
                      : ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final item = _searchResults[index];
                          final title =
                              item['type'] == 'clothing'
                                  ? item['name'] ?? 'Unnamed Clothing'
                                  : item['outfit_name'] ?? 'Unnamed Outfit';
                          final icon =
                              item['type'] == 'clothing'
                                  ? Icons.checkroom
                                  : Icons.style;

                          return ListTile(
                            leading: Icon(icon, color: colorScheme.primary),
                            title: Text(
                              title,
                              style: theme.textTheme.titleMedium,
                            ),
                            subtitle: Text(
                              item['type'],
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            onTap: () => _onItemTap(item),
                            tileColor: colorScheme.surface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                          );
                        },
                      ),
            ),
        ],
      ),
    );
  }
}
