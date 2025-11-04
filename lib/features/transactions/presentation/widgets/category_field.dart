import 'package:fin_track/app/extension/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CategoryField extends StatelessWidget {
  const CategoryField({
    super.key,
    required this.controller,
    required this.suggestions,
  });

  final TextEditingController controller;
  final List<String> suggestions;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue value) {
        final q = value.text.trim().toLowerCase();
        if (q.isEmpty) return const Iterable<String>.empty();
        return suggestions.where((c) => c.toLowerCase().contains(q));
      },
      fieldViewBuilder: (context, _ignored, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: context.loc.categoryLabel,
            filled: true,
            fillColor: cs.surface,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: cs.outlineVariant),
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
          ),
          validator: (v) =>
              (v?.trim().isEmpty ?? true) ? context.loc.categoryError : null,
          onFieldSubmitted: (_) => onFieldSubmitted(),
        );
      },
      onSelected: (value) {
        controller.text = value;
        HapticFeedback.selectionClick();
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 240, maxWidth: 360),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: options.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final opt = options.elementAt(index);
                  return ListTile(
                    title: Text(opt),
                    onTap: () => onSelected(opt),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
