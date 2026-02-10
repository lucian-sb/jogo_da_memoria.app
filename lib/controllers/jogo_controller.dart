import 'dart:math';
import 'package:flutter/material.dart';
import '../models/carta_model.dart';

class JogoController {
  List<CartaModel> cartas = [];
  int? primeiraCartaSelecionada;
  int? segundaCartaSelecionada;
  bool bloqueandoToque = false;
  int movimentos = 0;

  // Lista de ícones disponíveis (será passada pela tela)
  List<IconData>? iconesDisponiveis;
  int totalCartas = 4;

  // Callback para notificar mudanças de estado
  void Function()? onStateChanged;
  
  // Callback para notificar vitória
  void Function()? onVitoria;

  // Callback para quando carta é virada
  void Function()? onCardFlipped;

  // Callback para quando par é encontrado
  void Function()? onMatchFound;

  JogoController({
    this.onStateChanged,
    this.onVitoria,
    this.onCardFlipped,
    this.onMatchFound,
    this.iconesDisponiveis,
    this.totalCartas = 4,
  }) {
    _inicializarJogo();
  }

  // Inicializa o jogo criando pares e embaralhando
  void _inicializarJogo() {
    // Resetar movimentos
    movimentos = 0;
    
    if (iconesDisponiveis == null || iconesDisponiveis!.isEmpty) {
      return;
    }
    
    // Calcular quantos pares são necessários
    final quantidadePares = totalCartas ~/ 2;
    
    // Criar lista de cartas com pares de ícones
    final List<CartaModel> cartasTemp = [];
    for (int i = 0; i < quantidadePares; i++) {
      // Usar ícone do índice, repetindo se necessário
      final icone = iconesDisponiveis![i % iconesDisponiveis!.length];
      // Adicionar o par (duas cartas com mesmo ícone)
      cartasTemp.add(CartaModel(icone: icone));
      cartasTemp.add(CartaModel(icone: icone));
    }
    
    // Embaralhar as cartas
    final random = Random();
    cartasTemp.shuffle(random);
    
    // Atribuir a lista embaralhada
    cartas = cartasTemp;
  }
  
  // Reinicia o jogo com nova quantidade de cartas
  void reiniciarJogoComQuantidade(int novaQuantidade) {
    totalCartas = novaQuantidade;
    _resetarSelecao();
    _inicializarJogo();
    onStateChanged?.call();
  }

  // Processa o toque em uma carta
  void tocarCarta(int index) {
    // Validar índice
    if (index < 0 || index >= cartas.length) return;

    final carta = cartas[index];

    // Não permitir toque se:
    // - Carta já está aberta ou encontrada
    // - Jogo está bloqueado
    // - Tentar tocar a mesma carta duas vezes
    if (!carta.podeSerClicada() || 
        bloqueandoToque || 
        index == primeiraCartaSelecionada) {
      return;
    }

    // Abrir a carta
    carta.aberta = true;
    onCardFlipped?.call(); // Callback para som/vibração
    onStateChanged?.call();

    // Processar seleção
    if (primeiraCartaSelecionada == null) {
      // Primeira carta selecionada
      primeiraCartaSelecionada = index;
    } else {
      // Segunda carta selecionada
      segundaCartaSelecionada = index;
      bloqueandoToque = true;
      
      // Incrementar contador de movimentos
      movimentos++;
      
      onStateChanged?.call();

      // Comparar as cartas
      _compararCartas();
    }
  }

  // Compara as duas cartas selecionadas
  void _compararCartas() {
    if (primeiraCartaSelecionada == null || segundaCartaSelecionada == null) {
      return;
    }

    final primeiraCarta = cartas[primeiraCartaSelecionada!];
    final segundaCarta = cartas[segundaCartaSelecionada!];

    if (primeiraCarta.icone == segundaCarta.icone) {
      // Par encontrado - marcar como encontradas
      primeiraCarta.encontrada = true;
      segundaCarta.encontrada = true;
      
      // Callback para som/vibração de match
      onMatchFound?.call();
      
      // Resetar seleção
      _resetarSelecao();
      onStateChanged?.call();
      
      // Verificar se o jogo foi vencido
      _verificarVitoria();
    } else {
      // Par diferente - aguardar 700ms e fechar
      Future.delayed(const Duration(milliseconds: 700), () {
        primeiraCarta.aberta = false;
        segundaCarta.aberta = false;
        
        // Resetar seleção
        _resetarSelecao();
        onStateChanged?.call();
      });
    }
  }

  // Reseta a seleção de cartas
  void _resetarSelecao() {
    primeiraCartaSelecionada = null;
    segundaCartaSelecionada = null;
    bloqueandoToque = false;
  }

  // Verifica se todas as cartas foram encontradas
  void _verificarVitoria() {
    final todasEncontradas = cartas.every((carta) => carta.encontrada);
    if (todasEncontradas) {
      onVitoria?.call();
    }
  }

  // Reinicia o jogo
  void reiniciarJogo() {
    _resetarSelecao();
    _inicializarJogo();
    onStateChanged?.call();
  }
}
