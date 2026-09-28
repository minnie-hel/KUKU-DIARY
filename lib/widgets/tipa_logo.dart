import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class TipaLogo extends StatelessWidget {
  final double size;
  final bool showTitle;
  final String? tagline;

  const TipaLogo({
    super.key,
    this.size = 88,
    this.showTitle = true,
    this.tagline,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(size * 0.5),
          child: Image.asset(
            'assets/images/tipa_logo.png',
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => Icon(Icons.pets_rounded, size: size * 0.6),
          ),
        ),
        if (showTitle) ...[
          const SizedBox(height: 12),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'KUKU ',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.primaryGreen,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                'DIARY',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppTheme.amberGold,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          if (tagline != null) ...[
            const SizedBox(height: 4),
            Text(
              tagline!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E293B),
                letterSpacing: 1.0,
              ),
            ),
          ],
        ],
      ],
    );
  }
}
