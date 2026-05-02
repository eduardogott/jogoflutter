// selecionar_fase.dart
// Tela de seleção de fase com 3 níveis.
// Mostra o melhor resultado (estrelas) de cada fase já jogada.

import 'package:flutter/material.dart';
import 'utils/db.dart';
import 'utils/game_scaffold.dart';
import 'fases/fase.dart';

class SelecionarFase extends StatefulWidget {
  const SelecionarFase({super.key});

  @override
  State<SelecionarFase> createState() => _SelecionarFaseState();
}

class _SelecionarFaseState extends State<SelecionarFase> {
  // Progresso de cada fase (null = nunca jogada)
  Map<String, dynamic>? _progress1;
  Map<String, dynamic>? _progress2;
  Map<String, dynamic>? _progress3;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final p1 = await DB.getProgress(1);
    final p2 = await DB.getProgress(2);
    final p3 = await DB.getProgress(3);
    setState(() {
      _progress1 = p1;
      _progress2 = p2;
      _progress3 = p3;
    });
  }

  void _goToLevel(int level) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => Fase(level: level)))
        .then((_) {
      // Quando voltar da fase, recarrega o progresso.
      _loadProgress();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      backgroundAsset: 'assets/images/selecionar_fase.png',
      overlays: [
        // ── Botão Voltar ────────────────────────────────────────────────────
        GameOverlay(
          refX: 30,
          refY: 50,
          refWidth: 110,
          refHeight: 110,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: const Color(0xFFFFB300),
              padding: EdgeInsets.zero,
              side: const BorderSide(color: Colors.white, width: 4),
              elevation: 8,
              shadowColor: Colors.black.withOpacity(0.4),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 48,
            ),
          ),
        ),

        // - Texto FASES -
        GameOverlay(
          refX: 150,
          refY: 100,
          refWidth: 700,
          refHeight: 350,
          child: Padding(
            // Important: gives room for the thick stroke
            padding: const EdgeInsets.all(30),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 🔹 Outer white "background" stroke
                  Text(
                    'FASES',
                    style: TextStyle(
                      fontFamily: 'ComicSans',
                      fontSize: 120,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 25
                        ..color = Colors.white,
                    ),
                  ),

                  // 🔹 Brown border
                  Text(
                    'FASES',
                    style: TextStyle(
                      fontFamily: 'ComicSans',
                      fontSize: 120,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 10
                        ..color = const Color(0xff8b5512),
                    ),
                  ),

                  // 🔹 Fill
                  const Text(
                    'FASES',
                    style: TextStyle(
                      color: Color(0xfff8d752),
                      fontSize: 120,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'ComicSans',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // HORA DA MISSÃO
        GameOverlay(
          refX: 300,
          refY: 380,
          refWidth: 400,
          refHeight: 120,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xfffbf3c7), // light beige (matches your UI style)
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Text(
                'Hora da missão!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'ComicSans',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0c447e),
                ),
              ),
            ),
          ),
        ),
        // ── Fase 1 ─────────────────────────────────────────────────────────
        // Ajuste as coordenadas para bater com os botões da sua imagem.
        GameOverlay(
          refX: 100,
          refY: 1200,
          refWidth: 280,
          refHeight: 400,
          child: _LevelButton(
            label: '1',
            stars: _progress1?['stars'] as int?,
            onTap: () => _goToLevel(1),
            unlocked: true, // Fase 1 sempre desbloqueada
          ),
        ),

        // ── Fase 2 ─────────────────────────────────────────────────────────
        GameOverlay(
          refX: 400,
          refY: 1200,
          refWidth: 280,
          refHeight: 400,
          child: _LevelButton(
            label: '2',
            stars: _progress2?['stars'] as int?,
            onTap: () => _goToLevel(2),
            unlocked: (_progress1?['stars'] as int? ?? 0) >= 2,
          ),
        ),

        // ── Fase 3 ─────────────────────────────────────────────────────────
        GameOverlay(
          refX: 700,
          refY: 1200,
          refWidth: 280,
          refHeight: 400,
          child: _LevelButton(
            label: '3',
            stars: _progress3?['stars'] as int?,
            onTap: () => _goToLevel(3),
            unlocked: (_progress2?['stars'] as int? ?? 0) >= 2,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Widget auxiliar: botão de fase com estrelas
// ─────────────────────────────────────────────────────────────────────────────
class _LevelButton extends StatelessWidget {
  final String label;
  final int? stars;
  final VoidCallback onTap;
  final bool unlocked;

  const _LevelButton({
    required this.label,
    required this.stars,
    required this.onTap,
    required this.unlocked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: unlocked ? onTap : null, // ignore taps when locked
      child: Container(
        decoration: BoxDecoration(
          color: unlocked ? const Color(0xff7cb84b) : const Color(0xff9e9e9e), // grey when locked
          borderRadius: BorderRadius.circular(42),
          border: Border.all(
            color: unlocked ? const Color(0xffadd000) : const Color(0xff757575),
            width: 6,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // 🔹 Blur / glow behind
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'ComicSans',
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12)
                      ..color = const Color(0xff000000),
                  ),
                ),
                // 🔹 Border (stroke)
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'ComicSans',
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 12
                      ..color = unlocked
                          ? const Color(0xff3a7906)
                          : const Color(0xff424242),
                  ),
                ),
                // 🔹 Fill
                Text(
                  label,
                  style: TextStyle(
                    color: unlocked ? Colors.white : Colors.white60,
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ComicSans',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 🔹 Lock icon OR stars
            if (!unlocked)
              const Icon(
                Icons.lock,
                color: Colors.white60,
                size: 48,
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  final earned = stars != null && i < stars!;
                  return Icon(
                    Icons.star,
                    color: earned ? Colors.amber : Colors.blueGrey,
                    size: 48,
                  );
                }),
              ),
          ],
        ),
      ),
    );
  }
}