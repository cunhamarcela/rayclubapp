// Mocks generated by Mockito 5.4.5 from annotations
// in ray_club_app/test/core/services/expiration_service_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:flutter_riverpod/flutter_riverpod.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;
import 'package:ray_club_app/features/benefits/models/benefit.dart' as _i7;
import 'package:ray_club_app/features/benefits/models/redeemed_benefit.dart'
    as _i6;
import 'package:ray_club_app/features/benefits/viewmodels/benefit_state.dart'
    as _i2;
import 'package:ray_club_app/features/benefits/viewmodels/benefit_view_model.dart'
    as _i3;
import 'package:state_notifier/state_notifier.dart' as _i8;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeBenefitState_0 extends _i1.SmartFake implements _i2.BenefitState {
  _FakeBenefitState_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [BenefitViewModel].
///
/// See the documentation for Mockito's code generation for more information.
class MockBenefitViewModel extends _i1.Mock implements _i3.BenefitViewModel {
  MockBenefitViewModel() {
    _i1.throwOnMissingStub(this);
  }

  @override
  set onError(_i4.ErrorListener? _onError) => super.noSuchMethod(
        Invocation.setter(
          #onError,
          _onError,
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool get mounted => (super.noSuchMethod(
        Invocation.getter(#mounted),
        returnValue: false,
      ) as bool);

  @override
  _i5.Stream<_i2.BenefitState> get stream => (super.noSuchMethod(
        Invocation.getter(#stream),
        returnValue: _i5.Stream<_i2.BenefitState>.empty(),
      ) as _i5.Stream<_i2.BenefitState>);

  @override
  _i2.BenefitState get state => (super.noSuchMethod(
        Invocation.getter(#state),
        returnValue: _FakeBenefitState_0(
          this,
          Invocation.getter(#state),
        ),
      ) as _i2.BenefitState);

  @override
  set state(_i2.BenefitState? value) => super.noSuchMethod(
        Invocation.setter(
          #state,
          value,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i2.BenefitState get debugState => (super.noSuchMethod(
        Invocation.getter(#debugState),
        returnValue: _FakeBenefitState_0(
          this,
          Invocation.getter(#debugState),
        ),
      ) as _i2.BenefitState);

  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);

  @override
  _i5.Future<void> loadBenefits() => (super.noSuchMethod(
        Invocation.method(
          #loadBenefits,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> loadRedeemedBenefits() => (super.noSuchMethod(
        Invocation.method(
          #loadRedeemedBenefits,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> checkExpiredBenefits(List<_i6.RedeemedBenefit>? benefits) =>
      (super.noSuchMethod(
        Invocation.method(
          #checkExpiredBenefits,
          [benefits],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> filterByCategory(String? category) => (super.noSuchMethod(
        Invocation.method(
          #filterByCategory,
          [category],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> selectBenefit(String? benefitId) => (super.noSuchMethod(
        Invocation.method(
          #selectBenefit,
          [benefitId],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> selectRedeemedBenefit(String? redeemedBenefitId) =>
      (super.noSuchMethod(
        Invocation.method(
          #selectRedeemedBenefit,
          [redeemedBenefitId],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<_i6.RedeemedBenefit?> redeemBenefit(String? benefitId) =>
      (super.noSuchMethod(
        Invocation.method(
          #redeemBenefit,
          [benefitId],
        ),
        returnValue: _i5.Future<_i6.RedeemedBenefit?>.value(),
      ) as _i5.Future<_i6.RedeemedBenefit?>);

  @override
  _i5.Future<bool> markBenefitAsUsed(String? redeemedBenefitId) =>
      (super.noSuchMethod(
        Invocation.method(
          #markBenefitAsUsed,
          [redeemedBenefitId],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<bool> cancelRedeemedBenefit(String? redeemedBenefitId) =>
      (super.noSuchMethod(
        Invocation.method(
          #cancelRedeemedBenefit,
          [redeemedBenefitId],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<void> loadFeaturedBenefits() => (super.noSuchMethod(
        Invocation.method(
          #loadFeaturedBenefits,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  void clearSelectedBenefit() => super.noSuchMethod(
        Invocation.method(
          #clearSelectedBenefit,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void clearSelectedRedeemedBenefit() => super.noSuchMethod(
        Invocation.method(
          #clearSelectedRedeemedBenefit,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void clearError() => super.noSuchMethod(
        Invocation.method(
          #clearError,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void clearSuccessMessage() => super.noSuchMethod(
        Invocation.method(
          #clearSuccessMessage,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i5.Future<void> addUserPoints(int? points) => (super.noSuchMethod(
        Invocation.method(
          #addUserPoints,
          [points],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<bool> isAdmin() => (super.noSuchMethod(
        Invocation.method(
          #isAdmin,
          [],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<void> loadAllRedeemedBenefits() => (super.noSuchMethod(
        Invocation.method(
          #loadAllRedeemedBenefits,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<bool> updateBenefitExpiration(
    String? benefitId,
    DateTime? newExpirationDate,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateBenefitExpiration,
          [
            benefitId,
            newExpirationDate,
          ],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<bool> extendRedeemedBenefitExpiration(
    String? redeemedBenefitId,
    DateTime? newExpirationDate,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #extendRedeemedBenefitExpiration,
          [
            redeemedBenefitId,
            newExpirationDate,
          ],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<void> toggleAdminStatus() => (super.noSuchMethod(
        Invocation.method(
          #toggleAdminStatus,
          [],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<_i7.Benefit?> getBenefitById(String? benefitId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getBenefitById,
          [benefitId],
        ),
        returnValue: _i5.Future<_i7.Benefit?>.value(),
      ) as _i5.Future<_i7.Benefit?>);

  @override
  _i5.Future<bool> updateBenefit(_i7.Benefit? benefit) => (super.noSuchMethod(
        Invocation.method(
          #updateBenefit,
          [benefit],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  _i5.Future<bool> createBenefit(_i7.Benefit? benefit) => (super.noSuchMethod(
        Invocation.method(
          #createBenefit,
          [benefit],
        ),
        returnValue: _i5.Future<bool>.value(false),
      ) as _i5.Future<bool>);

  @override
  bool updateShouldNotify(
    _i2.BenefitState? old,
    _i2.BenefitState? current,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateShouldNotify,
          [
            old,
            current,
          ],
        ),
        returnValue: false,
      ) as bool);

  @override
  _i4.RemoveListener addListener(
    _i8.Listener<_i2.BenefitState>? listener, {
    bool? fireImmediately = true,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
          {#fireImmediately: fireImmediately},
        ),
        returnValue: () {},
      ) as _i4.RemoveListener);

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
