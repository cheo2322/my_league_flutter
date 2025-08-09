class PhaseDto {
  final String? id;
  final String name;
  final String status;

  PhaseDto({required this.id, required this.name, required this.status});

  factory PhaseDto.fromJson(Map<String, dynamic> json) {
    return PhaseDto(id: json['id'], name: json['name'], status: json['status']);
  }

  static List<PhaseDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PhaseDto.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'status': status};
  }
}
