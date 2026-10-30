// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'patient_tab_states.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PatientSummaryState {

 bool get isLoading; bool get isOffline; bool get loadFailed; PatientSummary? get summary; bool get isStartingConsultation; bool get showStartError;
/// Create a copy of PatientSummaryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PatientSummaryStateCopyWith<PatientSummaryState> get copyWith => _$PatientSummaryStateCopyWithImpl<PatientSummaryState>(this as PatientSummaryState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PatientSummaryState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PatientSummaryState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isOffline, _this.isOffline) || other.isOffline == _this.isOffline)&&(identical(other.loadFailed, _this.loadFailed) || other.loadFailed == _this.loadFailed)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&(identical(other.isStartingConsultation, _this.isStartingConsultation) || other.isStartingConsultation == _this.isStartingConsultation)&&(identical(other.showStartError, _this.showStartError) || other.showStartError == _this.showStartError));
}


@override
int get hashCode {
  final _this = this as PatientSummaryState;
  return Object.hash(runtimeType,_this.isLoading,_this.isOffline,_this.loadFailed,_this.summary,_this.isStartingConsultation,_this.showStartError);
}

@override
String toString() {
  final _this = this as PatientSummaryState;
  return 'PatientSummaryState(isLoading: ${_this.isLoading}, isOffline: ${_this.isOffline}, loadFailed: ${_this.loadFailed}, summary: ${_this.summary}, isStartingConsultation: ${_this.isStartingConsultation}, showStartError: ${_this.showStartError})';
}


}

/// @nodoc
abstract mixin class $PatientSummaryStateCopyWith<$Res>  {
  factory $PatientSummaryStateCopyWith(PatientSummaryState value, $Res Function(PatientSummaryState) _then) = _$PatientSummaryStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isOffline, bool loadFailed, PatientSummary? summary, bool isStartingConsultation, bool showStartError
});




}
/// @nodoc
class _$PatientSummaryStateCopyWithImpl<$Res>
    implements $PatientSummaryStateCopyWith<$Res> {
  _$PatientSummaryStateCopyWithImpl(this._self, this._then);

  final PatientSummaryState _self;
  final $Res Function(PatientSummaryState) _then;

/// Create a copy of PatientSummaryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isOffline = null,Object? loadFailed = null,Object? summary = freezed,Object? isStartingConsultation = null,Object? showStartError = null,}) {
  return _then(PatientSummaryState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,loadFailed: null == loadFailed ? _self.loadFailed : loadFailed // ignore: cast_nullable_to_non_nullable
as bool,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as PatientSummary?,isStartingConsultation: null == isStartingConsultation ? _self.isStartingConsultation : isStartingConsultation // ignore: cast_nullable_to_non_nullable
as bool,showStartError: null == showStartError ? _self.showStartError : showStartError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PatientSummaryState].
extension PatientSummaryStatePatterns on PatientSummaryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PatientSummaryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PatientSummaryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PatientSummaryState value)  $default,){
final _that = this;
switch (_that) {
case _PatientSummaryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PatientSummaryState value)?  $default,){
final _that = this;
switch (_that) {
case _PatientSummaryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isOffline,  bool loadFailed,  PatientSummary? summary,  bool isStartingConsultation,  bool showStartError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PatientSummaryState() when $default != null:
return $default(_that.isLoading,_that.isOffline,_that.loadFailed,_that.summary,_that.isStartingConsultation,_that.showStartError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isOffline,  bool loadFailed,  PatientSummary? summary,  bool isStartingConsultation,  bool showStartError)  $default,) {final _that = this;
switch (_that) {
case _PatientSummaryState():
return $default(_that.isLoading,_that.isOffline,_that.loadFailed,_that.summary,_that.isStartingConsultation,_that.showStartError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isOffline,  bool loadFailed,  PatientSummary? summary,  bool isStartingConsultation,  bool showStartError)?  $default,) {final _that = this;
switch (_that) {
case _PatientSummaryState() when $default != null:
return $default(_that.isLoading,_that.isOffline,_that.loadFailed,_that.summary,_that.isStartingConsultation,_that.showStartError);case _:
  return null;

}
}

}

/// @nodoc


class _PatientSummaryState implements PatientSummaryState {
  const _PatientSummaryState({this.isLoading = true, this.isOffline = false, this.loadFailed = false, this.summary, this.isStartingConsultation = false, this.showStartError = false});
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isOffline;
@override@JsonKey() final  bool loadFailed;
@override final  PatientSummary? summary;
@override@JsonKey() final  bool isStartingConsultation;
@override@JsonKey() final  bool showStartError;

/// Create a copy of PatientSummaryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PatientSummaryStateCopyWith<_PatientSummaryState> get copyWith => __$PatientSummaryStateCopyWithImpl<_PatientSummaryState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PatientSummaryState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline)&&(identical(other.loadFailed, loadFailed) || other.loadFailed == loadFailed)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.isStartingConsultation, isStartingConsultation) || other.isStartingConsultation == isStartingConsultation)&&(identical(other.showStartError, showStartError) || other.showStartError == showStartError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,isOffline,loadFailed,summary,isStartingConsultation,showStartError);
}

@override
String toString() {
    return 'PatientSummaryState(isLoading: $isLoading, isOffline: $isOffline, loadFailed: $loadFailed, summary: $summary, isStartingConsultation: $isStartingConsultation, showStartError: $showStartError)';
}


}

