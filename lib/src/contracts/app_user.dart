class AppUser {
  const AppUser({
    required this.id,
    this.name,
    this.email,
    this.extra = const {},
  });

  final String id;
  final String? name;
  final String? email;
  final Map<String, Object?> extra;
}
