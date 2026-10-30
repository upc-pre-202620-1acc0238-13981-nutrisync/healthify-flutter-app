/// Why a roster patient needs something from the nutritionist. Declaration order is the priority: if several apply,
/// the first one counts, and the "Need action" card sorts its rows by the same rule.
enum RosterAttention {
  /// There is an open signal in the review inbox (`hasOpenReviewItem`).
  openReview,

  /// A guided consultation was left half done (`hasConsultationInProgress`).
  consultationInProgress,

  /// No baseline data yet (`!hasBaseline`).
  missingBaseline,

  /// Has baseline data but no published plan (`isNew`).
  planNotPublished,
}
