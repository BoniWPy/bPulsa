import 'dart:async';
import 'dart:convert';
import 'dart:convert' show jsonDecode;
import 'package:http/http.dart' as http;
import 'package:bpulsa/config.dart';
import 'package:http/http.dart' as http;
import 'package:bpulsa/model/TukarPointModel.dart';

class TukarPointBloc {
  final tukarPointController = StreamController<List<TukarPointModel>>();
  Stream<List<TukarPointModel>> get tukarPointItems => tukarPointController.stream;
  ConfigClass configClass = new ConfigClass();

  TukarPointBloc() {
      List dataResult;
      List dataContent;
      List<TukarPointModel> kolom = [];
      (() async {
        await http.post(configClass.daftarTukarPoint(), body: {"email":"vulnwalker@tuyul.online"}).then((response) {
            kolom = [];
            var extractdata = json.decode(response.body);
            dataResult = extractdata["result"];
            dataContent = dataResult[0]["content"];
            for (var i = 0; i < dataContent.length; i++) {
               kolom.add( 
                  TukarPointModel(
                          id_trade_point: dataContent[i]['id'],
                          brand: "PULSA",
                          description: dataContent[i]['description'],
                          image:dataContent[i]['gambar'],
                          name: dataContent[i]['title'],
                          price: dataContent[i]['price'],
                          rating: dataContent[i]['stock'],
                          quantity: 0,
                      )
                );     
              
            }
          
          
        });
        getTukarPoints()  => kolom;
        tukarPointController.add(getTukarPoints());

      })();
     
      
  }
}
