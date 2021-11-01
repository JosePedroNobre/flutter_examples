import 'package:json_annotation/json_annotation.dart';
part 'staff.g.dart';

@JsonSerializable()
class Staff {
  int id;
  String name;

  Staff({this.id, this.name});

  factory Staff.fromJson(Map<String, dynamic> json) => _$StaffFromJson(json);

  Map<String, dynamic> toJson() => _$StaffToJson(this);
}
