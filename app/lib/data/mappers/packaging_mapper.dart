import '../../models/packaging_request.dart';
import '../../models/packaging_request_dto.dart';
import '../../models/packaging_response.dart';
import '../../models/packaging_response_dto.dart';

class PackagingMapper {
  static PackagingRequestDto toDto(PackagingRequest request) {
    return PackagingRequestDto.fromDomain(request);
  }

  static PackagingResponse toDomain(PackagingResponseDto dto) {
    return dto.toDomain();
  }
}
