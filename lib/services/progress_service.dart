import 'package:shared_preferences/shared_preferences.dart';

/// Serviço para gerenciar progresso do jogador
class ProgressService {
  static const String _keyNivelAtual = 'nivel_atual';
  static const String _keyMelhorTempo = 'melhor_tempo_';
  static const String _keyMovimentos = 'movimentos_';
  static const String _keyMaxUnlockedLevel = 'max_unlocked_level';

  /// Salva o nível atual
  static Future<void> saveNivelAtual(int nivel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyNivelAtual, nivel);
  }

  /// Obtém o nível atual salvo
  static Future<int?> getNivelAtual() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyNivelAtual);
  }

  /// Salva o melhor tempo de um nível
  static Future<void> saveMelhorTempo(int nivel, int segundos) async {
    final prefs = await SharedPreferences.getInstance();
    final tempoAtual = await getMelhorTempo(nivel);
    
    // Salva apenas se for melhor tempo
    if (tempoAtual == null || segundos < tempoAtual) {
      await prefs.setInt('$_keyMelhorTempo$nivel', segundos);
    }
  }

  /// Obtém o melhor tempo de um nível
  static Future<int?> getMelhorTempo(int nivel) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_keyMelhorTempo$nivel');
  }

  /// Salva movimentos de um nível
  static Future<void> saveMovimentos(int nivel, int movimentos) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('$_keyMovimentos$nivel', movimentos);
  }

  /// Obtém movimentos de um nível
  static Future<int?> getMovimentos(int nivel) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('$_keyMovimentos$nivel');
  }

  /// Limpa todo o progresso
  static Future<void> clearProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyNivelAtual);
    // Limpar todos os tempos e movimentos salvos
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith(_keyMelhorTempo) || key.startsWith(_keyMovimentos)) {
        await prefs.remove(key);
      }
    }
  }

  /// Verifica se existe progresso salvo
  static Future<bool> hasProgress() async {
    final nivel = await getNivelAtual();
    return nivel != null && nivel > 1;
  }

  /// Obtém o nível máximo desbloqueado
  static Future<int> getMaxUnlockedLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyMaxUnlockedLevel) ?? 1; // Nível 1 sempre desbloqueado
  }

  /// Desbloqueia um nível
  static Future<void> unlockLevel(int nivel) async {
    final prefs = await SharedPreferences.getInstance();
    final maxUnlocked = await getMaxUnlockedLevel();
    if (nivel > maxUnlocked) {
      await prefs.setInt(_keyMaxUnlockedLevel, nivel);
    }
  }

  /// Verifica se um nível está desbloqueado
  static Future<bool> isLevelUnlocked(int nivel) async {
    final maxUnlocked = await getMaxUnlockedLevel();
    return nivel <= maxUnlocked;
  }
}
