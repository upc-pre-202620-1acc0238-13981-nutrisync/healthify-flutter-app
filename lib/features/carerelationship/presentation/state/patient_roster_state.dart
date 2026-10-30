import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/common/searchable_text.dart';
import '../../domain/entity/patient_roster.dart';
import '../../domain/valueobject/roster_attention.dart';

part 'patient_roster_state.freezed.dart';

/// A roster row.
///
/// [attention]: why the patient needs action (the first reason by priority); `null` = up to date.
@freezed
abstract class RosterItem with _$RosterItem {
  const factory RosterItem({
    required int patientId,
    required int careLinkId,
    required String fullName,
    required DateTime linkedSince,
    required bool isNew,
    RosterAttention? attention,
    @Default(false) bool hasConsultationInProgress,
    @Default(false) bool hasOpenReviewItem,
    DateTime? nextFollowUpAt,
  }) = _RosterItem;

  factory RosterItem.of(RosterPatient patient) => RosterItem(
    patientId: patient.patientId,
    careLinkId: patient.careLinkId.value,
    fullName: patient.fullName,
    linkedSince: patient.linkedSince,
    isNew: patient.isNew,
    attention: patient.attention,
    hasConsultationInProgress: patient.hasConsultationInProgress,
    hasOpenReviewItem: patient.hasOpenReviewItem,
    nextFollowUpAt: patient.nextFollowUpAt,
  );
}

/// My roster, grouped by action. `patients == null` = not read yet; empty list = empty state. Offline with no read =
/// offline state. The search filters on the phone, without a new call.
///
/// [query] is what was typed in "Search patient…". [isUpToDateExpanded]: the "Up to date" row expanded in place.
@freezed
abstract class PatientRosterState with _$PatientRosterState {
  const PatientRosterState._();

  const factory PatientRosterState({
    @Default(true) bool isLoading,
    @Default(false) bool isOffline,
    @Default(false) bool loadFailed,
    List<RosterItem>? patients,
    @Default('') String query,
    @Default(false) bool isUpToDateExpanded,
  }) = _PatientRosterState;

  bool get isEmpty => patients?.isEmpty ?? false;
  bool get needsConnection => patients == null && loadFailed && isOffline;

  List<RosterItem> get _matching {
    final term = query.searchable;
    return (patients ?? const <RosterItem>[])
        .where((patient) => term.isEmpty || patient.fullName.searchable.contains(term))
        .toList();
  }

  /// "Need action": sorted by the priority of their reason ([RosterAttention]); the rest, in backend order.
  List<RosterItem> get needsAction {
    final rows = _matching.where((patient) => patient.attention != null).toList();
    // `List.sort` is not stable: the original index breaks ties so equal reasons keep the backend order.
    final indexed = [for (var i = 0; i < rows.length; i++) (i, rows[i])]
      ..sort((a, b) {
        final byReason = a.$2.attention!.index.compareTo(b.$2.attention!.index);
        return byReason != 0 ? byReason : a.$1.compareTo(b.$1);
      });
    return [for (final (_, row) in indexed) row];
  }

  /// "Up to date": nothing pending.
  List<RosterItem> get upToDate => _matching.where((patient) => patient.attention == null).toList();

  /// There is a roster, but nobody matches the search.
  bool get noSearchResults => query.trim().isNotEmpty && (patients?.isNotEmpty ?? false) && _matching.isEmpty;
}
