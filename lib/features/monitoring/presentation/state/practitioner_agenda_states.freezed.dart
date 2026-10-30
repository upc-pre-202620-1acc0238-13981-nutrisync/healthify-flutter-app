// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'practitioner_agenda_states.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AgendaRow {

 int get followUpId; int get patientId; String? get patientName; DateTime get scheduledFor; Set<PreparationCode> get preparation;
/// Create a copy of AgendaRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgendaRowCopyWith<AgendaRow> get copyWith => _$AgendaRowCopyWithImpl<AgendaRow>(this as AgendaRow, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AgendaRow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgendaRow&&(identical(other.followUpId, _this.followUpId) || other.followUpId == _this.followUpId)&&(identical(other.patientId, _this.patientId) || other.patientId == _this.patientId)&&(identical(other.patientName, _this.patientName) || other.patientName == _this.patientName)&&(identical(other.scheduledFor, _this.scheduledFor) || other.scheduledFor == _this.scheduledFor)&&const DeepCollectionEquality().equals(other.preparation, _this.preparation));
}


@override
int get hashCode {
  final _this = this as AgendaRow;
  return Object.hash(runtimeType,_this.followUpId,_this.patientId,_this.patientName,_this.scheduledFor,const DeepCollectionEquality().hash(_this.preparation));
}

@override
String toString() {
  final _this = this as AgendaRow;
  return 'AgendaRow(followUpId: ${_this.followUpId}, patientId: ${_this.patientId}, patientName: ${_this.patientName}, scheduledFor: ${_this.scheduledFor}, preparation: ${_this.preparation})';
}


}

/// @nodoc
abstract mixin class $AgendaRowCopyWith<$Res>  {
  factory $AgendaRowCopyWith(AgendaRow value, $Res Function(AgendaRow) _then) = _$AgendaRowCopyWithImpl;
@useResult
$Res call({
 int followUpId, int patientId, String? patientName, DateTime scheduledFor, Set<PreparationCode> preparation
});




}
/// @nodoc
class _$AgendaRowCopyWithImpl<$Res>
    implements $AgendaRowCopyWith<$Res> {
  _$AgendaRowCopyWithImpl(this._self, this._then);

  final AgendaRow _self;
  final $Res Function(AgendaRow) _then;

/// Create a copy of AgendaRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? followUpId = null,Object? patientId = null,Object? patientName = freezed,Object? scheduledFor = null,Object? preparation = null,}) {
  return _then(AgendaRow(
followUpId: null == followUpId ? _self.followUpId : followUpId // ignore: cast_nullable_to_non_nullable
as int,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as int,patientName: freezed == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String?,scheduledFor: null == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as DateTime,preparation: null == preparation ? _self.preparation : preparation // ignore: cast_nullable_to_non_nullable
as Set<PreparationCode>,
  ));
}

}


/// Adds pattern-matching-related methods to [AgendaRow].
extension AgendaRowPatterns on AgendaRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgendaRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgendaRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgendaRow value)  $default,){
final _that = this;
switch (_that) {
case _AgendaRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgendaRow value)?  $default,){
final _that = this;
switch (_that) {
case _AgendaRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int followUpId,  int patientId,  String? patientName,  DateTime scheduledFor,  Set<PreparationCode> preparation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgendaRow() when $default != null:
return $default(_that.followUpId,_that.patientId,_that.patientName,_that.scheduledFor,_that.preparation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int followUpId,  int patientId,  String? patientName,  DateTime scheduledFor,  Set<PreparationCode> preparation)  $default,) {final _that = this;
switch (_that) {
case _AgendaRow():
return $default(_that.followUpId,_that.patientId,_that.patientName,_that.scheduledFor,_that.preparation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int followUpId,  int patientId,  String? patientName,  DateTime scheduledFor,  Set<PreparationCode> preparation)?  $default,) {final _that = this;
switch (_that) {
case _AgendaRow() when $default != null:
return $default(_that.followUpId,_that.patientId,_that.patientName,_that.scheduledFor,_that.preparation);case _:
  return null;

}
}

}

/// @nodoc


class _AgendaRow implements AgendaRow {
  const _AgendaRow({required this.followUpId, required this.patientId, required this.patientName, required this.scheduledFor, required  Set<PreparationCode> preparation}): _preparation = preparation;
  

@override final  int followUpId;
@override final  int patientId;
@override final  String? patientName;
@override final  DateTime scheduledFor;
 final  Set<PreparationCode> _preparation;
@override Set<PreparationCode> get preparation {
  if (_preparation is EqualUnmodifiableSetView) return _preparation;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_preparation);
}


/// Create a copy of AgendaRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgendaRowCopyWith<_AgendaRow> get copyWith => __$AgendaRowCopyWithImpl<_AgendaRow>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgendaRow&&(identical(other.followUpId, followUpId) || other.followUpId == followUpId)&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.patientName, patientName) || other.patientName == patientName)&&(identical(other.scheduledFor, scheduledFor) || other.scheduledFor == scheduledFor)&&const DeepCollectionEquality().equals(other.preparation, _preparation));
}


@override
int get hashCode {
    return Object.hash(runtimeType,followUpId,patientId,patientName,scheduledFor,const DeepCollectionEquality().hash(_preparation));
}

