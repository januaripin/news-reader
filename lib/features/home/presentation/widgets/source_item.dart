import 'package:flutter/material.dart';

class SourceItem extends StatelessWidget {
  final String label;
  final ValueChanged<bool> onSelected;
  final bool selected;

  const SourceItem(
      {Key? key,
      required this.label,
      required this.onSelected,
      required this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: ChoiceChip(
          label: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey[800]),
          ),
          selected: selected,
          selectedColor: Colors.grey[300],
          backgroundColor: Colors.grey,
          onSelected: onSelected,
        ));
  }
}
