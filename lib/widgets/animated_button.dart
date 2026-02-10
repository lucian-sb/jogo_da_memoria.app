import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Botão animado com efeito bounce para feedback visual
class AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final IconData? icon;
  final String? label;
  final bool isOutlined;

  const AnimatedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.width,
    this.icon,
    this.label,
    this.isOutlined = false,
  });

  const AnimatedButton.icon({
    super.key,
    this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.width,
    required this.icon,
    required this.label,
    this.isOutlined = false,
  }) : child = const SizedBox.shrink();

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
    HapticFeedback.lightImpact();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final button = widget.icon != null && widget.label != null
        ? widget.isOutlined
            ? OutlinedButton.icon(
                onPressed: widget.onPressed,
                icon: Icon(widget.icon, size: 24),
                label: Text(widget.label!),
                style: OutlinedButton.styleFrom(
                  foregroundColor: widget.foregroundColor,
                  backgroundColor: widget.backgroundColor,
                  padding: widget.padding ??
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  minimumSize: Size(
                    widget.width ?? double.infinity,
                    50,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide(
                    color: widget.foregroundColor ?? Theme.of(context).primaryColor,
                    width: 3,
                  ),
                ),
              )
            : ElevatedButton.icon(
                onPressed: widget.onPressed,
                icon: Icon(widget.icon, size: 24),
                label: Text(widget.label!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.backgroundColor,
                  foregroundColor: widget.foregroundColor,
                  padding: widget.padding ??
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  minimumSize: Size(
                    widget.width ?? double.infinity,
                    50,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                ),
              )
        : widget.isOutlined
            ? OutlinedButton(
                onPressed: widget.onPressed,
                style: OutlinedButton.styleFrom(
                  foregroundColor: widget.foregroundColor,
                  backgroundColor: widget.backgroundColor,
                  padding: widget.padding ??
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  minimumSize: Size(
                    widget.width ?? double.infinity,
                    50,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide(
                    color: widget.foregroundColor ?? Theme.of(context).primaryColor,
                    width: 3,
                  ),
                ),
                child: widget.child,
              )
            : ElevatedButton(
                onPressed: widget.onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.backgroundColor,
                  foregroundColor: widget.foregroundColor,
                  padding: widget.padding ??
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  minimumSize: Size(
                    widget.width ?? double.infinity,
                    50,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 4,
                ),
                child: widget.child,
              );

    return GestureDetector(
      onTapDown: widget.onPressed != null ? _handleTapDown : null,
      onTapUp: widget.onPressed != null ? _handleTapUp : null,
      onTapCancel: widget.onPressed != null ? _handleTapCancel : null,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: button,
      ),
    );
  }
}