/// @nodoc
abstract mixin class _$PatientSummaryStateCopyWith<$Res> implements $PatientSummaryStateCopyWith<$Res> {
  factory _$PatientSummaryStateCopyWith(_PatientSummaryState value, $Res Function(_PatientSummaryState) _then) = __$PatientSummaryStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isOffline, bool loadFailed, PatientSummary? summary, bool isStartingConsultation, bool showStartError
});




}
/// @nodoc
class __$PatientSummaryStateCopyWithImpl<$Res>
    implements _$PatientSummaryStateCopyWith<$Res> {
  __$PatientSummaryStateCopyWithImpl(this._self, this._then);

  final _PatientSummaryState _self;
  final $Res Function(_PatientSummaryState) _then;

/// Create a copy of PatientSummaryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isOffline = null,Object? loadFailed = null,Object? summary = freezed,Object? isStartingConsultation = null,Object? showStartError = null,}) {
  return _then(_PatientSummaryState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,loadFailed: null == loadFailed ? _self.loadFailed : loadFailed // ignore: cast_nullable_to_non_nullable
as bool,summary: freezed == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as PatientSummary?,isStartingConsultation: null == isStartingConsultation ? _self.isStartingConsultation : isStartingConsultation // ignore: cast_nullable_to_non_nullable
as bool,showStartError: null == showStartError ? _self.showStartError : showStartError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$PatientPlanState {

 bool get isLoading; bool get isOffline; bool get loadFailed; PlanHistory? get history; TargetsReadStatus? get readStatus; bool get isStartingConsultation; bool get showStartError;
/// Create a copy of PatientPlanState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PatientPlanStateCopyWith<PatientPlanState> get copyWith => _$PatientPlanStateCopyWithImpl<PatientPlanState>(this as PatientPlanState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PatientPlanState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PatientPlanState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isOffline, _this.isOffline) || other.isOffline == _this.isOffline)&&(identical(other.loadFailed, _this.loadFailed) || other.loadFailed == _this.loadFailed)&&(identical(other.history, _this.history) || other.history == _this.history)&&(identical(other.readStatus, _this.readStatus) || other.readStatus == _this.readStatus)&&(identical(other.isStartingConsultation, _this.isStartingConsultation) || other.isStartingConsultation == _this.isStartingConsultation)&&(identical(other.showStartError, _this.showStartError) || other.showStartError == _this.showStartError));
}


@override
int get hashCode {
  final _this = this as PatientPlanState;
  return Object.hash(runtimeType,_this.isLoading,_this.isOffline,_this.loadFailed,_this.history,_this.readStatus,_this.isStartingConsultation,_this.showStartError);
}

@override
String toString() {
  final _this = this as PatientPlanState;
  return 'PatientPlanState(isLoading: ${_this.isLoading}, isOffline: ${_this.isOffline}, loadFailed: ${_this.loadFailed}, history: ${_this.history}, readStatus: ${_this.readStatus}, isStartingConsultation: ${_this.isStartingConsultation}, showStartError: ${_this.showStartError})';
}


}

/// @nodoc
abstract mixin class $PatientPlanStateCopyWith<$Res>  {
  factory $PatientPlanStateCopyWith(PatientPlanState value, $Res Function(PatientPlanState) _then) = _$PatientPlanStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isOffline, bool loadFailed, PlanHistory? history, TargetsReadStatus? readStatus, bool isStartingConsultation, bool showStartError
});




}
/// @nodoc
class _$PatientPlanStateCopyWithImpl<$Res>
    implements $PatientPlanStateCopyWith<$Res> {
  _$PatientPlanStateCopyWithImpl(this._self, this._then);

  final PatientPlanState _self;
  final $Res Function(PatientPlanState) _then;

/// Create a copy of PatientPlanState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isOffline = null,Object? loadFailed = null,Object? history = freezed,Object? readStatus = freezed,Object? isStartingConsultation = null,Object? showStartError = null,}) {
  return _then(PatientPlanState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,loadFailed: null == loadFailed ? _self.loadFailed : loadFailed // ignore: cast_nullable_to_non_nullable
as bool,history: freezed == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as PlanHistory?,readStatus: freezed == readStatus ? _self.readStatus : readStatus // ignore: cast_nullable_to_non_nullable
as TargetsReadStatus?,isStartingConsultation: null == isStartingConsultation ? _self.isStartingConsultation : isStartingConsultation // ignore: cast_nullable_to_non_nullable
as bool,showStartError: null == showStartError ? _self.showStartError : showStartError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PatientPlanState].
extension PatientPlanStatePatterns on PatientPlanState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PatientPlanState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PatientPlanState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PatientPlanState value)  $default,){
final _that = this;
switch (_that) {
case _PatientPlanState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PatientPlanState value)?  $default,){
final _that = this;
switch (_that) {
case _PatientPlanState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isOffline,  bool loadFailed,  PlanHistory? history,  TargetsReadStatus? readStatus,  bool isStartingConsultation,  bool showStartError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PatientPlanState() when $default != null:
return $default(_that.isLoading,_that.isOffline,_that.loadFailed,_that.history,_that.readStatus,_that.isStartingConsultation,_that.showStartError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isOffline,  bool loadFailed,  PlanHistory? history,  TargetsReadStatus? readStatus,  bool isStartingConsultation,  bool showStartError)  $default,) {final _that = this;
switch (_that) {
case _PatientPlanState():
return $default(_that.isLoading,_that.isOffline,_that.loadFailed,_that.history,_that.readStatus,_that.isStartingConsultation,_that.showStartError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isOffline,  bool loadFailed,  PlanHistory? history,  TargetsReadStatus? readStatus,  bool isStartingConsultation,  bool showStartError)?  $default,) {final _that = this;
switch (_that) {
case _PatientPlanState() when $default != null:
return $default(_that.isLoading,_that.isOffline,_that.loadFailed,_that.history,_that.readStatus,_that.isStartingConsultation,_that.showStartError);case _:
  return null;

}
}

}

/// @nodoc


class _PatientPlanState implements PatientPlanState {
  const _PatientPlanState({this.isLoading = true, this.isOffline = false, this.loadFailed = false, this.history, this.readStatus, this.isStartingConsultation = false, this.showStartError = false});
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isOffline;
@override@JsonKey() final  bool loadFailed;
@override final  PlanHistory? history;
@override final  TargetsReadStatus? readStatus;
@override@JsonKey() final  bool isStartingConsultation;
@override@JsonKey() final  bool showStartError;

/// Create a copy of PatientPlanState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PatientPlanStateCopyWith<_PatientPlanState> get copyWith => __$PatientPlanStateCopyWithImpl<_PatientPlanState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PatientPlanState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline)&&(identical(other.loadFailed, loadFailed) || other.loadFailed == loadFailed)&&(identical(other.history, history) || other.history == history)&&(identical(other.readStatus, readStatus) || other.readStatus == readStatus)&&(identical(other.isStartingConsultation, isStartingConsultation) || other.isStartingConsultation == isStartingConsultation)&&(identical(other.showStartError, showStartError) || other.showStartError == showStartError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,isOffline,loadFailed,history,readStatus,isStartingConsultation,showStartError);
}

@override
String toString() {
    return 'PatientPlanState(isLoading: $isLoading, isOffline: $isOffline, loadFailed: $loadFailed, history: $history, readStatus: $readStatus, isStartingConsultation: $isStartingConsultation, showStartError: $showStartError)';
}


}