@override
String toString() {
    return 'AgendaRow(followUpId: $followUpId, patientId: $patientId, patientName: $patientName, scheduledFor: $scheduledFor, preparation: $preparation)';
}


}

/// @nodoc
abstract mixin class _$AgendaRowCopyWith<$Res> implements $AgendaRowCopyWith<$Res> {
  factory _$AgendaRowCopyWith(_AgendaRow value, $Res Function(_AgendaRow) _then) = __$AgendaRowCopyWithImpl;
@override @useResult
$Res call({
 int followUpId, int patientId, String? patientName, DateTime scheduledFor, Set<PreparationCode> preparation
});




}
/// @nodoc
class __$AgendaRowCopyWithImpl<$Res>
    implements _$AgendaRowCopyWith<$Res> {
  __$AgendaRowCopyWithImpl(this._self, this._then);

  final _AgendaRow _self;
  final $Res Function(_AgendaRow) _then;

/// Create a copy of AgendaRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? followUpId = null,Object? patientId = null,Object? patientName = freezed,Object? scheduledFor = null,Object? preparation = null,}) {
  return _then(_AgendaRow(
followUpId: null == followUpId ? _self.followUpId : followUpId // ignore: cast_nullable_to_non_nullable
as int,patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as int,patientName: freezed == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String?,scheduledFor: null == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as DateTime,preparation: null == preparation ? _self._preparation : preparation // ignore: cast_nullable_to_non_nullable
as Set<PreparationCode>,
  ));
}


}

/// @nodoc
mixin _$AgendaState {

 bool get isLoading; bool get isOffline; bool get loadFailed; List<AgendaRow>? get visits;/// Tapped visit: sheet with "Reschedule", "View patient" and "Cancel visit".
 AgendaRow? get selected; AgendaDialog? get dialog; bool get isCancelling; bool get isOpeningPatient;
/// Create a copy of AgendaState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgendaStateCopyWith<AgendaState> get copyWith => _$AgendaStateCopyWithImpl<AgendaState>(this as AgendaState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AgendaState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgendaState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isOffline, _this.isOffline) || other.isOffline == _this.isOffline)&&(identical(other.loadFailed, _this.loadFailed) || other.loadFailed == _this.loadFailed)&&const DeepCollectionEquality().equals(other.visits, _this.visits)&&(identical(other.selected, _this.selected) || other.selected == _this.selected)&&(identical(other.dialog, _this.dialog) || other.dialog == _this.dialog)&&(identical(other.isCancelling, _this.isCancelling) || other.isCancelling == _this.isCancelling)&&(identical(other.isOpeningPatient, _this.isOpeningPatient) || other.isOpeningPatient == _this.isOpeningPatient));
}


@override
int get hashCode {
  final _this = this as AgendaState;
  return Object.hash(runtimeType,_this.isLoading,_this.isOffline,_this.loadFailed,const DeepCollectionEquality().hash(_this.visits),_this.selected,_this.dialog,_this.isCancelling,_this.isOpeningPatient);
}

@override
String toString() {
  final _this = this as AgendaState;
  return 'AgendaState(isLoading: ${_this.isLoading}, isOffline: ${_this.isOffline}, loadFailed: ${_this.loadFailed}, visits: ${_this.visits}, selected: ${_this.selected}, dialog: ${_this.dialog}, isCancelling: ${_this.isCancelling}, isOpeningPatient: ${_this.isOpeningPatient})';
}


}

/// @nodoc
abstract mixin class $AgendaStateCopyWith<$Res>  {
  factory $AgendaStateCopyWith(AgendaState value, $Res Function(AgendaState) _then) = _$AgendaStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isOffline, bool loadFailed, List<AgendaRow>? visits, AgendaRow? selected, AgendaDialog? dialog, bool isCancelling, bool isOpeningPatient
});


$AgendaRowCopyWith<$Res>? get selected;

}
/// @nodoc
class _$AgendaStateCopyWithImpl<$Res>
    implements $AgendaStateCopyWith<$Res> {
  _$AgendaStateCopyWithImpl(this._self, this._then);

  final AgendaState _self;
  final $Res Function(AgendaState) _then;

/// Create a copy of AgendaState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isOffline = null,Object? loadFailed = null,Object? visits = freezed,Object? selected = freezed,Object? dialog = freezed,Object? isCancelling = null,Object? isOpeningPatient = null,}) {
  return _then(AgendaState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,loadFailed: null == loadFailed ? _self.loadFailed : loadFailed // ignore: cast_nullable_to_non_nullable
as bool,visits: freezed == visits ? _self.visits : visits // ignore: cast_nullable_to_non_nullable
as List<AgendaRow>?,selected: freezed == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as AgendaRow?,dialog: freezed == dialog ? _self.dialog : dialog // ignore: cast_nullable_to_non_nullable
as AgendaDialog?,isCancelling: null == isCancelling ? _self.isCancelling : isCancelling // ignore: cast_nullable_to_non_nullable
as bool,isOpeningPatient: null == isOpeningPatient ? _self.isOpeningPatient : isOpeningPatient // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of AgendaState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AgendaRowCopyWith<$Res>? get selected {
    if (_self.selected == null) {
    return null;
  }

  return $AgendaRowCopyWith<$Res>(_self.selected!, (value) {
    return _then(_self.copyWith(selected: value));
  });
}
}


