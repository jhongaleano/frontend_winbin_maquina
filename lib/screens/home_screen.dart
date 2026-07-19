import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:front_winbin/poviders/RankingProvider.dart';

import '../theme/app_colors.dart';
import '../widgets/nature_background.dart';
import '../widgets/pixel_button.dart';
import '../widgets/pixel_card.dart';
import '../widgets/pixel_title_box.dart';
import '../widgets/pixel_tree_icon.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RankingProvider>().cargarLeaderboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NatureBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
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
                    Consumer<RankingProvider>(
                      builder: (context, rankingProvider, child) {
                        if (rankingProvider.cargandoRanking) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: CircularProgressIndicator(
                              color: AppColors.oliveGreen,
                            ),
                          );
                        }
                        final topUsuario = rankingProvider.topUsuario;
                        final topCurso = rankingProvider.topCurso;
                        const double metaPuntos = 1000.0;

                        final double progresoUsuario = topUsuario != null
                            ? (topUsuario.puntos / metaPuntos).clamp(0.0, 1.0)
                            : 0.0;

                        final double progresoCurso = topCurso != null
                            ? (topCurso.puntosTotales / metaPuntos).clamp(
                                0.0,
                                1.0,
                              )
                            : 0.0;

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: PixelInfoCard(
                                tabLabel: "Usuario Top",
                                title: topUsuario?.nombre ?? 'Cargando...',
                                score: topUsuario != null
                                    ? 'Score: ${topUsuario.puntos} pts'
                                    : '---',
                                progress: progresoUsuario,
                                accentColor: AppColors.softPink,
                                treeType: TreeType.pine,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: PixelInfoCard(
                                tabLabel: 'Curso Top',
                                title: topCurso != null
                                    ? 'Curso ${topCurso.nombre}'
                                    : 'Cargando...',
                                score: topCurso != null
                                    ? 'Score: ${topCurso.puntosTotales} pts'
                                    : '---',
                                progress: progresoCurso,
                                accentColor: AppColors.oliveGreen,
                                treeType: TreeType.leafy,
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
