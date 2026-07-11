import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/nature_background.dart';
import '../widgets/pixel_button.dart';
import '../widgets/pixel_card.dart';
import '../widgets/pixel_title_box.dart';
import '../widgets/pixel_tree_icon.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NatureBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              children: [
                const PixelTitleBox(
                  title: 'Ingresa A Tu Reciclaje',
                  subtitle: 'TEJIENDO EXPERIENCIAS FUERA DEL AULA',
                ),
                const SizedBox(height: 32),
                PixelButton(
                  label: 'INGRESAR',
                  width: 220,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const LoginScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                PixelButton(
                  label: 'CREAR UNA CUENTA',
                  width: 220,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => const RegisterScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
                Row(
                  children: const [
                    PixelInfoCard(
                      tabLabel: 'Usuario',
                      title: 'Ivvone Castillo',
                      score: 'Score: 15,900 puntos',
                      progress: 0.55,
                      accentColor: AppColors.softPink,
                      treeType: TreeType.pine,
                    ),
                    PixelInfoCard(
                      tabLabel: 'Curso',
                      title: 'Curso Que Mas Recicla',
                      score: 'Score: 24,000 puntos',
                      progress: 0.82,
                      accentColor: AppColors.oliveGreen,
                      treeType: TreeType.leafy,
                    ),
                  ],
                ),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
