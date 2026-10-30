// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'patient_follow_up_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PatientFollowUpState {

 bool get isLoading; bool get isOffline; bool get loadFailed; PatientMonitoringPanel? get panel; String? get aiSummary;
/// Create a copy of PatientFollowUpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PatientFollowUpStateCopyWith<PatientFollowUpState> get copyWith => _$PatientFollowUpStateCopyWithImpl<PatientFollowUpState>(this as PatientFollowUpState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PatientFollowUpState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PatientFollowUpState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isOffline, _this.isOffline) || other.isOffline == _this.isOffline)&&(identical(other.loadFailed, _this.loadFailed) || other.loadFailed == _this.loadFailed)&&(identical(other.panel, _this.panel) || other.panel == _this.panel)&&(identical(other.aiSummary, _this.aiSummary) || other.aiSummary == _this.aiSummary));
}


@override
int get hashCode {
  final _this = this as PatientFollowUpState;
  return Object.hash(runtimeType,_this.isLoading,_this.isOffline,_this.loadFailed,_this.panel,_this.aiSummary);
}

@override
String toString() {
  final _this = this as PatientFollowUpState;
  return 'PatientFollowUpState(isLoading: ${_this.isLoading}, isOffline: ${_this.isOffline}, loadFailed: ${_this.loadFailed}, panel: ${_this.panel}, aiSummary: ${_this.aiSummary})';
}


}

/// @nodoc
abstract mixin class $PatientFollowUpStateCopyWith<$Res>  {
  factory $PatientFollowUpStateCopyWith(PatientFollowUpState value, $Res Function(PatientFollowUpState) _then) = _$PatientFollowUpStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isOffline, bool loadFailed, PatientMonitoringPanel? panel, String? aiSummary
});




}
/// @nodoc
class _$PatientFollowUpStateCopyWithImpl<$Res>
    implements $PatientFollowUpStateCopyWith<$Res> {
  _$PatientFollowUpStateCopyWithImpl(this._self, this._then);

  final PatientFollowUpState _self;
  final $Res Function(PatientFollowUpState) _then;

/// Create a copy of PatientFollowUpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isOffline = null,Object? loadFailed = null,Object? panel = freezed,Object? aiSummary = freezed,}) {
  return _then(PatientFollowUpState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,loadFailed: null == loadFailed ? _self.loadFailed : loadFailed // ignore: cast_nullable_to_non_nullable
as bool,panel: freezed == panel ? _self.panel : panel // ignore: cast_nullable_to_non_nullable
as PatientMonitoringPanel?,aiSummary: freezed == aiSummary ? _self.aiSummary : aiSummary // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PatientFollowUpState].
extension PatientFollowUpStatePatterns on PatientFollowUpState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PatientFollowUpState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PatientFollowUpState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PatientFollowUpState value)  $default,){
final _that = this;
switch (_that) {
case _PatientFollowUpState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PatientFollowUpState value)?  $default,){
final _that = this;
switch (_that) {
case _PatientFollowUpState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isOffline,  bool loadFailed,  PatientMonitoringPanel? panel,  String? aiSummary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PatientFollowUpState() when $default != null:
return $default(_that.isLoading,_that.isOffline,_that.loadFailed,_that.panel,_that.aiSummary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isOffline,  bool loadFailed,  PatientMonitoringPanel? panel,  String? aiSummary)  $default,) {final _that = this;
switch (_that) {
case _PatientFollowUpState():
return $default(_that.isLoading,_that.isOffline,_that.loadFailed,_that.panel,_that.aiSummary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isOffline,  bool loadFailed,  PatientMonitoringPanel? panel,  String? aiSummary)?  $default,) {final _that = this;
switch (_that) {
case _PatientFollowUpState() when $default != null:
return $default(_that.isLoading,_that.isOffline,_that.loadFailed,_that.panel,_that.aiSummary);case _:
  return null;

}
}

}

/// @nodoc


class _PatientFollowUpState implements PatientFollowUpState {
  const _PatientFollowUpState({this.isLoading = true, this.isOffline = false, this.loadFailed = false, this.panel, this.aiSummary});
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isOffline;
@override@JsonKey() final  bool loadFailed;
@override final  PatientMonitoringPanel? panel;
@override final  String? aiSummary;

/// Create a copy of PatientFollowUpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PatientFollowUpStateCopyWith<_PatientFollowUpState> get copyWith => __$PatientFollowUpStateCopyWithImpl<_PatientFollowUpState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PatientFollowUpState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline)&&(identical(other.loadFailed, loadFailed) || other.loadFailed == loadFailed)&&(identical(other.panel, panel) || other.panel == panel)&&(identical(other.aiSummary, aiSummary) || other.aiSummary == aiSummary));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,isOffline,loadFailed,panel,aiSummary);
}

@override
String toString() {
    return 'PatientFollowUpState(isLoading: $isLoading, isOffline: $isOffline, loadFailed: $loadFailed, panel: $panel, aiSummary: $aiSummary)';
}


}

/// @nodoc
abstract mixin class _$PatientFollowUpStateCopyWith<$Res> implements $PatientFollowUpStateCopyWith<$Res> {
  factory _$PatientFollowUpStateCopyWith(_PatientFollowUpState value, $Res Function(_PatientFollowUpState) _then) = __$PatientFollowUpStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isOffline, bool loadFailed, PatientMonitoringPanel? panel, String? aiSummary
});




}
/// @nodoc
class __$PatientFollowUpStateCopyWithImpl<$Res>
    implements _$PatientFollowUpStateCopyWith<$Res> {
  __$PatientFollowUpStateCopyWithImpl(this._self, this._then);

  final _PatientFollowUpState _self;
  final $Res Function(_PatientFollowUpState) _then;

/// Create a copy of PatientFollowUpState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isOffline = null,Object? loadFailed = null,Object? panel = freezed,Object? aiSummary = freezed,}) {
  return _then(_PatientFollowUpState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,loadFailed: null == loadFailed ? _self.loadFailed : loadFailed // ignore: cast_nullable_to_non_nullable
as bool,panel: freezed == panel ? _self.panel : panel // ignore: cast_nullable_to_non_nullable
as PatientMonitoringPanel?,aiSummary: freezed == aiSummary ? _self.aiSummary : aiSummary // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