/// Adds pattern-matching-related methods to [AgendaState].
extension AgendaStatePatterns on AgendaState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgendaState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgendaState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgendaState value)  $default,){
final _that = this;
switch (_that) {
case _AgendaState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgendaState value)?  $default,){
final _that = this;
switch (_that) {
case _AgendaState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isOffline,  bool loadFailed,  List<AgendaRow>? visits,  AgendaRow? selected,  AgendaDialog? dialog,  bool isCancelling,  bool isOpeningPatient)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgendaState() when $default != null:
return $default(_that.isLoading,_that.isOffline,_that.loadFailed,_that.visits,_that.selected,_that.dialog,_that.isCancelling,_that.isOpeningPatient);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isOffline,  bool loadFailed,  List<AgendaRow>? visits,  AgendaRow? selected,  AgendaDialog? dialog,  bool isCancelling,  bool isOpeningPatient)  $default,) {final _that = this;
switch (_that) {
case _AgendaState():
return $default(_that.isLoading,_that.isOffline,_that.loadFailed,_that.visits,_that.selected,_that.dialog,_that.isCancelling,_that.isOpeningPatient);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isOffline,  bool loadFailed,  List<AgendaRow>? visits,  AgendaRow? selected,  AgendaDialog? dialog,  bool isCancelling,  bool isOpeningPatient)?  $default,) {final _that = this;
switch (_that) {
case _AgendaState() when $default != null:
return $default(_that.isLoading,_that.isOffline,_that.loadFailed,_that.visits,_that.selected,_that.dialog,_that.isCancelling,_that.isOpeningPatient);case _:
  return null;

}
}

}

/// @nodoc


class _AgendaState extends AgendaState {
  const _AgendaState({this.isLoading = true, this.isOffline = false, this.loadFailed = false,  List<AgendaRow>? visits, this.selected, this.dialog, this.isCancelling = false, this.isOpeningPatient = false}): _visits = visits,super._();
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isOffline;
@override@JsonKey() final  bool loadFailed;
 final  List<AgendaRow>? _visits;
@override List<AgendaRow>? get visits {
  final value = _visits;
  if (value == null) return null;
  if (_visits is EqualUnmodifiableListView) return _visits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

/// Tapped visit: sheet with "Reschedule", "View patient" and "Cancel visit".
@override final  AgendaRow? selected;
@override final  AgendaDialog? dialog;
@override@JsonKey() final  bool isCancelling;
@override@JsonKey() final  bool isOpeningPatient;

/// Create a copy of AgendaState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgendaStateCopyWith<_AgendaState> get copyWith => __$AgendaStateCopyWithImpl<_AgendaState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgendaState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline)&&(identical(other.loadFailed, loadFailed) || other.loadFailed == loadFailed)&&const DeepCollectionEquality().equals(other.visits, _visits)&&(identical(other.selected, selected) || other.selected == selected)&&(identical(other.dialog, dialog) || other.dialog == dialog)&&(identical(other.isCancelling, isCancelling) || other.isCancelling == isCancelling)&&(identical(other.isOpeningPatient, isOpeningPatient) || other.isOpeningPatient == isOpeningPatient));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,isOffline,loadFailed,const DeepCollectionEquality().hash(_visits),selected,dialog,isCancelling,isOpeningPatient);
}

@override
String toString() {
    return 'AgendaState(isLoading: $isLoading, isOffline: $isOffline, loadFailed: $loadFailed, visits: $visits, selected: $selected, dialog: $dialog, isCancelling: $isCancelling, isOpeningPatient: $isOpeningPatient)';
}


}

/// @nodoc
abstract mixin class _$AgendaStateCopyWith<$Res> implements $AgendaStateCopyWith<$Res> {
  factory _$AgendaStateCopyWith(_AgendaState value, $Res Function(_AgendaState) _then) = __$AgendaStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isOffline, bool loadFailed, List<AgendaRow>? visits, AgendaRow? selected, AgendaDialog? dialog, bool isCancelling, bool isOpeningPatient
});


@override $AgendaRowCopyWith<$Res>? get selected;

}
/// @nodoc
class __$AgendaStateCopyWithImpl<$Res>
    implements _$AgendaStateCopyWith<$Res> {
  __$AgendaStateCopyWithImpl(this._self, this._then);

  final _AgendaState _self;
  final $Res Function(_AgendaState) _then;

/// Create a copy of AgendaState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isOffline = null,Object? loadFailed = null,Object? visits = freezed,Object? selected = freezed,Object? dialog = freezed,Object? isCancelling = null,Object? isOpeningPatient = null,}) {
  return _then(_AgendaState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,loadFailed: null == loadFailed ? _self.loadFailed : loadFailed // ignore: cast_nullable_to_non_nullable
as bool,visits: freezed == visits ? _self._visits : visits // ignore: cast_nullable_to_non_nullable
as List<AgendaRow>?,selected: freezed == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as AgendaRow?,dialog: freezed == dialog ? _self.dialog : dialog // ignore: cast_nullable_to_non_nullable
as AgendaDialog?,isCancelling: null == isCancelling ? _self.isCancelling : isCancelling // ignore: cast_nullable_to_non_nullable
as bool,isOpeningPatient: null == isOpeningPatient ? _self.isOpeningPatient : isOpeningPatient // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of AgendaState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AgendaRowCopyWith<$Res>? get selected {
    if (_self.selected == null) {
    return null;
  }

  return $AgendaRowCopyWith<$Res>(_self.selected!, (value) {
    return _then(_self.copyWith(selected: value));
  });
}
}

