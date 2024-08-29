import 'package:flutter/material.dart';
import 'package:flutter_pokemon/db/favorites.dart';

class FavoritesNotifier extends ChangeNotifier {
  final List<Favorite> _favs = [];

  FavoritesNotifier() {
    syncDb();
  }

  void syncDb() async {
    FavoritesDB.read().then(
      (val) => _favs
        ..clear()
        ..addAll(val),
    );
    notifyListeners();
  }

  List<Favorite> get favs => _favs;

  void toggle(Favorite fav) {
    if(isExist(fav.pokeId)) {
      delete(fav.pokeId);
    } else {
      add(fav);
    }
  }

  bool isExist(int id) {
    return !(_favs.indexWhere((fav) => fav.pokeId == id) < 0);
  }

  void add(Favorite fav) async{
    await FavoritesDB.create(fav);
    syncDb();
  }

  void delete(int id) async{
    await FavoritesDB.delete(id);
    syncDb();
  }
}

class Favorite {
  final int pokeId;

  Favorite({
    required this.pokeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': pokeId,
    };
  }
}
