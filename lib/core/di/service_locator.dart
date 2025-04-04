import 'package:shared_preferences/shared_preferences.dart';
import 'package:get_it/get_it.dart';

/// Instância global do GetIt para injeção de dependências
final GetIt getIt = GetIt.instance;

/// Inicializa as dependências principais da aplicação
Future<void> initializeDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);
}
