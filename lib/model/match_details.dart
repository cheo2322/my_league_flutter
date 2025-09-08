class MatchDetailsDto {
  final String? field;
  final bool isTheOwner;

  MatchDetailsDto({this.field, required this.isTheOwner});

  factory MatchDetailsDto.fromJson(Map<String, dynamic> json) {
    return MatchDetailsDto(
      field: json['field'] as String?,
      isTheOwner: json['isTheOwner'] as bool? ?? false,
    );
  }

  static List<MatchDetailsDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MatchDetailsDto.fromJson(json as Map<String, dynamic>)).toList();
  }

  Map<String, dynamic> toJson() {
    return {'field': field, 'isTheOwner': isTheOwner};
  }
}
