class LoginDto {
  final String email;
  final String token;

  LoginDto({required this.email, required this.token});

  factory LoginDto.fromJson(Map<String, dynamic> json) {
    return LoginDto(email: json['email'], token: json['token']);
  }

  static List<LoginDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => LoginDto.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'token': token};
  }
}
