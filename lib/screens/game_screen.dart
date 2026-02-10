import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import '../controllers/jogo_controller.dart';
import '../widgets/carta_memoria.dart';
import '../widgets/victory_overlay.dart';
import '../services/progress_service.dart';
import '../services/ranking_service.dart';
import '../services/audio_service.dart';

/// Tela principal do jogo
class GameScreen extends StatefulWidget {
  final String nomeJogador;
  final int nivelInicial;

  const GameScreen({
    super.key,
    required this.nomeJogador,
    this.nivelInicial = 1,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late JogoController _jogoController;
  
  // Estado de nível
  int nivel = 1;
  
  // Lista de níveis progressivos expandida
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
  
  // Função para obter quantidade de cartas por nível
  int getQuantidadeCartas() {
    if (nivel > 0 && nivel <= niveisCartas.length) {
      return niveisCartas[nivel - 1];
    }
    return 4;
  }
  
  // Função para calcular colunas do grid dinamicamente
  // Calcula baseado na raiz quadrada aproximada para manter grid equilibrado
  int _calcularColunas(int totalCartas) {
    if (totalCartas <= 4) {
      return 2;
    } else if (totalCartas <= 6) {
      return 3;
    } else if (totalCartas <= 12) {
      return 4;
    } else if (totalCartas <= 20) {
      return 5;
    } else if (totalCartas <= 24) {
      return 6;
    } else {
      // Para 30 cartas, usar 6 colunas (5 linhas)
      return 6;
    }
  }
  
  // Contador de tempo e movimentos
  Timer? timerJogo;
  int segundos = 0;
  int movimentos = 0;
  
  // Lista de ícones para as cartas (expandida)
  final List<IconData> iconesCartas = [
    Icons.star,
    Icons.favorite,
    Icons.catching_pokemon,
    Icons.flash_on,
    Icons.airplanemode_active,
    Icons.beach_access,
    Icons.cake,
    Icons.directions_car,
    Icons.eco,
    Icons.favorite_border,
    Icons.games,
    Icons.home,
    Icons.music_note,
    Icons.pets,
    Icons.sports_soccer,
    Icons.wb_sunny,
    Icons.cloud,
    Icons.local_pizza,
    Icons.phone,
    Icons.computer,
    Icons.book,
    Icons.school,
    Icons.work,
    Icons.restaurant,
    Icons.hotel,
    Icons.shopping_cart,
    Icons.movie,
    Icons.camera_alt,
    Icons.palette,
    Icons.code,
  ];

  // Controla a exibição do overlay de vitória
  bool _mostrarVitoria = false;
  
  // Controla o período inicial de visualização das cartas
  bool _mostrandoCartasInicial = true;
  bool _podeInteragir = false;

  @override
  void initState() {
    super.initState();
    
    // Carregar nível salvo ou usar inicial
    nivel = widget.nivelInicial;
    
    _inicializarJogo();
    
    // Mostrar todas as cartas inicialmente por 3 segundos
    _mostrarCartasInicialmente();
  }
  
  Future<void> _mostrarCartasInicialmente() async {
    // Abrir todas as cartas para visualização
    for (var carta in _jogoController.cartas) {
      carta.aberta = true;
    }
    setState(() {});
    
    // Aguardar 3 segundos para memorização
    await Future.delayed(const Duration(seconds: 3));
    
    // Fechar todas as cartas
    if (mounted) {
      for (var carta in _jogoController.cartas) {
        carta.aberta = false;
      }
      setState(() {
        _mostrandoCartasInicial = false;
        _podeInteragir = true;
      });
      
      // Iniciar timer do jogo apenas após o período de visualização
      timerJogo = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          if (mounted) {
            setState(() {
              segundos++;
            });
          }
        },
      );
    }
  }
  
  void _inicializarJogo() {
    final quantidadeCartas = getQuantidadeCartas();
    movimentos = 0;
    
    _jogoController = JogoController(
      iconesDisponiveis: iconesCartas,
      totalCartas: quantidadeCartas,
      onStateChanged: () {
        setState(() {
          // Atualizar movimentos do controller
          movimentos = _jogoController.movimentos;
        });
      },
      onCardFlipped: () {
        // Som e vibração ao virar carta
        AudioService.playFlip();
        HapticFeedback.lightImpact();
      },
      onMatchFound: () {
        // Som e vibração ao acertar par
        AudioService.playMatch();
        HapticFeedback.mediumImpact();
      },
      onVitoria: () {
        timerJogo?.cancel();
        // Som e vibração ao vencer
        AudioService.playWin();
        HapticFeedback.heavyImpact();
        _salvarProgresso();
        _mostrarVitoriaOverlay();
      },
    );
  }
  
