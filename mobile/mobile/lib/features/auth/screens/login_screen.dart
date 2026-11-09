import 'package:flutter/material.dart';
import 'package:inspection_app/features/auth/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final wide = constraints.maxWidth >= 960;
            if (wide) {
              return const Row(
                children: [
                  Expanded(flex: 11, child: _BrandPanel()),
                  Expanded(flex: 9, child: _SignInPanel()),
                ],
              );
            }
            return const SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(22, 28, 22, 24),
                child: Column(
                  children: [
                    _CompactBrand(),
                    SizedBox(height: 28),
                    _SignInCard(),
                    SizedBox(height: 22),
                    _Footer(),
                  ],
                ),
              ),
            );
          },
        ),
      );
}

class _SignInPanel extends StatelessWidget {
  const _SignInPanel();

  @override
  Widget build(BuildContext context) => Container(
        color: Theme.of(context).colorScheme.surface,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(36),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CompactBrand(),
              SizedBox(height: 36),
              _SignInCard(),
              SizedBox(height: 22),
              _Footer(),
            ],
          ),
        ),
      );
}

class _SignInCard extends StatelessWidget {
  const _SignInCard();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(34),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(22),
          border:
              Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          boxShadow: const [
            BoxShadow(
                color: Color(0x0D102A43),
                blurRadius: 32,
                offset: Offset(0, 14)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.6,
                    )),
            const SizedBox(height: 8),
            Text('Sign in to continue to your operations workspace.',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.5)),
            const SizedBox(height: 30),
            const LoginForm(),
          ],
        ),
      );
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({this.inverse = false, this.compact = false});
  final bool inverse;
  final bool compact;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 42 : 48,
            height: compact ? 42 : 48,
            decoration: BoxDecoration(
              color: inverse
                  ? Colors.white.withValues(alpha: 0.12)
                  : Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.warehouse_rounded,
                size: compact ? 23 : 27,
                color: inverse
                    ? Colors.white
                    : Theme.of(context).colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('INSPECT',
                  style: TextStyle(
                    color: inverse
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                    fontSize: compact ? 16 : 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  )),
              Text('WAREHOUSE OPERATIONS',
                  style: TextStyle(
                    color: inverse
                        ? Colors.white70
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.05,
                  )),
            ],
          ),
        ],
      );
}

class _CompactBrand extends StatelessWidget {
  const _CompactBrand();

  @override
  Widget build(BuildContext context) => const Align(
        alignment: Alignment.centerLeft,
        child: _BrandMark(compact: true),
      );
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) => Container(
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF102A4C), Color(0xFF164C82), Color(0xFF16769A)],
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
                top: -100,
                right: -90,
                child: _GlowCircle(size: 360, opacity: 0.08)),
            const Positioned(
                bottom: -150,
                left: -120,
                child: _GlowCircle(size: 420, opacity: 0.07)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 46),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _BrandMark(inverse: true),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15)),
                        ),
                        child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.circle,
                                  size: 8, color: Color(0xFF6EE7B7)),
                              SizedBox(width: 8),
                              Text('YOUR WAREHOUSE, IN CLEAR VIEW',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                  )),
                            ]),
                      ),
                      const SizedBox(height: 22),
                      const Text('Every aisle.\nEvery detail.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 46,
                            height: 1.08,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -1.4,
                          )),
                      const SizedBox(height: 18),
                      const Text(
                        'Plan inspections, track inventory issues, and keep your team aligned from one reliable workspace.',
                        style: TextStyle(
                            color: Color(0xFFD5E4F2),
                            fontSize: 16,
                            height: 1.65),
                      ),
                      const SizedBox(height: 38),
                      const _OperationsPreview(),
                      const Spacer(),
                      const Row(children: [
                        Icon(Icons.verified_user_outlined,
                            color: Color(0xFFC4D9EA), size: 17),
                        SizedBox(width: 9),
                        Text(
                            'Built for focused, accountable warehouse operations',
                            style: TextStyle(
                                color: Color(0xFFC4D9EA), fontSize: 12)),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class _OperationsPreview extends StatelessWidget {
  const _OperationsPreview();

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
        ),
        child: Column(
          children: [
            Row(children: [
              const Expanded(
                  child: Text('Workspace preview',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w700))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                    color: const Color(0xFF6EE7B7).withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(20)),
                child: const Text('SAMPLE',
                    style: TextStyle(
                        color: Color(0xFF9AF0D0),
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.7)),
              ),
            ]),
            const SizedBox(height: 18),
            const Row(children: [
              Expanded(child: _PreviewMetric(value: '24', label: 'LOCATIONS')),
              SizedBox(width: 12),
              Expanded(
                  child: _PreviewMetric(value: '08', label: 'CHECKS TODAY')),
              SizedBox(width: 12),
              Expanded(
                  child: _PreviewMetric(
                      value: '02', label: 'NEEDS REVIEW', warning: true)),
            ]),
            const SizedBox(height: 17),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: const LinearProgressIndicator(
                value: 0.72,
                minHeight: 5,
                backgroundColor: Color(0x334B6886),
                valueColor: AlwaysStoppedAnimation(Color(0xFF73E0BF)),
              ),
            ),
            const SizedBox(height: 9),
            const Row(children: [
              Text('Daily inspection progress',
                  style: TextStyle(color: Color(0xFFD5E4F2), fontSize: 11)),
              Spacer(),
              Text('72%',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
            ]),
          ],
        ),
      );
}

class _PreviewMetric extends StatelessWidget {
  const _PreviewMetric(
      {required this.value, required this.label, this.warning = false});
  final String value;
  final String label;
  final bool warning;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(value,
              style: TextStyle(
                  color: warning ? const Color(0xFFFFD18C) : Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 5),
          Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                  color: Color(0xFFC4D9EA),
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.55)),
        ]),
      );
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.size, required this.opacity});
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: opacity)),
      );
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_outline,
              size: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
          const SizedBox(width: 7),
          Text('Secure sign in · Inspection App',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 12)),
        ],
      );
}
