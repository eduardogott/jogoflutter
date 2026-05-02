# Dengue Game — Guia de Setup e Personalização

## Estrutura de arquivos

```
lib/
├── main.dart               ← Ponto de entrada, decide qual tela abrir primeiro
├── tela_inicial.dart       ← Tela de cadastro do nome
├── menu_principal.dart     ← Menu com Jogar, Como Jogar e Som
├── como_jogar.dart         ← Tutorial (só exibe a imagem)
├── selecionar_fase.dart    ← Seleção de fase com estrelas
├── fases/
│   ├── fase.dart           ← Lógica do jogo (itens clicáveis)
│   └── pos_fase.dart       ← Tela de resultado
└── utils/
    ├── db.dart             ← Banco de dados SQLite
    └── game_scaffold.dart  ← Widget de fundo + sistema de overlay
```

## Setup inicial

1. **Instale o Flutter** (https://docs.flutter.dev/get-started/install)

2. **Crie o projeto base:**
   ```bash
   flutter create dengue_game
   cd dengue_game
   ```

3. **Copie os arquivos** deste scaffold para dentro da pasta `dengue_game/`.

4. **Coloque suas imagens** em `assets/images/`:
   ```
   assets/images/
   ├── tela_inicial.png
   ├── menu_principal.png
   ├── como_jogar.png
   ├── selecionar_fase.png
   └── fases/
       ├── fase_1.png
       ├── fase_2.png
       ├── fase_3.png
       └── pos_fase.png
   ```

5. **Instale as dependências:**
   ```bash
   flutter pub get
   ```

6. **Rode o app:**
   ```bash
   flutter run
   ```

---

## Como ajustar as coordenadas dos botões e overlays

Todas as coordenadas usam o sistema de referência **1080×1920**.

Em qualquer arquivo, procure por `GameOverlay(` e ajuste os 4 valores:

```dart
GameOverlay(
  refX: 760,    // posição X do canto esquerdo do elemento (em 1920px)
  refY: 380,    // posição Y do canto superior do elemento (em 1080px)
  refWidth: 400,  // largura do elemento
  refHeight: 80,  // altura do elemento
  child: ...,
)
```

**Dica:** Abra sua imagem no Photoshop ou GIMP, posicione o cursor no canto
superior esquerdo do botão e anote X e Y. Faça o mesmo para o canto inferior
direito para calcular largura e altura.

---

## Como adicionar/editar itens clicáveis nas fases

No arquivo `lib/fases/fase.dart`, procure a função `_buildLevelData(int level)`.

Cada item é definido assim:

```dart
ClickableItem(
  id: 'nome_unico',   // identificador (qualquer texto único)
  refX: 200,          // posição X na imagem 1920×1080
  refY: 300,          // posição Y na imagem 1920×1080
  refWidth: 120,      // largura da área clicável
  refHeight: 120,     // altura da área clicável
  isCorrect: true,    // true = acerto (verde), false = erro (vermelho)
),
```

Adicione quantos itens quiser em cada `case`.

---

## Sistema de pontuação

Definido em `fase.dart`:
- Acerto: **+10 pontos**
- Erro: **-5 pontos** (mínimo: 0)

Para mudar, edite as constantes:
```dart
static const int pointsPerCorrect = 10;
static const int pointsPerMistake = 5;
```

## Sistema de estrelas

Calculado em `_finishLevel()` em `fase.dart`:
- ⭐⭐⭐ → 0 erros
- ⭐⭐  → 1-2 erros
- ⭐   → 3+ erros
- 0   → nenhum acerto

---

## Banco de dados

O banco fica em `utils/db.dart`. Tabelas:

| Tabela   | Campos                                          |
|----------|-------------------------------------------------|
| player   | id, name                                        |
| progress | level (PK), correct, best_score, stars          |
| settings | id, sound (1=ligado, 0=desligado)               |

Para resetar o progresso durante desenvolvimento, desinstale e reinstale o app.

---

## Orientação da tela

O app força **portrait** em `main.dart`. Não altere isso pois as imagens são 1080×1920.
