// utils/game_scaffold.dart
// Widget reutilizável que:
//   1. Exibe um PNG 1080×1920 com letterbox (barras pretas) se necessário.
//   2. Permite sobrepor botões e áreas clicáveis usando coordenadas relativas
//      a 1080×1920 — alinhadas à imagem, ignorando as barras pretas.

import 'package:flutter/material.dart';

class GameScaffold extends StatelessWidget {
  /// Caminho do asset da imagem de fundo (ex: 'assets/images/menu_principal.png')
  final String backgroundAsset;

  /// Overlays posicionados sobre a imagem.
  /// Use coordenadas relativas ao espaço 1080×1920.
  final List<GameOverlay> overlays;

  const GameScaffold({
    super.key,
    required this.backgroundAsset,
    this.overlays = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // barras pretas (letterbox)
      body: Center(
        child: AspectRatio(
          // Proporção 9:16 — imagens são 1080×1920 (portrait).
          aspectRatio: 1080 / 1920,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final imageWidth  = constraints.maxWidth;
              final imageHeight = constraints.maxHeight;

              return Stack(
                children: [
                  // ── Imagem de fundo ───────────────────────────────────────
                  Positioned.fill(
                    child: Image.asset(
                      backgroundAsset,
                      fit: BoxFit.fill,
                    ),
                  ),

                  // ── Overlays escalados ────────────────────────────────────
                  for (final overlay in overlays)
                    overlay._positioned(imageWidth, imageHeight),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// GameOverlay
// Widget posicionado por coordenadas relativas ao espaço 1080×1920.
// ─────────────────────────────────────────────────────────────────────────────
class GameOverlay extends StatelessWidget {
  /// Coordenada X do canto superior esquerdo (referência: 1080px de largura).
  final double refX;

  /// Coordenada Y do canto superior esquerdo (referência: 1920px de altura).
  final double refY;

  /// Largura no espaço de referência 1080×1920.
  final double refWidth;

  /// Altura no espaço de referência 1080×1920.
  final double refHeight;

  /// Widget filho exibido nessa posição.
  final Widget child;

  const GameOverlay({
    super.key,
    required this.refX,
    required this.refY,
    required this.refWidth,
    required this.refHeight,
    required this.child,
  });

  /// Converte coordenadas de referência para pixels reais da tela.
  Widget _positioned(double imageWidth, double imageHeight) {
    final scaleX = imageWidth  / 1080;
    final scaleY = imageHeight / 1920;

    return Positioned(
      left:   refX      * scaleX,
      top:    refY      * scaleY,
      width:  refWidth  * scaleX,
      height: refHeight * scaleY,
      child:  child,
    );
  }

  @override
  Widget build(BuildContext context) => child;
}
