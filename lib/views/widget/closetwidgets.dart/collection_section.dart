import 'package:flutter/material.dart';


class CollectionSection extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onTap;


  const CollectionSection({
    super.key,
    required this.isExpanded,
    required this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Collection',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'Montserrat',
                fontWeight: isExpanded ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (isExpanded)
              const Padding(
                padding: EdgeInsets.only(top: 12.0),
                child: Text(
                  "You haven't saved any items here yet.",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
          ],
        ),
      ),
    );
  }
}



