String? validateImageUrl(String? value) {
  if (value == null || value.trim().isEmpty) return null;

  final uri = Uri.tryParse(value.trim());
  if (uri == null || (uri.scheme != 'http' && uri.scheme != 'https')) {
    return 'Entrez une URL d’image valide';
  }

  final host = uri.host.toLowerCase();
  if (host == 'pinterest.com' || host.endsWith('.pinterest.com') ||
      host == 'pin.it') {
    return 'Utilisez le lien direct i.pinimg.com, pas le lien Pinterest';
  }

  return null;
}