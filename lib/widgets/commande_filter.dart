import 'package:flutter/material.dart';

class CommandeFilter extends StatelessWidget {
  final String selectedFilter;
  final Function(String) onSelected;

  const CommandeFilter({
    super.key,
    required this.selectedFilter,
    required this.onSelected,
  });

  final List<String> filters = const [
    'Toutes',
    'En cours',
    'Livrée',
    'Annuler',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final filter = filters[index];

          final isSelected = selectedFilter == filter;

          return GestureDetector(
            onTap: () => onSelected(filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF2F80C9)
                    : const Color(0xFFE5E5E5),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}