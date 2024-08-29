import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_pokemon/models/pokemon.dart';
import 'package:flutter_pokemon/const/pokeapi.dart';

Future<Pokemon> fetchPokemon(int id) async {
  final res = await http.get(Uri.parse('$pokeApiRoute/pokemon/$id'));
  if(res.statusCode == 200) {
    return Pokemon.fromJson(jsonDecode(res.body));
  } else {
    throw Exception('Failed to Load Pokemon');
  }
}