/// @nodoc
mixin _$PatientOption {

 int get patientId; String get fullName;
/// Create a copy of PatientOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PatientOptionCopyWith<PatientOption> get copyWith => _$PatientOptionCopyWithImpl<PatientOption>(this as PatientOption, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PatientOption;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PatientOption&&(identical(other.patientId, _this.patientId) || other.patientId == _this.patientId)&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName));
}


@override
int get hashCode {
  final _this = this as PatientOption;
  return Object.hash(runtimeType,_this.patientId,_this.fullName);
}

@override
String toString() {
  final _this = this as PatientOption;
  return 'PatientOption(patientId: ${_this.patientId}, fullName: ${_this.fullName})';
}


}

/// @nodoc
abstract mixin class $PatientOptionCopyWith<$Res>  {
  factory $PatientOptionCopyWith(PatientOption value, $Res Function(PatientOption) _then) = _$PatientOptionCopyWithImpl;
@useResult
$Res call({
 int patientId, String fullName
});




}
/// @nodoc
class _$PatientOptionCopyWithImpl<$Res>
    implements $PatientOptionCopyWith<$Res> {
  _$PatientOptionCopyWithImpl(this._self, this._then);

  final PatientOption _self;
  final $Res Function(PatientOption) _then;

/// Create a copy of PatientOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? patientId = null,Object? fullName = null,}) {
  return _then(PatientOption(
patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as int,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PatientOption].
extension PatientOptionPatterns on PatientOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PatientOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PatientOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PatientOption value)  $default,){
final _that = this;
switch (_that) {
case _PatientOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PatientOption value)?  $default,){
final _that = this;
switch (_that) {
case _PatientOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int patientId,  String fullName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PatientOption() when $default != null:
return $default(_that.patientId,_that.fullName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int patientId,  String fullName)  $default,) {final _that = this;
switch (_that) {
case _PatientOption():
return $default(_that.patientId,_that.fullName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int patientId,  String fullName)?  $default,) {final _that = this;
switch (_that) {
case _PatientOption() when $default != null:
return $default(_that.patientId,_that.fullName);case _:
  return null;

}
}

}

/// @nodoc


class _PatientOption implements PatientOption {
  const _PatientOption({required this.patientId, required this.fullName});
  

@override final  int patientId;
@override final  String fullName;

/// Create a copy of PatientOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PatientOptionCopyWith<_PatientOption> get copyWith => __$PatientOptionCopyWithImpl<_PatientOption>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PatientOption&&(identical(other.patientId, patientId) || other.patientId == patientId)&&(identical(other.fullName, fullName) || other.fullName == fullName));
}


@override
int get hashCode {
    return Object.hash(runtimeType,patientId,fullName);
}

@override
String toString() {
    return 'PatientOption(patientId: $patientId, fullName: $fullName)';
}


}

