import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Serviço para gerenciar efeitos sonoros
class AudioService {
  // Players separados para cada som (evita conflitos)
  static final AudioPlayer _playerFlip = AudioPlayer();
  static final AudioPlayer _playerMatch = AudioPlayer();
  static final AudioPlayer _playerWin = AudioPlayer();
  
  static double _volume = 0.7; // Volume aumentado para melhor audição
  static bool _enabled = true; // Controle de habilitação

  /// Habilita ou desabilita os sons
  static void setEnabled(bool enabled) {
    _enabled = enabled;
  }

  /// Configura o volume dos sons
  static void setVolume(double volume) {
    _volume = volume.clamp(0.0, 1.0);
  }

  /// Toca som de virar carta
  static Future<void> playFlip() async {
    if (!_enabled) return;
    try {
      await _playerFlip.play(
        AssetSource('sounds/flip.mp3'),
        volume: _volume,
      );
    } catch (e) {
      // Erro silencioso ao tocar flip.mp3
    }
  }

  /// Toca som de acertar par
  static Future<void> playMatch() async {
    if (!_enabled) return;
    try {
      await _playerMatch.play(
        AssetSource('sounds/match.mp3'),
        volume: _volume,
      );
    } catch (e) {
      // Erro silencioso ao tocar match.mp3
    }
  }

  /// Toca som de vitória
  static Future<void> playWin() async {
    if (!_enabled) return;
    try {
      // Parar o som de match antes de tocar o win para evitar conflito
      await _playerMatch.stop();
      // Pequeno delay para garantir que o match parou completamente
      await Future.delayed(const Duration(milliseconds: 50));
      await _playerWin.play(
        AssetSource('sounds/win.mp3'),
        volume: _volume,
      );
    } catch (e) {
      // Erro silencioso ao tocar win.mp3
    }
  }

  /// Para todos os sons
  static Future<void> stop() async {
    try {
      await _playerFlip.stop();
      await _playerMatch.stop();
      await _playerWin.stop();
    } catch (e) {
      // Ignorar erro
    }
  }

  /// Testa se os assets estão acessíveis
  static Future<void> testAssets() async {
    try {
      await _playerFlip.play(AssetSource('sounds/flip.mp3'), volume: 0.1);
      await Future.delayed(const Duration(milliseconds: 100));
      await _playerFlip.stop();
      
      await _playerMatch.play(AssetSource('sounds/match.mp3'), volume: 0.1);
      await Future.delayed(const Duration(milliseconds: 100));
      await _playerMatch.stop();
      
      await _playerWin.play(AssetSource('sounds/win.mp3'), volume: 0.1);
      await Future.delayed(const Duration(milliseconds: 100));
      await _playerWin.stop();
    } catch (e, stackTrace) {
      // Erro silencioso ao testar assets
    }
  }

  /// Libera recursos dos players
  static Future<void> dispose() async {
    try {
      await _playerFlip.dispose();
      await _playerMatch.dispose();
      await _playerWin.dispose();
    } catch (e) {
      // Ignorar erro
    }
  }
}
