class BeritaModel {
  String idBerita;
  String judulBerita;
  String message;
  String messageImage;
  String postTime;
  List<String> photos;

  BeritaModel(
      {
      this.idBerita,
      this.judulBerita,
      this.message,
      this.messageImage,
      this.postTime,
      this.photos
      });
}
