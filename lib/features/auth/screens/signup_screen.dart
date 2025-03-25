import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_route/auto_route.dart';
import '../viewmodels/auth_view_model.dart';
import '../widgets/signup_form.dart';

@RoutePage()
class SignupScreen extends ConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authViewModelProvider);
    final theme = Theme.of(context);
    
    // Redirecionar se já estiver autenticado
    state.maybeWhen(
      authenticated: (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.router.replaceNamed('/home');
        });
      },
      orElse: () {},
    );
    
    // Verificar se há mensagem de erro para mostrar
    state.maybeWhen(
      error: (message) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Colors.red,
            ),
          );
        });
      },
      orElse: () {},
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.pop(),
        ),
        title: const Text("Cadastro"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo circular animado
              Center(
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary.withOpacity(0.1),
                  ),
                  child: Center(
                    child: RotatingText(
                      text: "ray club fitness saúde bem estar",
                      radius: 60,
                      textStyle: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              // Formulário de cadastro
              SignupForm(
                isLoading: state.maybeWhen(
                  loading: () => true,
                  orElse: () => false,
                ),
                onSignup: (name, email, password) {
                  ref.read(authViewModelProvider.notifier).signUp(
                        email,
                        password,
                        name,
                      );
                },
              ),
              
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Já tem uma conta?'),
                  TextButton(
                    onPressed: () {
                      context.router.pop();
                    },
                    child: const Text('Faça login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget para texto circular rotacionado
class RotatingText extends StatelessWidget {
  final String text;
  final double radius;
  final TextStyle textStyle;
  
  const RotatingText({
    super.key,
    required this.text,
    required this.radius,
    required this.textStyle,
  });
  
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RotatingTextPainter(
        text: text,
        radius: radius,
        textStyle: textStyle,
      ),
      size: Size.square(radius * 2),
    );
  }
}

class _RotatingTextPainter extends CustomPainter {
  final String text;
  final double radius;
  final TextStyle textStyle;
  
  _RotatingTextPainter({
    required this.text,
    required this.radius,
    required this.textStyle,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);
    
    final spacing = 0.22; // espaçamento entre caracteres em radianos
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );
    
    for (int i = 0; i < text.length; i++) {
      final double angle = i * spacing;
      final char = text[i];
      
      canvas.save();
      canvas.rotate(angle);
      
      textPainter.text = TextSpan(
        text: char,
        style: textStyle,
      );
      
      textPainter.layout();
      textPainter.paint(canvas, Offset(-textPainter.width / 2, -radius));
      
      canvas.restore();
    }
  }
  
  @override
  bool shouldRepaint(_RotatingTextPainter oldDelegate) => 
    text != oldDelegate.text || 
    radius != oldDelegate.radius || 
    textStyle != oldDelegate.textStyle;
} 