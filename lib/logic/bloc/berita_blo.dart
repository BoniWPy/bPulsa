import 'dart:async';

import 'package:bpulsa/model/berita.dart';

class BeritaBloc {
  final BeritaViewModel beritaViewModel = BeritaViewModel();
  final beritaController = StreamController<List<BeritaModel>>();
  final fabController = StreamController<bool>();
  final fabVisibleController = StreamController<bool>();
  Sink<bool> get fabSink => fabController.sink;
  Stream<List<BeritaModel>> get beritaItems => beritaController.stream;
  Stream<bool> get fabVisible => fabVisibleController.stream;

  BeritaBloc() {
    beritaController.add(beritaViewModel.getBeritas());
    fabController.stream.listen(onScroll);
  }
  onScroll(bool visible) {
    fabVisibleController.add(visible);
  }

  void dispose() {
    beritaController?.close();
    fabController?.close();
    fabVisibleController?.close();
  }
}


class BeritaViewModel {
  List<BeritaModel> beritaItems;

  BeritaViewModel({this.beritaItems});

  getBeritas() => <BeritaModel>[
        BeritaModel(
            judulBerita: "Google Developer Expert for Flutter",
            message:
                "Google Developer Expert for Flutter. Passionate #Flutter, #Android Developer. #Entrepreneur #YouTuber",
            messageImage:
                "https://cdn.pixabay.com/photo/2018/03/09/16/32/woman-3211957_1280.jpg",
            postTime: "Just Now"),
        BeritaModel(
            judulBerita: "Entrepreneur",
            message:
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since",
            messageImage:
                "https://cdn.pixabay.com/photo/2016/04/10/21/34/woman-1320810_960_720.jpg",
            postTime: "Just Now"),
        BeritaModel(
            judulBerita: "Android Developer",
            message:
                "#Android Developer. #Entrepreneur #YouTuber",
            messageImage:
                "https://cdn.pixabay.com/photo/2013/07/18/20/24/brad-pitt-164880_960_720.jpg",
            postTime: "Just Now"),
      
      ];
}
