// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'discharge_patient_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DischargePatientState {

 String get reason; bool get reasonMissing; DischargeDialog? get dialog; bool get isDischarging; bool get isOffline;
/// Create a copy of DischargePatientState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DischargePatientStateCopyWith<DischargePatientState> get copyWith => _$DischargePatientStateCopyWithImpl<DischargePatientState>(this as DischargePatientState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DischargePatientState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DischargePatientState&&(identical(other.reason, _this.reason) || other.reason == _this.reason)&&(identical(other.reasonMissing, _this.reasonMissing) || other.reasonMissing == _this.reasonMissing)&&(identical(other.dialog, _this.dialog) || other.dialog == _this.dialog)&&(identical(other.isDischarging, _this.isDischarging) || other.isDischarging == _this.isDischarging)&&(identical(other.isOffline, _this.isOffline) || other.isOffline == _this.isOffline));
}


@override
int get hashCode {
  final _this = this as DischargePatientState;
  return Object.hash(runtimeType,_this.reason,_this.reasonMissing,_this.dialog,_this.isDischarging,_this.isOffline);
}

@override
String toString() {
  final _this = this as DischargePatientState;
  return 'DischargePatientState(reason: ${_this.reason}, reasonMissing: ${_this.reasonMissing}, dialog: ${_this.dialog}, isDischarging: ${_this.isDischarging}, isOffline: ${_this.isOffline})';
}


}

/// @nodoc
abstract mixin class $DischargePatientStateCopyWith<$Res>  {
  factory $DischargePatientStateCopyWith(DischargePatientState value, $Res Function(DischargePatientState) _then) = _$DischargePatientStateCopyWithImpl;
@useResult
$Res call({
 String reason, bool reasonMissing, DischargeDialog? dialog, bool isDischarging, bool isOffline
});




}
/// @nodoc
class _$DischargePatientStateCopyWithImpl<$Res>
    implements $DischargePatientStateCopyWith<$Res> {
  _$DischargePatientStateCopyWithImpl(this._self, this._then);

  final DischargePatientState _self;
  final $Res Function(DischargePatientState) _then;

/// Create a copy of DischargePatientState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reason = null,Object? reasonMissing = null,Object? dialog = freezed,Object? isDischarging = null,Object? isOffline = null,}) {
  return _then(DischargePatientState(
reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,reasonMissing: null == reasonMissing ? _self.reasonMissing : reasonMissing // ignore: cast_nullable_to_non_nullable
as bool,dialog: freezed == dialog ? _self.dialog : dialog // ignore: cast_nullable_to_non_nullable
as DischargeDialog?,isDischarging: null == isDischarging ? _self.isDischarging : isDischarging // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DischargePatientState].
extension DischargePatientStatePatterns on DischargePatientState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DischargePatientState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DischargePatientState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DischargePatientState value)  $default,){
final _that = this;
switch (_that) {
case _DischargePatientState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DischargePatientState value)?  $default,){
final _that = this;
switch (_that) {
case _DischargePatientState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String reason,  bool reasonMissing,  DischargeDialog? dialog,  bool isDischarging,  bool isOffline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DischargePatientState() when $default != null:
return $default(_that.reason,_that.reasonMissing,_that.dialog,_that.isDischarging,_that.isOffline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String reason,  bool reasonMissing,  DischargeDialog? dialog,  bool isDischarging,  bool isOffline)  $default,) {final _that = this;
switch (_that) {
case _DischargePatientState():
return $default(_that.reason,_that.reasonMissing,_that.dialog,_that.isDischarging,_that.isOffline);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String reason,  bool reasonMissing,  DischargeDialog? dialog,  bool isDischarging,  bool isOffline)?  $default,) {final _that = this;
switch (_that) {
case _DischargePatientState() when $default != null:
return $default(_that.reason,_that.reasonMissing,_that.dialog,_that.isDischarging,_that.isOffline);case _:
  return null;

}
}

}

/// @nodoc


class _DischargePatientState implements DischargePatientState {
  const _DischargePatientState({this.reason = '', this.reasonMissing = false, this.dialog, this.isDischarging = false, this.isOffline = false});
  

@override@JsonKey() final  String reason;
@override@JsonKey() final  bool reasonMissing;
@override final  DischargeDialog? dialog;
@override@JsonKey() final  bool isDischarging;
@override@JsonKey() final  bool isOffline;

/// Create a copy of DischargePatientState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DischargePatientStateCopyWith<_DischargePatientState> get copyWith => __$DischargePatientStateCopyWithImpl<_DischargePatientState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DischargePatientState&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.reasonMissing, reasonMissing) || other.reasonMissing == reasonMissing)&&(identical(other.dialog, dialog) || other.dialog == dialog)&&(identical(other.isDischarging, isDischarging) || other.isDischarging == isDischarging)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline));
}


@override
int get hashCode {
    return Object.hash(runtimeType,reason,reasonMissing,dialog,isDischarging,isOffline);
}

@override
String toString() {
    return 'DischargePatientState(reason: $reason, reasonMissing: $reasonMissing, dialog: $dialog, isDischarging: $isDischarging, isOffline: $isOffline)';
}


}

/// @nodoc
abstract mixin class _$DischargePatientStateCopyWith<$Res> implements $DischargePatientStateCopyWith<$Res> {
  factory _$DischargePatientStateCopyWith(_DischargePatientState value, $Res Function(_DischargePatientState) _then) = __$DischargePatientStateCopyWithImpl;
@override @useResult
$Res call({
 String reason, bool reasonMissing, DischargeDialog? dialog, bool isDischarging, bool isOffline
});




}
/// @nodoc
class __$DischargePatientStateCopyWithImpl<$Res>
    implements _$DischargePatientStateCopyWith<$Res> {
  __$DischargePatientStateCopyWithImpl(this._self, this._then);

  final _DischargePatientState _self;
  final $Res Function(_DischargePatientState) _then;

/// Create a copy of DischargePatientState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reason = null,Object? reasonMissing = null,Object? dialog = freezed,Object? isDischarging = null,Object? isOffline = null,}) {
  return _then(_DischargePatientState(
reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,reasonMissing: null == reasonMissing ? _self.reasonMissing : reasonMissing // ignore: cast_nullable_to_non_nullable
as bool,dialog: freezed == dialog ? _self.dialog : dialog // ignore: cast_nullable_to_non_nullable
as DischargeDialog?,isDischarging: null == isDischarging ? _self.isDischarging : isDischarging // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
