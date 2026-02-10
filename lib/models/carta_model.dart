import 'package:flutter/material.dart';

class CartaModel {
  final IconData icone;
  bool aberta;
  bool encontrada;

  CartaModel({
    required this.icone,
    this.aberta = false,
    this.encontrada = false,
  });

  // Método para verificar se a carta pode ser clicada
  bool podeSerClicada() {
    return !aberta && !encontrada;
  }

  // Método para verificar se a carta está visível (aberta ou encontrada)
  bool estaVisivel() {
    return aberta || encontrada;
  }
}
