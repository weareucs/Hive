class UserModel {
  final String name;
  final String email;
  final String mobile;
  final String created_at;

  UserModel(
      {required this.name,
      required this.email,
      required this.mobile,
      required this.created_at});

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      mobile: data['mobile'] ?? '',
      created_at: data['created_at'] ?? '',
    );
  }
}
