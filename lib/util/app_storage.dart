import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:poker_app/models/player.dart';

class AppStorage {
    static final AppStorage _instance = AppStorage._internal();
    static AppStorage get instance => _instance;

    final String _playerDataFilename = "profiles.json";
    final String _roundsDataFilename = "rounds.json";

    factory AppStorage() {
        return _instance;
    }

    AppStorage._internal();

    Future<String> get _documentsPath async {
        final Directory documentsDir = await getApplicationDocumentsDirectory();

        return documentsDir.path;
    }

    Future<File> get _profilesFilePath async {
        final path = await _documentsPath;
        return File('$path/$_playerDataFilename');
    }

    Future<File> get _roundsFilePath async {
        final path = await _documentsPath;
        return File('$path/$_roundsDataFilename');
    }

    Future<void> storeProfile(PokerPlayer player) async {
        final List<PokerPlayer> users = await fetchUsers();
        users.add(player);
        final File file = await _profilesFilePath;
        file.writeAsString(jsonEncode(player));
    }

    // TODO: get profiles, add it to the list then write it
    Future<void> storeRound() async {
        const String json = "";
        final File file = await _profilesFilePath;
        file.writeAsString(json);
    }

    Future<List<PokerPlayer>> fetchUsers() async {
        final File file = await _profilesFilePath;
        final String contents = await file.readAsString();
        return jsonDecode(contents);
    }

}
