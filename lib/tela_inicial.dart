// tela_inicial.dart
// Tela de primeiro acesso: jogador digita seu nome.
// Após salvar, vai para o MenuPrincipal.

import 'package:flutter/material.dart';
import 'utils/db.dart';
import 'utils/game_scaffold.dart';
import 'menu_principal.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  // Controlador do campo de texto para capturar o nome.
  final TextEditingController _nameController = TextEditingController();

  // Mensagem de erro exibida se o jogador tentar confirmar sem digitar nada.
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final name = _nameController.text.trim();

    if (name.isEmpty) {
      setState(() => _errorMessage = 'Digite seu nome para continuar!');
      return;
    }

    // Salva o nome no banco de dados.
    await DB.savePlayerName(name);

    if (!mounted) return;

    // Navega para o menu principal, removendo esta tela da pilha
    // (o jogador não pode voltar para cá).
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MenuPrincipal()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      backgroundAsset: 'assets/images/tela_inicial.png',
      overlays: [
        // LOGO SUPER MISSAO AEDES
        GameOverlay(
          refX: 120,
          refY: 850,
          refWidth: 860,
          refHeight: 450,
          child: IgnorePointer(
            child: SvgPicture.asset(
              'assets/logo/logo.svg',
              fit: BoxFit.contain,
            ),
          ),
        ),
        // ── Campo de texto para o nome ──────────────────────────────────────
        // Ajuste refX, refY, refWidth, refHeight conforme sua imagem.
        GameOverlay(
          refX: 180,
          refY: 1360,
          refWidth: 760,
          refHeight: 220,
          child: TextField(
            controller: _nameController,
            maxLength: 20,
            textAlign: TextAlign.center, // centers typed text
            style: const TextStyle(
              color: Colors.black,
              fontSize: 26,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: 'Seu nome...',
              hintStyle: const TextStyle(
                color: Colors.grey,
              ),
              hintTextDirection: TextDirection.ltr,
              alignLabelWithHint: true,

              // Center the hint
              contentPadding: const EdgeInsets.symmetric(vertical: 0),

              filled: true,
              fillColor: Colors.white, // white background

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100), // very rounded corners
                borderSide: const BorderSide(
                  color: Color(0xFFC7C7C7), // light gray border
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: const BorderSide(
                  color: Color(0xFFC7C7C7),
                  width: 1,
                ),
              ),

              errorText: _errorMessage,
            ),
            onSubmitted: (_) => _confirm(),
          ),
        ),

        // ── Botão Confirmar ─────────────────────────────────────────────────
        GameOverlay(
          refX: 180,
          refY: 1540,
          refWidth: 760,
          refHeight: 130,
          child: ElevatedButton(
            onPressed: _confirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xff4e80ff),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: const Text(
              'ENTRAR',
              style: TextStyle(
                fontFamily: 'ComicSans',
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 0,
                    offset: Offset(2, 2),
                    color: Colors.black,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
