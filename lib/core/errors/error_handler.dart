import "package:flutter/foundation.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ray_club_app/core/errors/app_exception.dart';
import 'package:ray_club_app/core/providers/service_providers.dart';
import 'package:ray_club_app/services/remote_logging_service.dart';
import 'package:ray_club_app/utils/log_utils.dart';

/// Utilitário para classificação de erros
class ErrorClassifier {
  /// Classifica um erro como exceção do app baseado em seu conteúdo
  static AppException classifyError(Object error, StackTrace stackTrace) {
    if (error is AppException) {
      return error;
    }
    
    // Categorizar com base em padrões de erro comuns
    final String errorString = error.toString().toLowerCase();
    
    // Handle network errors
    if (_isNetworkError(errorString)) {
      return NetworkException(
        message: 'A conexão falhou. Verifique sua internet.',
        originalError: error,
        stackTrace: stackTrace,
        code: _extractErrorCode(errorString),
      );
    }
    
    // Handle authentication errors
    if (_isAuthError(errorString)) {
      return AuthException(
        message: 'Erro de autenticação. Faça login novamente.',
        originalError: error,
        stackTrace: stackTrace,
        code: _extractErrorCode(errorString),
      );
    }
    
    // Handle storage errors
    if (_isStorageError(errorString)) {
      return StorageException(
        message: 'Erro de armazenamento. Tente novamente mais tarde.',
        originalError: error,
        stackTrace: stackTrace,
        code: _extractErrorCode(errorString),
      );
    }
    
    // Handle validation errors
    if (_isValidationError(errorString)) {
      return ValidationException(
        message: 'Dados inválidos. Verifique os campos informados.',
        originalError: error,
        stackTrace: stackTrace,
        code: _extractErrorCode(errorString),
      );
    }
    
    // Default to generic AppException
    return AppException(
      message: error.toString(),
      originalError: error,
      stackTrace: stackTrace,
    );
  }
  
  /// Verifica se o erro é relacionado a rede
  static bool _isNetworkError(String errorString) {
    return errorString.contains('socketexception') ||
           errorString.contains('connection refused') ||
           errorString.contains('network') ||
           errorString.contains('timeout') ||
           errorString.contains('certificate') ||
           errorString.contains('handshake') ||
           errorString.contains('host') ||
           errorString.contains('address');
  }
  
  /// Verifica se o erro é relacionado a autenticação
  static bool _isAuthError(String errorString) {
    return errorString.contains('authentication') ||
           errorString.contains('unauthorized') ||
           errorString.contains('forbidden') ||
           errorString.contains('permission') ||
           errorString.contains('token') ||
           errorString.contains('credential') ||
           errorString.contains('login') ||
           errorString.contains('password') ||
           errorString.contains('auth');
  }
  
  /// Verifica se o erro é relacionado a armazenamento
  static bool _isStorageError(String errorString) {
    return errorString.contains('storage') ||
           errorString.contains('file') ||
           errorString.contains('bucket') ||
           errorString.contains('upload') ||
           errorString.contains('download') ||
           errorString.contains('io error');
  }
  
  /// Verifica se o erro é relacionado a validação
  static bool _isValidationError(String errorString) {
    return errorString.contains('validation') ||
           errorString.contains('invalid') ||
           errorString.contains('required') ||
           errorString.contains('format') ||
           errorString.contains('constraint') ||
           errorString.contains('not null');
  }
  
  /// Attempts to extract an error code from the error message
  static String? _extractErrorCode(String errorString) {
    // Check for common error code patterns
    final RegExp codeRegex = RegExp(r'code[\s:]+([a-zA-Z0-9_-]+)', caseSensitive: false);
    final match = codeRegex.firstMatch(errorString);
    
    if (match != null && match.groupCount >= 1) {
      return match.group(1);
    }
    return null;
  }
}

