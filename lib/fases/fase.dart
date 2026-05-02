// fases/fase.dart
// Tela de jogo principal.
//
// Recebe o número da fase (1, 2 ou 3) e carrega:
//   - A imagem de fundo correspondente
//   - A lista de itens clicáveis dessa fase (definida em _levelData)
//
// Cada item tem:
//   - Coordenadas no espaço 1920×1080
//   - Se é correto (adiciona pontos) ou errado (subtrai pontos)
//   - Se já foi encontrado pelo jogador
//
// Ao apertar "Pronto" ou encontrar todos os itens corretos, vai para PósFase.

import 'package:flutter/material.dart';
import '../utils/game_scaffold.dart';
import 'pos_fase.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Modelo de um item clicável
// ─────────────────────────────────────────────────────────────────────────────
class ClickableItem {
  final String id;
  final double refX;      // coordenada X no espaço 1920×1080
  final double refY;      // coordenada Y no espaço 1920×1080
  final double refWidth;
  final double refHeight;
  final bool isCorrect;   // true = dá ponto; false = tira ponto
  bool found = false;     // marcado quando o jogador clica

  ClickableItem({
    required this.id,
    required this.refX,
    required this.refY,
    required this.refWidth,
    required this.refHeight,
    required this.isCorrect,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Dados de cada fase
// Edite aqui para ajustar posições e itens de cada fase.
// ─────────────────────────────────────────────────────────────────────────────
List<ClickableItem> _buildLevelData(int level) {
  switch (level) {
    case 1:
      return [
        // Itens CORRETOS (foco do Aedes / água parada, etc.)
        ClickableItem(id: 'pneu',    refX: 200,  refY: 300, refWidth: 120, refHeight: 120, isCorrect: true),
        ClickableItem(id: 'garrafa', refX: 500,  refY: 450, refWidth: 100, refHeight: 150, isCorrect: true),
        ClickableItem(id: 'vaso',    refX: 850,  refY: 500, refWidth: 130, refHeight: 130, isCorrect: true),
        // Itens INCORRETOS (distrações)
        ClickableItem(id: 'cadeira', refX: 1200, refY: 400, refWidth: 150, refHeight: 200, isCorrect: false),
        ClickableItem(id: 'arvore',  refX: 1500, refY: 200, refWidth: 180, refHeight: 300, isCorrect: false),
      ];

    case 2:
      return [
        ClickableItem(id: 'calha',   refX: 300,  refY: 150, refWidth: 200, refHeight: 80,  isCorrect: true),
        ClickableItem(id: 'balde',   refX: 700,  refY: 600, refWidth: 100, refHeight: 120, isCorrect: true),
        ClickableItem(id: 'piscina', refX: 1100, refY: 550, refWidth: 300, refHeight: 200, isCorrect: true),
        ClickableItem(id: 'mesa',    refX: 400,  refY: 700, refWidth: 200, refHeight: 150, isCorrect: false),
        ClickableItem(id: 'janela',  refX: 1400, refY: 300, refWidth: 160, refHeight: 200, isCorrect: false),
      ];

    case 3:
    default:
      return [
        ClickableItem(id: 'lata',    refX: 150,  refY: 500, refWidth: 90,  refHeight: 120, isCorrect: true),
        ClickableItem(id: 'poco',    refX: 600,  refY: 350, refWidth: 200, refHeight: 200, isCorrect: true),
        ClickableItem(id: 'saco',    refX: 1000, refY: 600, refWidth: 140, refHeight: 100, isCorrect: true),
        ClickableItem(id: 'banco',   refX: 1300, refY: 450, refWidth: 180, refHeight: 150, isCorrect: false),
        ClickableItem(id: 'porta',   refX: 1650, refY: 300, refWidth: 120, refHeight: 280, isCorrect: false),
      ];
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Fase (StatefulWidget)
// ─────────────────────────────────────────────────────────────────────────────
class Fase extends StatefulWidget {
  final int level;
  const Fase({super.key, required this.level});

  @override
  State<Fase> createState() => _FaseState();
}

class _FaseState extends State<Fase> {
  late List<ClickableItem> _items;
  int _score = 0;
  int _mistakes = 0;

  // Pontos ganhos/perdidos por acerto/erro.
  static const int pointsPerCorrect = 10;
  static const int pointsPerMistake = 5;

  @override
  void initState() {
    super.initState();
    _items = _buildLevelData(widget.level);
  }

  int get _totalCorrect => _items.where((i) => i.isCorrect).length;
  int get _foundCorrect => _items.where((i) => i.isCorrect && i.found).length;
  bool get _allCorrectFound => _foundCorrect == _totalCorrect;

  void _onItemTap(ClickableItem item) {
    if (item.found) return; // ignora cliques repetidos

    setState(() {
      item.found = true;
      if (item.isCorrect) {
        _score += pointsPerCorrect;
      } else {
        _score -= pointsPerMistake;
        if (_score < 0) _score = 0; // pontuação mínima: 0
        _mistakes++;
      }
    });

    // Se todos os itens corretos foram encontrados, encerra automaticamente.
    if (_allCorrectFound) {
      _finishLevel();
    }
  }

  void _finishLevel() {
    // Calcula estrelas: 3 = sem erros, 2 = 1-2 erros, 1 = 3+ erros, 0 = 0 acertos
    int stars;
    if (_foundCorrect == 0) {
      stars = 0;
    } else if (_mistakes == 0) {
      stars = 3;
    } else if (_mistakes <= 2) {
      stars = 2;
    } else {
      stars = 1;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => PosFase(
          level: widget.level,
          score: _score,
          totalCorrect: _totalCorrect,
          foundCorrect: _foundCorrect,
          mistakes: _mistakes,
          stars: stars,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      backgroundAsset: 'assets/images/fase.png',
      overlays: [
        // ── Placar no topo (espaço portrait: 1080×1920) ────────────────────
        GameOverlay(
          refX: 120,
          refY: 150,
          refWidth: 840,
          refHeight: 320,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Color(0xfff8e1bb),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Color(0xfff5ac46), // border color
                width: 4,            // thickness
              ),
            ),
          ),
        ),

        GameOverlay(
          refX: 120,
          refY: 150,
          refWidth: 240,
          refHeight: 120,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Color(0xfff8e1bb),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Color(0xfff5ac46), // border color
                width: 4,            // thickness
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Fase ${widget.level}',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontFamily: 'ComicSans', fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),

        // ── Botão "Pronto" no canto inferior direito ────────────────────────
        GameOverlay(
          refX: 820,
          refY: 1780,
          refWidth: 240,
          refHeight: 110,
          child: ElevatedButton(
            onPressed: _finishLevel,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade700,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'PRONTO',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        // ── Áreas clicáveis ─────────────────────────────────────────────────
        ..._items.map((item) => _buildClickableArea(item)),
      ],
    );
  }

  // Constrói o GameOverlay de cada item clicável.
  GameOverlay _buildClickableArea(ClickableItem item) {
    return GameOverlay(
      refX: item.refX,
      refY: item.refY,
      refWidth: item.refWidth,
      refHeight: item.refHeight,
      child: GestureDetector(
        onTap: () => _onItemTap(item),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            // Quando encontrado: mostra destaque colorido.
            // Quando não encontrado: completamente transparente (invisível).
            border: item.found
                ? Border.all(
                    color: item.isCorrect ? Colors.green : Colors.red,
                    width: 3,
                  )
                : null,
            color: item.found
                ? (item.isCorrect
                    ? Colors.green.withOpacity(0.35)
                    : Colors.red.withOpacity(0.35))
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          // Ícone exibido após clique
          child: item.found
              ? Center(
                  child: Icon(
                    item.isCorrect ? Icons.check_circle : Icons.cancel,
                    color: item.isCorrect ? Colors.green : Colors.red,
                    size: 36,
                  ),
                )
              : const SizedBox.expand(), // área invisível mas clicável
        ),
      ),
    );
  }
}
