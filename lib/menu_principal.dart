// menu_principal.dart
// Menu principal com: Jogar, Como Jogar e toggle de Som.

import 'package:flutter/material.dart';
import 'utils/db.dart';
import 'utils/game_scaffold.dart';
import 'selecionar_fase.dart';
import 'como_jogar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class MenuPrincipal extends StatefulWidget {
  const MenuPrincipal({super.key});

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<MenuPrincipal> {
  bool _soundEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final sound = await DB.getSoundEnabled();
    setState(() => _soundEnabled = sound);
  }

  Future<void> _toggleSound() async {
    final newValue = !_soundEnabled;
    await DB.setSoundEnabled(newValue);
    setState(() => _soundEnabled = newValue);
  }

  void _goToPlay() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SelecionarFase()),
    );
  }

  void _goToHowToPlay() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ComoJogar()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      backgroundAsset: 'assets/images/menu_principal.png',
      overlays: [
        // LOGO SUPER MISSAO AEDES
        GameOverlay(
          refX: 120,
          refY: 250,
          refWidth: 860,
          refHeight: 450,
          child: IgnorePointer(
            child: SvgPicture.asset(
              'assets/logo/logo.svg',
              fit: BoxFit.contain,
            ),
          ),
        ),
        // ── Botão: Jogar ────────────────────────────────────────────────────
        // Ajuste as coordenadas conforme sua imagem de fundo.
        GameOverlay(
          refX: 220,
          refY: 1220,
          refWidth: 660,
          refHeight: 180,
          child: ElevatedButton(
            onPressed: _goToPlay,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff5f9731),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(48),
                side: const BorderSide(
                  color: Colors.white, // border color
                  width: 4,            // thickness (increase if you want)
                ),
              ),
            ),
            child: const Text(
              'JOGAR',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                fontFamily: 'ComicSans',
                color: Colors.white,
              ),
            ),
          ),
        ),

        // ── Botão: Como Jogar ───────────────────────────────────────────────
        GameOverlay(
          refX: 220,
          refY: 1420,
          refWidth: 660,
          refHeight: 180,
          child: ElevatedButton(
            onPressed: _goToHowToPlay,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff1e92e4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(48),
                side: const BorderSide(
                  color: Colors.white, // border color
                  width: 4,            // thickness (increase if you want)
                )
              ),
            ),
            child: const Text(
              'COMO JOGAR',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                fontFamily: 'ComicSans',
                color: Colors.white),
            ),
          ),
        ),

        // ── BOTÃO SAIR ─────────────────────────────────────────────────────
        GameOverlay(
          refX: 220,
          refY: 1620,
          refWidth: 660,
          refHeight: 180,
          child: ElevatedButton(
            onPressed: () => SystemNavigator.pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xffff200c),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(48),
                side: const BorderSide(
                  color: Colors.white,
                  width: 4,
                ),
              ),
            ),
            child: const Text(
              'SAIR',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                fontFamily: 'ComicSans',
                color: Colors.white,
              ),
            ),
          ),
        ),

        // ── Toggle: Som ─────────────────────────────────────────────────────
        GameOverlay(
          refX: 860,
          refY: 40,
          refWidth: 180,
          refHeight: 180,
          child: GestureDetector(
            onTap: _toggleSound,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffb039c5),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: Colors.white, // border color
                  width: 4,            // thickness
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _soundEnabled ? Icons.volume_up : Icons.volume_off,
                    color: Colors.white,
                    size: 90,
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
