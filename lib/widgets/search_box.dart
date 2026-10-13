import 'package:flutter/material.dart';

class SearchBox extends StatelessWidget {
  final ValueChanged<String>? onChanged;
  final String hintText;

  const SearchBox({
    super.key,
    this.onChanged,
    this.hintText = 'Rechercher une destination',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return TextField(
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(
          Icons.search,
          color: cs.onSurfaceVariant,
        ),
        suffixIcon: IconButton(
          tooltip: 'Filtres',
          onPressed: () {},
          icon: Icon(
            Icons.tune,
            color: cs.primary,
          ),
        ),
        filled: true,
        fillColor: cs.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: cs.onSurfaceVariant,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: cs.primary,
            width: 1.5,
          ),
        ),
      ),
      style: theme.textTheme.bodyMedium?.copyWith(
        color: cs.onSurface,
      ),
    );
  }
}