/// @nodoc
abstract mixin class _$PatientOptionCopyWith<$Res> implements $PatientOptionCopyWith<$Res> {
  factory _$PatientOptionCopyWith(_PatientOption value, $Res Function(_PatientOption) _then) = __$PatientOptionCopyWithImpl;
@override @useResult
$Res call({
 int patientId, String fullName
});




}
/// @nodoc
class __$PatientOptionCopyWithImpl<$Res>
    implements _$PatientOptionCopyWith<$Res> {
  __$PatientOptionCopyWithImpl(this._self, this._then);

  final _PatientOption _self;
  final $Res Function(_PatientOption) _then;

/// Create a copy of PatientOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? patientId = null,Object? fullName = null,}) {
  return _then(_PatientOption(
patientId: null == patientId ? _self.patientId : patientId // ignore: cast_nullable_to_non_nullable
as int,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ScheduleFollowUpState {

 PatientOption? get patient; bool get patientFixed; List<PatientOption>? get patients; bool get isLoadingPatients;/// Wall-clock date (time of day ignored) and time in the phone's time zone.
 DateTime? get date; TimeOfDay? get time; Set<PreparationCode> get preparation; SchedulePatientError? get patientError; ScheduleMomentError? get momentError; bool get isSaving; bool get failed; bool get isOffline; int? get rescheduleId;
/// Create a copy of ScheduleFollowUpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleFollowUpStateCopyWith<ScheduleFollowUpState> get copyWith => _$ScheduleFollowUpStateCopyWithImpl<ScheduleFollowUpState>(this as ScheduleFollowUpState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ScheduleFollowUpState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleFollowUpState&&(identical(other.patient, _this.patient) || other.patient == _this.patient)&&(identical(other.patientFixed, _this.patientFixed) || other.patientFixed == _this.patientFixed)&&const DeepCollectionEquality().equals(other.patients, _this.patients)&&(identical(other.isLoadingPatients, _this.isLoadingPatients) || other.isLoadingPatients == _this.isLoadingPatients)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.time, _this.time) || other.time == _this.time)&&const DeepCollectionEquality().equals(other.preparation, _this.preparation)&&(identical(other.patientError, _this.patientError) || other.patientError == _this.patientError)&&(identical(other.momentError, _this.momentError) || other.momentError == _this.momentError)&&(identical(other.isSaving, _this.isSaving) || other.isSaving == _this.isSaving)&&(identical(other.failed, _this.failed) || other.failed == _this.failed)&&(identical(other.isOffline, _this.isOffline) || other.isOffline == _this.isOffline)&&(identical(other.rescheduleId, _this.rescheduleId) || other.rescheduleId == _this.rescheduleId));
}


@override
int get hashCode {
  final _this = this as ScheduleFollowUpState;
  return Object.hash(runtimeType,_this.patient,_this.patientFixed,const DeepCollectionEquality().hash(_this.patients),_this.isLoadingPatients,_this.date,_this.time,const DeepCollectionEquality().hash(_this.preparation),_this.patientError,_this.momentError,_this.isSaving,_this.failed,_this.isOffline,_this.rescheduleId);
}

@override
String toString() {
  final _this = this as ScheduleFollowUpState;
  return 'ScheduleFollowUpState(patient: ${_this.patient}, patientFixed: ${_this.patientFixed}, patients: ${_this.patients}, isLoadingPatients: ${_this.isLoadingPatients}, date: ${_this.date}, time: ${_this.time}, preparation: ${_this.preparation}, patientError: ${_this.patientError}, momentError: ${_this.momentError}, isSaving: ${_this.isSaving}, failed: ${_this.failed}, isOffline: ${_this.isOffline}, rescheduleId: ${_this.rescheduleId})';
}


}

/// @nodoc
abstract mixin class $ScheduleFollowUpStateCopyWith<$Res>  {
  factory $ScheduleFollowUpStateCopyWith(ScheduleFollowUpState value, $Res Function(ScheduleFollowUpState) _then) = _$ScheduleFollowUpStateCopyWithImpl;
@useResult
$Res call({
 PatientOption? patient, bool patientFixed, List<PatientOption>? patients, bool isLoadingPatients, DateTime? date, TimeOfDay? time, Set<PreparationCode> preparation, SchedulePatientError? patientError, ScheduleMomentError? momentError, bool isSaving, bool failed, bool isOffline, int? rescheduleId
});


$PatientOptionCopyWith<$Res>? get patient;

}
/// @nodoc
class _$ScheduleFollowUpStateCopyWithImpl<$Res>
    implements $ScheduleFollowUpStateCopyWith<$Res> {
  _$ScheduleFollowUpStateCopyWithImpl(this._self, this._then);

  final ScheduleFollowUpState _self;
  final $Res Function(ScheduleFollowUpState) _then;

/// Create a copy of ScheduleFollowUpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? patient = freezed,Object? patientFixed = null,Object? patients = freezed,Object? isLoadingPatients = null,Object? date = freezed,Object? time = freezed,Object? preparation = null,Object? patientError = freezed,Object? momentError = freezed,Object? isSaving = null,Object? failed = null,Object? isOffline = null,Object? rescheduleId = freezed,}) {
  return _then(ScheduleFollowUpState(
patient: freezed == patient ? _self.patient : patient // ignore: cast_nullable_to_non_nullable
as PatientOption?,patientFixed: null == patientFixed ? _self.patientFixed : patientFixed // ignore: cast_nullable_to_non_nullable
as bool,patients: freezed == patients ? _self.patients : patients // ignore: cast_nullable_to_non_nullable
as List<PatientOption>?,isLoadingPatients: null == isLoadingPatients ? _self.isLoadingPatients : isLoadingPatients // ignore: cast_nullable_to_non_nullable
as bool,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,preparation: null == preparation ? _self.preparation : preparation // ignore: cast_nullable_to_non_nullable
as Set<PreparationCode>,patientError: freezed == patientError ? _self.patientError : patientError // ignore: cast_nullable_to_non_nullable
as SchedulePatientError?,momentError: freezed == momentError ? _self.momentError : momentError // ignore: cast_nullable_to_non_nullable
as ScheduleMomentError?,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,rescheduleId: freezed == rescheduleId ? _self.rescheduleId : rescheduleId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}
/// Create a copy of ScheduleFollowUpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PatientOptionCopyWith<$Res>? get patient {
    if (_self.patient == null) {
    return null;
  }

  return $PatientOptionCopyWith<$Res>(_self.patient!, (value) {
    return _then(_self.copyWith(patient: value));
  });
}
}


/// Adds pattern-matching-related methods to [ScheduleFollowUpState].
extension ScheduleFollowUpStatePatterns on ScheduleFollowUpState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleFollowUpState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleFollowUpState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleFollowUpState value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleFollowUpState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleFollowUpState value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleFollowUpState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PatientOption? patient,  bool patientFixed,  List<PatientOption>? patients,  bool isLoadingPatients,  DateTime? date,  TimeOfDay? time,  Set<PreparationCode> preparation,  SchedulePatientError? patientError,  ScheduleMomentError? momentError,  bool isSaving,  bool failed,  bool isOffline,  int? rescheduleId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleFollowUpState() when $default != null:
return $default(_that.patient,_that.patientFixed,_that.patients,_that.isLoadingPatients,_that.date,_that.time,_that.preparation,_that.patientError,_that.momentError,_that.isSaving,_that.failed,_that.isOffline,_that.rescheduleId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PatientOption? patient,  bool patientFixed,  List<PatientOption>? patients,  bool isLoadingPatients,  DateTime? date,  TimeOfDay? time,  Set<PreparationCode> preparation,  SchedulePatientError? patientError,  ScheduleMomentError? momentError,  bool isSaving,  bool failed,  bool isOffline,  int? rescheduleId)  $default,) {final _that = this;
switch (_that) {
case _ScheduleFollowUpState():
return $default(_that.patient,_that.patientFixed,_that.patients,_that.isLoadingPatients,_that.date,_that.time,_that.preparation,_that.patientError,_that.momentError,_that.isSaving,_that.failed,_that.isOffline,_that.rescheduleId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PatientOption? patient,  bool patientFixed,  List<PatientOption>? patients,  bool isLoadingPatients,  DateTime? date,  TimeOfDay? time,  Set<PreparationCode> preparation,  SchedulePatientError? patientError,  ScheduleMomentError? momentError,  bool isSaving,  bool failed,  bool isOffline,  int? rescheduleId)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleFollowUpState() when $default != null:
return $default(_that.patient,_that.patientFixed,_that.patients,_that.isLoadingPatients,_that.date,_that.time,_that.preparation,_that.patientError,_that.momentError,_that.isSaving,_that.failed,_that.isOffline,_that.rescheduleId);case _:
  return null;

}
}

}

