// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'patient_history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PatientHistoryState {

 bool get isLoading; bool get isOffline; bool get loadFailed; HistoryData? get data; EvaluationSheetState? get evaluationSheet;
/// Create a copy of PatientHistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PatientHistoryStateCopyWith<PatientHistoryState> get copyWith => _$PatientHistoryStateCopyWithImpl<PatientHistoryState>(this as PatientHistoryState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PatientHistoryState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PatientHistoryState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isOffline, _this.isOffline) || other.isOffline == _this.isOffline)&&(identical(other.loadFailed, _this.loadFailed) || other.loadFailed == _this.loadFailed)&&(identical(other.data, _this.data) || other.data == _this.data)&&(identical(other.evaluationSheet, _this.evaluationSheet) || other.evaluationSheet == _this.evaluationSheet));
}


@override
int get hashCode {
  final _this = this as PatientHistoryState;
  return Object.hash(runtimeType,_this.isLoading,_this.isOffline,_this.loadFailed,_this.data,_this.evaluationSheet);
}

@override
String toString() {
  final _this = this as PatientHistoryState;
  return 'PatientHistoryState(isLoading: ${_this.isLoading}, isOffline: ${_this.isOffline}, loadFailed: ${_this.loadFailed}, data: ${_this.data}, evaluationSheet: ${_this.evaluationSheet})';
}


}

/// @nodoc
abstract mixin class $PatientHistoryStateCopyWith<$Res>  {
  factory $PatientHistoryStateCopyWith(PatientHistoryState value, $Res Function(PatientHistoryState) _then) = _$PatientHistoryStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isOffline, bool loadFailed, HistoryData? data, EvaluationSheetState? evaluationSheet
});




}
/// @nodoc
class _$PatientHistoryStateCopyWithImpl<$Res>
    implements $PatientHistoryStateCopyWith<$Res> {
  _$PatientHistoryStateCopyWithImpl(this._self, this._then);

  final PatientHistoryState _self;
  final $Res Function(PatientHistoryState) _then;

/// Create a copy of PatientHistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isOffline = null,Object? loadFailed = null,Object? data = freezed,Object? evaluationSheet = freezed,}) {
  return _then(PatientHistoryState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,loadFailed: null == loadFailed ? _self.loadFailed : loadFailed // ignore: cast_nullable_to_non_nullable
as bool,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as HistoryData?,evaluationSheet: freezed == evaluationSheet ? _self.evaluationSheet : evaluationSheet // ignore: cast_nullable_to_non_nullable
as EvaluationSheetState?,
  ));
}

}


/// Adds pattern-matching-related methods to [PatientHistoryState].
extension PatientHistoryStatePatterns on PatientHistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PatientHistoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PatientHistoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PatientHistoryState value)  $default,){
final _that = this;
switch (_that) {
case _PatientHistoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PatientHistoryState value)?  $default,){
final _that = this;
switch (_that) {
case _PatientHistoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isOffline,  bool loadFailed,  HistoryData? data,  EvaluationSheetState? evaluationSheet)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PatientHistoryState() when $default != null:
return $default(_that.isLoading,_that.isOffline,_that.loadFailed,_that.data,_that.evaluationSheet);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isOffline,  bool loadFailed,  HistoryData? data,  EvaluationSheetState? evaluationSheet)  $default,) {final _that = this;
switch (_that) {
case _PatientHistoryState():
return $default(_that.isLoading,_that.isOffline,_that.loadFailed,_that.data,_that.evaluationSheet);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isOffline,  bool loadFailed,  HistoryData? data,  EvaluationSheetState? evaluationSheet)?  $default,) {final _that = this;
switch (_that) {
case _PatientHistoryState() when $default != null:
return $default(_that.isLoading,_that.isOffline,_that.loadFailed,_that.data,_that.evaluationSheet);case _:
  return null;

}
}

}

/// @nodoc


class _PatientHistoryState implements PatientHistoryState {
  const _PatientHistoryState({this.isLoading = true, this.isOffline = false, this.loadFailed = false, this.data, this.evaluationSheet});
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isOffline;
@override@JsonKey() final  bool loadFailed;
@override final  HistoryData? data;
@override final  EvaluationSheetState? evaluationSheet;

/// Create a copy of PatientHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PatientHistoryStateCopyWith<_PatientHistoryState> get copyWith => __$PatientHistoryStateCopyWithImpl<_PatientHistoryState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PatientHistoryState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline)&&(identical(other.loadFailed, loadFailed) || other.loadFailed == loadFailed)&&(identical(other.data, data) || other.data == data)&&(identical(other.evaluationSheet, evaluationSheet) || other.evaluationSheet == evaluationSheet));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,isOffline,loadFailed,data,evaluationSheet);
}

@override
String toString() {
    return 'PatientHistoryState(isLoading: $isLoading, isOffline: $isOffline, loadFailed: $loadFailed, data: $data, evaluationSheet: $evaluationSheet)';
}


}

/// @nodoc
abstract mixin class _$PatientHistoryStateCopyWith<$Res> implements $PatientHistoryStateCopyWith<$Res> {
  factory _$PatientHistoryStateCopyWith(_PatientHistoryState value, $Res Function(_PatientHistoryState) _then) = __$PatientHistoryStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isOffline, bool loadFailed, HistoryData? data, EvaluationSheetState? evaluationSheet
});




}
/// @nodoc
class __$PatientHistoryStateCopyWithImpl<$Res>
    implements _$PatientHistoryStateCopyWith<$Res> {
  __$PatientHistoryStateCopyWithImpl(this._self, this._then);

  final _PatientHistoryState _self;
  final $Res Function(_PatientHistoryState) _then;

/// Create a copy of PatientHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isOffline = null,Object? loadFailed = null,Object? data = freezed,Object? evaluationSheet = freezed,}) {
  return _then(_PatientHistoryState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,loadFailed: null == loadFailed ? _self.loadFailed : loadFailed // ignore: cast_nullable_to_non_nullable
as bool,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as HistoryData?,evaluationSheet: freezed == evaluationSheet ? _self.evaluationSheet : evaluationSheet // ignore: cast_nullable_to_non_nullable
as EvaluationSheetState?,
  ));
}


}

// dart format on
