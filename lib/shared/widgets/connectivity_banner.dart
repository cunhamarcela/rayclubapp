// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:connectivity_plus/connectivity_plus.dart';

/// Widget que exibe um banner informando o status de conectividade
class ConnectivityBanner extends StatelessWidget {
  final ConnectivityResult? connectivityResult;
  final VoidCallback? onRetry;
  final VoidCallback? onClose;
  
  const ConnectivityBanner({
    Key? key,
    required this.connectivityResult,
    this.onRetry,
    this.onClose,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    // Não exibir nada se estiver online
    if (connectivityResult == ConnectivityResult.wifi || 
        connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == null) {
      return const SizedBox.shrink();
    }
    
    // Exibir banner para modo offline
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.orange[700],
      child: Row(
        children: [
          const Icon(
            Icons.wifi_off,
            color: Colors.white,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Você está offline. Algumas funcionalidades podem estar limitadas.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(40, 24),
                foregroundColor: Colors.white,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Tentar novamente'),
            ),
          if (onClose != null)
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 16),
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(),
              onPressed: onClose,
            ),
        ],
      ),
    );
  }
}

/// Widget que monitora o status de conectividade e exibe um banner quando offline
class ConnectivityBannerWrapper extends StatefulWidget {
  final Widget child;
  final bool showBanner;
  final VoidCallback? onConnectivityChanged;
  
  const ConnectivityBannerWrapper({
    Key? key,
    required this.child,
    this.showBanner = true,
    this.onConnectivityChanged,
  }) : super(key: key);
  
  @override
  State<ConnectivityBannerWrapper> createState() => _ConnectivityBannerWrapperState();
}

class _ConnectivityBannerWrapperState extends State<ConnectivityBannerWrapper> {
  final Connectivity _connectivity = Connectivity();
  ConnectivityResult? _connectivityResult;
  bool _bannerDismissed = false;
  
  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }
  
  Future<void> _initConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (mounted) {
        setState(() {
          _connectivityResult = result;
          // Resetar o estado de dismissed quando a conectividade muda
          if (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) {
            _bannerDismissed = false;
          }
        });
        // Chamar o callback de maneira segura se existir
        widget.onConnectivityChanged?.call();
      }
    } catch (_) {
      // Em caso de erro, deixar _connectivityResult como null
    }
  }
  
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    if (mounted) {
      // Considerar o primeiro resultado da lista ou none se a lista estiver vazia
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      
      setState(() {
        _connectivityResult = result;
        // Resetar o estado de dismissed quando a conectividade muda
        if (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) {
          _bannerDismissed = false;
        }
      });
      // Chamar o callback de maneira segura se existir
      widget.onConnectivityChanged?.call();
    }
  }
  
  void _dismissBanner() {
    if (mounted) {
      setState(() {
        _bannerDismissed = true;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (!widget.showBanner || _bannerDismissed) {
      return widget.child;
    }
    
    return Column(
      children: [
        ConnectivityBanner(
          connectivityResult: _connectivityResult,
          onRetry: _initConnectivity,
          onClose: _dismissBanner,
        ),
        Expanded(child: widget.child),
      ],
    );
  }
} 
