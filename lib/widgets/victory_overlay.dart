import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'animated_button.dart';

/// Overlay profissional de vitória
class VictoryOverlay extends StatefulWidget {
  final int nivel;
  final int tempo;
  final int movimentos;
  final VoidCallback? onProximoNivel;
  final VoidCallback? onMenu;
  final bool isUltimoNivel;

  const VictoryOverlay({
    super.key,
    required this.nivel,
    required this.tempo,
    required this.movimentos,
    this.onProximoNivel,
    this.onMenu,
    this.isUltimoNivel = false,
  });

  @override
  State<VictoryOverlay> createState() => _VictoryOverlayState();
}

class _VictoryOverlayState extends State<VictoryOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward().then((_) {
      // Animar de volta para 1.0 após o bounce
      _controller.animateTo(1.0, duration: const Duration(milliseconds: 200));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
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
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Material(
        color: Colors.black.withOpacity(0.7),
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              margin: const EdgeInsets.all(24.0),
              padding: const EdgeInsets.all(40.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.amarelo,
                    AppTheme.rosa,
                  ],
                ),
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(
                  color: AppTheme.branco,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.amarelo.withOpacity(0.5),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ícone de troféu
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.branco,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.emoji_events,
                      size: 80,
                      color: AppTheme.amarelo,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Título
                  Text(
                    'Nível Completo!',
                    style: AppTheme.titleStyle(
                      fontSize: 36,
                      color: AppTheme.branco,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // Estatísticas
                  _buildStatItem(
                    Icons.timer,
                    'Tempo',
                    _formatarTempo(widget.tempo),
                  ),
                  const SizedBox(height: 16),
                  _buildStatItem(
                    Icons.touch_app,
                    'Movimentos',
                    '${widget.movimentos}',
                  ),
                  const SizedBox(height: 40),
                  // Botões
                  if (!widget.isUltimoNivel && widget.onProximoNivel != null)
                    AnimatedButton(
                      onPressed: widget.onProximoNivel,
                      backgroundColor: AppTheme.verde,
                      foregroundColor: AppTheme.branco,
                      child: const Text(
                        'Próximo Nível',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (!widget.isUltimoNivel && widget.onProximoNivel != null)
                    const SizedBox(height: 16),
                  AnimatedButton(
                    onPressed: widget.onMenu,
                    isOutlined: true,
                    foregroundColor: AppTheme.branco,
                    child: Text(
                      widget.isUltimoNivel ? 'Voltar ao Menu' : 'Menu',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.branco.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: AppTheme.azulPrincipal,
            size: 32,
          ),
          const SizedBox(width: 16),
          Text(
            '$label: ',
            style: TextStyle(
              color: AppTheme.azulPrincipal,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppTheme.roxo,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
