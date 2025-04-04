import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Utilitário para logging de eventos e erros no aplicativo
class LogUtils {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0, 
      errorMethodCount: 5,
      lineLength: 80,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
    level: kDebugMode ? Level.verbose : Level.warning,
  );
  
  /// Registra uma mensagem informativa
  static void info(String message, {String? tag, Object? data}) {
    _logger.i({'tag': tag, 'message': message, 'data': data});
  }
  
  /// Registra uma mensagem de debug (apenas em modo debug)
  static void debug(String message, {String? tag, Object? data}) {
    _logger.d({'tag': tag, 'message': message, 'data': data});
  }
  
  /// Registra uma mensagem de warning
  static void warning(String message, {String? tag, Object? data}) {
    _logger.w({'tag': tag, 'message': message, 'data': data});
  }
  
  /// Registra um erro
  static void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _logger.e(
      {'tag': tag, 'message': message, 'error': error},
      error: error,
      stackTrace: stackTrace,
    );
  }
  
  /// Registra um erro crítico
  static void critical(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    _logger.f(
      {'tag': tag, 'message': message, 'error': error},
      error: error,
      stackTrace: stackTrace,
    );
  }
} 