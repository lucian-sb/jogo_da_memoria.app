import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CartaMemoria extends StatefulWidget {
  final bool aberta;
  final bool encontrada;
  final IconData? icone;
  final VoidCallback? onTap;

  const CartaMemoria({
    super.key,
    required this.aberta,
    required this.encontrada,
    this.icone,
    this.onTap,
  });

  @override
  State<CartaMemoria> createState() => _CartaMemoriaState();
}

class _CartaMemoriaState extends State<CartaMemoria>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    // Inicializar estado da animação
    if (widget.aberta || widget.encontrada) {
      _controller.value = 1.0;
    } else {
      _controller.value = 0.0;
    }
  }

  @override
  void didUpdateWidget(CartaMemoria oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Controlar animação baseado na mudança de estado
    if (oldWidget.aberta != widget.aberta) {
      if (widget.aberta) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }

    // Se a carta foi encontrada, garantir que está virada
    if (widget.encontrada && _controller.value < 1.0) {
      _controller.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _obterCor() {
    if (widget.encontrada) {
      return AppTheme.cartaEncontrada;
    } else if (widget.aberta) {
      return AppTheme.cartaAberta;
    } else {
      return AppTheme.cartaFechada;
    }
  }

  Widget _buildLadoVerso() {
    // Lado de trás (carta fechada - azul claro)
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.cartaFechada,
            AppTheme.azulPrincipal,
          ],
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: [
          BoxShadow(
            color: AppTheme.azulPrincipal.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.help_outline,
          color: AppTheme.branco.withOpacity(0.5),
          size: 40,
        ),
      ),
    );
  }

  Widget _buildLadoFrente() {
    // Lado da frente (carta aberta - amarelo/verde com ícone)
    final cor = _obterCor();
    final temSombra = widget.aberta && !widget.encontrada;
    final temBrilho = widget.encontrada;

    final container = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: temBrilho
              ? [
                  cor,
                  cor.withOpacity(0.8),
                ]
              : [
                  cor,
                  cor.withOpacity(0.9),
                ],
        ),
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: temSombra
            ? [
                BoxShadow(
                  color: cor.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : temBrilho
                ? [
                    BoxShadow(
                      color: cor.withOpacity(0.6),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: 2,
                    ),
                  ]
                : null,
        border: temBrilho
            ? Border.all(
                color: AppTheme.branco,
                width: 3,
              )
            : null,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calcular tamanho do ícone baseado no espaço disponível
          final iconSize = constraints.maxWidth * 0.5;
          return Center(
            child: widget.icone != null
                ? Icon(
                    widget.icone,
                    color: AppTheme.branco,
                    size: iconSize,
                  )
                : const SizedBox.shrink(),
          );
        },
      ),
    );

    // Adicionar AnimatedScale para efeito quando encontrada (com bounce)
    if (widget.encontrada) {
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 1.0, end: 1.15),
        duration: const Duration(milliseconds: 300),
        curve: Curves.elasticOut,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: container,
          );
        },
      );
    }

    return container;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.encontrada ? null : widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final isFlipped = _animation.value >= 0.5;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspectiva
              ..rotateY(pi * _animation.value),
            child: isFlipped ? _buildLadoFrente() : _buildLadoVerso(),
          );
        },
      ),
    );
  }
}