/// @nodoc


class _ScheduleFollowUpState extends ScheduleFollowUpState {
  const _ScheduleFollowUpState({this.patient, this.patientFixed = false,  List<PatientOption>? patients, this.isLoadingPatients = false, this.date, this.time,  Set<PreparationCode> preparation = const <PreparationCode>{}, this.patientError, this.momentError, this.isSaving = false, this.failed = false, this.isOffline = false, this.rescheduleId}): _patients = patients,_preparation = preparation,super._();
  

@override final  PatientOption? patient;
@override@JsonKey() final  bool patientFixed;
 final  List<PatientOption>? _patients;
@override List<PatientOption>? get patients {
  final value = _patients;
  if (value == null) return null;
  if (_patients is EqualUnmodifiableListView) return _patients;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  bool isLoadingPatients;
/// Wall-clock date (time of day ignored) and time in the phone's time zone.
@override final  DateTime? date;
@override final  TimeOfDay? time;
 final  Set<PreparationCode> _preparation;
@override@JsonKey() Set<PreparationCode> get preparation {
  if (_preparation is EqualUnmodifiableSetView) return _preparation;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_preparation);
}

@override final  SchedulePatientError? patientError;
@override final  ScheduleMomentError? momentError;
@override@JsonKey() final  bool isSaving;
@override@JsonKey() final  bool failed;
@override@JsonKey() final  bool isOffline;
@override final  int? rescheduleId;

/// Create a copy of ScheduleFollowUpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleFollowUpStateCopyWith<_ScheduleFollowUpState> get copyWith => __$ScheduleFollowUpStateCopyWithImpl<_ScheduleFollowUpState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleFollowUpState&&(identical(other.patient, patient) || other.patient == patient)&&(identical(other.patientFixed, patientFixed) || other.patientFixed == patientFixed)&&const DeepCollectionEquality().equals(other.patients, _patients)&&(identical(other.isLoadingPatients, isLoadingPatients) || other.isLoadingPatients == isLoadingPatients)&&(identical(other.date, date) || other.date == date)&&(identical(other.time, time) || other.time == time)&&const DeepCollectionEquality().equals(other.preparation, _preparation)&&(identical(other.patientError, patientError) || other.patientError == patientError)&&(identical(other.momentError, momentError) || other.momentError == momentError)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.failed, failed) || other.failed == failed)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline)&&(identical(other.rescheduleId, rescheduleId) || other.rescheduleId == rescheduleId));
}


@override
int get hashCode {
    return Object.hash(runtimeType,patient,patientFixed,const DeepCollectionEquality().hash(_patients),isLoadingPatients,date,time,const DeepCollectionEquality().hash(_preparation),patientError,momentError,isSaving,failed,isOffline,rescheduleId);
}

@override
String toString() {
    return 'ScheduleFollowUpState(patient: $patient, patientFixed: $patientFixed, patients: $patients, isLoadingPatients: $isLoadingPatients, date: $date, time: $time, preparation: $preparation, patientError: $patientError, momentError: $momentError, isSaving: $isSaving, failed: $failed, isOffline: $isOffline, rescheduleId: $rescheduleId)';
}


}

