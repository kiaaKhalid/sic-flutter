import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PlanetHeader extends StatelessWidget {
  const PlanetHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x55D7F759),
                    blurRadius: 60,
                    spreadRadius: 10,
                  ),
                ],
                gradient: RadialGradient(
                  colors: [Color(0xFF2C2C2C), AppTheme.neon],
                  stops: [0.2, 1.0],
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              child: Container(
                width: 90,
                height: 18,
                decoration: BoxDecoration(
                  color: Color.lerp(Colors.transparent, AppTheme.neon, 0.08),
                  borderRadius: BorderRadius.circular(9),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
