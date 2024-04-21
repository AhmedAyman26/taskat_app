class UserRegisterInput {
  final String name;
  final String email;
  final String password;

  UserRegisterInput(this.name, this.email, this.password);

  Map<String, dynamic> toJson(final bool isCreate) => {
    'name': name,
    'email': email,
    if (!isCreate) "password": password,
  };
}