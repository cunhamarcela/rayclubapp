import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:ray_club_app/features/challenges/models/challenge_group.dart';
import 'package:ray_club_app/features/challenges/models/challenge_progress.dart';
import 'package:ray_club_app/features/challenges/repositories/challenge_repository.dart';
import 'package:ray_club_app/features/challenges/viewmodels/challenge_group_view_model.dart';

@GenerateMocks([ChallengeRepository])
import 'challenge_group_view_model_test.mocks.dart';

void main() {
  late ChallengeGroupViewModel viewModel;
  late MockChallengeRepository mockRepository;

  setUp(() {
    mockRepository = MockChallengeRepository();
    viewModel = ChallengeGroupViewModel(mockRepository);
  });

  group('ChallengeGroupViewModel Tests', () {
    test('loadUserGroups updates state correctly', () async {
      // Arrange
      final groups = [
        ChallengeGroup(
          id: '1',
          challengeId: 'c1',
          creatorId: 'u1',
          name: 'Test Group',
          createdAt: DateTime.now(),
        ),
      ];
      
      when(mockRepository.getUserCreatedGroups('u1')).thenAnswer((_) async => groups);
      when(mockRepository.getUserMemberGroups('u1')).thenAnswer((_) async => []);
      
      // Act
      await viewModel.loadUserGroups('u1');
      
      // Assert
      expect(viewModel.state.groups, equals(groups));
      expect(viewModel.state.isLoading, isFalse);
      expect(viewModel.state.errorMessage, isNull);
    });

    test('loadPendingInvites loads invites correctly', () async {
      // Arrange
      final invites = [
        ChallengeGroupInvite(
          id: '1',
          groupId: 'g1',
          groupName: 'Group 1',
          inviterId: 'u2',
          inviterName: 'User 2',
          inviteeId: 'u1',
          createdAt: DateTime.now(),
        ),
      ];
      
      when(mockRepository.getPendingGroupInvites('u1')).thenAnswer((_) async => invites);
      
      // Act
      await viewModel.loadPendingInvites('u1');
      
      // Assert
      expect(viewModel.state.pendingInvites, equals(invites));
      expect(viewModel.state.isLoading, isFalse);
      expect(viewModel.state.errorMessage, isNull);
    });

    test('loadGroupDetails loads group and ranking', () async {
      // Arrange
      final group = ChallengeGroup(
        id: 'g1',
        challengeId: 'c1',
        creatorId: 'u1',
        name: 'Test Group',
        createdAt: DateTime.now(),
      );
      
      final ranking = [
        ChallengeProgress(
          id: 'p1',
          userId: 'u1',
          challengeId: 'c1',
          points: 100,
          rank: 1,
          createdAt: DateTime.now(),
        ),
      ];
      
      when(mockRepository.getGroupById('g1')).thenAnswer((_) async => group);
      when(mockRepository.getGroupRanking('g1')).thenAnswer((_) async => ranking);
      
      // Act
      await viewModel.loadGroupDetails('g1');
      
      // Assert
      expect(viewModel.state.selectedGroup, equals(group));
      expect(viewModel.state.groupRanking, equals(ranking));
      expect(viewModel.state.isLoading, isFalse);
      expect(viewModel.state.errorMessage, isNull);
    });

    test('createGroup adds new group to state', () async {
      // Arrange
      final newGroup = ChallengeGroup(
        id: 'g1',
        challengeId: 'c1',
        creatorId: 'u1',
        name: 'New Group',
        createdAt: DateTime.now(),
      );
      
      when(mockRepository.createGroup(
        challengeId: 'c1',
        creatorId: 'u1',
        name: 'New Group',
        description: null,
      )).thenAnswer((_) async => newGroup);
      
      // Act
      await viewModel.createGroup(
        challengeId: 'c1',
        creatorId: 'u1',
        name: 'New Group',
      );
      
      // Assert
      expect(viewModel.state.groups, contains(newGroup));
      expect(viewModel.state.selectedGroup, equals(newGroup));
      expect(viewModel.state.isLoading, isFalse);
      expect(viewModel.state.errorMessage, isNull);
      expect(viewModel.state.successMessage, contains('criado com sucesso'));
    });
  });
} 