import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_pokemon/theme_mode_selection_page.dart';
import 'package:flutter_pokemon/models/theme_mode.dart';


class Settings extends StatefulWidget {
  const Settings({super.key,});

  @override
  State<Settings> createState() => _SettingsState();
}


class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModeNotifier>(
      builder: (context, mode, child) {
        return ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.lightbulb),
              title: const Text('Dark/Light Mode'),
              trailing: Text((mode.mode == ThemeMode.system)
                ? 'System'
                : (mode.mode == ThemeMode.dark ? 'Dark' : 'Light')
              ),
              onTap: () async {
                var ret = await Navigator.of(context).push<ThemeMode>(
                  MaterialPageRoute(
                    builder: (context) => ThemeModeSelectionPage(mode: mode.mode),
                  ),
                );
                if (ret != null) {
                  mode.update(ret);
                }
              },
            ),
          ],
        );
      }
    );
  }
}
