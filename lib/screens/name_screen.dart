import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import '../widgets/animated_button.dart';
import '../services/local_storage.dart';
import 'start_screen.dart';

/// Tela para coletar nome do jogador
class NameScreen extends StatefulWidget {
  const NameScreen({super.key});

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Garantir que o teclado abra após o build
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _iniciarJogo() async {
    final nomeJogador = _nomeController.text.trim();
    if (nomeJogador.isNotEmpty) {
      // Salvar nome
      await LocalStorage.savePlayerName(nomeJogador);
      
      // Navegar para start screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => StartScreen(nomeJogador: nomeJogador),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Por favor, digite seu nome'),
          backgroundColor: AppTheme.vermelho,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 600;
    
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 20.0 : 32.0,
                vertical: isSmallScreen ? 16.0 : 32.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo com animação
                  AppLogo(
                    size: isSmallScreen ? 140 : 180,
                    animated: true,
                    animationType: AnimationType.bounce,
                  ),
                  SizedBox(height: isSmallScreen ? 24 : 32),
                  // Título
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Jogo da Memória',
                      style: AppTheme.titleStyle(
                        fontSize: isSmallScreen ? 32 : 42,
                        color: AppTheme.branco,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 32 : 48),
                // Campo de nome
                TextField(
                  controller: _nomeController,
                  focusNode: _focusNode,
                  autofocus: true,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.words,
                  style: AppTheme.bodyStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                  cursorColor: AppTheme.roxo,
                  decoration: InputDecoration(
                    hintText: 'Qual seu nome?',
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 18,
                    ),
                    filled: true,
                    fillColor: AppTheme.branco,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: AppTheme.azulPrincipal,
                        width: 3,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: AppTheme.azulPrincipal,
                        width: 3,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: AppTheme.roxo,
                        width: 3,
                      ),
                    ),
                  ),
                  onSubmitted: (_) => _iniciarJogo(),
                ),
                const SizedBox(height: 48),
                // Botão iniciar
                AnimatedButton(
                  onPressed: _iniciarJogo,
                  backgroundColor: AppTheme.roxo,
                  foregroundColor: AppTheme.branco,
                  child: const Text(
                    'Iniciar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
