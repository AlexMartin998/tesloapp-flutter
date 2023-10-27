class User {
  final String id;
  final String email;
  final String fullName;
  final String isActive;
  final String token;
  final List<String> roles;

  User({
    required this.id,
      required this.email,
      required this.fullName,
      required this.isActive,
      required this.token,
      required this.roles
  });


  bool get isAdmin {
    return roles.contains('admin');
  }

}
