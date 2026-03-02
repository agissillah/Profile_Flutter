import 'package:flutter/material.dart';

class NavItem extends StatefulWidget {
  final String title;

  const NavItem({super.key, required this.title});

  @override
  State<NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 160),
        style: Theme.of(context).textTheme.titleSmall!.copyWith(
          color: _isHovered
              ? colorScheme.primary
              : colorScheme.onSurface.withValues(alpha: 0.85),
          fontWeight: FontWeight.w600,
        ),
        child: Text(widget.title),
      ),
    );
  }
}