/// @nodoc
abstract mixin class _$ScheduleFollowUpStateCopyWith<$Res> implements $ScheduleFollowUpStateCopyWith<$Res> {
  factory _$ScheduleFollowUpStateCopyWith(_ScheduleFollowUpState value, $Res Function(_ScheduleFollowUpState) _then) = __$ScheduleFollowUpStateCopyWithImpl;
@override @useResult
$Res call({
 PatientOption? patient, bool patientFixed, List<PatientOption>? patients, bool isLoadingPatients, DateTime? date, TimeOfDay? time, Set<PreparationCode> preparation, SchedulePatientError? patientError, ScheduleMomentError? momentError, bool isSaving, bool failed, bool isOffline, int? rescheduleId
});


@override $PatientOptionCopyWith<$Res>? get patient;

}
/// @nodoc
class __$ScheduleFollowUpStateCopyWithImpl<$Res>
    implements _$ScheduleFollowUpStateCopyWith<$Res> {
  __$ScheduleFollowUpStateCopyWithImpl(this._self, this._then);

  final _ScheduleFollowUpState _self;
  final $Res Function(_ScheduleFollowUpState) _then;

/// Create a copy of ScheduleFollowUpState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? patient = freezed,Object? patientFixed = null,Object? patients = freezed,Object? isLoadingPatients = null,Object? date = freezed,Object? time = freezed,Object? preparation = null,Object? patientError = freezed,Object? momentError = freezed,Object? isSaving = null,Object? failed = null,Object? isOffline = null,Object? rescheduleId = freezed,}) {
  return _then(_ScheduleFollowUpState(
patient: freezed == patient ? _self.patient : patient // ignore: cast_nullable_to_non_nullable
as PatientOption?,patientFixed: null == patientFixed ? _self.patientFixed : patientFixed // ignore: cast_nullable_to_non_nullable
as bool,patients: freezed == patients ? _self._patients : patients // ignore: cast_nullable_to_non_nullable
as List<PatientOption>?,isLoadingPatients: null == isLoadingPatients ? _self.isLoadingPatients : isLoadingPatients // ignore: cast_nullable_to_non_nullable
as bool,date: freezed == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime?,time: freezed == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as TimeOfDay?,preparation: null == preparation ? _self._preparation : preparation // ignore: cast_nullable_to_non_nullable
as Set<PreparationCode>,patientError: freezed == patientError ? _self.patientError : patientError // ignore: cast_nullable_to_non_nullable
as SchedulePatientError?,momentError: freezed == momentError ? _self.momentError : momentError // ignore: cast_nullable_to_non_nullable
as ScheduleMomentError?,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,rescheduleId: freezed == rescheduleId ? _self.rescheduleId : rescheduleId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of ScheduleFollowUpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PatientOptionCopyWith<$Res>? get patient {
    if (_self.patient == null) {
    return null;
  }

  return $PatientOptionCopyWith<$Res>(_self.patient!, (value) {
    return _then(_self.copyWith(patient: value));
  });
}
}

/// @nodoc
mixin _$RecordReferralState {

 String get specialty; String get reason; Set<ReferralField> get missing; bool get isSaving; bool get failed; bool get noActiveLink; bool get isOffline;
/// Create a copy of RecordReferralState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecordReferralStateCopyWith<RecordReferralState> get copyWith => _$RecordReferralStateCopyWithImpl<RecordReferralState>(this as RecordReferralState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RecordReferralState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecordReferralState&&(identical(other.specialty, _this.specialty) || other.specialty == _this.specialty)&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&const DeepCollectionEquality().equals(other.missing, _this.missing)&&(identical(other.isSaving, _this.isSaving) || other.isSaving == _this.isSaving)&&(identical(other.failed, _this.failed) || other.failed == _this.failed)&&(identical(other.noActiveLink, _this.noActiveLink) || other.noActiveLink == _this.noActiveLink)&&(identical(other.isOffline, _this.isOffline) || other.isOffline == _this.isOffline));
}


@override
int get hashCode {
  final _this = this as RecordReferralState;
  return Object.hash(runtimeType,_this.specialty,_this.reason,const DeepCollectionEquality().hash(_this.missing),_this.isSaving,_this.failed,_this.noActiveLink,_this.isOffline);
}

@override
String toString() {
  final _this = this as RecordReferralState;
  return 'RecordReferralState(specialty: ${_this.specialty}, reason: ${_this.reason}, missing: ${_this.missing}, isSaving: ${_this.isSaving}, failed: ${_this.failed}, noActiveLink: ${_this.noActiveLink}, isOffline: ${_this.isOffline})';
}


}

/// @nodoc
abstract mixin class $RecordReferralStateCopyWith<$Res>  {
  factory $RecordReferralStateCopyWith(RecordReferralState value, $Res Function(RecordReferralState) _then) = _$RecordReferralStateCopyWithImpl;
@useResult
$Res call({
 String specialty, String reason, Set<ReferralField> missing, bool isSaving, bool failed, bool noActiveLink, bool isOffline
});




}
/// @nodoc
class _$RecordReferralStateCopyWithImpl<$Res>
    implements $RecordReferralStateCopyWith<$Res> {
  _$RecordReferralStateCopyWithImpl(this._self, this._then);

  final RecordReferralState _self;
  final $Res Function(RecordReferralState) _then;

/// Create a copy of RecordReferralState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? specialty = null,Object? reason = null,Object? missing = null,Object? isSaving = null,Object? failed = null,Object? noActiveLink = null,Object? isOffline = null,}) {
  return _then(RecordReferralState(
specialty: null == specialty ? _self.specialty : specialty // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,missing: null == missing ? _self.missing : missing // ignore: cast_nullable_to_non_nullable
as Set<ReferralField>,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,noActiveLink: null == noActiveLink ? _self.noActiveLink : noActiveLink // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [RecordReferralState].
extension RecordReferralStatePatterns on RecordReferralState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecordReferralState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecordReferralState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecordReferralState value)  $default,){
final _that = this;
switch (_that) {
case _RecordReferralState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecordReferralState value)?  $default,){
final _that = this;
switch (_that) {
case _RecordReferralState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String specialty,  String reason,  Set<ReferralField> missing,  bool isSaving,  bool failed,  bool noActiveLink,  bool isOffline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecordReferralState() when $default != null:
return $default(_that.specialty,_that.reason,_that.missing,_that.isSaving,_that.failed,_that.noActiveLink,_that.isOffline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String specialty,  String reason,  Set<ReferralField> missing,  bool isSaving,  bool failed,  bool noActiveLink,  bool isOffline)  $default,) {final _that = this;
switch (_that) {
case _RecordReferralState():
return $default(_that.specialty,_that.reason,_that.missing,_that.isSaving,_that.failed,_that.noActiveLink,_that.isOffline);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String specialty,  String reason,  Set<ReferralField> missing,  bool isSaving,  bool failed,  bool noActiveLink,  bool isOffline)?  $default,) {final _that = this;
switch (_that) {
case _RecordReferralState() when $default != null:
return $default(_that.specialty,_that.reason,_that.missing,_that.isSaving,_that.failed,_that.noActiveLink,_that.isOffline);case _:
  return null;

}
}

}

/// @nodoc


class _RecordReferralState implements RecordReferralState {
  const _RecordReferralState({this.specialty = '', this.reason = '',  Set<ReferralField> missing = const <ReferralField>{}, this.isSaving = false, this.failed = false, this.noActiveLink = false, this.isOffline = false}): _missing = missing;
  

@override@JsonKey() final  String specialty;
@override@JsonKey() final  String reason;
 final  Set<ReferralField> _missing;
@override@JsonKey() Set<ReferralField> get missing {
  if (_missing is EqualUnmodifiableSetView) return _missing;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_missing);
}

@override@JsonKey() final  bool isSaving;
@override@JsonKey() final  bool failed;
@override@JsonKey() final  bool noActiveLink;
@override@JsonKey() final  bool isOffline;

/// Create a copy of RecordReferralState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecordReferralStateCopyWith<_RecordReferralState> get copyWith => __$RecordReferralStateCopyWithImpl<_RecordReferralState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecordReferralState&&(identical(other.specialty, specialty) || other.specialty == specialty)&&(identical(other.reason, reason) || other.reason == reason)&&const DeepCollectionEquality().equals(other.missing, _missing)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.failed, failed) || other.failed == failed)&&(identical(other.noActiveLink, noActiveLink) || other.noActiveLink == noActiveLink)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline));
}


@override
int get hashCode {
    return Object.hash(runtimeType,specialty,reason,const DeepCollectionEquality().hash(_missing),isSaving,failed,noActiveLink,isOffline);
}

@override
String toString() {
    return 'RecordReferralState(specialty: $specialty, reason: $reason, missing: $missing, isSaving: $isSaving, failed: $failed, noActiveLink: $noActiveLink, isOffline: $isOffline)';
}


}

