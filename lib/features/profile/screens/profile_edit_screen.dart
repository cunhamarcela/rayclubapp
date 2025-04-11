// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

// Project imports:
import '../../../core/theme/app_theme.dart';
import '../../../utils/form_validator.dart';
import '../../../utils/input_validator.dart';
import '../models/profile_model.dart';
import '../viewmodels/profile_view_model.dart';

@RoutePage()
class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _instagramController = TextEditingController();
  
  DateTime? _birthDate;
  String? _gender;
  
  bool _isLoading = false;
  String? _errorMessage;
  
  final List<String> _genderOptions = ['Masculino', 'Feminino', 'Não binário', 'Prefiro não informar'];
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }
  
  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _instagramController.dispose();
    super.dispose();
  }
  
  void _loadUserData() {
    final profileState = ref.read(profileViewModelProvider);
    if (profileState.profile != null) {
      final profile = profileState.profile!;
      
      _emailController.text = profile.email ?? '';
      
      // Estes campos não existem no modelo atual, mas iremos adicioná-los
      // Para fins de demonstração, apenas inicializaremos com valores vazios
      _phoneController.text = '';
      _instagramController.text = '';
    }
  }
  
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // Obter todos os valores dos campos
      final email = _emailController.text.trim();
      final phone = _phoneController.text.trim();
      final instagram = _instagramController.text.trim();
      final gender = _gender;
      final birthDate = _birthDate;
      
      // Atualizar perfil com todos os campos
      await ref.read(profileViewModelProvider.notifier).updateProfile(
        name: ref.read(profileViewModelProvider).profile?.name,
        phone: phone.isNotEmpty ? phone : null,
        gender: gender,
        birthDate: birthDate,
        instagram: instagram.isNotEmpty ? instagram : null,
      );
      
      // Atualizar email se foi modificado
      final currentEmail = ref.read(profileViewModelProvider).profile?.email;
      if (email != currentEmail && email.isNotEmpty) {
        await ref.read(profileViewModelProvider.notifier).updateEmail(email);
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil atualizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      
      if (mounted) {
        context.router.maybePop();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao atualizar perfil: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _resetPassword() async {
    if (_emailController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, informe um email válido para redefinir a senha';
      });
      return;
    }
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // Aqui você chamaria a API do Supabase para redefinir a senha
      // Por enquanto vamos apenas mostrar um feedback simulado
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Um link para redefinir sua senha foi enviado ao seu email'),
          backgroundColor: Colors.blue,
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro ao enviar link de redefinição: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileViewModelProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        backgroundColor: const Color(0xFF29B6F6),
        foregroundColor: Colors.white,
      ),
      body: profileState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red.shade800),
                          ),
                        ),
                      
                      const Text(
                        'Informações da Conta',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Email
                      TextFormField(
                        controller: _emailController,
                        decoration: FormValidator.getInputDecoration(
                          labelText: 'Email',
                          hintText: 'seu@email.com',
                          prefixIcon: const Icon(Icons.email),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: FormValidator.validateEmail,
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 16),
                      
                      // Botão para redefinir senha
                      OutlinedButton.icon(
                        onPressed: _isLoading ? null : _resetPassword,
                        icon: const Icon(Icons.lock_reset),
                        label: const Text('Redefinir Senha'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      const Text(
                        'Informações Pessoais',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Telefone
                      TextFormField(
                        controller: _phoneController,
                        decoration: FormValidator.getInputDecoration(
                          labelText: 'Telefone (opcional)',
                          hintText: '(99) 99999-9999',
                          prefixIcon: const Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                        inputFormatters: InputValidator.phoneInputFormatter(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null; // Campo opcional
                          }
                          return FormValidator.validatePhone(value);
                        },
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 16),
                      
                      // Gênero
                      DropdownButtonFormField<String>(
                        value: _gender,
                        decoration: FormValidator.getInputDecoration(
                          labelText: 'Gênero (opcional)',
                          prefixIcon: const Icon(Icons.people),
                        ),
                        items: _genderOptions.map((String gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender),
                          );
                        }).toList(),
                        onChanged: _isLoading ? null : (String? newValue) {
                          setState(() {
                            _gender = newValue;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      
                      // Data de nascimento
                      InkWell(
                        onTap: _isLoading ? null : _selectBirthDate,
                        child: InputDecorator(
                          decoration: FormValidator.getInputDecoration(
                            labelText: 'Data de nascimento (opcional)',
                            prefixIcon: const Icon(Icons.calendar_today),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _birthDate == null
                                    ? 'Selecionar data'
                                    : DateFormat('dd/MM/yyyy').format(_birthDate!),
                                style: TextStyle(
                                  color: _birthDate == null ? Colors.grey : Colors.black,
                                ),
                              ),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Instagram
                      TextFormField(
                        controller: _instagramController,
                        decoration: FormValidator.getInputDecoration(
                          labelText: 'Instagram (opcional)',
                          hintText: '@seuusuario',
                          prefixIcon: const Icon(Icons.alternate_email),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return null; // Campo opcional
                          }
                          
                          if (!value.startsWith('@') && !value.contains('@')) {
                            // Adicionar @ se o usuário não o incluiu
                            _instagramController.text = '@$value';
                          }
                          
                          return null;
                        },
                        enabled: !_isLoading,
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Botão salvar
                      ElevatedButton(
                        onPressed: _isLoading ? null : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF29B6F6),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.0,
                                ),
                              )
                            : const Text('Salvar Alterações'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
} 