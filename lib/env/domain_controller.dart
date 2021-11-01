class DomainController {
  //One instance, needs factory
  static DomainController _instance;
  factory DomainController() => _instance ??= new DomainController._();
  DomainController._();

  String domain = '';

  String getServerUrl() {
    return domain;
  }
}