/// @nodoc
abstract mixin class _$RecordReferralStateCopyWith<$Res> implements $RecordReferralStateCopyWith<$Res> {
  factory _$RecordReferralStateCopyWith(_RecordReferralState value, $Res Function(_RecordReferralState) _then) = __$RecordReferralStateCopyWithImpl;
@override @useResult
$Res call({
 String specialty, String reason, Set<ReferralField> missing, bool isSaving, bool failed, bool noActiveLink, bool isOffline
});




}
/// @nodoc
class __$RecordReferralStateCopyWithImpl<$Res>
    implements _$RecordReferralStateCopyWith<$Res> {
  __$RecordReferralStateCopyWithImpl(this._self, this._then);

  final _RecordReferralState _self;
  final $Res Function(_RecordReferralState) _then;

/// Create a copy of RecordReferralState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? specialty = null,Object? reason = null,Object? missing = null,Object? isSaving = null,Object? failed = null,Object? noActiveLink = null,Object? isOffline = null,}) {
  return _then(_RecordReferralState(
specialty: null == specialty ? _self.specialty : specialty // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,missing: null == missing ? _self._missing : missing // ignore: cast_nullable_to_non_nullable
as Set<ReferralField>,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,failed: null == failed ? _self.failed : failed // ignore: cast_nullable_to_non_nullable
as bool,noActiveLink: null == noActiveLink ? _self.noActiveLink : noActiveLink // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
