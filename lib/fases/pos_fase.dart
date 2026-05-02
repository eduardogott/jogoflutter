// fases/pos_fase.dart
// Tela de resultado pós-fase.
// Recebe os dados do jogo como parâmetros, salva no banco e exibe o resultado.

import 'package:flutter/material.dart';
import '../utils/db.dart';
import '../utils/game_scaffold.dart';
import '../selecionar_fase.dart';

class PosFase extends StatefulWidget {
  final int level;
  final int score;
  final int totalCorrect;
  final int foundCorrect;
  final int mistakes;
  final int stars;

  const PosFase({
    super.key,
    required this.level,
    required this.score,
    required this.totalCorrect,
    required this.foundCorrect,
    required this.mistakes,
    required this.stars,
  });

  @override
  State<PosFase> createState() => _PosFaseState();
}

class _PosFaseState extends State<PosFase> {
  @override
  void initState() {
    super.initState();
    _saveResult();
  }

  Future<void> _saveResult() async {
    await DB.saveProgress(
      level: widget.level,
      correct: widget.foundCorrect,
      score: widget.score,
      stars: widget.stars,
    );
  }

  void _goToLevelSelect() {
    // Volta para a seleção de fases, limpando a pilha de navegação até ela.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const SelecionarFase()),
      (route) => false, // remove todas as rotas anteriores
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      backgroundAsset: 'assets/images/fases/pos_fase.png',
      overlays: [
        // ── Pontuação ───────────────────────────────────────────────────────
        GameOverlay(
          refX: 660,
          refY: 300,
          refWidth: 600,
          refHeight: 60,
          child: Center(
            child: Text(
              'Pontuação: ${widget.score}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: Colors.black, blurRadius: 4)],
              ),
            ),
          ),
        ),

        // ── Acertos ─────────────────────────────────────────────────────────
        GameOverlay(
          refX: 660,
          refY: 380,
          refWidth: 600,
          refHeight: 50,
          child: Center(
            child: Text(
              'Acertos: ${widget.foundCorrect} / ${widget.totalCorrect}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                shadows: [Shadow(color: Colors.black, blurRadius: 4)],
              ),
            ),
          ),
        ),

        // ── Erros ───────────────────────────────────────────────────────────
        GameOverlay(
          refX: 660,
          refY: 445,
          refWidth: 600,
          refHeight: 50,
          child: Center(
            child: Text(
              'Erros: ${widget.mistakes}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                shadows: [Shadow(color: Colors.black, blurRadius: 4)],
              ),
            ),
          ),
        ),

        // ── Estrelas ────────────────────────────────────────────────────────
        GameOverlay(
          refX: 760,
          refY: 510,
          refWidth: 400,
          refHeight: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (i) {
              return Icon(
                Icons.star,
                color: i < widget.stars ? Colors.amber : Colors.grey,
                size: 50,
              );
            }),
          ),
        ),

        // ── Botão: Voltar para seleção de fases ─────────────────────────────
        GameOverlay(
          refX: 760,
          refY: 620,
          refWidth: 400,
          refHeight: 80,
          child: ElevatedButton(
            onPressed: _goToLevelSelect,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'SELECIONAR FASE',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
