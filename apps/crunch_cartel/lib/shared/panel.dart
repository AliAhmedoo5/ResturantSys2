import 'package:flutter/material.dart';
import '../app/theme.dart';

class Panel extends StatelessWidget {
  const Panel({required this.child, this.padding = const EdgeInsets.all(24), super.key});
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(color: CartelColors.panel, border: Border.all(color: CartelColors.line), borderRadius: BorderRadius.circular(12)),
    child: child,
  );
}

class PageHeading extends StatelessWidget {
  const PageHeading(this.eyebrow, this.title, this.description, {super.key});
  final String eyebrow;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(eyebrow, style: const TextStyle(color: CartelColors.yellow, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.8)),
    const SizedBox(height: 12),
    Text(title, style: Theme.of(context).textTheme.headlineMedium),
    const SizedBox(height: 8),
    Text(description, style: const TextStyle(color: CartelColors.muted, height: 1.5)),
  ]);
}
