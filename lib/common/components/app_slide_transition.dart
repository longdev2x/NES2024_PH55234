import 'package:flutter/material.dart';

class AppSlideTransiton extends StatefulWidget {
  final Widget child;
  final Duration? duration;
  final bool? isRepeat;
  final Offset? begin;
  final Curve? curve;

  const AppSlideTransiton({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.isRepeat = false,
    this.begin = const Offset(0, -2),
    this.curve = Curves.bounceOut,
  });

  @override
  State<AppSlideTransiton> createState() => _AppSlideTransitonState();
}

class _AppSlideTransitonState extends State<AppSlideTransiton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _offsetAnimation = Tween<Offset>(
      begin: widget.begin ?? const Offset(0, -2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _controller, curve: widget.curve ?? Curves.bounceOut));

    widget.isRepeat!
      ? _controller.repeat(reverse: true)
      : _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: widget.child,
    );
  }
}
