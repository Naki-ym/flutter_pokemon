import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_pokemon/poke_detail.dart';
import 'package:flutter_pokemon/models/pokemon.dart';
import 'package:flutter_pokemon/const/pokeapi.dart';

class PokeListItem extends StatelessWidget {
  const PokeListItem({super.key, required this.poke});
  final Pokemon? poke;

  @override
  Widget build(BuildContext context) {
    if (poke != null) {
      return ListTile(
        leading: Container(
          width: 80,
          decoration: BoxDecoration(
            color: (pokeTypeColors[poke!.types.first] ?? Colors.grey[100])?.withOpacity(.3),
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              fit: BoxFit.fitWidth,
              image: CachedNetworkImageProvider(
                poke!.imageUrl,
              ),
            )
          ),
        ),
        title: Text(
          poke!.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(poke!.types.first),
        trailing: const Icon(Icons.navigate_next),
        onTap: () => {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => PokeDetail(poke: poke!),
            ),
          ),
        },
      );
    } else {
      return const ListTile(
        title: Text('...'),
      );
    }
  }
}