  Future<void> _salvarProgresso() async {
    // Salvar nível atual
    await ProgressService.saveNivelAtual(nivel);
    
    // Salvar melhor tempo e movimentos do nível
    await ProgressService.saveMelhorTempo(nivel, segundos);
    await ProgressService.saveMovimentos(nivel, movimentos);
    
    // Salvar no ranking
    await RankingService.saveResult(
      nome: widget.nomeJogador,
      nivel: nivel,
      tempo: segundos,
      movimentos: movimentos,
    );
    
    // Desbloquear próximo nível
    if (nivel < niveisCartas.length) {
      await ProgressService.unlockLevel(nivel + 1);
    }
  }
  
  void _reiniciarCartas() {
    final quantidadeCartas = getQuantidadeCartas();
    movimentos = 0;
    segundos = 0;
    _mostrandoCartasInicial = true;
    _podeInteragir = false;
    timerJogo?.cancel();
    _jogoController.reiniciarJogoComQuantidade(quantidadeCartas);
    
    // Mostrar cartas inicialmente novamente
    _mostrarCartasInicialmente();
  }
  
  void _voltarMenu() {
    Navigator.pop(context);
  }
  
  void _mostrarVitoriaOverlay() {
    setState(() {
      _mostrarVitoria = true;
    });
  }

  void _ocultarVitoriaOverlay() {
    setState(() {
      _mostrarVitoria = false;
    });
  }

  void _proximoNivel() {
    if (nivel < niveisCartas.length) {
      // Avançar para próximo nível
      setState(() {
        nivel++;
        movimentos = 0;
        segundos = 0;
        _mostrarVitoria = false;
      });
      
      // Reiniciar timer para novo nível
      timerJogo?.cancel();
      timerJogo = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          setState(() {
            segundos++;
          });
        },
      );
      
      _reiniciarCartas();
    } else {
      _voltarMenu();
    }
  }

  @override
  void dispose() {
    timerJogo?.cancel();
    super.dispose();
  }
  
  String _formatarTempo(int segundos) {
    final minutos = segundos ~/ 60;
    final segs = segundos % 60;
    if (minutos > 0) {
      return '${minutos}m ${segs}s';
    }
    return '${segs}s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Stack(
          children: [
            Column(
              children: [
                AppBar(
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: _voltarMenu,
                  ),
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const AppLogo(size: 40, animated: false),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.nomeJogador,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Nível $nivel',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.branco.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  backgroundColor: AppTheme.azulPrincipal,
                  foregroundColor: AppTheme.branco,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.refresh, size: 28),
                      onPressed: () {
                        _reiniciarCartas();
                      },
                      tooltip: 'Reiniciar',
                    ),
                  ],
                ),
                // HUD - Cronômetro e Movimentos
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.roxo.withOpacity(0.8),
                        AppTheme.rosa.withOpacity(0.8),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.branco,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.timer,
                              color: AppTheme.azulPrincipal,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _formatarTempo(segundos),
                              style: TextStyle(
                                color: AppTheme.azulPrincipal,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.branco,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.touch_app,
                              color: AppTheme.verde,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '$movimentos',
                              style: TextStyle(
                                color: AppTheme.verde,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Grid de cartas
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final totalCartas = getQuantidadeCartas();
                      final colunas = _calcularColunas(totalCartas);
                      
                      // Calcular número de linhas
                      final linhas = (totalCartas / colunas).ceil();
                      
                      // Calcular aspect ratio dinâmico para preencher toda a altura
                      final padding = 24.0; // padding total (12 * 2)
                      final crossSpacing = (colunas - 1) * 12.0;
                      final mainSpacing = (linhas - 1) * 12.0;
                      
                      final larguraDisponivel = constraints.maxWidth - padding - crossSpacing;
                      final alturaDisponivel = constraints.maxHeight - padding - mainSpacing;
                      
                      final larguraCarta = larguraDisponivel / colunas;
                      final alturaCarta = alturaDisponivel / linhas;
                      
                      final aspectRatio = larguraCarta / alturaCarta;
                      
                      return GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(12),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: colunas,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: aspectRatio,
                        ),
                        itemCount: _jogoController.cartas.length,
                        itemBuilder: (context, index) {
                          final carta = _jogoController.cartas[index];
                          
                          return CartaMemoria(
                            aberta: carta.aberta,
                            encontrada: carta.encontrada,
                            icone: carta.icone,
                            onTap: _podeInteragir && !_mostrandoCartasInicial
                                ? () => _jogoController.tocarCarta(index)
                                : null,
                          );
                        },
                      );
                    },
                  ),
                ),
                // Espaço para banner ad futuro
                Container(
                  height: 50,
                  color: Colors.transparent,
                ),
              ],
            ),
            // Victory Overlay
            if (_mostrarVitoria)
              VictoryOverlay(
                nivel: nivel,
                tempo: segundos,
                movimentos: movimentos,
                isUltimoNivel: nivel >= niveisCartas.length,
                onProximoNivel: nivel < niveisCartas.length ? _proximoNivel : null,
                onMenu: () {
                  _ocultarVitoriaOverlay();
                  _voltarMenu();
                },
              ),
          ],
        ),
      ),
    );
  }
}
