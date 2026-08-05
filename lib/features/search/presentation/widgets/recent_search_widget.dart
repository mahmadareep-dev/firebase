import 'package:flutter/material.dart';

class RecentSearchWidget extends StatelessWidget {
  const RecentSearchWidget({
    super.key,
    required this.items,
    required this.onSelected,
  });

  final List<String> items;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        return ActionChip(label: Text(item), onPressed: () => onSelected(item));
      }).toList(),
    );
  }
}
