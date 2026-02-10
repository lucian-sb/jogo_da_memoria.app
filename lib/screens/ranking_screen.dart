import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import '../services/ranking_service.dart';

/// Tela de ranking/leaderboard
class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  List<RankingEntry> _ranking = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarRanking();
  }

  Future<void> _carregarRanking() async {
    final ranking = await RankingService.getRanking();
    setState(() {
      _ranking = ranking;
      _isLoading = false;
    });
  }

  String _formatarTempo(int segundos) {
    final minutos = segundos ~/ 60;
    final segs = segundos % 60;
    if (minutos > 0) {
      return '${minutos}m ${segs}s';
    }
    return '${segs}s';
  }

  String _formatarData(DateTime data) {
    return '${data.day}/${data.month}/${data.year}';
  }

  Widget _buildRankingItem(RankingEntry entry, int posicao) {
    final isTop3 = posicao <= 3;
    final corPosicao = AppTheme.getRankingColor(posicao);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isTop3
              ? [
                  corPosicao.withOpacity(0.9),
                  corPosicao.withOpacity(0.7),
                ]
              : [
                  AppTheme.branco,
                  AppTheme.azulClaro.withOpacity(0.3),
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isTop3 ? corPosicao : AppTheme.azulPrincipal,
          width: isTop3 ? 3 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (isTop3 ? corPosicao : AppTheme.azulPrincipal)
                .withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // Posição
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isTop3 ? corPosicao : AppTheme.azulPrincipal,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$posicao',
                style: TextStyle(
                  color: isTop3 && posicao == 1
                      ? Colors.black87
                      : AppTheme.branco,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          // Informações
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.nome,
                  style: TextStyle(
                    color: isTop3 ? Colors.black87 : AppTheme.azulPrincipal,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.verde.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            size: 16,
                            color: AppTheme.verde,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Nível ${entry.nivel}',
                            style: TextStyle(
                              color: AppTheme.verde,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.azulPrincipal.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.timer,
                            size: 16,
                            color: AppTheme.azulPrincipal,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              _formatarTempo(entry.tempo),
                              style: TextStyle(
                                color: AppTheme.azulPrincipal,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.roxo.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.touch_app,
                            size: 16,
                            color: AppTheme.roxo,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${entry.movimentos}',
                            style: TextStyle(
                              color: AppTheme.roxo,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _formatarData(entry.data),
                  style: TextStyle(
                    color: isTop3
                        ? Colors.black54
                        : AppTheme.azulPrincipal.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Column(
          children: [
            AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const AppLogo(size: 48, animated: false),
                  const SizedBox(width: 12),
                  const Text('Ranking'),
                ],
              ),
              backgroundColor: AppTheme.azulPrincipal,
              foregroundColor: AppTheme.branco,
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh, size: 28),
                  onPressed: () {
                    setState(() {
                      _isLoading = true;
                    });
                    _carregarRanking();
                  },
                ),
              ],
            ),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.azulPrincipal,
                        strokeWidth: 4,
                      ),
                    )
                  : _ranking.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.emoji_events,
                                size: 80,
                                color: AppTheme.amarelo,
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Nenhum resultado ainda',
                                style: AppTheme.subtitleStyle(
                                  fontSize: 24,
                                  color: AppTheme.azulPrincipal,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          itemCount: _ranking.length,
                          itemBuilder: (context, index) {
                            return _buildRankingItem(_ranking[index], index + 1);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
