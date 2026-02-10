import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import '../services/progress_service.dart';
import 'game_screen.dart';

/// Tela de seleção de níveis
class LevelSelectScreen extends StatefulWidget {
  final String nomeJogador;

  const LevelSelectScreen({
    super.key,
    required this.nomeJogador,
  });

  @override
  State<LevelSelectScreen> createState() => _LevelSelectScreenState();
}

class _LevelSelectScreenState extends State<LevelSelectScreen>
    with WidgetsBindingObserver {
  // Lista de níveis (mesma do GameScreen)
  final List<int> niveisCartas = [
    4,   // nivel 1
    6,   // nivel 2
    8,   // nivel 3
    10,  // nivel 4
    12,  // nivel 5
    16,  // nivel 6
    20,  // nivel 7
    24,  // nivel 8
    30   // nivel 9
  ];

  int _maxUnlocked = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _carregarNiveisDesbloqueados();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _carregarNiveisDesbloqueados();
    }
  }

  Future<void> _carregarNiveisDesbloqueados() async {
    final maxUnlocked = await ProgressService.getMaxUnlockedLevel();
    if (mounted) {
      setState(() {
        _maxUnlocked = maxUnlocked;
      });
    }
  }

  Future<void> _iniciarNivel(int nivel) async {
    final isUnlocked = await ProgressService.isLevelUnlocked(nivel);
    if (!isUnlocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Nível ainda não desbloqueado!'),
          backgroundColor: AppTheme.vermelho,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
      return;
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(
          nomeJogador: widget.nomeJogador,
          nivelInicial: nivel,
        ),
      ),
    );
    
    // Recarregar níveis quando volta da tela de jogo
    _carregarNiveisDesbloqueados();
  }

  Widget _buildLevelCard(int nivelIndex) {
    final nivel = nivelIndex + 1;
    final totalCartas = niveisCartas[nivelIndex];
    final isUnlocked = nivel <= _maxUnlocked;
    final corNivel = AppTheme.getLevelColor(nivel);

    return FutureBuilder<int?>(
      future: ProgressService.getMelhorTempo(nivel),
      builder: (context, snapshot) {
        final melhorTempo = snapshot.data;

        return AnimatedScale(
          scale: 1.0,
          duration: const Duration(milliseconds: 200),
          child: GestureDetector(
            onTap: () => _iniciarNivel(nivel),
            child: Container(
              decoration: BoxDecoration(
                gradient: isUnlocked
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          corNivel,
                          corNivel.withOpacity(0.7),
                        ],
                      )
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.grey.shade400,
                          Colors.grey.shade500,
                        ],
                      ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isUnlocked ? corNivel : Colors.grey.shade600,
                  width: 3,
                ),
                boxShadow: isUnlocked
                    ? [
                        BoxShadow(
                          color: corNivel.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : null,
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isUnlocked)
                        Icon(
                          Icons.lock,
                          size: 48,
                          color: AppTheme.branco.withOpacity(0.7),
                        )
                      else
                        Text(
                          'Nível $nivel',
                          style: const TextStyle(
                            color: AppTheme.branco,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        '$totalCartas cartas',
                        style: TextStyle(
                          color: AppTheme.branco.withOpacity(0.9),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (isUnlocked && melhorTempo != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.timer,
                              size: 18,
                              color: AppTheme.branco,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${melhorTempo}s',
                              style: const TextStyle(
                                color: AppTheme.branco,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Column(
          children: [
            AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  await _carregarNiveisDesbloqueados();
                  if (mounted) {
                    Navigator.pop(context);
                  }
                },
              ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppLogo(size: 48, animated: false),
                  const SizedBox(width: 12),
                  const Text('Selecionar Nível'),
                ],
              ),
              backgroundColor: AppTheme.azulPrincipal,
              foregroundColor: AppTheme.branco,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16.0,
                    mainAxisSpacing: 16.0,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: niveisCartas.length,
                  itemBuilder: (context, index) {
                    return _buildLevelCard(index);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
