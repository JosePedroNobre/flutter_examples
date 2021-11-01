import 'package:json_annotation/json_annotation.dart';

part 'sensei_error.g.dart';

@JsonSerializable()
class SenseiError {
  String message;
  String errorCode;
  int status;

  SenseiError(this.message, this.errorCode, this.status);

  factory SenseiError.fromJson(Map<String, dynamic> json) =>
      _$SenseiErrorFromJson(json);

  Map<String, dynamic> toJson() => _$SenseiErrorToJson(this);
}
