class Resp{
  int status;
  bool success;
  String reason,message;
  Result result;
  Resp({
    this.status,
    this.reason,
    this.success,
    this.message,
    this.result,
});

factory Resp.fromJson(Map<String, dynamic> parsedJson){
    return Resp(
      status: parsedJson['status'],
      reason: parsedJson['reason'],
      success: parsedJson['success'],
      message: parsedJson['message'],
      result: Result.fromJson(parsedJson['result'])
    );
  }
}

class Result{
  String cek;
  String err;
  Content content;
  Result({
    this.cek,
    this.err,
    this.content
});
//
factory Result.fromJson(List<dynamic> json){
    var parsedJson = new Map<String, dynamic>.from(json[0]);
    return Result(
      cek: parsedJson['cek'],
      err: parsedJson['err'],
      content: Content.fromJson(parsedJson['content'])
    );
  }
}

class Content{
  String id,nama,nomor_telepon,saldo,status;
  Content({
    this.id,
    this.nama,
    this.nomor_telepon,
    this.saldo,
    this.status,
});

  factory Content.fromJson(Map<String, dynamic> json){
    return Content(
      id: json['id'],
      nama: json['nama'],
      nomor_telepon: json['nomor_telepon'],
      saldo: json['saldo'],
      status: json['status']
    );
  }
}
