class DomainController {
  //One instance, needs factory
  static DomainController _instance;
  factory DomainController() => _instance ??= new DomainController._();
  DomainController._();

  String domain = '';
  int storeId = 1;

  String getServerUrl() {
    return domain;
  }

  int setStoreId() {
    return storeId;
  }
}
