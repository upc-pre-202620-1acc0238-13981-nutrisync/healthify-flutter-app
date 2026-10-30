// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'patient_roster_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RosterItem {

 int get patientId; int get careLinkId; String get fullName; DateTime get linkedSince; bool get isNew; RosterAttention? get attention; bool get hasConsultationInProgress; bool get hasOpenReviewItem; DateTime? get nextFollowUpAt;
/// Create a copy of RosterItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RosterItemCopyWith<RosterItem> get copyWith => _$RosterItemCopyWithImpl<RosterItem>(this as RosterItem, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RosterItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RosterItem&&(identical(other.patientId, _this.patientId) || other.patientId == _this.patientId)&&(identical(other.careLinkId, _this.careLinkId) || other.careLinkId == _this.careLinkId)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.linkedSince, _this.linkedSince) || other.linkedSince == _this.linkedSince)&&(identical(other.isNew, _this.isNew) || other.isNew == _this.isNew)&&(identical(other.attention, _this.attention) || other.attention == _this.attention)&&(identical(other.hasConsultationInProgress, _this.hasConsultationInProgress) || other.hasConsultationInProgress == _this.hasConsultationInProgress)&&(identical(other.hasOpenReviewItem, _this.hasOpenReviewItem) || other.hasOpenReviewItem == _this.hasOpenReviewItem)&&(identical(other.nextFollowUpAt, _this.nextFollowUpAt) || other.nextFollowUpAt == _this.nextFollowUpAt));
}


@override
int get hashCode {
  final _this = this as RosterItem;
  return Object.hash(runtimeType,_this.patientId,_this.careLinkId,_this.fullName,_this.linkedSince,_this.isNew,_this.attention,_this.hasConsultationInProgress,_this.hasOpenReviewItem,_this.nextFollowUpAt);
}

@override
String toString() {
  final _this = this as RosterItem;
  return 'RosterItem(patientId: ${_this.patientId}, careLinkId: ${_this.careLinkId}, fullName: ${_this.fullName}, linkedSince: ${_this.linkedSince}, isNew: ${_this.isNew}, attention: ${_this.attention}, hasConsultationInProgress: ${_this.hasConsultationInProgress}, hasOpenReviewItem: ${_this.hasOpenReviewItem}, nextFollowUpAt: ${_this.nextFollowUpAt})';
}


}

