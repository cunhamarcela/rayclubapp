import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Widget que exibe um banner informando o status de conectividade
class ConnectivityBanner extends StatelessWidget {
  final ConnectivityResult? connectivityResult;
  final VoidCallback? onRetry;
  
  const ConnectivityBanner({
    Key? key,
    required this.connectivityResult,
    this.onRetry,
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
        });
        if (widget.onConnectivityChanged != null) {
          widget.onConnectivityChanged!();
        }
      }
    } catch (_) {
      // Em caso de erro, deixar _connectivityResult como null
    }
  }
  
  void _updateConnectionStatus(ConnectivityResult result) {
    if (mounted) {
      setState(() {
        _connectivityResult = result;
      });
      if (widget.onConnectivityChanged != null) {
        widget.onConnectivityChanged!();
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (!widget.showBanner) {
      return widget.child;
    }
    
    return Column(
      children: [
        ConnectivityBanner(
          connectivityResult: _connectivityResult,
          onRetry: _initConnectivity,
        ),
        Expanded(child: widget.child),
      ],
    );
  }
} 