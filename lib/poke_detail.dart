import 'package:flutter/material.dart';
import 'package:flutter_pokemon/const/pokeapi.dart';
import 'package:flutter_pokemon/models/favorite.dart';
import 'package:flutter_pokemon/models/pokemon.dart';
import 'package:provider/provider.dart';

class PokeDetail extends StatelessWidget {
  const PokeDetail({super.key, required this.poke});
  final Pokemon poke;

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesNotifier>(
      builder: (context, favs, child) => Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                trailing: IconButton(
                  icon: favs.isExist(poke.id)
                    ? Icon(Icons.star, color: Colors.yellow[700])
                    : const Icon(Icons.star_outline,),  // <- お気に入りボタン
                  onPressed: () => {
                    favs.toggle(Favorite(pokeId: poke.id)),
                  },
                ),
              ),
              const Spacer(),
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    child: Image.network(
                          poke.imageUrl,
                          height: 100,
                          width: 100,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      'No. ${poke.id}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              Text(
                poke.name,
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: poke.types.map(
                  (type) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Chip(
                      backgroundColor: pokeTypeColors[type] ?? Colors.grey,
                      label: Text(
                        type,
                        style: TextStyle(
                          color: (pokeTypeColors[type] ?? Colors.grey).computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ).toList(),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
