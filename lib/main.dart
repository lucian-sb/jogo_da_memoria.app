import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'services/local_storage.dart';
import 'screens/start_screen.dart';
import 'screens/name_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MemoriaApp());
}

class MemoriaApp extends StatelessWidget {
  const MemoriaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jogo da Memória',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const InitialScreen(),
      onGenerateRoute: (settings) {
        // Transições animadas entre telas
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, secondaryAnimation) {
            switch (settings.name) {
              case '/start':
                return const StartScreen();
              case '/name':
                return const NameScreen();
              default:
                return const InitialScreen();
            }
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 0.1);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;

            var tween = Tween(begin: begin, end: end).chain(
              CurveTween(curve: curve),
            );

            var fadeTween = Tween(begin: 0.0, end: 1.0).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(tween),
              child: FadeTransition(
                opacity: animation.drive(fadeTween),
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
      },
    );
  }
}

/// Tela inicial que verifica se há nome salvo
class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  bool _isLoading = true;
  String? _nomeSalvo;

  @override
  void initState() {
    super.initState();
    _verificarNome();
  }

  Future<void> _verificarNome() async {
    final nome = await LocalStorage.getPlayerName();
    setState(() {
      _nomeSalvo = nome;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.backgroundGradient,
          ),
          child: const Center(
            child: CircularProgressIndicator(
              color: AppTheme.azulPrincipal,
              strokeWidth: 4,
            ),
          ),
        ),
      );
    }

    // Se existe nome salvo, ir direto para start screen
    if (_nomeSalvo != null && _nomeSalvo!.isNotEmpty) {
      return StartScreen(nomeJogador: _nomeSalvo);
    }

    // Se não existe, pedir nome
    return const NameScreen();
  }
}
