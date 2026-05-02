// como_jogar.dart
// Tela de tutorial construída inteiramente em Flutter sobre o PNG de fundo.
// Estrutura:
//   - PNG de fundo (grama, céu, mosquito) via GameScaffold
//   - Placa "COMO JOGAR" no topo
//   - Subtítulo verde
//   - 4 caixas bege com ícone + título + descrição
//   - Botão "VAMOS COMEÇAR!" no rodapé
//   - Botão voltar (canto superior esquerdo)

import 'package:flutter/material.dart';
import 'utils/game_scaffold.dart';
import 'selecionar_fase.dart';

class ComoJogar extends StatelessWidget {
  const ComoJogar({super.key});

  // Dados das 4 caixas de instrução
  static const _items = [
    _TutorialItem(
      icon: Icons.search,
      iconColor: Color(0xFFFFB300),
      title: 'Observe bem!',
      description:
          'Explore o cenário com atenção e procure locais com água parada.',
    ),
    _TutorialItem(
      icon: Icons.water_drop,
      iconColor: Color(0xFF43A047),
      title: 'Encontre os focos!',
      description:
          'Toque nos objetos que podem acumular água e virar criadouros do mosquito.',
    ),
    _TutorialItem(
      icon: Icons.star,
      iconColor: Color(0xFFFFD600),
      title: 'Ganhe pontos!',
      description:
          'Cada foco encontrado vale pontos. Quanto mais você encontrar, melhor!',
    ),
    _TutorialItem(
      icon: Icons.shield,
      iconColor: Color(0xFFE53935),
      title: 'Seja um herói!',
      description:
          'Ajude a manter sua casa e seu bairro protegidos da dengue!',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      backgroundAsset: 'assets/images/como_jogar.png',
      overlays: [
        // ── Botão voltar (canto superior esquerdo) ──────────────────────────
        GameOverlay(
          refX: 30,
          refY: 50,
          refWidth: 110,
          refHeight: 110,
          child: _BackButton(onTap: () => Navigator.of(context).pop()),
        ),

        // ── Conteúdo central (placa + caixas + botão) ───────────────────────
        // Ocupa quase toda a largura, começando abaixo do mosquito no topo.
        GameOverlay(
          refX: 140,
          refY: 370,
          refWidth: 800,
          refHeight: 1680,
          child: _TutorialContent(
            onStart: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const SelecionarFase()),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Botão voltar circular amarelo
// ─────────────────────────────────────────────────────────────────────────────
class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFFFFB300),
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Center(
          child: Icon(Icons.arrow_back, color: Colors.white, size: 48),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Conteúdo principal da tela
// ─────────────────────────────────────────────────────────────────────────────
class _TutorialContent extends StatelessWidget {
  final VoidCallback onStart;
  const _TutorialContent({required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        // ── Placa "COMO JOGAR" ─────────────────────────────────────────────
        _SignBoard(),
        const SizedBox(height: 80),
        // ── Subtítulo ──────────────────────────────────────────────────────
        const Text(
          'Siga estas dicas e ajude\na combater a dengue!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF2E7D32),
            fontSize: 42,
            fontWeight: FontWeight.bold,
            height: 1.1,
            fontFamily: 'ComicSans',
          ),
        ),
        const SizedBox(height: 20),
        // ── 4 caixas de instrução ──────────────────────────────────────────
        _InstructionBox(item: ComoJogar._items[0]),
        const SizedBox(height: 12),
        _InstructionBox(item: ComoJogar._items[1]),
        const SizedBox(height: 12),
        _InstructionBox(item: ComoJogar._items[2]),
        const SizedBox(height: 12),
        _InstructionBox(item: ComoJogar._items[3]),
        const SizedBox(height: 16),
        // ── Botão "VAMOS COMEÇAR!" ─────────────────────────────────────────
        _StartButton(onTap: onStart),
        const SizedBox(height: 2),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Placa de madeira "COMO JOGAR"
// ─────────────────────────────────────────────────────────────────────────────
class _SignBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
  child: Stack(
    alignment: Alignment.center,
    children: [
      // Outline
      Text(
        'COMO JOGAR',
        style: TextStyle(
          fontFamily: 'ComicSans',
          fontSize: 46,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 6
            ..color = Colors.black,
        ),
      ),

      // Fill
      Text(
        'COMO JOGAR',
        style: TextStyle(
          fontFamily: 'ComicSans',
          fontSize: 46,
          fontWeight: FontWeight.w900,
          letterSpacing: 2,
          color: Colors.white,
        ),
      ),
    ],
  ),
);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Caixa de instrução individual
// ─────────────────────────────────────────────────────────────────────────────
class _InstructionBox extends StatelessWidget {
  final _TutorialItem item;
  const _InstructionBox({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xfff2ebc7),   // bege claro
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Ícone circular colorido
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: item.iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
              border: Border.all(color: item.iconColor, width: 2),
            ),
            child: Icon(item.icon, color: item.iconColor, size: 38),
          ),
          const SizedBox(width: 24),
          // Título + descrição
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xff40280a),
                    fontFamily: 'ComicSans'
                  ),
                ),

                Text(
                  item.description,
                  style: const TextStyle(
                    fontSize: 22,
                    color: Color(0xff40280a),
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'ComicSans'
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Botão "VAMOS COMEÇAR!"
// ─────────────────────────────────────────────────────────────────────────────
class _StartButton extends StatelessWidget {
  final VoidCallback onTap;
  const _StartButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FractionallySizedBox(
        widthFactor: 0.7,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: const Color(0xFF388E3C),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: const Color(0xFF1B5E20), width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'VAMOS COMEÇAR!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(width: 10),
              Icon(Icons.arrow_forward, color: Colors.white, size: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Model dos itens do tutorial
// ─────────────────────────────────────────────────────────────────────────────
class _TutorialItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  const _TutorialItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
  });
}
