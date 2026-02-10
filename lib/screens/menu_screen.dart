import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/progress_service.dart';
import 'game_screen.dart';

/// Tela de menu principal do jogo
class MenuScreen extends StatefulWidget {
  final String nomeJogador;

  const MenuScreen({
    super.key,
    required this.nomeJogador,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool _temProgresso = false;

  @override
  void initState() {
    super.initState();
    _verificarProgresso();
  }

  Future<void> _verificarProgresso() async {
    final temProgresso = await ProgressService.hasProgress();
    setState(() {
      _temProgresso = temProgresso;
    });
  }

  void _novoJogo() {
    // Limpar progresso e iniciar do nível 1
    ProgressService.clearProgress();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          nomeJogador: widget.nomeJogador,
          nivelInicial: 1,
        ),
      ),
    );
  }

  void _continuar() async {
    final nivelSalvo = await ProgressService.getNivelAtual();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          nomeJogador: widget.nomeJogador,
          nivelInicial: nivelSalvo ?? 1,
        ),
      ),
    );
  }

  void _sair() {
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Jogo da Memória',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Olá, ${widget.nomeJogador}!',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 48),
              if (_temProgresso)
                ElevatedButton(
                  onPressed: _continuar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: const Text(
                    'Continuar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (_temProgresso) const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _novoJogo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                child: const Text(
                  'Novo Jogo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _sair,
                child: const Text(
                  'Sair',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