/// @nodoc
abstract mixin class $RosterItemCopyWith<$Res>  {
  factory $RosterItemCopyWith(RosterItem value, $Res Function(RosterItem) _then) = _$RosterItemCopyWithImpl;
@useResult
$Res call({
 int patientId, int careLinkId, String fullName, DateTime linkedSince, bool isNew, RosterAttention? attention, bool hasConsultationInProgress, bool hasOpenReviewItem, DateTime? nextFollowUpAt
});




}
/// @nodoc
class _$RosterItemCopyWithImpl<$Res>
    implements $RosterItemCopyWith<$Res> {
  _$RosterItemCopyWithImpl(this._self, this._then);

  final RosterItem _self;
  final $Res Function(RosterItem) _then;

/// Create a copy of RosterItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? patientId = null,Object? careLinkId = null,Object? fullName = null,Object? linkedSince = null,Object? isNew = null,Object? attention = freezed,Object? hasConsultationInProgress = null,Object? hasOpenReviewItem = null,Object? nextFollowUpAt = freezed,}) {
  return _then(RosterItem(
patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as int,careLinkId: null == careLinkId ? _self.careLinkId : careLinkId // ignore: cast_nullable_to_non_nullable
as int,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,linkedSince: null == linkedSince ? _self.linkedSince : linkedSince // ignore: cast_nullable_to_non_nullable
as DateTime,isNew: null == isNew ? _self.isNew : isNew // ignore: cast_nullable_to_non_nullable
as bool,attention: freezed == attention ? _self.attention : attention // ignore: cast_nullable_to_non_nullable
as RosterAttention?,hasConsultationInProgress: null == hasConsultationInProgress ? _self.hasConsultationInProgress : hasConsultationInProgress // ignore: cast_nullable_to_non_nullable
as bool,hasOpenReviewItem: null == hasOpenReviewItem ? _self.hasOpenReviewItem : hasOpenReviewItem // ignore: cast_nullable_to_non_nullable
as bool,nextFollowUpAt: freezed == nextFollowUpAt ? _self.nextFollowUpAt : nextFollowUpAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RosterItem].
extension RosterItemPatterns on RosterItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RosterItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RosterItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RosterItem value)  $default,){
final _that = this;
switch (_that) {
case _RosterItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RosterItem value)?  $default,){
final _that = this;
switch (_that) {
case _RosterItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int patientId,  int careLinkId,  String fullName,  DateTime linkedSince,  bool isNew,  RosterAttention? attention,  bool hasConsultationInProgress,  bool hasOpenReviewItem,  DateTime? nextFollowUpAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RosterItem() when $default != null:
return $default(_that.patientId,_that.careLinkId,_that.fullName,_that.linkedSince,_that.isNew,_that.attention,_that.hasConsultationInProgress,_that.hasOpenReviewItem,_that.nextFollowUpAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int patientId,  int careLinkId,  String fullName,  DateTime linkedSince,  bool isNew,  RosterAttention? attention,  bool hasConsultationInProgress,  bool hasOpenReviewItem,  DateTime? nextFollowUpAt)  $default,) {final _that = this;
switch (_that) {
case _RosterItem():
return $default(_that.patientId,_that.careLinkId,_that.fullName,_that.linkedSince,_that.isNew,_that.attention,_that.hasConsultationInProgress,_that.hasOpenReviewItem,_that.nextFollowUpAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int patientId,  int careLinkId,  String fullName,  DateTime linkedSince,  bool isNew,  RosterAttention? attention,  bool hasConsultationInProgress,  bool hasOpenReviewItem,  DateTime? nextFollowUpAt)?  $default,) {final _that = this;
switch (_that) {
case _RosterItem() when $default != null:
return $default(_that.patientId,_that.careLinkId,_that.fullName,_that.linkedSince,_that.isNew,_that.attention,_that.hasConsultationInProgress,_that.hasOpenReviewItem,_that.nextFollowUpAt);case _:
  return null;

}
}

}

/// @nodoc


class _RosterItem implements RosterItem {
  const _RosterItem({required this.patientId, required this.careLinkId, required this.fullName, required this.linkedSince, required this.isNew, this.attention, this.hasConsultationInProgress = false, this.hasOpenReviewItem = false, this.nextFollowUpAt});
  

@override final  int patientId;
@override final  int careLinkId;
@override final  String fullName;
@override final  DateTime linkedSince;
@override final  bool isNew;
@override final  RosterAttention? attention;
@override@JsonKey() final  bool hasConsultationInProgress;
@override@JsonKey() final  bool hasOpenReviewItem;
@override final  DateTime? nextFollowUpAt;

/// Create a copy of RosterItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RosterItemCopyWith<_RosterItem> get copyWith => __$RosterItemCopyWithImpl<_RosterItem>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RosterItem&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.careLinkId, careLinkId) || other.careLinkId == careLinkId)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.linkedSince, linkedSince) || other.linkedSince == linkedSince)&&(identical(other.isNew, isNew) || other.isNew == isNew)&&(identical(other.attention, attention) || other.attention == attention)&&(identical(other.hasConsultationInProgress, hasConsultationInProgress) || other.hasConsultationInProgress == hasConsultationInProgress)&&(identical(other.hasOpenReviewItem, hasOpenReviewItem) || other.hasOpenReviewItem == hasOpenReviewItem)&&(identical(other.nextFollowUpAt, nextFollowUpAt) || other.nextFollowUpAt == nextFollowUpAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,patientId,careLinkId,fullName,linkedSince,isNew,attention,hasConsultationInProgress,hasOpenReviewItem,nextFollowUpAt);
}

@override
String toString() {
    return 'RosterItem(patientId: $patientId, careLinkId: $careLinkId, fullName: $fullName, linkedSince: $linkedSince, isNew: $isNew, attention: $attention, hasConsultationInProgress: $hasConsultationInProgress, hasOpenReviewItem: $hasOpenReviewItem, nextFollowUpAt: $nextFollowUpAt)';
}


}

