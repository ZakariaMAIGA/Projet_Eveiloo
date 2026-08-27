import '../../../models/proposition.dart';

String? normalizeChoiceAnswer(
  String value,
  List<Proposition> options,
) {
  final input = value.trim();
  if (input.isEmpty) return null;

  for (final option in options) {
    if (option.id.toLowerCase() == input.toLowerCase() ||
        option.texte.trim().toLowerCase() == input.toLowerCase()) {
      return option.id;
    }
  }

  return null;
}