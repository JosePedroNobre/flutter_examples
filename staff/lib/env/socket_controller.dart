class SocketController {
  //One instance, needs factory
  static SocketController _instance;
  factory SocketController() => _instance ??= new SocketController._();
  SocketController._();

  String socketurl = '';

  String getSocketUrl() {
    return socketurl;
  }
}
