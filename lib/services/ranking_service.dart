import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Entrada do ranking
class RankingEntry {
  final String nome;
  final int nivel;
  final int tempo;
  final int movimentos;
  final DateTime data;

  RankingEntry({
    required this.nome,
    required this.nivel,
    required this.tempo,
    required this.movimentos,
    required this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'nivel': nivel,
      'tempo': tempo,
      'movimentos': movimentos,
      'data': data.toIso8601String(),
    };
  }

  factory RankingEntry.fromJson(Map<String, dynamic> json) {
    return RankingEntry(
      nome: json['nome'],
      nivel: json['nivel'],
      tempo: json['tempo'],
      movimentos: json['movimentos'],
      data: DateTime.parse(json['data']),
    );
  }
}

/// Serviço para gerenciar ranking local
class RankingService {
  static const String _keyRanking = 'ranking_list';
  static const int _maxEntries = 20;

  /// Salva um resultado no ranking
  static Future<void> saveResult({
    required String nome,
    required int nivel,
    required int tempo,
    required int movimentos,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final ranking = await getRanking();

    // Adicionar novo resultado
    ranking.add(RankingEntry(
      nome: nome,
      nivel: nivel,
      tempo: tempo,
      movimentos: movimentos,
      data: DateTime.now(),
    ));

    // Ordenar por tempo (menor é melhor)
    ranking.sort((a, b) {
      if (a.tempo != b.tempo) {
        return a.tempo.compareTo(b.tempo);
      }
      return a.movimentos.compareTo(b.movimentos);
    });

    // Manter apenas os últimos 20
    if (ranking.length > _maxEntries) {
      ranking.removeRange(_maxEntries, ranking.length);
    }

    // Salvar
    final jsonList = ranking.map((e) => e.toJson()).toList();
    await prefs.setString(_keyRanking, jsonEncode(jsonList));
  }

  /// Obtém o ranking completo
  static Future<List<RankingEntry>> getRanking() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyRanking);

    if (jsonString == null) {
      return [];
    }

    try {
      final jsonList = jsonDecode(jsonString) as List;
      return jsonList
          .map((e) => RankingEntry.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Limpa o ranking
  static Future<void> clearRanking() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyRanking);
  }
}
