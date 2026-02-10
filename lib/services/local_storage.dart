import 'package:shared_preferences/shared_preferences.dart';

/// Serviço para gerenciar armazenamento local do nome do jogador
class LocalStorage {
  static const String _keyPlayerName = 'player_name';

  /// Salva o nome do jogador
  static Future<void> savePlayerName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPlayerName, name);
  }

  /// Obtém o nome do jogador salvo
  static Future<String?> getPlayerName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyPlayerName);
  }

  /// Remove o nome do jogador salvo
  static Future<void> clearPlayerName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyPlayerName);
  }
}
