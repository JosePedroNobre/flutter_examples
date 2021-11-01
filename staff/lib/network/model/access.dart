class Access {
  int id;
  String name;
  String image;
  String lastAccess;
  String qrData;
  bool isOpened;
  bool hasTextInput;
  bool showQrCode;

  Access(
      {this.id,
      this.image,
      this.lastAccess,
      this.name,
      this.qrData,
      this.showQrCode = true,
      this.hasTextInput = false,
      this.isOpened = false});
}
