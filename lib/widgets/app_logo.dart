import 'package:flutter/material.dart';

/// Widget reutilizável para exibir o logo do app
class AppLogo extends StatefulWidget {
  final double size;
  final bool animated;
  final AnimationType animationType;

  const AppLogo({
    super.key,
    this.size = 120,
    this.animated = false,
    this.animationType = AnimationType.bounce,
  });

  @override
  State<AppLogo> createState() => _AppLogoState();
}

enum AnimationType {
  bounce,
  pulse,
}

class _AppLogoState extends State<AppLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    if (widget.animated) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
      );

      switch (widget.animationType) {
        case AnimationType.bounce:
          _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Curves.elasticOut,
            ),
          );
          _controller.forward();
          break;
        case AnimationType.pulse:
          _animation = Tween<double>(begin: 0.9, end: 1.1).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Curves.easeInOut,
            ),
          );
          _controller.repeat(reverse: true);
          break;
      }
    }
  }

  @override
  void dispose() {
    if (widget.animated) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logo = Image.asset(
      'assets/icon/icon.png',
      width: widget.size,
      height: widget.size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback se a imagem não carregar
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.size * 0.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            Icons.games,
            size: widget.size * 0.6,
            color: Colors.blue,
          ),
        );
      },
    );

    if (!widget.animated) {
      return logo;
    }

    switch (widget.animationType) {
      case AnimationType.bounce:
        return ScaleTransition(
          scale: _animation,
          child: logo,
        );
      case AnimationType.pulse:
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value,
              child: logo,
            );
          },
        );
    }
  }
}
