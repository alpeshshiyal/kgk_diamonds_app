
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:kgk_diamonds_app/ui/cart_page.dart';
import 'package:kgk_diamonds_app/ui/result_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../model/diamond.dart';
import 'events.dart';


class DiamondFilterBloc extends Bloc<DiamondFilterEvent, DiamondFilterState> {
  DiamondFilterBloc() : super(DiamondFilterState());
  List<Diamond> _allDiamonds = [];

  void loadData() async {
    final String response = await rootBundle.loadString('assets/diamonds.json');
    final List<dynamic> data = json.decode(response);
    final List<Diamond> diamonds = data.map((e) =>e!=null?Diamond.fromJson(e):Diamond()).toList();
    final List<dynamic> jsonResponse = json.decode(response);
    // _allDiamonds = jsonResponse.map((data) => Diamond.fromJson(data)).toList();
    _allDiamonds = diamonds;
    debugPrint("all diamond list:${_allDiamonds.length}");
    emit(DiamondFilterState(diamonds: diamonds, filteredDiamonds: diamonds));
  }

  @override
  Stream<DiamondFilterState> mapEventToState(DiamondFilterEvent event) async* {
    if (event is ApplyFilterEvent) {
      List<Diamond> filtered = state.diamonds.where((diamond) {
        return (event.lab.isEmpty || diamond.lab == event.lab) &&
            (event.shape.isEmpty || diamond.shape == event.shape) &&
            (event.color.isEmpty || diamond.color == event.color) &&
            (event.clarity.isEmpty || diamond.clarity == event.clarity);
      }).toList();
      yield DiamondFilterState(diamonds: state.diamonds, filteredDiamonds: filtered);
    }
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'cart.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE cart(lotId TEXT PRIMARY KEY, size TEXT, carat REAL, lab TEXT, shape TEXT, color TEXT, clarity TEXT, cut TEXT, polish TEXT, symmetry TEXT, fluorescence TEXT, discount REAL, perCaratRate REAL, finalAmount REAL)"
        );
      },
    );
  }
  void applyFilters(double? minCarat, double? maxCarat,
      String? lab,
      String? shape,
      String? color,
      String? clarity) {
    debugPrint("all diamond in apply filters:$_allDiamonds");
    List<Diamond> filteredDiamonds = _allDiamonds.where((d) {
      return
        (minCarat == null || (d.carat??0.0) >= minCarat) &&
            (maxCarat == null || (d.carat??0.0) <= maxCarat) &&
            (lab == null || d.lab == lab) &&
            (shape == null || d.shape == shape) &&
            (color == null || d.color == color) &&
            (clarity == null || d.clarity == clarity);
    }).toList();
    // filteredDiamonds = _allDiamonds;
    // emit(filteredDiamonds);
    debugPrint("filter diamond list:${filteredDiamonds}");
    emit(DiamondFilterState(diamonds: _allDiamonds,filteredDiamonds: filteredDiamonds));
  }

  void sortDiamonds(String criteria, bool ascending) {
    List<Diamond> sortedDiamonds = List.from(state.filteredDiamonds);
    sortedDiamonds.sort((a, b) {
      switch (criteria) {
        case 'Price':
          return ascending ? a.finalAmount!.compareTo(b.finalAmount!) : b.finalAmount!.compareTo(a.finalAmount!);
        case 'Carat':
          return ascending ? a.carat!.compareTo(b.carat!) : b.carat!.compareTo(a.carat!);
        default:
          return 0;
      }
    });
    emit(DiamondFilterState(diamonds: _allDiamonds,filteredDiamonds:sortedDiamonds ));
  }
}

