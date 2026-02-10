# Jogo da Memoria

Jogo da memoria infantil desenvolvido em Flutter para Android.

## Descricao

Aplicativo educativo e divertido para criancas, focado no desenvolvimento da memoria e concentracao. O jogo apresenta niveis progressivos com diferentes quantidades de cartas, proporcionando desafios adequados para diferentes faixas etarias.

## Caracteristicas

- Interface colorida e amigavel para criancas
- Niveis progressivos (4 a 30 cartas)
- Sistema de ranking local
- Efeitos sonoros e feedback haptico
- Design responsivo para diferentes tamanhos de tela
- Funciona totalmente offline

## Tecnologias

- **Flutter** - Framework multiplataforma
- **Dart** - Linguagem de programacao
- **SharedPreferences** - Armazenamento local
- **AudioPlayers** - Efeitos sonoros

## Plataforma

- Android (minSdk: 21)

## Status

- Funcional e testado
- Publicado na Google Play Store

## Como rodar localmente

### Pre-requisitos

- Flutter SDK instalado
- Android Studio ou Android SDK configurado
- Dispositivo Android ou emulador

### Instalacao

1. Clone o repositorio:
```bash
git clone https://github.com/lucian-sb/jogo_da_memoria.app.git
cd jogo_da_memoria.app
```

2. Instale as dependencias:
```bash
flutter pub get
```

3. Execute o aplicativo:
```bash
flutter run
```

### Build para producao

```bash
flutter build apk --release
```

## Estrutura do Projeto

```
lib/
  ├── controllers/    # Logica do jogo
  ├── models/        # Modelos de dados
  ├── screens/       # Telas do aplicativo
  ├── services/      # Servicos (audio, storage, ranking)
  ├── theme/         # Tema e cores
  └── widgets/       # Componentes reutilizaveis
```

## Observacoes

- Este repositorio nao contem chaves sensiveis
- Arquivos de build e configuracoes locais estao no .gitignore
- O aplicativo funciona completamente offline

## Licenca

Este projeto e de uso pessoal/educacional.
