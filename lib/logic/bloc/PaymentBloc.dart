import 'dart:async';
import 'dart:convert';
import 'package:bpulsa/config.dart';
import 'package:http/http.dart' as http;
import 'package:bpulsa/model/PaymentModel.dart';
import 'package:bpulsa/database/DatabaseHelper.dart';

class PaymentBloc {
   var databaseHelper = new  DatabaseHelper() ;
  final PaymentController = StreamController<List<PaymentModel>>();
  Stream<List<PaymentModel>> get PaymentItems => PaymentController.stream;
  ConfigClass configClass = new ConfigClass();
  String emailMember ;
  PaymentBloc() {
      List dataResult;
      List dataContent;
      List<PaymentModel> kolom = [];
      (() async {
        var dbClient = await databaseHelper.db;
        List<Map> list = await dbClient.rawQuery('SELECT * FROM tabel_account');
        emailMember = list[0]["email"];
        await http.post(configClass.daftarPayment(), body: {"email":emailMember}).then((response) {
            kolom = [];
            var extractdata = json.decode(response.body);
            dataResult = extractdata["result"];
            dataContent = dataResult[0]["content"];
            for (var i = 0; i < dataContent.length; i++) {
               kolom.add( 
                  PaymentModel(
                          id_payment: dataContent[i]['id'],
                          id_trade_point: dataContent[i]['id_trade_point'],
                          tanggal: dataContent[i]['tanggal'],
                          jam: dataContent[i]['jam'],
                          status: dataContent[i]['status'],
                      )
                );     
              
            }
          
          
        });
        getPayments()  => kolom;
        PaymentController.add(getPayments());

      })();
     
      
  }
}
