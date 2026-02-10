import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import '../widgets/animated_button.dart';
import '../services/local_storage.dart';
import 'level_select_screen.dart';
import 'ranking_screen.dart';
import 'name_screen.dart';

/// Tela inicial estilo Play Store
class StartScreen extends StatefulWidget {
  final String? nomeJogador;

  const StartScreen({
    super.key,
    this.nomeJogador,
  });

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  String? _nomeJogador;
  bool _mostrarCampoNome = false;
  final TextEditingController _nomeController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nomeJogador = widget.nomeJogador;
    _mostrarCampoNome = _nomeJogador == null;
    // Se o campo de nome já deve aparecer, focar após o build
    if (_mostrarCampoNome) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _salvarNome() async {
    final nome = _nomeController.text.trim();
    if (nome.isNotEmpty) {
      await LocalStorage.savePlayerName(nome);
      setState(() {
        _nomeJogador = nome;
        _mostrarCampoNome = false;
      });
    }
  }

  void _jogar() {
    if (_nomeJogador == null || _nomeJogador!.isEmpty) {
      setState(() {
        _mostrarCampoNome = true;
      });
      // Solicitar foco após a animação
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LevelSelectScreen(nomeJogador: _nomeJogador!),
      ),
    );
  }

  void _niveis() {
    if (_nomeJogador == null || _nomeJogador!.isEmpty) {
      setState(() {
        _mostrarCampoNome = true;
      });
      // Solicitar foco após a animação
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LevelSelectScreen(nomeJogador: _nomeJogador!),
      ),
    );
  }

  void _ranking() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RankingScreen(),
      ),
    );
  }

  void _sair() {
    SystemNavigator.pop();
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
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 20.0 : 32.0,
              vertical: isSmallScreen ? 8.0 : 12.0,
            ),
            child: Column(
              children: [
                const Spacer(flex: 1),
                // Logo com animação
                AppLogo(
                  size: isSmallScreen ? 80 : 100,
                  animated: true,
                  animationType: AnimationType.bounce,
                ),
                SizedBox(height: isSmallScreen ? 8 : 12),
                // Título
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Jogo da Memória',
                    style: AppTheme.titleStyle(
                      fontSize: isSmallScreen ? 28 : 32,
                      color: AppTheme.branco,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 12 : 16),
                // Campo nome (se necessário)
                if (_mostrarCampoNome)
                  AnimatedOpacity(
                    opacity: _mostrarCampoNome ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      children: [
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
                          onSubmitted: (_) => _salvarNome(),
                        ),
                        SizedBox(height: isSmallScreen ? 12 : 16),
                        AnimatedButton(
                          onPressed: _salvarNome,
                          backgroundColor: AppTheme.roxo,
                          foregroundColor: AppTheme.branco,
                          child: Text(
                            'Salvar Nome',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 18 : 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 16 : 24),
                      ],
                    ),
                  ),
                // Saudação
                if (_nomeJogador != null && !_mostrarCampoNome)
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Olá, $_nomeJogador!',
                      style: AppTheme.subtitleStyle(
                        fontSize: isSmallScreen ? 18 : 20,
                        color: AppTheme.branco,
                      ),
                    ),
                  ),
                if (_nomeJogador != null && !_mostrarCampoNome)
                  SizedBox(height: isSmallScreen ? 12 : 16),
                // Botões de ação
                if (!_mostrarCampoNome) ...[
                  AnimatedButton.icon(
                    icon: Icons.play_arrow,
                    label: 'Jogar',
                    onPressed: _jogar,
                    backgroundColor: AppTheme.azulPrincipal,
                    foregroundColor: AppTheme.branco,
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 12),
                  AnimatedButton.icon(
                    icon: Icons.grid_view,
                    label: 'Níveis',
                    onPressed: _niveis,
                    backgroundColor: AppTheme.roxo,
                    foregroundColor: AppTheme.branco,
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 12),
                  AnimatedButton.icon(
                    icon: Icons.emoji_events,
                    label: 'Ranking',
                    onPressed: _ranking,
                    backgroundColor: AppTheme.amarelo,
                    foregroundColor: Colors.black87,
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 12),
                  AnimatedButton(
                    onPressed: _sair,
                    isOutlined: true,
                    foregroundColor: AppTheme.branco,
                    child: Text(
                      'Sair',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                const Spacer(flex: 1),
                // Versão no rodapé
                Text(
                  'v1.0.0',
                  style: TextStyle(
                    fontSize: 10,
                    color: AppTheme.branco.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
