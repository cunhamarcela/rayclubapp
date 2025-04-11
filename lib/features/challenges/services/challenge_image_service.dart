import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'dart:math';

import '../models/challenge.dart';
import '../../../core/widgets/loading_indicator.dart';

/// Provider para o serviço de imagens de desafios
final challengeImageServiceProvider = Provider<ChallengeImageService>((ref) {
  return ChallengeImageService();
});

/// Serviço para gerenciar imagens de desafios
class ChallengeImageService {
  // Cache de URLs que falharam para evitar tentativas repetidas
  final Map<String, bool> _failedUrls = {};
  
  /// Lista de URLs conhecidas que falham (baseada nos logs)
  final List<String> _knownBadUrls = [
    'photo-1553530666-ba11a90a0868',
    'photo-1567187374635-6d59e71480b6',
    'photo-1531053270060-6643c9e70514',
    'photo-1616118132534-731f2d30fa9d'
  ];
  
  /// Imagens locais padrão para desafios
  static const _defaultImages = [
    'assets/images/challenge_default.jpg',
    'assets/images/art_office.jpg',
    'assets/images/art_bodyweight.jpg',
    'assets/images/art_hiit.jpg',
    'assets/images/art_yoga.jpg',
    'assets/images/art_travel.jpg',
  ];
  
  /// Imagem específica para o desafio oficial da Ray
  static const _rayOfficialImage = 'assets/images/art_bodyweight.jpg';
  
  /// URLs validadas que são garantidas de funcionar
  static const _workingUrls = [
    'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=500', // running
    'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=500', // fitness
    'https://images.unsplash.com/photo-1518611012118-696072aa579a?q=80&w=500', // workout
    'https://images.unsplash.com/photo-1576678927484-cc907957088c?q=80&w=500', // yoga
    'https://images.unsplash.com/photo-1549576490-b0b4831ef60a?q=80&w=500'  // hiking
  ];
  
  /// Retorna uma imagem padrão para um desafio
  String getDefaultImageForChallenge(Challenge challenge) {
    if (challenge.isOfficial) {
      return _rayOfficialImage;
    }
    
    try {
      // Usar um algoritmo determinístico para escolher uma imagem consistente
      final index = challenge.id.hashCode.abs() % (_defaultImages.length - 1);
      return _defaultImages[index];
    } catch (e) {
      // Em caso de erro, retornar a primeira imagem
      debugPrint('Error getting default image: $e');
      return _defaultImages.first;
    }
  }
  
  /// Gera uma URL de backup para uma imagem que falhou
  /// URLs validadas e testadas que funcionam com garantia
  String _generateBackupImageUrl() {
    return _workingUrls[Random().nextInt(_workingUrls.length)];
  }
  
  /// Verifica se uma URL de imagem é válida
  bool isValidImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty || !imageUrl.startsWith('http')) {
      return false;
    }
    
    // Verificar se a URL já falhou anteriormente
    if (_failedUrls.containsKey(imageUrl) && _failedUrls[imageUrl] == true) {
      return false;
    }
    
    // Verificar se é uma URL conhecida que falha
    for (final badUrl in _knownBadUrls) {
      if (imageUrl.contains(badUrl)) {
        return false;
      }
    }
    
    return true;
  }
  
  /// Registra uma URL que falhou para não tentar novamente
  void markUrlAsFailed(String url) {
    _failedUrls[url] = true;
    debugPrint('Marcando URL como falha: $url');
  }
  
  /// Limpa o cache de URLs que falharam
  void clearCache() {
    _failedUrls.clear();
    debugPrint('Cache de imagens de desafios limpo');
  }
  
  /// Retorna uma URL de imagem válida garantida de funcionar 
  /// Ignora completamente as URLs originais para evitar erros 404
  String getValidImageUrl(Challenge challenge) {
    // Always return a guaranteed working URL from our list
    final index = challenge.id.hashCode.abs() % _workingUrls.length;
    return _workingUrls[index];
  }
  
  /// Widget para exibir a imagem do desafio com fallback para imagem local
  Widget buildChallengeImage(Challenge challenge, {
    double? height,
    double? width,
    BoxFit fit = BoxFit.cover,
  }) {
    final imageUrl = getValidImageUrl(challenge);
    final defaultImage = getDefaultImageForChallenge(challenge);
    
    return FadeInImage(
      placeholder: AssetImage(defaultImage),
      image: NetworkImage(imageUrl),
      height: height,
      width: width,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 300),
      imageErrorBuilder: (context, error, stackTrace) {
        // Marcar URL como falha para não tentar novamente
        markUrlAsFailed(imageUrl);
        
        debugPrint('Erro ao carregar imagem do desafio: $error');
        return Image.asset(
          defaultImage,
          height: height,
          width: width,
          fit: fit,
        );
      },
    );
  }
  
  /// Widget para exibir a imagem do desafio como background de um container com gradiente
  Widget buildChallengeImageWithGradient(Challenge challenge, {
    double? height,
    double? width,
    required Widget child,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: _getImageProvider(challenge),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.3),
            BlendMode.darken,
          ),
          onError: (exception, stackTrace) {
            debugPrint('Error loading image as background: $exception');
          },
        ),
      ),
      child: child,
    );
  }
  
  /// Retorna o provider de imagem apropriado (rede ou asset)
  ImageProvider _getImageProvider(Challenge challenge) {
    final imageUrl = getValidImageUrl(challenge);
    final defaultImage = getDefaultImageForChallenge(challenge);
    
    try {
      return NetworkImage(
        imageUrl,
        // Adicionar headers personalizados para melhorar o carregamento
        headers: {
          HttpHeaders.cacheControlHeader: 'max-age=86400', // Cache por 24h
        },
      );
    } catch (e) {
      debugPrint('Erro ao criar NetworkImage: $e');
      return AssetImage(defaultImage);
    }
  }
  
  /// Método para pré-carregar imagens para melhorar a experiência do usuário
  Future<void> precacheImages(BuildContext context, List<Challenge> challenges) async {
    try {
      for (final challenge in challenges) {
        final imageUrl = getValidImageUrl(challenge);
        
        try {
          await precacheImage(NetworkImage(imageUrl), context);
        } catch (e) {
          // Se falhar, marcar como falha 
          markUrlAsFailed(imageUrl);
          try {
            // Pré-carregar a imagem local para garantir suavidade
            await precacheImage(AssetImage(getDefaultImageForChallenge(challenge)), context);
          } catch (assetError) {
            debugPrint('Failed to precache asset image: $assetError');
          }
        }
      }
    } catch (e) {
      debugPrint('Error in precacheImages: $e');
    }
  }
} 