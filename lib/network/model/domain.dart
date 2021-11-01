import 'package:json_annotation/json_annotation.dart';

part 'domain.g.dart';

@JsonSerializable()
class Domain {
  int id;
  String name;
  String dnsName;

  Domain({this.id, this.dnsName, this.name});

  factory Domain.fromJson(Map<String, dynamic> json) => _$DomainFromJson(json);

  Map<String, dynamic> toJson() => _$DomainToJson(this);
}