/// @nodoc
abstract mixin class _$RosterItemCopyWith<$Res> implements $RosterItemCopyWith<$Res> {
  factory _$RosterItemCopyWith(_RosterItem value, $Res Function(_RosterItem) _then) = __$RosterItemCopyWithImpl;
@override @useResult
$Res call({
 int patientId, int careLinkId, String fullName, DateTime linkedSince, bool isNew, RosterAttention? attention, bool hasConsultationInProgress, bool hasOpenReviewItem, DateTime? nextFollowUpAt
});




}
/// @nodoc
class __$RosterItemCopyWithImpl<$Res>
    implements _$RosterItemCopyWith<$Res> {
  __$RosterItemCopyWithImpl(this._self, this._then);

  final _RosterItem _self;
  final $Res Function(_RosterItem) _then;

/// Create a copy of RosterItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? patientId = null,Object? careLinkId = null,Object? fullName = null,Object? linkedSince = null,Object? isNew = null,Object? attention = freezed,Object? hasConsultationInProgress = null,Object? hasOpenReviewItem = null,Object? nextFollowUpAt = freezed,}) {
  return _then(_RosterItem(
patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as int,careLinkId: null == careLinkId ? _self.careLinkId : careLinkId // ignore: cast_nullable_to_non_nullable
as int,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,linkedSince: null == linkedSince ? _self.linkedSince : linkedSince // ignore: cast_nullable_to_non_nullable
as DateTime,isNew: null == isNew ? _self.isNew : isNew // ignore: cast_nullable_to_non_nullable
as bool,attention: freezed == attention ? _self.attention : attention // ignore: cast_nullable_to_non_nullable
as RosterAttention?,hasConsultationInProgress: null == hasConsultationInProgress ? _self.hasConsultationInProgress : hasConsultationInProgress // ignore: cast_nullable_to_non_nullable
as bool,hasOpenReviewItem: null == hasOpenReviewItem ? _self.hasOpenReviewItem : hasOpenReviewItem // ignore: cast_nullable_to_non_nullable
as bool,nextFollowUpAt: freezed == nextFollowUpAt ? _self.nextFollowUpAt : nextFollowUpAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$PatientRosterState {

 bool get isLoading; bool get isOffline; bool get loadFailed; List<RosterItem>? get patients; String get query; bool get isUpToDateExpanded;
/// Create a copy of PatientRosterState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PatientRosterStateCopyWith<PatientRosterState> get copyWith => _$PatientRosterStateCopyWithImpl<PatientRosterState>(this as PatientRosterState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PatientRosterState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PatientRosterState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isOffline, _this.isOffline) || other.isOffline == _this.isOffline)&&(identical(other.loadFailed, _this.loadFailed) || other.loadFailed == _this.loadFailed)&&const DeepCollectionEquality().equals(other.patients, _this.patients)&&(identical(other.query, _this.query) || other.query == _this.query)&&(identical(other.isUpToDateExpanded, _this.isUpToDateExpanded) || other.isUpToDateExpanded == _this.isUpToDateExpanded));
}


@override
int get hashCode {
  final _this = this as PatientRosterState;
  return Object.hash(runtimeType,_this.isLoading,_this.isOffline,_this.loadFailed,const DeepCollectionEquality().hash(_this.patients),_this.query,_this.isUpToDateExpanded);
}

@override
String toString() {
  final _this = this as PatientRosterState;
  return 'PatientRosterState(isLoading: ${_this.isLoading}, isOffline: ${_this.isOffline}, loadFailed: ${_this.loadFailed}, patients: ${_this.patients}, query: ${_this.query}, isUpToDateExpanded: ${_this.isUpToDateExpanded})';
}


}

/// @nodoc
abstract mixin class $PatientRosterStateCopyWith<$Res>  {
  factory $PatientRosterStateCopyWith(PatientRosterState value, $Res Function(PatientRosterState) _then) = _$PatientRosterStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isOffline, bool loadFailed, List<RosterItem>? patients, String query, bool isUpToDateExpanded
});




}
/// @nodoc
class _$PatientRosterStateCopyWithImpl<$Res>
    implements $PatientRosterStateCopyWith<$Res> {
  _$PatientRosterStateCopyWithImpl(this._self, this._then);

  final PatientRosterState _self;
  final $Res Function(PatientRosterState) _then;

/// Create a copy of PatientRosterState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isOffline = null,Object? loadFailed = null,Object? patients = freezed,Object? query = null,Object? isUpToDateExpanded = null,}) {
  return _then(PatientRosterState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,loadFailed: null == loadFailed ? _self.loadFailed : loadFailed // ignore: cast_nullable_to_non_nullable
as bool,patients: freezed == patients ? _self.patients : patients // ignore: cast_nullable_to_non_nullable
as List<RosterItem>?,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,isUpToDateExpanded: null == isUpToDateExpanded ? _self.isUpToDateExpanded : isUpToDateExpanded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PatientRosterState].
extension PatientRosterStatePatterns on PatientRosterState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PatientRosterState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PatientRosterState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PatientRosterState value)  $default,){
final _that = this;
switch (_that) {
case _PatientRosterState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PatientRosterState value)?  $default,){
final _that = this;
switch (_that) {
case _PatientRosterState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isOffline,  bool loadFailed,  List<RosterItem>? patients,  String query,  bool isUpToDateExpanded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PatientRosterState() when $default != null:
return $default(_that.isLoading,_that.isOffline,_that.loadFailed,_that.patients,_that.query,_that.isUpToDateExpanded);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isOffline,  bool loadFailed,  List<RosterItem>? patients,  String query,  bool isUpToDateExpanded)  $default,) {final _that = this;
switch (_that) {
case _PatientRosterState():
return $default(_that.isLoading,_that.isOffline,_that.loadFailed,_that.patients,_that.query,_that.isUpToDateExpanded);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isOffline,  bool loadFailed,  List<RosterItem>? patients,  String query,  bool isUpToDateExpanded)?  $default,) {final _that = this;
switch (_that) {
case _PatientRosterState() when $default != null:
return $default(_that.isLoading,_that.isOffline,_that.loadFailed,_that.patients,_that.query,_that.isUpToDateExpanded);case _:
  return null;

}
}

}

