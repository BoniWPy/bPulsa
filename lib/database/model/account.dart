class Account {
  int id;
  String _email;
  String _password;
  String _nama;
  String _nomor_telepon;
  int _saldo;
  int _status;
  Account(this._email, this._password, this._nama, this._nomor_telepon,this._saldo,this._status);
  Account.map(dynamic obj) {
    this._email = obj["email"];
    this._nama = obj["password"];
    this._password = obj["nama"];
    this._nomor_telepon = obj["nomor_telepon"];
    this._saldo = obj["saldo"];
    this._status = obj["status"];
  }
  String get accountEmail => _email;
  String get accountPassword => _password;
  String get accountNama => _nama;
  String get accountNomorTelepon => _nomor_telepon;
  int get accountSaldo => _saldo;
  int get accountStatus => _status;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map["email"] = accountEmail;
    map["password"] = accountPassword;
    map["nama"] = accountNama;
    map["nomor_telepon"] = accountNomorTelepon;
    map["saldo"] = accountSaldo;
    map["status"] = accountStatus;
    return map;
  }
  void setAccountId(int id) {
    this.id = id;
  }
}