/// Global error handler for Riverpod providers
class AppProviderObserver extends ProviderObserver {
  ProviderContainer? _container;

  AppProviderObserver();

  /// Define o container a ser usado pelo observer para ler providers
  void setContainer(ProviderContainer container) {
    _container = container;
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    // Convert to AppException if needed using unified error classifier
    final appError = ErrorClassifier.classifyError(error, stackTrace);
    
    // Log the error
    LogUtils.error(
      'Provider error: ${provider.name ?? provider.runtimeType}',
      error: appError,
      stackTrace: appError.stackTrace ?? stackTrace,
    );
    
    // Send to remote logging service if available
    if (_container != null) {
      _sendToRemoteLogging(
        'Provider error: ${provider.name ?? provider.runtimeType}',
        appError,
        appError.stackTrace ?? stackTrace,
        {'providerType': provider.runtimeType.toString()},
      );
    } else {
      LogUtils.warning(
        'Container não configurado no AppProviderObserver',
        tag: 'AppProviderObserver',
      );
    }
    
    super.providerDidFail(provider, error, stackTrace, container);
  }
  
  /// Sends error to remote logging service
  void _sendToRemoteLogging(
    String message,
    AppException error,
    StackTrace stackTrace,
    [Map<String, dynamic>? metadata]
  ) {
    try {
      // Evitar potencial recursão ao detectar erros do próprio sistema de logging
      if (error.message.contains('remoteLoggingService') || 
          (error.originalError != null && error.originalError.toString().contains('remoteLoggingService'))) {
        LogUtils.warning(
          'Evitando recursão potencial no log remoto',
          tag: 'AppProviderObserver',
          data: {'errorType': error.runtimeType.toString()},
        );
        return;
      }
      
      final remoteLoggingService = _container?.read(remoteLoggingServiceProvider);
      remoteLoggingService?.logError(
        message,
        error: error,
        stackTrace: stackTrace,
        tag: 'Provider',
        metadata: metadata,
      );
    } catch (e) {
      // Fallback to local logging if remote logging fails
      LogUtils.warning(
        'Falha ao enviar erro para serviço remoto',
        tag: 'AppProviderObserver',
        data: {'erro': e.toString()},
      );
    }
  }
}

/// Global error handler for the app
class ErrorHandler {
  static RemoteLoggingService? _remoteLoggingService;
  
  /// Define o serviço de log remoto
  static void setRemoteLoggingService(RemoteLoggingService service) {
    _remoteLoggingService = service;
  }
  
  /// Trata qualquer erro na aplicação
  static void handleError(Object error, [StackTrace? stackTrace]) {
    stackTrace ??= StackTrace.current;
    
    // Usar o mesmo classificador de erros para consistência
    final appError = ErrorClassifier.classifyError(error, stackTrace);
    
    // Log error locally
    LogUtils.error(
      'App error: ${appError.message}',
      error: appError,
      stackTrace: appError.stackTrace ?? stackTrace,
    );
    
    // Send to remote logging if available
    if (_remoteLoggingService != null) {
      _remoteLoggingService!.logError(
        'App error: ${appError.message}',
        error: appError,
        stackTrace: appError.stackTrace ?? stackTrace,
        tag: 'AppError',
      );
    }
  }
  
  /// Shows a user-friendly error message based on the exception type
  static String getUserFriendlyMessage(AppException exception) {
    if (exception is NetworkException) {
      return 'A conexão falhou. Verifique sua internet e tente novamente.';
    } else if (exception is AuthException) {
      return 'Houve um problema com sua autenticação. Por favor, faça login novamente.';
    } else if (exception is StorageException) {
      return 'Não foi possível acessar os arquivos necessários. Tente novamente.';
    } else if (exception is ValidationException) {
      return 'Os dados informados não são válidos. Por favor, verifique e tente novamente.';
    } else {
      return 'Ocorreu um erro inesperado. Por favor, tente novamente.';
    }
  }
}
