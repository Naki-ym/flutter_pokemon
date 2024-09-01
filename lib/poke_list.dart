import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_pokemon/models/pokemon.dart';
import 'package:flutter_pokemon/models/favorite.dart';
import 'package:flutter_pokemon/const/pokeapi.dart';
import 'package:flutter_pokemon/poke_list_item.dart';
import 'package:flutter_pokemon/poke_grid_item.dart';

class PokeList extends StatefulWidget {
  const PokeList({super.key,});
  @override
  State<PokeList> createState() => _PokeListState();
}

class _PokeListState extends State<PokeList> {
  static const int pageSize = 30;
  bool isFavoriteMode = false;
  bool isGridMode = true;
  int _currentPage = 1;

  bool isLastPage(int favscount, int page) {
    if(isFavoriteMode) {
      return !(_currentPage * pageSize < favscount);
    } else {
      return !(_currentPage * pageSize < pokeMaxId);
    }
  }

  // 表示個数
  int itemCount(int favscount, int page) {
    int ret = page * pageSize;
    if(isFavoriteMode && ret > favscount) {
      ret = favscount;
    }
    if(ret > pokeMaxId) {
      ret = pokeMaxId;
    }
    return ret;
  }

  int itemId(List<Favorite> favs, int index) {
    int ret = index + 1;
    if(isFavoriteMode) {
      ret = favs[index].pokeId;
    }
    return ret;
  }

  void changeFavMode(bool currentMode) {
    setState(() => isFavoriteMode = !currentMode);
  }

  void changeGridMode(bool currentMode) {
    setState(() => isGridMode = !currentMode);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesNotifier>(
      builder: (context, favs, child) => Column(
        children: [
          Container(
            height: 24,
            alignment: Alignment.topRight,
            child: IconButton(
              padding: const EdgeInsets.all(0),
              icon: const Icon(Icons.auto_awesome_outlined),
              onPressed: () async {
                await showModalBottomSheet<bool>(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  builder: (BuildContext context){
                    return ViewModeBottomSheet(
                      favMode: isFavoriteMode,
                      changeFavMode: changeFavMode,
                      gridMode: isGridMode,
                      changeGridMode: changeGridMode,
                    );
                  },
                );
              },
            ),
          ),
          Expanded(
            child: Consumer<PokemonsNotifier>(
              builder: (context, pokes, child) {
                if(itemCount(favs.favs.length, _currentPage) == 0) {
                  return const Text('no data');
                } else {
                  if(isGridMode) {
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3
                      ),
                      itemCount: itemCount(favs.favs.length, _currentPage) + (isLastPage(favs.favs.length, _currentPage) ? 0 : 1),
                      itemBuilder: (context, index) {
                        if (index == itemCount(favs.favs.length, _currentPage)) {
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              onPressed: isLastPage(favs.favs.length, _currentPage)
                                ? null
                                : () => {
                                  setState(() => _currentPage++),
                                },
                              child: const Text('more'),
                            ),
                          );
                        } else {
                          return PokeGridItem(
                            poke: pokes.byId(itemId(favs.favs, index)),
                          );
                        }
                      }
                    );
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      itemCount: itemCount(favs.favs.length, _currentPage) + (isLastPage(favs.favs.length, _currentPage) ? 0 : 1),
                      itemBuilder: (context, index) {
                        if (index == itemCount(favs.favs.length, _currentPage)) {
                          return OutlinedButton(
                            child: const Text('more'),
                            onPressed: () => {
                              setState(() => _currentPage++),
                            },
                          );
                        } else {
                          return PokeListItem(
                            poke: pokes.byId(itemId(favs.favs, index)),
                          );
                        }
                      }
                    );
                  }
                }
              }
            ),
          ),
        ],
      ),
    );
  }
}

class ViewModeBottomSheet extends StatelessWidget {
  const ViewModeBottomSheet({
    super.key,
    required this.favMode,
    required this.changeFavMode,
    required this.gridMode,
    required this.changeGridMode,
  });
  final bool favMode;
  final Function(bool) changeFavMode;
  final bool gridMode;
  final Function(bool) changeGridMode;

  String mainText() {
    return '表示設定';
  }

  String menuFavTitle(bool fav) {
    if (fav) {
      return '「すべて」表示に切り替え';
    } else {
      return '「お気に入り」表示に切り替え';
    }
  }

  String menuFavSubtitle(bool fav) {
    if (fav) {
      return 'すべてのポケモンが表示されます';
    } else {
      return 'お気に入りに登録したポケモンのみが表示されます';
    }
  }

  String menuGridTitle(bool grid) {
    if (grid) {
      return 'リスト表示に切り替え';
    } else {
      return 'グリッド表示に切り替え';
    }
  }

  String menuGridSubtitle(bool grid) {
    if (grid) {
      return 'ポケモンをグリッド表示します';
    } else {
      return 'ポケモンをリスト表示します';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 5,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).canvasColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Text(
                mainText(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: Text(
                menuFavTitle(favMode),
              ),
              subtitle: Text(
                menuFavSubtitle(favMode),
              ),
              onTap: () {
                changeFavMode(favMode);
                Navigator.pop(context, true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.grid_3x3),
              title: Text(
                menuGridTitle(favMode),
              ),
              subtitle: Text(
                menuGridSubtitle(favMode),
              ),
              onTap: () {
                changeGridMode(gridMode);
                Navigator.pop(context, true);
              },
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
              ),
              child: const Text('キャンセル'),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        ),
      ),
    );
  }
}