# Integração de Treinos e Desafios

Este documento detalha a implementação da integração entre treinos e desafios no Ray Club App.

## Visão Geral

A integração permite que os registros de treinos feitos pelos usuários atualizem automaticamente seu progresso em desafios ativos. Isto é especialmente importante para o "Desafio da Ray", que se baseia em check-ins diários.

## Estrutura Implementada

1. **WorkoutChallengeService**: Serviço responsável por processar a conclusão de treinos e atualizar desafios
2. **ChallengeImageService**: Responsável por lidar com imagens de desafios e resolver problemas com URLs quebradas
3. **Modelos**: ChallengeProgress, usando Freezed para imutabilidade
4. **Tabelas do Banco de Dados**: challenge_check_ins e challenge_bonuses
5. **Integração em UserWorkoutViewModel**: Hook para atualizar desafios quando um treino é concluído

## Como Executar os Geradores de Código

Os modelos Freezed e JSON requerem a execução dos geradores de código para funcionar corretamente:

```bash
# Para executar os geradores uma única vez
flutter pub run build_runner build --delete-conflicting-outputs

# Para executar os geradores em modo observador (watch)
flutter pub run build_runner watch --delete-conflicting-outputs
```

## Atualização do Banco de Dados

Execute o script SQL em `sql/challenge_update.sql` no Supabase para criar as novas tabelas:

1. Acesse o Dashboard do Supabase
2. Vá para a seção "SQL Editor"
3. Crie um novo script
4. Cole o conteúdo de `sql/challenge_update.sql`
5. Execute o script

## Como Testar a Integração

1. Faça login no aplicativo
2. Participe de um desafio ativo
3. Complete um treino
4. Verifique se o progresso do desafio foi atualizado automaticamente

## Lógica de Pontuação

- **Desafio da Ray**: Pontos por check-in diário + bônus por sequências consecutivas
- **Desafios Privados**: Pontos base por check-in, com regras personalizáveis

## Próximos Passos

1. Implementar tela de check-in manual para desafios
2. Adicionar tela de criação de desafios privados
3. Implementar notificações para lembrar os usuários de fazer check-in 