/// @nodoc


class _PatientRosterState extends PatientRosterState {
  const _PatientRosterState({this.isLoading = true, this.isOffline = false, this.loadFailed = false,  List<RosterItem>? patients, this.query = '', this.isUpToDateExpanded = false}): _patients = patients,super._();
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isOffline;
@override@JsonKey() final  bool loadFailed;
 final  List<RosterItem>? _patients;
@override List<RosterItem>? get patients {
  final value = _patients;
  if (value == null) return null;
  if (_patients is EqualUnmodifiableListView) return _patients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  String query;
@override@JsonKey() final  bool isUpToDateExpanded;

/// Create a copy of PatientRosterState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PatientRosterStateCopyWith<_PatientRosterState> get copyWith => __$PatientRosterStateCopyWithImpl<_PatientRosterState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PatientRosterState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline)&&(identical(other.loadFailed, loadFailed) || other.loadFailed == loadFailed)&&const DeepCollectionEquality().equals(other.patients, _patients)&&(identical(other.query, query) || other.query == query)&&(identical(other.isUpToDateExpanded, isUpToDateExpanded) || other.isUpToDateExpanded == isUpToDateExpanded));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,isOffline,loadFailed,const DeepCollectionEquality().hash(_patients),query,isUpToDateExpanded);
}

@override
String toString() {
    return 'PatientRosterState(isLoading: $isLoading, isOffline: $isOffline, loadFailed: $loadFailed, patients: $patients, query: $query, isUpToDateExpanded: $isUpToDateExpanded)';
}


}

/// @nodoc
abstract mixin class _$PatientRosterStateCopyWith<$Res> implements $PatientRosterStateCopyWith<$Res> {
  factory _$PatientRosterStateCopyWith(_PatientRosterState value, $Res Function(_PatientRosterState) _then) = __$PatientRosterStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isOffline, bool loadFailed, List<RosterItem>? patients, String query, bool isUpToDateExpanded
});




}
/// @nodoc
class __$PatientRosterStateCopyWithImpl<$Res>
    implements _$PatientRosterStateCopyWith<$Res> {
  __$PatientRosterStateCopyWithImpl(this._self, this._then);

  final _PatientRosterState _self;
  final $Res Function(_PatientRosterState) _then;

/// Create a copy of PatientRosterState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isOffline = null,Object? loadFailed = null,Object? patients = freezed,Object? query = null,Object? isUpToDateExpanded = null,}) {
  return _then(_PatientRosterState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,loadFailed: null == loadFailed ? _self.loadFailed : loadFailed // ignore: cast_nullable_to_non_nullable
as bool,patients: freezed == patients ? _self._patients : patients // ignore: cast_nullable_to_non_nullable
as List<RosterItem>?,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,isUpToDateExpanded: null == isUpToDateExpanded ? _self.isUpToDateExpanded : isUpToDateExpanded // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
