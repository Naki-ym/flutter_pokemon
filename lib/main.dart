import 'package:flutter/material.dart';
import 'package:flutter_pokemon/models/pokemon.dart';
import 'package:flutter_pokemon/models/theme_mode.dart';
import 'package:flutter_pokemon/models/favorite.dart';
import 'package:flutter_pokemon/settings.dart';
import 'package:flutter_pokemon/poke_list.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences pref = await SharedPreferences.getInstance();
  final themeModeNotifier = ThemeModeNotifier(pref);
  final pokemonsNotifier = PokemonsNotifier();
  final favoritesNotifier = FavoritesNotifier();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => themeModeNotifier,
        ),
        ChangeNotifierProvider(
          create: (context) => pokemonsNotifier,
        ),
        ChangeNotifierProvider(
          create: (context) => favoritesNotifier,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModeNotifier>(
      builder: (context, mode, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: mode.mode,
          home: const TopPage(),
        );
      }
    );
  }
}

class TopPage extends StatefulWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  int currentbnb = 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // TODO: onPopInvokedで確認ダイアログを出すようにする
      child: Scaffold(
        body: SafeArea(
          child: IndexedStack(
            index: currentbnb,
            children: const [PokeList(), Settings()],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) => {
            setState(
              () => currentbnb = index,
            ),
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'settings',
            ),
          ],
        ),
      ),
    );
  }
}