/// @nodoc
abstract mixin class _$PatientPlanStateCopyWith<$Res> implements $PatientPlanStateCopyWith<$Res> {
  factory _$PatientPlanStateCopyWith(_PatientPlanState value, $Res Function(_PatientPlanState) _then) = __$PatientPlanStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isOffline, bool loadFailed, PlanHistory? history, TargetsReadStatus? readStatus, bool isStartingConsultation, bool showStartError
});




}
/// @nodoc
class __$PatientPlanStateCopyWithImpl<$Res>
    implements _$PatientPlanStateCopyWith<$Res> {
  __$PatientPlanStateCopyWithImpl(this._self, this._then);

  final _PatientPlanState _self;
  final $Res Function(_PatientPlanState) _then;

/// Create a copy of PatientPlanState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isOffline = null,Object? loadFailed = null,Object? history = freezed,Object? readStatus = freezed,Object? isStartingConsultation = null,Object? showStartError = null,}) {
  return _then(_PatientPlanState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,loadFailed: null == loadFailed ? _self.loadFailed : loadFailed // ignore: cast_nullable_to_non_nullable
as bool,history: freezed == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as PlanHistory?,readStatus: freezed == readStatus ? _self.readStatus : readStatus // ignore: cast_nullable_to_non_nullable
as TargetsReadStatus?,isStartingConsultation: null == isStartingConsultation ? _self.isStartingConsultation : isStartingConsultation // ignore: cast_nullable_to_non_nullable
as bool,showStartError: null == showStartError ? _self.showStartError : showStartError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
