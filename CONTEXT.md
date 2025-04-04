# Ray Club - Contexto do Aplicativo

## Visão Geral
O Ray Club é um aplicativo de fitness e bem-estar que oferece uma experiência gamificada para treinos e desafios. O app foi desenvolvido para motivar usuários a manterem uma rotina de exercícios através de desafios, recompensas e uma comunidade engajada.

## Funcionalidades Principais

### 1. Sistema de Treinos
- Biblioteca de treinos categorizados por tipo, nível e duração
- Treinos com exercícios detalhados, incluindo séries, repetições e tempos de descanso
- Acompanhamento de progresso em tempo real
- Sistema de favoritos e histórico de treinos realizados
- Sincronização offline para acesso a treinos sem internet
- Lembretes e notificações personalizáveis
- **NOVO**: Temporizador avançado com notificações sonoras e visuais
- **NOVO**: Animações para transições de exercícios
- **NOVO**: Sugestão inteligente de treinos baseada no histórico

### 2. Sistema de Desafios
- Desafios diários, semanais e mensais
- Sistema de pontuação e ranking
- Recompensas por completar desafios
- Acompanhamento de progresso e streaks
- Busca e filtros avançados de desafios
- Indicadores visuais de dificuldade
- **NOVO**: Medalhas virtuais por conclusão de desafios
- **NOVO**: Compartilhamento de conquistas em redes sociais
- **NOVO**: Destaque visual para desafios oficiais Ray Club

### 2.1 Sub-Desafios Personalizados
- Usuários podem criar seus próprios sub-desafios dentro de desafios principais
- Personalização de metas, duração e critérios
- Convite de amigos para participar
- Sistema de verificação e validação
- Gamificação específica para sub-desafios
- Rankings separados para cada sub-desafio
- Recompensas exclusivas para criadores de sub-desafios populares
- Integração com o sistema principal de pontuação
- **NOVO**: Suporte a equipes para desafios em grupo
- **NOVO**: Sistema de verificação com fotos e geolocalização

### 3. Perfil e Progresso
- Estatísticas detalhadas de treinos e desafios
- Sistema de níveis e conquistas
- Histórico de atividades
- Personalização de perfil
- Dashboard com métricas personalizadas
- Gráficos de evolução ao longo do tempo
- **NOVO**: Histórico detalhado de atividades com filtros
- **NOVO**: Gráficos interativos de evolução
- **NOVO**: Exportação de dados de progresso em CSV/PDF

### 4. Sistema de Nutrição
- Registro de refeições e alimentos
- Cálculo automático de macronutrientes
- Histórico alimentar com visualização por data
- Sugestões personalizadas baseadas em objetivos
- Integração com o sistema de treinos
- **NOVO**: Visualização gráfica de macronutrientes
- **NOVO**: Algoritmo de sugestões personalizadas
- **NOVO**: Scanner de código de barras para alimentos

### 5. Sistema de Benefícios
- Cupons e descontos exclusivos
- Verificação de autenticidade via QR Code
- Sistema automático de expiração
- Histórico de utilização
- Notificações de novos benefícios disponíveis
- **NOVO**: Detecção automática de cupons expirados
- **NOVO**: Sistema de reativação para administradores
- **NOVO**: Notificações push para novos benefícios

### 6. Modo Offline
- Sincronização automática quando voltar online
- Cache estratégico para dados críticos
- Indicador visual de status de conectividade
- Fila de operações para ações realizadas offline
- **NOVO**: Política de priorização para sincronização
- **NOVO**: Resolução automática de conflitos
- **NOVO**: Logs detalhados de sincronização

## Serviços Externos

### Supabase
O Supabase é a principal plataforma de backend, oferecendo:
- Autenticação de usuários (email/senha, Google Sign-In e Apple Sign-In)
- Banco de dados PostgreSQL para armazenamento de dados
- Sistema de armazenamento para imagens e mídia
- Realtime subscriptions para atualizações em tempo real
- Row Level Security (RLS) para segurança dos dados
- **NOVO**: Configuração completa de deep linking para autenticação social
- **NOVO**: Buckets otimizados por tipo de conteúdo

### Cache Local
Implementado com Hive para:
- Armazenamento local de dados frequentemente acessados
- Persistência durante modo offline
- Sincronização automática com banco remoto
- **NOVO**: Sistema otimizado de expiração de cache
- **NOVO**: Compressão de dados para economia de espaço

## Arquitetura do App

### MVVM com Riverpod
O aplicativo utiliza a arquitetura MVVM (Model-View-ViewModel) com Riverpod para gerenciamento de estado:

1. **Model (Modelos de Dados)**
   - Representação dos dados do negócio com Freezed para imutabilidade
   - Implementação das regras de negócio
   - Integração com Supabase

2. **View (Interface do Usuário)**
   - Widgets Flutter
   - Layouts responsivos
   - Componentes reutilizáveis

3. **ViewModel (Lógica de Apresentação)**
   - Gerenciamento de estado com Riverpod
   - Lógica de apresentação
   - Comunicação entre View e Model

### Sistemas Avançados Implementados

1. **Sistema de Tratamento de Erros** [NOVO]
   - Hierarquia unificada de exceções
   - ErrorClassifier para categorização automática
   - Middleware para captura de erros em providers
   - Sistema de validação de formulários
   - Sanitização de dados sensíveis nos logs
   - RetryPolicy para operações críticas

2. **Comunicação Entre Features** [NOVO]
   - SharedAppState para estado global compartilhado
   - AppEventBus para comunicação assíncrona desacoplada
   - Tipagem forte para eventos
   - Prevenção de memory leaks em listeners
   - Persistência de estado entre sessões

3. **Sistema Offline Robusto** [NOVO]
   - Cache local estratégico
   - Fila de operações com priorização
   - Indicador visual de conectividade
   - Resolução automática de conflitos
   - Sincronização em background

4. **Métricas e Telemetria** [NOVO]
   - Rastreamento de desempenho para operações críticas
   - Métricas de tempo para operações de rede
   - Monitoramento de uso de memória e bateria
   - Analytics para eventos chave e funis de conversão
   - Dashboard para visualização de métricas

### Estrutura Organizada por Features
O código está organizado por features para facilitar manutenção e escalabilidade:

```
lib/
├── core/                 # Componentes essenciais
├── features/             # Features independentes
│   ├── auth/             # Autenticação
│   ├── benefits/         # Benefícios e cupons
│   ├── challenges/       # Sistema de desafios
│   ├── home/             # Tela inicial
│   ├── intro/            # Introdução ao app
│   ├── nutrition/        # Controle nutricional
│   ├── profile/          # Perfil de usuário
│   ├── progress/         # Acompanhamento de progresso
│   └── workout/          # Sistema de treinos
├── services/             # Serviços globais
└── shared/               # Componentes compartilhados
```

### Fluxo de Dados
1. User interage com a View
2. View notifica o ViewModel
3. ViewModel processa a lógica e atualiza o Model
4. Model comunica com Supabase/APIs
5. Dados retornam pelo mesmo fluxo
6. View é atualizada automaticamente via Riverpod

### Comunicação Entre Features
1. **SharedAppState**: Estado global compartilhado e persistente
2. **AppEventBus**: Sistema de eventos para comunicação assíncrona

## Fluxo de Telas

### 1. Onboarding e Autenticação
- Tela de Introdução → Login/Registro
- Opções de login: Email/Senha, Google, Apple
- Verificação de email
- Recuperação de senha
- Introdução às funcionalidades principais
- **NOVO**: Animações Lottie para onboarding
- **NOVO**: Fluxo PKCE para autenticação segura

### 2. Home e Navegação Principal
- Dashboard com resumo de atividades
- Bottom Navigation: Home, Treinos, Desafios, Perfil
- Notificações e alertas
- **NOVO**: Skeleton loaders para carregamento
- **NOVO**: Tema escuro/claro com alternância automática

### 3. Fluxo de Treinos
- Lista de treinos disponíveis
- Filtros por categoria, duração e nível
- Detalhes do treino
- Execução do treino com cronômetro
- Finalização e feedback
- **NOVO**: Temporizador avançado com notificações
- **NOVO**: Animações para transições de exercícios

### 4. Fluxo de Desafios
- Lista de desafios ativos
- Detalhes do desafio
- Progresso do desafio
- Ranking e recompensas
- Criação de sub-desafios
- **NOVO**: Medalhas virtuais por conclusão
- **NOVO**: Compartilhamento de conquistas

### 5. Perfil e Configurações
- Informações do usuário
- Estatísticas e conquistas
- Personalização
- Preferências de notificações
- Configurações de privacidade
- **NOVO**: Histórico detalhado de atividades
- **NOVO**: Temas claro/escuro

### 6. Fluxo de Nutrição
- Registro de refeições
- Visualização de histórico
- Estatísticas nutricionais
- Sugestões personalizadas
- **NOVO**: Visualização gráfica de macronutrientes
- **NOVO**: Scanner de código de barras

### 7. Fluxo de Benefícios
- Lista de cupons disponíveis
- Detalhes do cupom
- QR Code para resgate
- Histórico de utilização
- **NOVO**: Detecção automática de cupons expirados
- **NOVO**: Sistema de reativação para administradores 