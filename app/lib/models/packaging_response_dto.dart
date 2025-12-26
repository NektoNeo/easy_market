import 'packaging_response.dart';

class PackagingResponseDto {
  const PackagingResponseDto({required this.json});
  final Map<String, dynamic> json;

  PackagingResponse toDomain() => PackagingResponse.fromJson(json);

  static PackagingResponseDto fromJson(Map<String, dynamic> json) =>
      PackagingResponseDto(json: json);
}
