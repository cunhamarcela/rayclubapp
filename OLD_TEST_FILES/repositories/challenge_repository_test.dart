// Package imports:
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:postgrest/postgrest.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Project imports:
import 'package:ray_club_app/core/exceptions/repository_exception.dart';
import 'package:ray_club_app/models/challenge.dart';
import 'package:ray_club_app/repositories/challenge_repository.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {
  final _filterBuilder = MockPostgrestFilterBuilder();

  @override
  PostgrestFilterBuilder<PostgrestList> select([String columns = '*']) =>
      _filterBuilder;

  @override
  PostgrestFilterBuilder<PostgrestList> from(String table) => _filterBuilder;

  @override
  PostgrestFilterBuilder<PostgrestList> insert(Object json,
          {bool? defaultToNull,
          bool? upsert,
          String? onConflict,
          bool? ignoreDuplicates,
          bool? count}) =>
      _filterBuilder;

  @override
  PostgrestFilterBuilder<PostgrestList> update(Map<dynamic, dynamic> json,
          {bool? defaultToNull, bool? count}) =>
      _filterBuilder;

  @override
  PostgrestFilterBuilder<PostgrestList> delete({bool? count}) => _filterBuilder;

  @override
  PostgrestFilterBuilder<PostgrestList> eq(String column, dynamic value) =>
      _filterBuilder;
}

class MockPostgrestFilterBuilder extends Mock
    implements PostgrestFilterBuilder<PostgrestList> {
  @override
  PostgrestTransformBuilder<PostgrestList> select([String columns = '*']) =>
      MockPostgrestTransformBuilder();

  @override
  PostgrestTransformBuilder<PostgrestMap> single() =>
      MockPostgrestTransformBuilder();

  @override
  PostgrestFilterBuilder<PostgrestList> eq(String column, dynamic value) =>
      this;

  @override
  PostgrestResponse<PostgrestList> execute() {
    return PostgrestResponse(
      data: [
        {
          'id': '1',
          'title': 'Test Challenge',
          'description': 'Test Description',
          'start_date': '2024-03-21',
          'end_date': '2024-04-21',
          'reward': 100,
          'participants': [],
          'created_at': '2024-03-21T00:00:00Z',
          'updated_at': '2024-03-21T00:00:00Z',
        }
      ],
      count: 1,
    );
  }
}

class MockPostgrestTransformBuilder extends Mock
    implements PostgrestTransformBuilder<PostgrestList> {
  @override
  PostgrestResponse<PostgrestList> execute() {
    return PostgrestResponse(
      data: [
        {
          'id': '1',
          'title': 'Test Challenge',
          'description': 'Test Description',
          'start_date': '2024-03-21',
          'end_date': '2024-04-21',
          'reward': 100,
          'participants': [],
          'created_at': '2024-03-21T00:00:00Z',
          'updated_at': '2024-03-21T00:00:00Z',
        }
      ],
      count: 1,
    );
  }
}

void main() {
  late MockSupabaseClient mockClient;
  late MockSupabaseQueryBuilder mockQueryBuilder;
  late ChallengeRepository repository;
  late Challenge testChallenge;

  setUp(() {
    mockClient = MockSupabaseClient();
    mockQueryBuilder = MockSupabaseQueryBuilder();
    repository = ChallengeRepository(mockClient);
    testChallenge = Challenge(
      id: '1',
      title: 'Test Challenge',
      description: 'Test Description',
      startDate: DateTime.parse('2024-03-21'),
      endDate: DateTime.parse('2024-04-21'),
      reward: 100,
      participants: [],
      createdAt: DateTime.parse('2024-03-21T00:00:00Z'),
      updatedAt: DateTime.parse('2024-03-21T00:00:00Z'),
    );

    when(() => mockClient.from(any())).thenReturn(mockQueryBuilder);
  });

  group('getChallenges', () {
    test('returns list of challenges', () async {
      final challenges = await repository.getChallenges();

      expect(challenges, isA<List<Challenge>>());
      expect(challenges.length, 1);
      expect(challenges.first.id, testChallenge.id);
      verify(() => mockClient.from('challenges')).called(1);
      verify(() => mockQueryBuilder.select()).called(1);
    });

    test('throws DatabaseException when database operation fails', () async {
      when(() => mockQueryBuilder.select())
          .thenThrow(Exception('Database error'));

      expect(
        () => repository.getChallenges(),
        throwsA(isA<DatabaseException>()),
      );
    });
  });

  group('getChallenge', () {
    test('returns challenge by id', () async {
      final challenge = await repository.getChallenge('1');

      expect(challenge, isA<Challenge>());
      expect(challenge.id, testChallenge.id);
      verify(() => mockClient.from('challenges')).called(1);
      verify(() => mockQueryBuilder.eq('id', '1')).called(1);
    });

    test('throws DatabaseException when database operation fails', () async {
      when(() => mockQueryBuilder.eq('id', '1'))
          .thenThrow(Exception('Database error'));

      expect(
        () => repository.getChallenge('1'),
        throwsA(isA<DatabaseException>()),
      );
    });

    test('throws ResourceNotFoundException when challenge not found', () async {
      when(() => mockQueryBuilder.eq('id', '1')).thenReturn(
          MockPostgrestFilterBuilder()
            ..when(() => execute())
                .thenAnswer((_) => PostgrestResponse(data: [], count: 0)));

      expect(
        () => repository.getChallenge('1'),
        throwsA(isA<ResourceNotFoundException>()),
      );
    });
  });

  group('createChallenge', () {
    test('creates and returns challenge', () async {
      final challenge = await repository.createChallenge(testChallenge);

      expect(challenge, isA<Challenge>());
      expect(challenge.id, testChallenge.id);
      verify(() => mockClient.from('challenges')).called(1);
      verify(() => mockQueryBuilder.insert(any())).called(1);
    });

    test('throws DatabaseException when database operation fails', () async {
      when(() => mockQueryBuilder.insert(any()))
          .thenThrow(Exception('Database error'));

      expect(
        () => repository.createChallenge(testChallenge),
        throwsA(isA<DatabaseException>()),
      );
    });
  });

  group('updateChallenge', () {
    test('updates and returns challenge', () async {
      final challenge =
          await repository.updateChallenge('1', testChallenge.toJson());

      expect(challenge, isA<Challenge>());
      expect(challenge.id, testChallenge.id);
      verify(() => mockClient.from('challenges')).called(1);
      verify(() => mockQueryBuilder.eq('id', '1')).called(1);
    });

    test('throws DatabaseException when database operation fails', () async {
      when(() => mockQueryBuilder.eq('id', '1'))
          .thenThrow(Exception('Database error'));

      expect(
        () => repository.updateChallenge('1', testChallenge.toJson()),
        throwsA(isA<DatabaseException>()),
      );
    });
  });

  group('deleteChallenge', () {
    test('deletes challenge', () async {
      await repository.deleteChallenge('1');

      verify(() => mockClient.from('challenges')).called(1);
      verify(() => mockQueryBuilder.eq('id', '1')).called(1);
    });

    test('throws DatabaseException when database operation fails', () async {
      when(() => mockQueryBuilder.eq('id', '1'))
          .thenThrow(Exception('Database error'));

      expect(
        () => repository.deleteChallenge('1'),
        throwsA(isA<DatabaseException>()),
      );
    });
  });
}
