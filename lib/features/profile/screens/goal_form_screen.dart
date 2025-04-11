// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

// Project imports:
import 'package:ray_club_app/features/goals/models/user_goal_model.dart';
import 'package:ray_club_app/features/goals/repositories/goal_repository.dart';
import 'package:ray_club_app/utils/form_validator.dart';

@RoutePage()
/// Tela para adicionar ou editar metas do usuário
class GoalFormScreen extends ConsumerStatefulWidget {
  /// Meta existente a ser editada (null para nova meta)
  final UserGoal? existingGoal;
  
  /// Construtor
  const GoalFormScreen({
    Key? key,
    this.existingGoal,
  }) : super(key: key);
  
  @override
  ConsumerState<GoalFormScreen> createState() => _GoalFormScreenState();
}

class _GoalFormScreenState extends ConsumerState<GoalFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late GoalType _selectedType = GoalType.workout;
  final _titleController = TextEditingController();
  final _targetController = TextEditingController();
  final _unitController = TextEditingController();
  String _selectedUnit = 'treinos';
  bool _isLoading = false;
  
  // Tipos de metas disponíveis com suas configurações
  final Map<GoalType, Map<String, dynamic>> _goalTypeConfigs = {
    GoalType.workout: {
      'name': 'Treino',
      'icon': Icons.fitness_center,
      'color': Colors.orange,
      'units': ['treinos', 'dias', 'sessões'],
      'defaultUnit': 'treinos',
      'defaultTitle': 'Completar treinos',
    },
    GoalType.weight: {
      'name': 'Peso',
      'icon': Icons.monitor_weight,
      'color': Colors.red,
      'units': ['kg', 'lb'],
      'defaultUnit': 'kg',
      'defaultTitle': 'Perder peso',
    },
    GoalType.steps: {
      'name': 'Passos',
      'icon': Icons.directions_walk,
      'color': Colors.green,
      'units': ['passos', 'km'],
      'defaultUnit': 'passos',
      'defaultTitle': 'Completar passos diários',
    },
    GoalType.nutrition: {
      'name': 'Nutrição',
      'icon': Icons.restaurant,
      'color': Colors.blue,
      'units': ['refeições', 'calorias', 'proteínas (g)'],
      'defaultUnit': 'refeições',
      'defaultTitle': 'Melhorar alimentação',
    },
    GoalType.custom: {
      'name': 'Personalizado',
      'icon': Icons.flag,
      'color': Colors.purple,
      'units': ['unidades', 'vezes', 'pontos'],
      'defaultUnit': 'unidades',
      'defaultTitle': 'Meta personalizada',
    },
  };
  
  @override
  void initState() {
    super.initState();
    
    // Se estiver editando uma meta existente, preenche o formulário
    if (widget.existingGoal != null) {
      _initializeFormWithExistingGoal();
    } else {
      // Inicializa com valores padrão
      _updateFormForSelectedType();
    }
  }
  
  void _initializeFormWithExistingGoal() {
    final goal = widget.existingGoal!;
    _selectedType = goal.type;
    _titleController.text = goal.title;
    _targetController.text = goal.target.toString();
    _selectedUnit = goal.unit;
    _unitController.text = goal.unit;
  }
  
  void _updateFormForSelectedType() {
    final config = _goalTypeConfigs[_selectedType]!;
    if (_titleController.text.isEmpty) {
      _titleController.text = config['defaultTitle'];
    }
    _selectedUnit = config['defaultUnit'];
    _unitController.text = _selectedUnit;
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _targetController.dispose();
    _unitController.dispose();
    super.dispose();
  }
  
  // Converte o GoalType para string descritiva
  String _getGoalTypeName(GoalType type) {
    return _goalTypeConfigs[type]?['name'] ?? 'Desconhecido';
  }
  
  // Obtém a cor para o tipo de meta
  Color _getGoalTypeColor(GoalType type) {
    return _goalTypeConfigs[type]?['color'] ?? Colors.grey;
  }
  
  // Obtém o ícone para o tipo de meta
  IconData _getGoalTypeIcon(GoalType type) {
    return _goalTypeConfigs[type]?['icon'] ?? Icons.help_outline;
  }
  
  // Obtém as unidades disponíveis para o tipo de meta
  List<String> _getUnitsForType(GoalType type) {
    return _goalTypeConfigs[type]?['units'] ?? ['unidades'];
  }
  
  // Salva a meta
  Future<void> _saveGoal() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final repository = ref.read(goalRepositoryProvider);
      final now = DateTime.now();
      
      // Criar nova meta ou atualizar existente
      final goal = widget.existingGoal == null
          ? UserGoal(
              id: const Uuid().v4(), // Gera um UUID para novas metas
              userId: '', // Será preenchido pelo repositório
              title: _titleController.text,
              type: _selectedType,
              target: double.parse(_targetController.text),
              unit: _selectedUnit,
              startDate: now,
              endDate: now.add(const Duration(days: 30)), // Meta de 30 dias por padrão
              createdAt: now,
            )
          : widget.existingGoal!.copyWith(
              title: _titleController.text,
              type: _selectedType,
              target: double.parse(_targetController.text),
              unit: _selectedUnit,
              updatedAt: now,
            );
      
      // Salvar no repositório
      if (widget.existingGoal == null) {
        await repository.createGoal(goal);
      } else {
        // Para atualizar uma meta existente, precisaria de um método updateGoal
        // Como não temos esse método no repositório, usamos o de progresso
        await repository.updateGoalProgress(goal.id, goal.progress);
      }
      
      if (mounted) {
        Navigator.of(context).pop(true); // Retorna true para indicar sucesso
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar meta: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingGoal != null ? 'Editar Meta' : 'Nova Meta'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tipo de Meta',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Seletor de tipo de meta
                DropdownButtonFormField<GoalType>(
                  value: _selectedType,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  items: GoalType.values.map((type) {
                    final config = _goalTypeConfigs[type]!;
                    return DropdownMenuItem<GoalType>(
                      value: type,
                      child: Row(
                        children: [
                          Icon(
                            config['icon'],
                            color: config['color'],
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(config['name']),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedType = value;
                        _updateFormForSelectedType();
                      });
                    }
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Campo para o título da meta
                const Text(
                  'Título da Meta',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    hintText: 'Ex: Completar 30 treinos',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  validator: (value) => FormValidator.validateRequired(value, fieldName: 'Título'),
                ),
                
                const SizedBox(height: 24),
                
                // Campo para o valor alvo
                const Text(
                  'Valor Alvo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Campo para o valor alvo
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        controller: _targetController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          hintText: 'Ex: 30',
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          
                          final numValue = double.tryParse(value);
                          if (numValue == null || numValue <= 0) {
                            return 'Digite um valor válido maior que zero';
                          }
                          
                          return null;
                        },
                      ),
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // Dropdown para selecionar a unidade
                    Expanded(
                      flex: 3,
                      child: DropdownButtonFormField<String>(
                        value: _selectedUnit,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        items: _getUnitsForType(_selectedType).map((unit) {
                          return DropdownMenuItem<String>(
                            value: unit,
                            child: Text(unit),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedUnit = value;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Botão de salvar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveGoal,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Salvar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 