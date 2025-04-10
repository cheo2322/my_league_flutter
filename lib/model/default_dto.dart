class DefaultDto {
  final String? id;
  final String name;

  DefaultDto({required this.id, required this.name});

  factory DefaultDto.fromJson(Map<String, dynamic> json) {
    return DefaultDto(id: json['id'], name: json['name']);
  }

  static List<DefaultDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => DefaultDto.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
