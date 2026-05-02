// main.dart
// Ponto de entrada do aplicativo.
// Decide qual tela mostrar primeiro baseado em se o jogador já tem nome salvo.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// FFI para desktop
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'utils/db.dart';
import 'tela_inicial.dart';
import 'menu_principal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicialização do SQLite para desktop
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  // Força orientação retrato
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Verifica se já existe um nome de jogador salvo
  final playerName = await DB.getPlayerName();

  runApp(DengueGame(showInitialScreen: playerName == null));
}

class DengueGame extends StatelessWidget {
  final bool showInitialScreen;
  const DengueGame({super.key, required this.showInitialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dengue Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
      ),
      home: showInitialScreen
          ? const TelaInicial()
          : const MenuPrincipal(),
    );
  }
}