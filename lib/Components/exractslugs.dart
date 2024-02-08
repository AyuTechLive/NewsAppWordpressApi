String extractSlugFromUrl(String url) {
  // Remove the http:// or https:// prefix from the URL
  Uri uri = Uri.parse(url);

  // Split the path into segments
  List<String> segments = uri.pathSegments;

  // The slug is typically the last segment in the path, so let's try to grab that
  String slug = segments.isNotEmpty ? segments.last : '';

  // In some cases, the last segment might be empty, so we check the one before last
  if (slug.isEmpty && segments.length > 1) {
    slug = segments[segments.length - 2];
  }

  // Remove any trailing slashes or file extensions (like .html) if present
  slug = slug.replaceAll(RegExp(r'\/$'), '').replaceAll(RegExp(r'\.html$'), '');

  return slug;
}
