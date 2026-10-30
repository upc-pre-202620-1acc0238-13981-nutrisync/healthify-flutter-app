// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'consultation_step_states.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StepLoadState {

 bool get isLoading; bool get loadFailed; bool get isOffline;
/// Create a copy of StepLoadState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StepLoadStateCopyWith<StepLoadState> get copyWith => _$StepLoadStateCopyWithImpl<StepLoadState>(this as StepLoadState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StepLoadState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StepLoadState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.loadFailed, _this.loadFailed) || other.loadFailed == _this.loadFailed)&&(identical(other.isOffline, _this.isOffline) || other.isOffline == _this.isOffline));
}


@override
int get hashCode {
  final _this = this as StepLoadState;
  return Object.hash(runtimeType,_this.isLoading,_this.loadFailed,_this.isOffline);
}

@override
String toString() {
  final _this = this as StepLoadState;
  return 'StepLoadState(isLoading: ${_this.isLoading}, loadFailed: ${_this.loadFailed}, isOffline: ${_this.isOffline})';
}


}

/// @nodoc
abstract mixin class $StepLoadStateCopyWith<$Res>  {
  factory $StepLoadStateCopyWith(StepLoadState value, $Res Function(StepLoadState) _then) = _$StepLoadStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool loadFailed, bool isOffline
});




}
/// @nodoc
class _$StepLoadStateCopyWithImpl<$Res>
    implements $StepLoadStateCopyWith<$Res> {
  _$StepLoadStateCopyWithImpl(this._self, this._then);

  final StepLoadState _self;
  final $Res Function(StepLoadState) _then;

/// Create a copy of StepLoadState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? loadFailed = null,Object? isOffline = null,}) {
  return _then(StepLoadState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,loadFailed: null == loadFailed ? _self.loadFailed : loadFailed // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StepLoadState].
extension StepLoadStatePatterns on StepLoadState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StepLoadState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StepLoadState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StepLoadState value)  $default,){
final _that = this;
switch (_that) {
case _StepLoadState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StepLoadState value)?  $default,){
final _that = this;
switch (_that) {
case _StepLoadState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool loadFailed,  bool isOffline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StepLoadState() when $default != null:
return $default(_that.isLoading,_that.loadFailed,_that.isOffline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool loadFailed,  bool isOffline)  $default,) {final _that = this;
switch (_that) {
case _StepLoadState():
return $default(_that.isLoading,_that.loadFailed,_that.isOffline);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool loadFailed,  bool isOffline)?  $default,) {final _that = this;
switch (_that) {
case _StepLoadState() when $default != null:
return $default(_that.isLoading,_that.loadFailed,_that.isOffline);case _:
  return null;

}
}

}

/// @nodoc


class _StepLoadState implements StepLoadState {
  const _StepLoadState({this.isLoading = true, this.loadFailed = false, this.isOffline = false});
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool loadFailed;
@override@JsonKey() final  bool isOffline;

/// Create a copy of StepLoadState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StepLoadStateCopyWith<_StepLoadState> get copyWith => __$StepLoadStateCopyWithImpl<_StepLoadState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StepLoadState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.loadFailed, loadFailed) || other.loadFailed == loadFailed)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,loadFailed,isOffline);
}

@override
String toString() {
    return 'StepLoadState(isLoading: $isLoading, loadFailed: $loadFailed, isOffline: $isOffline)';
}


}

/// @nodoc
abstract mixin class _$StepLoadStateCopyWith<$Res> implements $StepLoadStateCopyWith<$Res> {
  factory _$StepLoadStateCopyWith(_StepLoadState value, $Res Function(_StepLoadState) _then) = __$StepLoadStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool loadFailed, bool isOffline
});




}
/// @nodoc
class __$StepLoadStateCopyWithImpl<$Res>
    implements _$StepLoadStateCopyWith<$Res> {
  __$StepLoadStateCopyWithImpl(this._self, this._then);

  final _StepLoadState _self;
  final $Res Function(_StepLoadState) _then;

/// Create a copy of StepLoadState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? loadFailed = null,Object? isOffline = null,}) {
  return _then(_StepLoadState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,loadFailed: null == loadFailed ? _self.loadFailed : loadFailed // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$SaveFailure {

 bool get isNetwork;
/// Create a copy of SaveFailure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaveFailureCopyWith<SaveFailure> get copyWith => _$SaveFailureCopyWithImpl<SaveFailure>(this as SaveFailure, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SaveFailure;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaveFailure&&(identical(other.isNetwork, _this.isNetwork) || other.isNetwork == _this.isNetwork));
}


@override
int get hashCode {
  final _this = this as SaveFailure;
  return Object.hash(runtimeType,_this.isNetwork);
}

@override
String toString() {
  final _this = this as SaveFailure;
  return 'SaveFailure(isNetwork: ${_this.isNetwork})';
}


}

/// @nodoc
abstract mixin class $SaveFailureCopyWith<$Res>  {
  factory $SaveFailureCopyWith(SaveFailure value, $Res Function(SaveFailure) _then) = _$SaveFailureCopyWithImpl;
@useResult
$Res call({
 bool isNetwork
});




}
/// @nodoc
class _$SaveFailureCopyWithImpl<$Res>
    implements $SaveFailureCopyWith<$Res> {
  _$SaveFailureCopyWithImpl(this._self, this._then);

  final SaveFailure _self;
  final $Res Function(SaveFailure) _then;

/// Create a copy of SaveFailure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isNetwork = null,}) {
  return _then(SaveFailure(
isNetwork: null == isNetwork ? _self.isNetwork : isNetwork // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SaveFailure].
extension SaveFailurePatterns on SaveFailure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaveFailure value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaveFailure() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaveFailure value)  $default,){
final _that = this;
switch (_that) {
case _SaveFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaveFailure value)?  $default,){
final _that = this;
switch (_that) {
case _SaveFailure() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isNetwork)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaveFailure() when $default != null:
return $default(_that.isNetwork);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isNetwork)  $default,) {final _that = this;
switch (_that) {
case _SaveFailure():
return $default(_that.isNetwork);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isNetwork)?  $default,) {final _that = this;
switch (_that) {
case _SaveFailure() when $default != null:
return $default(_that.isNetwork);case _:
  return null;

}
}

}

/// @nodoc


class _SaveFailure implements SaveFailure {
  const _SaveFailure({required this.isNetwork});
  

@override final  bool isNetwork;

/// Create a copy of SaveFailure
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaveFailureCopyWith<_SaveFailure> get copyWith => __$SaveFailureCopyWithImpl<_SaveFailure>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveFailure&&(identical(other.isNetwork, isNetwork) || other.isNetwork == isNetwork));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isNetwork);
}

@override
String toString() {
    return 'SaveFailure(isNetwork: $isNetwork)';
}


}

/// @nodoc
abstract mixin class _$SaveFailureCopyWith<$Res> implements $SaveFailureCopyWith<$Res> {
  factory _$SaveFailureCopyWith(_SaveFailure value, $Res Function(_SaveFailure) _then) = __$SaveFailureCopyWithImpl;
@override @useResult
$Res call({
 bool isNetwork
});




}
/// @nodoc
class __$SaveFailureCopyWithImpl<$Res>
    implements _$SaveFailureCopyWith<$Res> {
  __$SaveFailureCopyWithImpl(this._self, this._then);

  final _SaveFailure _self;
  final $Res Function(_SaveFailure) _then;

/// Create a copy of SaveFailure
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isNetwork = null,}) {
  return _then(_SaveFailure(
isNetwork: null == isNetwork ? _self.isNetwork : isNetwork // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$MeasurementState {

 StepLoadState get load; BaselineSummary? get baseline; PatientCheckIn? get checkIn; MeasurementForm get form;/// Live BMI from the typed weight and the baseline height.
 double? get bmi; bool get habitsExpanded; bool get biochemistryExpanded; Map<MeasurementField, FieldProblem> get problems; bool get isSaving; SaveFailure? get saveFailure; bool get showExitDialog;/// "Delete consultation" (trash can): confirmation dialog, deletion in progress and failure with "Retry".
 bool get showDiscardDialog; bool get isDiscarding; SaveFailure? get discardFailure;
/// Create a copy of MeasurementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeasurementStateCopyWith<MeasurementState> get copyWith => _$MeasurementStateCopyWithImpl<MeasurementState>(this as MeasurementState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as MeasurementState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeasurementState&&(identical(other.load, _this.load) || other.load == _this.load)&&(identical(other.baseline, _this.baseline) || other.baseline == _this.baseline)&&(identical(other.checkIn, _this.checkIn) || other.checkIn == _this.checkIn)&&(identical(other.form, _this.form) || other.form == _this.form)&&(identical(other.bmi, _this.bmi) || other.bmi == _this.bmi)&&(identical(other.habitsExpanded, _this.habitsExpanded) || other.habitsExpanded == _this.habitsExpanded)&&(identical(other.biochemistryExpanded, _this.biochemistryExpanded) || other.biochemistryExpanded == _this.biochemistryExpanded)&&const DeepCollectionEquality().equals(other.problems, _this.problems)&&(identical(other.isSaving, _this.isSaving) || other.isSaving == _this.isSaving)&&(identical(other.saveFailure, _this.saveFailure) || other.saveFailure == _this.saveFailure)&&(identical(other.showExitDialog, _this.showExitDialog) || other.showExitDialog == _this.showExitDialog)&&(identical(other.showDiscardDialog, _this.showDiscardDialog) || other.showDiscardDialog == _this.showDiscardDialog)&&(identical(other.isDiscarding, _this.isDiscarding) || other.isDiscarding == _this.isDiscarding)&&(identical(other.discardFailure, _this.discardFailure) || other.discardFailure == _this.discardFailure));
}


@override
int get hashCode {
  final _this = this as MeasurementState;
  return Object.hash(runtimeType,_this.load,_this.baseline,_this.checkIn,_this.form,_this.bmi,_this.habitsExpanded,_this.biochemistryExpanded,const DeepCollectionEquality().hash(_this.problems),_this.isSaving,_this.saveFailure,_this.showExitDialog,_this.showDiscardDialog,_this.isDiscarding,_this.discardFailure);
}

@override
String toString() {
  final _this = this as MeasurementState;
  return 'MeasurementState(load: ${_this.load}, baseline: ${_this.baseline}, checkIn: ${_this.checkIn}, form: ${_this.form}, bmi: ${_this.bmi}, habitsExpanded: ${_this.habitsExpanded}, biochemistryExpanded: ${_this.biochemistryExpanded}, problems: ${_this.problems}, isSaving: ${_this.isSaving}, saveFailure: ${_this.saveFailure}, showExitDialog: ${_this.showExitDialog}, showDiscardDialog: ${_this.showDiscardDialog}, isDiscarding: ${_this.isDiscarding}, discardFailure: ${_this.discardFailure})';
}


}

/// @nodoc
abstract mixin class $MeasurementStateCopyWith<$Res>  {
  factory $MeasurementStateCopyWith(MeasurementState value, $Res Function(MeasurementState) _then) = _$MeasurementStateCopyWithImpl;
@useResult
$Res call({
 StepLoadState load, BaselineSummary? baseline, PatientCheckIn? checkIn, MeasurementForm form, double? bmi, bool habitsExpanded, bool biochemistryExpanded, Map<MeasurementField, FieldProblem> problems, bool isSaving, SaveFailure? saveFailure, bool showExitDialog, bool showDiscardDialog, bool isDiscarding, SaveFailure? discardFailure
});


$StepLoadStateCopyWith<$Res> get load;$SaveFailureCopyWith<$Res>? get saveFailure;$SaveFailureCopyWith<$Res>? get discardFailure;

}
/// @nodoc
class _$MeasurementStateCopyWithImpl<$Res>
    implements $MeasurementStateCopyWith<$Res> {
  _$MeasurementStateCopyWithImpl(this._self, this._then);

  final MeasurementState _self;
  final $Res Function(MeasurementState) _then;

/// Create a copy of MeasurementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? load = null,Object? baseline = freezed,Object? checkIn = freezed,Object? form = null,Object? bmi = freezed,Object? habitsExpanded = null,Object? biochemistryExpanded = null,Object? problems = null,Object? isSaving = null,Object? saveFailure = freezed,Object? showExitDialog = null,Object? showDiscardDialog = null,Object? isDiscarding = null,Object? discardFailure = freezed,}) {
  return _then(MeasurementState(
load: null == load ? _self.load : load // ignore: cast_nullable_to_non_nullable
as StepLoadState,baseline: freezed == baseline ? _self.baseline : baseline // ignore: cast_nullable_to_non_nullable
as BaselineSummary?,checkIn: freezed == checkIn ? _self.checkIn : checkIn // ignore: cast_nullable_to_non_nullable
as PatientCheckIn?,form: null == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as MeasurementForm,bmi: freezed == bmi ? _self.bmi : bmi // ignore: cast_nullable_to_non_nullable
as double?,habitsExpanded: null == habitsExpanded ? _self.habitsExpanded : habitsExpanded // ignore: cast_nullable_to_non_nullable
as bool,biochemistryExpanded: null == biochemistryExpanded ? _self.biochemistryExpanded : biochemistryExpanded // ignore: cast_nullable_to_non_nullable
as bool,problems: null == problems ? _self.problems : problems // ignore: cast_nullable_to_non_nullable
as Map<MeasurementField, FieldProblem>,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,saveFailure: freezed == saveFailure ? _self.saveFailure : saveFailure // ignore: cast_nullable_to_non_nullable
as SaveFailure?,showExitDialog: null == showExitDialog ? _self.showExitDialog : showExitDialog // ignore: cast_nullable_to_non_nullable
as bool,showDiscardDialog: null == showDiscardDialog ? _self.showDiscardDialog : showDiscardDialog // ignore: cast_nullable_to_non_nullable
as bool,isDiscarding: null == isDiscarding ? _self.isDiscarding : isDiscarding // ignore: cast_nullable_to_non_nullable
as bool,discardFailure: freezed == discardFailure ? _self.discardFailure : discardFailure // ignore: cast_nullable_to_non_nullable
as SaveFailure?,
  ));
}
/// Create a copy of MeasurementState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StepLoadStateCopyWith<$Res> get load {
  
  return $StepLoadStateCopyWith<$Res>(_self.load, (value) {
    return _then(_self.copyWith(load: value));
  });
}/// Create a copy of MeasurementState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SaveFailureCopyWith<$Res>? get saveFailure {
    if (_self.saveFailure == null) {
    return null;
  }

  return $SaveFailureCopyWith<$Res>(_self.saveFailure!, (value) {
    return _then(_self.copyWith(saveFailure: value));
  });
}/// Create a copy of MeasurementState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SaveFailureCopyWith<$Res>? get discardFailure {
    if (_self.discardFailure == null) {
    return null;
  }

  return $SaveFailureCopyWith<$Res>(_self.discardFailure!, (value) {
    return _then(_self.copyWith(discardFailure: value));
  });
}
}


/// Adds pattern-matching-related methods to [MeasurementState].
extension MeasurementStatePatterns on MeasurementState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeasurementState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeasurementState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeasurementState value)  $default,){
final _that = this;
switch (_that) {
case _MeasurementState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeasurementState value)?  $default,){
final _that = this;
switch (_that) {
case _MeasurementState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StepLoadState load,  BaselineSummary? baseline,  PatientCheckIn? checkIn,  MeasurementForm form,  double? bmi,  bool habitsExpanded,  bool biochemistryExpanded,  Map<MeasurementField, FieldProblem> problems,  bool isSaving,  SaveFailure? saveFailure,  bool showExitDialog,  bool showDiscardDialog,  bool isDiscarding,  SaveFailure? discardFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeasurementState() when $default != null:
return $default(_that.load,_that.baseline,_that.checkIn,_that.form,_that.bmi,_that.habitsExpanded,_that.biochemistryExpanded,_that.problems,_that.isSaving,_that.saveFailure,_that.showExitDialog,_that.showDiscardDialog,_that.isDiscarding,_that.discardFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StepLoadState load,  BaselineSummary? baseline,  PatientCheckIn? checkIn,  MeasurementForm form,  double? bmi,  bool habitsExpanded,  bool biochemistryExpanded,  Map<MeasurementField, FieldProblem> problems,  bool isSaving,  SaveFailure? saveFailure,  bool showExitDialog,  bool showDiscardDialog,  bool isDiscarding,  SaveFailure? discardFailure)  $default,) {final _that = this;
switch (_that) {
case _MeasurementState():
return $default(_that.load,_that.baseline,_that.checkIn,_that.form,_that.bmi,_that.habitsExpanded,_that.biochemistryExpanded,_that.problems,_that.isSaving,_that.saveFailure,_that.showExitDialog,_that.showDiscardDialog,_that.isDiscarding,_that.discardFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StepLoadState load,  BaselineSummary? baseline,  PatientCheckIn? checkIn,  MeasurementForm form,  double? bmi,  bool habitsExpanded,  bool biochemistryExpanded,  Map<MeasurementField, FieldProblem> problems,  bool isSaving,  SaveFailure? saveFailure,  bool showExitDialog,  bool showDiscardDialog,  bool isDiscarding,  SaveFailure? discardFailure)?  $default,) {final _that = this;
switch (_that) {
case _MeasurementState() when $default != null:
return $default(_that.load,_that.baseline,_that.checkIn,_that.form,_that.bmi,_that.habitsExpanded,_that.biochemistryExpanded,_that.problems,_that.isSaving,_that.saveFailure,_that.showExitDialog,_that.showDiscardDialog,_that.isDiscarding,_that.discardFailure);case _:
  return null;

}
}

}

/// @nodoc


class _MeasurementState implements MeasurementState {
  const _MeasurementState({this.load = const StepLoadState(), this.baseline, this.checkIn, this.form = const MeasurementForm(), this.bmi, this.habitsExpanded = false, this.biochemistryExpanded = false,  Map<MeasurementField, FieldProblem> problems = const {}, this.isSaving = false, this.saveFailure, this.showExitDialog = false, this.showDiscardDialog = false, this.isDiscarding = false, this.discardFailure}): _problems = problems;
  

@override@JsonKey() final  StepLoadState load;
@override final  BaselineSummary? baseline;
@override final  PatientCheckIn? checkIn;
@override@JsonKey() final  MeasurementForm form;
/// Live BMI from the typed weight and the baseline height.
@override final  double? bmi;
@override@JsonKey() final  bool habitsExpanded;
@override@JsonKey() final  bool biochemistryExpanded;
 final  Map<MeasurementField, FieldProblem> _problems;
@override@JsonKey() Map<MeasurementField, FieldProblem> get problems {
  if (_problems is EqualUnmodifiableMapView) return _problems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_problems);
}

@override@JsonKey() final  bool isSaving;
@override final  SaveFailure? saveFailure;
@override@JsonKey() final  bool showExitDialog;
/// "Delete consultation" (trash can): confirmation dialog, deletion in progress and failure with "Retry".
@override@JsonKey() final  bool showDiscardDialog;
@override@JsonKey() final  bool isDiscarding;
@override final  SaveFailure? discardFailure;

/// Create a copy of MeasurementState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeasurementStateCopyWith<_MeasurementState> get copyWith => __$MeasurementStateCopyWithImpl<_MeasurementState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeasurementState&&(identical(other.load, load) || other.load == load)&&(identical(other.baseline, baseline) || other.baseline == baseline)&&(identical(other.checkIn, checkIn) || other.checkIn == checkIn)&&(identical(other.form, form) || other.form == form)&&(identical(other.bmi, bmi) || other.bmi == bmi)&&(identical(other.habitsExpanded, habitsExpanded) || other.habitsExpanded == habitsExpanded)&&(identical(other.biochemistryExpanded, biochemistryExpanded) || other.biochemistryExpanded == biochemistryExpanded)&&const DeepCollectionEquality().equals(other.problems, _problems)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.saveFailure, saveFailure) || other.saveFailure == saveFailure)&&(identical(other.showExitDialog, showExitDialog) || other.showExitDialog == showExitDialog)&&(identical(other.showDiscardDialog, showDiscardDialog) || other.showDiscardDialog == showDiscardDialog)&&(identical(other.isDiscarding, isDiscarding) || other.isDiscarding == isDiscarding)&&(identical(other.discardFailure, discardFailure) || other.discardFailure == discardFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,load,baseline,checkIn,form,bmi,habitsExpanded,biochemistryExpanded,const DeepCollectionEquality().hash(_problems),isSaving,saveFailure,showExitDialog,showDiscardDialog,isDiscarding,discardFailure);
}

@override
String toString() {
    return 'MeasurementState(load: $load, baseline: $baseline, checkIn: $checkIn, form: $form, bmi: $bmi, habitsExpanded: $habitsExpanded, biochemistryExpanded: $biochemistryExpanded, problems: $problems, isSaving: $isSaving, saveFailure: $saveFailure, showExitDialog: $showExitDialog, showDiscardDialog: $showDiscardDialog, isDiscarding: $isDiscarding, discardFailure: $discardFailure)';
}


}

/// @nodoc
abstract mixin class _$MeasurementStateCopyWith<$Res> implements $MeasurementStateCopyWith<$Res> {
  factory _$MeasurementStateCopyWith(_MeasurementState value, $Res Function(_MeasurementState) _then) = __$MeasurementStateCopyWithImpl;
@override @useResult
$Res call({
 StepLoadState load, BaselineSummary? baseline, PatientCheckIn? checkIn, MeasurementForm form, double? bmi, bool habitsExpanded, bool biochemistryExpanded, Map<MeasurementField, FieldProblem> problems, bool isSaving, SaveFailure? saveFailure, bool showExitDialog, bool showDiscardDialog, bool isDiscarding, SaveFailure? discardFailure
});


@override $StepLoadStateCopyWith<$Res> get load;@override $SaveFailureCopyWith<$Res>? get saveFailure;@override $SaveFailureCopyWith<$Res>? get discardFailure;

}
/// @nodoc
class __$MeasurementStateCopyWithImpl<$Res>
    implements _$MeasurementStateCopyWith<$Res> {
  __$MeasurementStateCopyWithImpl(this._self, this._then);

  final _MeasurementState _self;
  final $Res Function(_MeasurementState) _then;

/// Create a copy of MeasurementState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? load = null,Object? baseline = freezed,Object? checkIn = freezed,Object? form = null,Object? bmi = freezed,Object? habitsExpanded = null,Object? biochemistryExpanded = null,Object? problems = null,Object? isSaving = null,Object? saveFailure = freezed,Object? showExitDialog = null,Object? showDiscardDialog = null,Object? isDiscarding = null,Object? discardFailure = freezed,}) {
  return _then(_MeasurementState(
load: null == load ? _self.load : load // ignore: cast_nullable_to_non_nullable
as StepLoadState,baseline: freezed == baseline ? _self.baseline : baseline // ignore: cast_nullable_to_non_nullable
as BaselineSummary?,checkIn: freezed == checkIn ? _self.checkIn : checkIn // ignore: cast_nullable_to_non_nullable
as PatientCheckIn?,form: null == form ? _self.form : form // ignore: cast_nullable_to_non_nullable
as MeasurementForm,bmi: freezed == bmi ? _self.bmi : bmi // ignore: cast_nullable_to_non_nullable
as double?,habitsExpanded: null == habitsExpanded ? _self.habitsExpanded : habitsExpanded // ignore: cast_nullable_to_non_nullable
as bool,biochemistryExpanded: null == biochemistryExpanded ? _self.biochemistryExpanded : biochemistryExpanded // ignore: cast_nullable_to_non_nullable
as bool,problems: null == problems ? _self._problems : problems // ignore: cast_nullable_to_non_nullable
as Map<MeasurementField, FieldProblem>,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,saveFailure: freezed == saveFailure ? _self.saveFailure : saveFailure // ignore: cast_nullable_to_non_nullable
as SaveFailure?,showExitDialog: null == showExitDialog ? _self.showExitDialog : showExitDialog // ignore: cast_nullable_to_non_nullable
as bool,showDiscardDialog: null == showDiscardDialog ? _self.showDiscardDialog : showDiscardDialog // ignore: cast_nullable_to_non_nullable
as bool,isDiscarding: null == isDiscarding ? _self.isDiscarding : isDiscarding // ignore: cast_nullable_to_non_nullable
as bool,discardFailure: freezed == discardFailure ? _self.discardFailure : discardFailure // ignore: cast_nullable_to_non_nullable
as SaveFailure?,
  ));
}

/// Create a copy of MeasurementState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StepLoadStateCopyWith<$Res> get load {
  
  return $StepLoadStateCopyWith<$Res>(_self.load, (value) {
    return _then(_self.copyWith(load: value));
  });
}/// Create a copy of MeasurementState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SaveFailureCopyWith<$Res>? get saveFailure {
    if (_self.saveFailure == null) {
    return null;
  }

  return $SaveFailureCopyWith<$Res>(_self.saveFailure!, (value) {
    return _then(_self.copyWith(saveFailure: value));
  });
}/// Create a copy of MeasurementState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SaveFailureCopyWith<$Res>? get discardFailure {
    if (_self.discardFailure == null) {
    return null;
  }

  return $SaveFailureCopyWith<$Res>(_self.discardFailure!, (value) {
    return _then(_self.copyWith(discardFailure: value));
  });
}
}

/// @nodoc
mixin _$DiagnosisState {

 StepLoadState get load;/// The AI suggestion: `loading` can last up to a minute; `failed` keeps the closed list usable and offers "Retry".
 AiRequestStatus get suggestionStatus; DiagnosisSuggestion? get suggestion; DiagnosisCode? get selected;/// `true` if the choice is the suggestion ("Use suggestion"); "Choose another" or tapping a chip turns it off.
 bool get usesSuggestion; bool get showRequired; bool get isSaving; SaveFailure? get saveFailure;
/// Create a copy of DiagnosisState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiagnosisStateCopyWith<DiagnosisState> get copyWith => _$DiagnosisStateCopyWithImpl<DiagnosisState>(this as DiagnosisState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DiagnosisState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiagnosisState&&(identical(other.load, _this.load) || other.load == _this.load)&&(identical(other.suggestionStatus, _this.suggestionStatus) || other.suggestionStatus == _this.suggestionStatus)&&(identical(other.suggestion, _this.suggestion) || other.suggestion == _this.suggestion)&&(identical(other.selected, _this.selected) || other.selected == _this.selected)&&(identical(other.usesSuggestion, _this.usesSuggestion) || other.usesSuggestion == _this.usesSuggestion)&&(identical(other.showRequired, _this.showRequired) || other.showRequired == _this.showRequired)&&(identical(other.isSaving, _this.isSaving) || other.isSaving == _this.isSaving)&&(identical(other.saveFailure, _this.saveFailure) || other.saveFailure == _this.saveFailure));
}


@override
int get hashCode {
  final _this = this as DiagnosisState;
  return Object.hash(runtimeType,_this.load,_this.suggestionStatus,_this.suggestion,_this.selected,_this.usesSuggestion,_this.showRequired,_this.isSaving,_this.saveFailure);
}

@override
String toString() {
  final _this = this as DiagnosisState;
  return 'DiagnosisState(load: ${_this.load}, suggestionStatus: ${_this.suggestionStatus}, suggestion: ${_this.suggestion}, selected: ${_this.selected}, usesSuggestion: ${_this.usesSuggestion}, showRequired: ${_this.showRequired}, isSaving: ${_this.isSaving}, saveFailure: ${_this.saveFailure})';
}


}

/// @nodoc
abstract mixin class $DiagnosisStateCopyWith<$Res>  {
  factory $DiagnosisStateCopyWith(DiagnosisState value, $Res Function(DiagnosisState) _then) = _$DiagnosisStateCopyWithImpl;
@useResult
$Res call({
 StepLoadState load, AiRequestStatus suggestionStatus, DiagnosisSuggestion? suggestion, DiagnosisCode? selected, bool usesSuggestion, bool showRequired, bool isSaving, SaveFailure? saveFailure
});


$StepLoadStateCopyWith<$Res> get load;$SaveFailureCopyWith<$Res>? get saveFailure;

}
/// @nodoc
class _$DiagnosisStateCopyWithImpl<$Res>
    implements $DiagnosisStateCopyWith<$Res> {
  _$DiagnosisStateCopyWithImpl(this._self, this._then);

  final DiagnosisState _self;
  final $Res Function(DiagnosisState) _then;

/// Create a copy of DiagnosisState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? load = null,Object? suggestionStatus = null,Object? suggestion = freezed,Object? selected = freezed,Object? usesSuggestion = null,Object? showRequired = null,Object? isSaving = null,Object? saveFailure = freezed,}) {
  return _then(DiagnosisState(
load: null == load ? _self.load : load // ignore: cast_nullable_to_non_nullable
as StepLoadState,suggestionStatus: null == suggestionStatus ? _self.suggestionStatus : suggestionStatus // ignore: cast_nullable_to_non_nullable
as AiRequestStatus,suggestion: freezed == suggestion ? _self.suggestion : suggestion // ignore: cast_nullable_to_non_nullable
as DiagnosisSuggestion?,selected: freezed == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as DiagnosisCode?,usesSuggestion: null == usesSuggestion ? _self.usesSuggestion : usesSuggestion // ignore: cast_nullable_to_non_nullable
as bool,showRequired: null == showRequired ? _self.showRequired : showRequired // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,saveFailure: freezed == saveFailure ? _self.saveFailure : saveFailure // ignore: cast_nullable_to_non_nullable
as SaveFailure?,
  ));
}
/// Create a copy of DiagnosisState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StepLoadStateCopyWith<$Res> get load {
  
  return $StepLoadStateCopyWith<$Res>(_self.load, (value) {
    return _then(_self.copyWith(load: value));
  });
}/// Create a copy of DiagnosisState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SaveFailureCopyWith<$Res>? get saveFailure {
    if (_self.saveFailure == null) {
    return null;
  }

  return $SaveFailureCopyWith<$Res>(_self.saveFailure!, (value) {
    return _then(_self.copyWith(saveFailure: value));
  });
}
}


/// Adds pattern-matching-related methods to [DiagnosisState].
extension DiagnosisStatePatterns on DiagnosisState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiagnosisState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiagnosisState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiagnosisState value)  $default,){
final _that = this;
switch (_that) {
case _DiagnosisState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiagnosisState value)?  $default,){
final _that = this;
switch (_that) {
case _DiagnosisState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StepLoadState load,  AiRequestStatus suggestionStatus,  DiagnosisSuggestion? suggestion,  DiagnosisCode? selected,  bool usesSuggestion,  bool showRequired,  bool isSaving,  SaveFailure? saveFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiagnosisState() when $default != null:
return $default(_that.load,_that.suggestionStatus,_that.suggestion,_that.selected,_that.usesSuggestion,_that.showRequired,_that.isSaving,_that.saveFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StepLoadState load,  AiRequestStatus suggestionStatus,  DiagnosisSuggestion? suggestion,  DiagnosisCode? selected,  bool usesSuggestion,  bool showRequired,  bool isSaving,  SaveFailure? saveFailure)  $default,) {final _that = this;
switch (_that) {
case _DiagnosisState():
return $default(_that.load,_that.suggestionStatus,_that.suggestion,_that.selected,_that.usesSuggestion,_that.showRequired,_that.isSaving,_that.saveFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StepLoadState load,  AiRequestStatus suggestionStatus,  DiagnosisSuggestion? suggestion,  DiagnosisCode? selected,  bool usesSuggestion,  bool showRequired,  bool isSaving,  SaveFailure? saveFailure)?  $default,) {final _that = this;
switch (_that) {
case _DiagnosisState() when $default != null:
return $default(_that.load,_that.suggestionStatus,_that.suggestion,_that.selected,_that.usesSuggestion,_that.showRequired,_that.isSaving,_that.saveFailure);case _:
  return null;

}
}

}

/// @nodoc


class _DiagnosisState implements DiagnosisState {
  const _DiagnosisState({this.load = const StepLoadState(), this.suggestionStatus = AiRequestStatus.idle, this.suggestion, this.selected, this.usesSuggestion = false, this.showRequired = false, this.isSaving = false, this.saveFailure});
  

@override@JsonKey() final  StepLoadState load;
/// The AI suggestion: `loading` can last up to a minute; `failed` keeps the closed list usable and offers "Retry".
@override@JsonKey() final  AiRequestStatus suggestionStatus;
@override final  DiagnosisSuggestion? suggestion;
@override final  DiagnosisCode? selected;
/// `true` if the choice is the suggestion ("Use suggestion"); "Choose another" or tapping a chip turns it off.
@override@JsonKey() final  bool usesSuggestion;
@override@JsonKey() final  bool showRequired;
@override@JsonKey() final  bool isSaving;
@override final  SaveFailure? saveFailure;

/// Create a copy of DiagnosisState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiagnosisStateCopyWith<_DiagnosisState> get copyWith => __$DiagnosisStateCopyWithImpl<_DiagnosisState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiagnosisState&&(identical(other.load, load) || other.load == load)&&(identical(other.suggestionStatus, suggestionStatus) || other.suggestionStatus == suggestionStatus)&&(identical(other.suggestion, suggestion) || other.suggestion == suggestion)&&(identical(other.selected, selected) || other.selected == selected)&&(identical(other.usesSuggestion, usesSuggestion) || other.usesSuggestion == usesSuggestion)&&(identical(other.showRequired, showRequired) || other.showRequired == showRequired)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.saveFailure, saveFailure) || other.saveFailure == saveFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,load,suggestionStatus,suggestion,selected,usesSuggestion,showRequired,isSaving,saveFailure);
}

@override
String toString() {
    return 'DiagnosisState(load: $load, suggestionStatus: $suggestionStatus, suggestion: $suggestion, selected: $selected, usesSuggestion: $usesSuggestion, showRequired: $showRequired, isSaving: $isSaving, saveFailure: $saveFailure)';
}


}

/// @nodoc
abstract mixin class _$DiagnosisStateCopyWith<$Res> implements $DiagnosisStateCopyWith<$Res> {
  factory _$DiagnosisStateCopyWith(_DiagnosisState value, $Res Function(_DiagnosisState) _then) = __$DiagnosisStateCopyWithImpl;
@override @useResult
$Res call({
 StepLoadState load, AiRequestStatus suggestionStatus, DiagnosisSuggestion? suggestion, DiagnosisCode? selected, bool usesSuggestion, bool showRequired, bool isSaving, SaveFailure? saveFailure
});


@override $StepLoadStateCopyWith<$Res> get load;@override $SaveFailureCopyWith<$Res>? get saveFailure;

}
/// @nodoc
class __$DiagnosisStateCopyWithImpl<$Res>
    implements _$DiagnosisStateCopyWith<$Res> {
  __$DiagnosisStateCopyWithImpl(this._self, this._then);

  final _DiagnosisState _self;
  final $Res Function(_DiagnosisState) _then;

/// Create a copy of DiagnosisState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? load = null,Object? suggestionStatus = null,Object? suggestion = freezed,Object? selected = freezed,Object? usesSuggestion = null,Object? showRequired = null,Object? isSaving = null,Object? saveFailure = freezed,}) {
  return _then(_DiagnosisState(
load: null == load ? _self.load : load // ignore: cast_nullable_to_non_nullable
as StepLoadState,suggestionStatus: null == suggestionStatus ? _self.suggestionStatus : suggestionStatus // ignore: cast_nullable_to_non_nullable
as AiRequestStatus,suggestion: freezed == suggestion ? _self.suggestion : suggestion // ignore: cast_nullable_to_non_nullable
as DiagnosisSuggestion?,selected: freezed == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as DiagnosisCode?,usesSuggestion: null == usesSuggestion ? _self.usesSuggestion : usesSuggestion // ignore: cast_nullable_to_non_nullable
as bool,showRequired: null == showRequired ? _self.showRequired : showRequired // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,saveFailure: freezed == saveFailure ? _self.saveFailure : saveFailure // ignore: cast_nullable_to_non_nullable
as SaveFailure?,
  ));
}

/// Create a copy of DiagnosisState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StepLoadStateCopyWith<$Res> get load {
  
  return $StepLoadStateCopyWith<$Res>(_self.load, (value) {
    return _then(_self.copyWith(load: value));
  });
}/// Create a copy of DiagnosisState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SaveFailureCopyWith<$Res>? get saveFailure {
    if (_self.saveFailure == null) {
    return null;
  }

  return $SaveFailureCopyWith<$Res>(_self.saveFailure!, (value) {
    return _then(_self.copyWith(saveFailure: value));
  });
}
}

/// @nodoc
mixin _$ParametersForm {

 EnergyEquation get equation; DeficitKind get deficitKind; String get deficit; String get proteinPerKg; String get fatPercent;
/// Create a copy of ParametersForm
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParametersFormCopyWith<ParametersForm> get copyWith => _$ParametersFormCopyWithImpl<ParametersForm>(this as ParametersForm, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ParametersForm;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParametersForm&&(identical(other.equation, _this.equation) || other.equation == _this.equation)&&(identical(other.deficitKind, _this.deficitKind) || other.deficitKind == _this.deficitKind)&&(identical(other.deficit, _this.deficit) || other.deficit == _this.deficit)&&(identical(other.proteinPerKg, _this.proteinPerKg) || other.proteinPerKg == _this.proteinPerKg)&&(identical(other.fatPercent, _this.fatPercent) || other.fatPercent == _this.fatPercent));
}


@override
int get hashCode {
  final _this = this as ParametersForm;
  return Object.hash(runtimeType,_this.equation,_this.deficitKind,_this.deficit,_this.proteinPerKg,_this.fatPercent);
}

@override
String toString() {
  final _this = this as ParametersForm;
  return 'ParametersForm(equation: ${_this.equation}, deficitKind: ${_this.deficitKind}, deficit: ${_this.deficit}, proteinPerKg: ${_this.proteinPerKg}, fatPercent: ${_this.fatPercent})';
}


}

/// @nodoc
abstract mixin class $ParametersFormCopyWith<$Res>  {
  factory $ParametersFormCopyWith(ParametersForm value, $Res Function(ParametersForm) _then) = _$ParametersFormCopyWithImpl;
@useResult
$Res call({
 EnergyEquation equation, DeficitKind deficitKind, String deficit, String proteinPerKg, String fatPercent
});




}
/// @nodoc
class _$ParametersFormCopyWithImpl<$Res>
    implements $ParametersFormCopyWith<$Res> {
  _$ParametersFormCopyWithImpl(this._self, this._then);

  final ParametersForm _self;
  final $Res Function(ParametersForm) _then;

/// Create a copy of ParametersForm
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? equation = null,Object? deficitKind = null,Object? deficit = null,Object? proteinPerKg = null,Object? fatPercent = null,}) {
  return _then(ParametersForm(
equation: null == equation ? _self.equation : equation // ignore: cast_nullable_to_non_nullable
as EnergyEquation,deficitKind: null == deficitKind ? _self.deficitKind : deficitKind // ignore: cast_nullable_to_non_nullable
as DeficitKind,deficit: null == deficit ? _self.deficit : deficit // ignore: cast_nullable_to_non_nullable
as String,proteinPerKg: null == proteinPerKg ? _self.proteinPerKg : proteinPerKg // ignore: cast_nullable_to_non_nullable
as String,fatPercent: null == fatPercent ? _self.fatPercent : fatPercent // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ParametersForm].
extension ParametersFormPatterns on ParametersForm {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParametersForm value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParametersForm() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParametersForm value)  $default,){
final _that = this;
switch (_that) {
case _ParametersForm():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParametersForm value)?  $default,){
final _that = this;
switch (_that) {
case _ParametersForm() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( EnergyEquation equation,  DeficitKind deficitKind,  String deficit,  String proteinPerKg,  String fatPercent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParametersForm() when $default != null:
return $default(_that.equation,_that.deficitKind,_that.deficit,_that.proteinPerKg,_that.fatPercent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( EnergyEquation equation,  DeficitKind deficitKind,  String deficit,  String proteinPerKg,  String fatPercent)  $default,) {final _that = this;
switch (_that) {
case _ParametersForm():
return $default(_that.equation,_that.deficitKind,_that.deficit,_that.proteinPerKg,_that.fatPercent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( EnergyEquation equation,  DeficitKind deficitKind,  String deficit,  String proteinPerKg,  String fatPercent)?  $default,) {final _that = this;
switch (_that) {
case _ParametersForm() when $default != null:
return $default(_that.equation,_that.deficitKind,_that.deficit,_that.proteinPerKg,_that.fatPercent);case _:
  return null;

}
}

}

/// @nodoc


class _ParametersForm implements ParametersForm {
  const _ParametersForm({this.equation = EnergyEquation.mifflinStJeor, this.deficitKind = DeficitKind.fixedKcal, this.deficit = '', this.proteinPerKg = '', this.fatPercent = ''});
  

@override@JsonKey() final  EnergyEquation equation;
@override@JsonKey() final  DeficitKind deficitKind;
@override@JsonKey() final  String deficit;
@override@JsonKey() final  String proteinPerKg;
@override@JsonKey() final  String fatPercent;

/// Create a copy of ParametersForm
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParametersFormCopyWith<_ParametersForm> get copyWith => __$ParametersFormCopyWithImpl<_ParametersForm>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParametersForm&&(identical(other.equation, equation) || other.equation == equation)&&(identical(other.deficitKind, deficitKind) || other.deficitKind == deficitKind)&&(identical(other.deficit, deficit) || other.deficit == deficit)&&(identical(other.proteinPerKg, proteinPerKg) || other.proteinPerKg == proteinPerKg)&&(identical(other.fatPercent, fatPercent) || other.fatPercent == fatPercent));
}


@override
int get hashCode {
    return Object.hash(runtimeType,equation,deficitKind,deficit,proteinPerKg,fatPercent);
}

@override
String toString() {
    return 'ParametersForm(equation: $equation, deficitKind: $deficitKind, deficit: $deficit, proteinPerKg: $proteinPerKg, fatPercent: $fatPercent)';
}


}

/// @nodoc
abstract mixin class _$ParametersFormCopyWith<$Res> implements $ParametersFormCopyWith<$Res> {
  factory _$ParametersFormCopyWith(_ParametersForm value, $Res Function(_ParametersForm) _then) = __$ParametersFormCopyWithImpl;
@override @useResult
$Res call({
 EnergyEquation equation, DeficitKind deficitKind, String deficit, String proteinPerKg, String fatPercent
});




}
/// @nodoc
class __$ParametersFormCopyWithImpl<$Res>
    implements _$ParametersFormCopyWith<$Res> {
  __$ParametersFormCopyWithImpl(this._self, this._then);

  final _ParametersForm _self;
  final $Res Function(_ParametersForm) _then;

/// Create a copy of ParametersForm
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? equation = null,Object? deficitKind = null,Object? deficit = null,Object? proteinPerKg = null,Object? fatPercent = null,}) {
  return _then(_ParametersForm(
equation: null == equation ? _self.equation : equation // ignore: cast_nullable_to_non_nullable
as EnergyEquation,deficitKind: null == deficitKind ? _self.deficitKind : deficitKind // ignore: cast_nullable_to_non_nullable
as DeficitKind,deficit: null == deficit ? _self.deficit : deficit // ignore: cast_nullable_to_non_nullable
as String,proteinPerKg: null == proteinPerKg ? _self.proteinPerKg : proteinPerKg // ignore: cast_nullable_to_non_nullable
as String,fatPercent: null == fatPercent ? _self.fatPercent : fatPercent // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$OverrideForm {

 String get energy; String get protein; String get carb; String get fat; String get reason;
/// Create a copy of OverrideForm
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OverrideFormCopyWith<OverrideForm> get copyWith => _$OverrideFormCopyWithImpl<OverrideForm>(this as OverrideForm, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OverrideForm;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OverrideForm&&(identical(other.energy, _this.energy) || other.energy == _this.energy)&&(identical(other.protein, _this.protein) || other.protein == _this.protein)&&(identical(other.carb, _this.carb) || other.carb == _this.carb)&&(identical(other.fat, _this.fat) || other.fat == _this.fat)&&(identical(other.reason, _this.reason) || other.reason == _this.reason));
}


@override
int get hashCode {
  final _this = this as OverrideForm;
  return Object.hash(runtimeType,_this.energy,_this.protein,_this.carb,_this.fat,_this.reason);
}

@override
String toString() {
  final _this = this as OverrideForm;
  return 'OverrideForm(energy: ${_this.energy}, protein: ${_this.protein}, carb: ${_this.carb}, fat: ${_this.fat}, reason: ${_this.reason})';
}


}

/// @nodoc
abstract mixin class $OverrideFormCopyWith<$Res>  {
  factory $OverrideFormCopyWith(OverrideForm value, $Res Function(OverrideForm) _then) = _$OverrideFormCopyWithImpl;
@useResult
$Res call({
 String energy, String protein, String carb, String fat, String reason
});




}
/// @nodoc
class _$OverrideFormCopyWithImpl<$Res>
    implements $OverrideFormCopyWith<$Res> {
  _$OverrideFormCopyWithImpl(this._self, this._then);

  final OverrideForm _self;
  final $Res Function(OverrideForm) _then;

/// Create a copy of OverrideForm
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? energy = null,Object? protein = null,Object? carb = null,Object? fat = null,Object? reason = null,}) {
  return _then(OverrideForm(
energy: null == energy ? _self.energy : energy // ignore: cast_nullable_to_non_nullable
as String,protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as String,carb: null == carb ? _self.carb : carb // ignore: cast_nullable_to_non_nullable
as String,fat: null == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OverrideForm].
extension OverrideFormPatterns on OverrideForm {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OverrideForm value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OverrideForm() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OverrideForm value)  $default,){
final _that = this;
switch (_that) {
case _OverrideForm():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OverrideForm value)?  $default,){
final _that = this;
switch (_that) {
case _OverrideForm() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String energy,  String protein,  String carb,  String fat,  String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OverrideForm() when $default != null:
return $default(_that.energy,_that.protein,_that.carb,_that.fat,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String energy,  String protein,  String carb,  String fat,  String reason)  $default,) {final _that = this;
switch (_that) {
case _OverrideForm():
return $default(_that.energy,_that.protein,_that.carb,_that.fat,_that.reason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String energy,  String protein,  String carb,  String fat,  String reason)?  $default,) {final _that = this;
switch (_that) {
case _OverrideForm() when $default != null:
return $default(_that.energy,_that.protein,_that.carb,_that.fat,_that.reason);case _:
  return null;

}
}

}

/// @nodoc


class _OverrideForm implements OverrideForm {
  const _OverrideForm({this.energy = '', this.protein = '', this.carb = '', this.fat = '', this.reason = ''});
  

@override@JsonKey() final  String energy;
@override@JsonKey() final  String protein;
@override@JsonKey() final  String carb;
@override@JsonKey() final  String fat;
@override@JsonKey() final  String reason;

/// Create a copy of OverrideForm
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OverrideFormCopyWith<_OverrideForm> get copyWith => __$OverrideFormCopyWithImpl<_OverrideForm>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OverrideForm&&(identical(other.energy, energy) || other.energy == energy)&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.carb, carb) || other.carb == carb)&&(identical(other.fat, fat) || other.fat == fat)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode {
    return Object.hash(runtimeType,energy,protein,carb,fat,reason);
}

@override
String toString() {
    return 'OverrideForm(energy: $energy, protein: $protein, carb: $carb, fat: $fat, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$OverrideFormCopyWith<$Res> implements $OverrideFormCopyWith<$Res> {
  factory _$OverrideFormCopyWith(_OverrideForm value, $Res Function(_OverrideForm) _then) = __$OverrideFormCopyWithImpl;
@override @useResult
$Res call({
 String energy, String protein, String carb, String fat, String reason
});




}
/// @nodoc
class __$OverrideFormCopyWithImpl<$Res>
    implements _$OverrideFormCopyWith<$Res> {
  __$OverrideFormCopyWithImpl(this._self, this._then);

  final _OverrideForm _self;
  final $Res Function(_OverrideForm) _then;

/// Create a copy of OverrideForm
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? energy = null,Object? protein = null,Object? carb = null,Object? fat = null,Object? reason = null,}) {
  return _then(_OverrideForm(
energy: null == energy ? _self.energy : energy // ignore: cast_nullable_to_non_nullable
as String,protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as String,carb: null == carb ? _self.carb : carb // ignore: cast_nullable_to_non_nullable
as String,fat: null == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$TargetsState {

 StepLoadState get load; bool get isCalculating; TargetProposal? get proposal; bool get proposalFailed; bool get showParameters; ParametersForm? get parameters; bool get parametersInvalid; bool get showOverride; OverrideForm get ownValues; Set<OverrideField> get overrideProblems; bool get isSaving; SaveFailure? get saveFailure;
/// Create a copy of TargetsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TargetsStateCopyWith<TargetsState> get copyWith => _$TargetsStateCopyWithImpl<TargetsState>(this as TargetsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TargetsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TargetsState&&(identical(other.load, _this.load) || other.load == _this.load)&&(identical(other.isCalculating, _this.isCalculating) || other.isCalculating == _this.isCalculating)&&(identical(other.proposal, _this.proposal) || other.proposal == _this.proposal)&&(identical(other.proposalFailed, _this.proposalFailed) || other.proposalFailed == _this.proposalFailed)&&(identical(other.showParameters, _this.showParameters) || other.showParameters == _this.showParameters)&&(identical(other.parameters, _this.parameters) || other.parameters == _this.parameters)&&(identical(other.parametersInvalid, _this.parametersInvalid) || other.parametersInvalid == _this.parametersInvalid)&&(identical(other.showOverride, _this.showOverride) || other.showOverride == _this.showOverride)&&(identical(other.ownValues, _this.ownValues) || other.ownValues == _this.ownValues)&&const DeepCollectionEquality().equals(other.overrideProblems, _this.overrideProblems)&&(identical(other.isSaving, _this.isSaving) || other.isSaving == _this.isSaving)&&(identical(other.saveFailure, _this.saveFailure) || other.saveFailure == _this.saveFailure));
}


@override
int get hashCode {
  final _this = this as TargetsState;
  return Object.hash(runtimeType,_this.load,_this.isCalculating,_this.proposal,_this.proposalFailed,_this.showParameters,_this.parameters,_this.parametersInvalid,_this.showOverride,_this.ownValues,const DeepCollectionEquality().hash(_this.overrideProblems),_this.isSaving,_this.saveFailure);
}

@override
String toString() {
  final _this = this as TargetsState;
  return 'TargetsState(load: ${_this.load}, isCalculating: ${_this.isCalculating}, proposal: ${_this.proposal}, proposalFailed: ${_this.proposalFailed}, showParameters: ${_this.showParameters}, parameters: ${_this.parameters}, parametersInvalid: ${_this.parametersInvalid}, showOverride: ${_this.showOverride}, ownValues: ${_this.ownValues}, overrideProblems: ${_this.overrideProblems}, isSaving: ${_this.isSaving}, saveFailure: ${_this.saveFailure})';
}


}

/// @nodoc
abstract mixin class $TargetsStateCopyWith<$Res>  {
  factory $TargetsStateCopyWith(TargetsState value, $Res Function(TargetsState) _then) = _$TargetsStateCopyWithImpl;
@useResult
$Res call({
 StepLoadState load, bool isCalculating, TargetProposal? proposal, bool proposalFailed, bool showParameters, ParametersForm? parameters, bool parametersInvalid, bool showOverride, OverrideForm ownValues, Set<OverrideField> overrideProblems, bool isSaving, SaveFailure? saveFailure
});


$StepLoadStateCopyWith<$Res> get load;$ParametersFormCopyWith<$Res>? get parameters;$OverrideFormCopyWith<$Res> get ownValues;$SaveFailureCopyWith<$Res>? get saveFailure;

}
/// @nodoc
class _$TargetsStateCopyWithImpl<$Res>
    implements $TargetsStateCopyWith<$Res> {
  _$TargetsStateCopyWithImpl(this._self, this._then);

  final TargetsState _self;
  final $Res Function(TargetsState) _then;

/// Create a copy of TargetsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? load = null,Object? isCalculating = null,Object? proposal = freezed,Object? proposalFailed = null,Object? showParameters = null,Object? parameters = freezed,Object? parametersInvalid = null,Object? showOverride = null,Object? ownValues = null,Object? overrideProblems = null,Object? isSaving = null,Object? saveFailure = freezed,}) {
  return _then(TargetsState(
load: null == load ? _self.load : load // ignore: cast_nullable_to_non_nullable
as StepLoadState,isCalculating: null == isCalculating ? _self.isCalculating : isCalculating // ignore: cast_nullable_to_non_nullable
as bool,proposal: freezed == proposal ? _self.proposal : proposal // ignore: cast_nullable_to_non_nullable
as TargetProposal?,proposalFailed: null == proposalFailed ? _self.proposalFailed : proposalFailed // ignore: cast_nullable_to_non_nullable
as bool,showParameters: null == showParameters ? _self.showParameters : showParameters // ignore: cast_nullable_to_non_nullable
as bool,parameters: freezed == parameters ? _self.parameters : parameters // ignore: cast_nullable_to_non_nullable
as ParametersForm?,parametersInvalid: null == parametersInvalid ? _self.parametersInvalid : parametersInvalid // ignore: cast_nullable_to_non_nullable
as bool,showOverride: null == showOverride ? _self.showOverride : showOverride // ignore: cast_nullable_to_non_nullable
as bool,ownValues: null == ownValues ? _self.ownValues : ownValues // ignore: cast_nullable_to_non_nullable
as OverrideForm,overrideProblems: null == overrideProblems ? _self.overrideProblems : overrideProblems // ignore: cast_nullable_to_non_nullable
as Set<OverrideField>,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,saveFailure: freezed == saveFailure ? _self.saveFailure : saveFailure // ignore: cast_nullable_to_non_nullable
as SaveFailure?,
  ));
}
/// Create a copy of TargetsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StepLoadStateCopyWith<$Res> get load {
  
  return $StepLoadStateCopyWith<$Res>(_self.load, (value) {
    return _then(_self.copyWith(load: value));
  });
}/// Create a copy of TargetsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParametersFormCopyWith<$Res>? get parameters {
    if (_self.parameters == null) {
    return null;
  }

  return $ParametersFormCopyWith<$Res>(_self.parameters!, (value) {
    return _then(_self.copyWith(parameters: value));
  });
}/// Create a copy of TargetsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OverrideFormCopyWith<$Res> get ownValues {
  
  return $OverrideFormCopyWith<$Res>(_self.ownValues, (value) {
    return _then(_self.copyWith(ownValues: value));
  });
}/// Create a copy of TargetsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SaveFailureCopyWith<$Res>? get saveFailure {
    if (_self.saveFailure == null) {
    return null;
  }

  return $SaveFailureCopyWith<$Res>(_self.saveFailure!, (value) {
    return _then(_self.copyWith(saveFailure: value));
  });
}
}


/// Adds pattern-matching-related methods to [TargetsState].
extension TargetsStatePatterns on TargetsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TargetsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TargetsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TargetsState value)  $default,){
final _that = this;
switch (_that) {
case _TargetsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TargetsState value)?  $default,){
final _that = this;
switch (_that) {
case _TargetsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StepLoadState load,  bool isCalculating,  TargetProposal? proposal,  bool proposalFailed,  bool showParameters,  ParametersForm? parameters,  bool parametersInvalid,  bool showOverride,  OverrideForm ownValues,  Set<OverrideField> overrideProblems,  bool isSaving,  SaveFailure? saveFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TargetsState() when $default != null:
return $default(_that.load,_that.isCalculating,_that.proposal,_that.proposalFailed,_that.showParameters,_that.parameters,_that.parametersInvalid,_that.showOverride,_that.ownValues,_that.overrideProblems,_that.isSaving,_that.saveFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StepLoadState load,  bool isCalculating,  TargetProposal? proposal,  bool proposalFailed,  bool showParameters,  ParametersForm? parameters,  bool parametersInvalid,  bool showOverride,  OverrideForm ownValues,  Set<OverrideField> overrideProblems,  bool isSaving,  SaveFailure? saveFailure)  $default,) {final _that = this;
switch (_that) {
case _TargetsState():
return $default(_that.load,_that.isCalculating,_that.proposal,_that.proposalFailed,_that.showParameters,_that.parameters,_that.parametersInvalid,_that.showOverride,_that.ownValues,_that.overrideProblems,_that.isSaving,_that.saveFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StepLoadState load,  bool isCalculating,  TargetProposal? proposal,  bool proposalFailed,  bool showParameters,  ParametersForm? parameters,  bool parametersInvalid,  bool showOverride,  OverrideForm ownValues,  Set<OverrideField> overrideProblems,  bool isSaving,  SaveFailure? saveFailure)?  $default,) {final _that = this;
switch (_that) {
case _TargetsState() when $default != null:
return $default(_that.load,_that.isCalculating,_that.proposal,_that.proposalFailed,_that.showParameters,_that.parameters,_that.parametersInvalid,_that.showOverride,_that.ownValues,_that.overrideProblems,_that.isSaving,_that.saveFailure);case _:
  return null;

}
}

}

/// @nodoc


class _TargetsState implements TargetsState {
  const _TargetsState({this.load = const StepLoadState(), this.isCalculating = false, this.proposal, this.proposalFailed = false, this.showParameters = false, this.parameters, this.parametersInvalid = false, this.showOverride = false, this.ownValues = const OverrideForm(),  Set<OverrideField> overrideProblems = const {}, this.isSaving = false, this.saveFailure}): _overrideProblems = overrideProblems;
  

@override@JsonKey() final  StepLoadState load;
@override@JsonKey() final  bool isCalculating;
@override final  TargetProposal? proposal;
@override@JsonKey() final  bool proposalFailed;
@override@JsonKey() final  bool showParameters;
@override final  ParametersForm? parameters;
@override@JsonKey() final  bool parametersInvalid;
@override@JsonKey() final  bool showOverride;
@override@JsonKey() final  OverrideForm ownValues;
 final  Set<OverrideField> _overrideProblems;
@override@JsonKey() Set<OverrideField> get overrideProblems {
  if (_overrideProblems is EqualUnmodifiableSetView) return _overrideProblems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_overrideProblems);
}

@override@JsonKey() final  bool isSaving;
@override final  SaveFailure? saveFailure;

/// Create a copy of TargetsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TargetsStateCopyWith<_TargetsState> get copyWith => __$TargetsStateCopyWithImpl<_TargetsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TargetsState&&(identical(other.load, load) || other.load == load)&&(identical(other.isCalculating, isCalculating) || other.isCalculating == isCalculating)&&(identical(other.proposal, proposal) || other.proposal == proposal)&&(identical(other.proposalFailed, proposalFailed) || other.proposalFailed == proposalFailed)&&(identical(other.showParameters, showParameters) || other.showParameters == showParameters)&&(identical(other.parameters, parameters) || other.parameters == parameters)&&(identical(other.parametersInvalid, parametersInvalid) || other.parametersInvalid == parametersInvalid)&&(identical(other.showOverride, showOverride) || other.showOverride == showOverride)&&(identical(other.ownValues, ownValues) || other.ownValues == ownValues)&&const DeepCollectionEquality().equals(other.overrideProblems, _overrideProblems)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.saveFailure, saveFailure) || other.saveFailure == saveFailure));
}


@override
int get hashCode {
    return Object.hash(runtimeType,load,isCalculating,proposal,proposalFailed,showParameters,parameters,parametersInvalid,showOverride,ownValues,const DeepCollectionEquality().hash(_overrideProblems),isSaving,saveFailure);
}

@override
String toString() {
    return 'TargetsState(load: $load, isCalculating: $isCalculating, proposal: $proposal, proposalFailed: $proposalFailed, showParameters: $showParameters, parameters: $parameters, parametersInvalid: $parametersInvalid, showOverride: $showOverride, ownValues: $ownValues, overrideProblems: $overrideProblems, isSaving: $isSaving, saveFailure: $saveFailure)';
}


}

/// @nodoc
abstract mixin class _$TargetsStateCopyWith<$Res> implements $TargetsStateCopyWith<$Res> {
  factory _$TargetsStateCopyWith(_TargetsState value, $Res Function(_TargetsState) _then) = __$TargetsStateCopyWithImpl;
@override @useResult
$Res call({
 StepLoadState load, bool isCalculating, TargetProposal? proposal, bool proposalFailed, bool showParameters, ParametersForm? parameters, bool parametersInvalid, bool showOverride, OverrideForm ownValues, Set<OverrideField> overrideProblems, bool isSaving, SaveFailure? saveFailure
});


@override $StepLoadStateCopyWith<$Res> get load;@override $ParametersFormCopyWith<$Res>? get parameters;@override $OverrideFormCopyWith<$Res> get ownValues;@override $SaveFailureCopyWith<$Res>? get saveFailure;

}
/// @nodoc
class __$TargetsStateCopyWithImpl<$Res>
    implements _$TargetsStateCopyWith<$Res> {
  __$TargetsStateCopyWithImpl(this._self, this._then);

  final _TargetsState _self;
  final $Res Function(_TargetsState) _then;

/// Create a copy of TargetsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? load = null,Object? isCalculating = null,Object? proposal = freezed,Object? proposalFailed = null,Object? showParameters = null,Object? parameters = freezed,Object? parametersInvalid = null,Object? showOverride = null,Object? ownValues = null,Object? overrideProblems = null,Object? isSaving = null,Object? saveFailure = freezed,}) {
  return _then(_TargetsState(
load: null == load ? _self.load : load // ignore: cast_nullable_to_non_nullable
as StepLoadState,isCalculating: null == isCalculating ? _self.isCalculating : isCalculating // ignore: cast_nullable_to_non_nullable
as bool,proposal: freezed == proposal ? _self.proposal : proposal // ignore: cast_nullable_to_non_nullable
as TargetProposal?,proposalFailed: null == proposalFailed ? _self.proposalFailed : proposalFailed // ignore: cast_nullable_to_non_nullable
as bool,showParameters: null == showParameters ? _self.showParameters : showParameters // ignore: cast_nullable_to_non_nullable
as bool,parameters: freezed == parameters ? _self.parameters : parameters // ignore: cast_nullable_to_non_nullable
as ParametersForm?,parametersInvalid: null == parametersInvalid ? _self.parametersInvalid : parametersInvalid // ignore: cast_nullable_to_non_nullable
as bool,showOverride: null == showOverride ? _self.showOverride : showOverride // ignore: cast_nullable_to_non_nullable
as bool,ownValues: null == ownValues ? _self.ownValues : ownValues // ignore: cast_nullable_to_non_nullable
as OverrideForm,overrideProblems: null == overrideProblems ? _self._overrideProblems : overrideProblems // ignore: cast_nullable_to_non_nullable
as Set<OverrideField>,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,saveFailure: freezed == saveFailure ? _self.saveFailure : saveFailure // ignore: cast_nullable_to_non_nullable
as SaveFailure?,
  ));
}

/// Create a copy of TargetsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StepLoadStateCopyWith<$Res> get load {
  
  return $StepLoadStateCopyWith<$Res>(_self.load, (value) {
    return _then(_self.copyWith(load: value));
  });
}/// Create a copy of TargetsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ParametersFormCopyWith<$Res>? get parameters {
    if (_self.parameters == null) {
    return null;
  }

  return $ParametersFormCopyWith<$Res>(_self.parameters!, (value) {
    return _then(_self.copyWith(parameters: value));
  });
}/// Create a copy of TargetsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OverrideFormCopyWith<$Res> get ownValues {
  
  return $OverrideFormCopyWith<$Res>(_self.ownValues, (value) {
    return _then(_self.copyWith(ownValues: value));
  });
}/// Create a copy of TargetsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SaveFailureCopyWith<$Res>? get saveFailure {
    if (_self.saveFailure == null) {
    return null;
  }

  return $SaveFailureCopyWith<$Res>(_self.saveFailure!, (value) {
    return _then(_self.copyWith(saveFailure: value));
  });
}
}

/// @nodoc
mixin _$PublicationState {

 StepLoadState get load; Set<PlanRestrictionCode> get restrictions; Set<PlanGuidelineCode> get guidelines; List<String> get customGuidelines; List<PlanGuidelineCode> get suggested; bool get suggestedByAi;/// The guideline suggestions (AI) arrive after the form: `loading` can last up to a minute, `failed` offers "Retry".
 AiRequestStatus get suggestionStatus; String get customDraft; bool get showCustomField; bool get customError; String get patientMessage; bool get messageTooLong; bool get isPublishing;/// "We could not publish the plan. What you wrote was not lost".
 bool get publishFailed; bool get isOffline;
/// Create a copy of PublicationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PublicationStateCopyWith<PublicationState> get copyWith => _$PublicationStateCopyWithImpl<PublicationState>(this as PublicationState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PublicationState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PublicationState&&(identical(other.load, _this.load) || other.load == _this.load)&&const DeepCollectionEquality().equals(other.restrictions, _this.restrictions)&&const DeepCollectionEquality().equals(other.guidelines, _this.guidelines)&&const DeepCollectionEquality().equals(other.customGuidelines, _this.customGuidelines)&&const DeepCollectionEquality().equals(other.suggested, _this.suggested)&&(identical(other.suggestedByAi, _this.suggestedByAi) || other.suggestedByAi == _this.suggestedByAi)&&(identical(other.suggestionStatus, _this.suggestionStatus) || other.suggestionStatus == _this.suggestionStatus)&&(identical(other.customDraft, _this.customDraft) || other.customDraft == _this.customDraft)&&(identical(other.showCustomField, _this.showCustomField) || other.showCustomField == _this.showCustomField)&&(identical(other.customError, _this.customError) || other.customError == _this.customError)&&(identical(other.patientMessage, _this.patientMessage) || other.patientMessage == _this.patientMessage)&&(identical(other.messageTooLong, _this.messageTooLong) || other.messageTooLong == _this.messageTooLong)&&(identical(other.isPublishing, _this.isPublishing) || other.isPublishing == _this.isPublishing)&&(identical(other.publishFailed, _this.publishFailed) || other.publishFailed == _this.publishFailed)&&(identical(other.isOffline, _this.isOffline) || other.isOffline == _this.isOffline));
}


@override
int get hashCode {
  final _this = this as PublicationState;
  return Object.hash(runtimeType,_this.load,const DeepCollectionEquality().hash(_this.restrictions),const DeepCollectionEquality().hash(_this.guidelines),const DeepCollectionEquality().hash(_this.customGuidelines),const DeepCollectionEquality().hash(_this.suggested),_this.suggestedByAi,_this.suggestionStatus,_this.customDraft,_this.showCustomField,_this.customError,_this.patientMessage,_this.messageTooLong,_this.isPublishing,_this.publishFailed,_this.isOffline);
}

@override
String toString() {
  final _this = this as PublicationState;
  return 'PublicationState(load: ${_this.load}, restrictions: ${_this.restrictions}, guidelines: ${_this.guidelines}, customGuidelines: ${_this.customGuidelines}, suggested: ${_this.suggested}, suggestedByAi: ${_this.suggestedByAi}, suggestionStatus: ${_this.suggestionStatus}, customDraft: ${_this.customDraft}, showCustomField: ${_this.showCustomField}, customError: ${_this.customError}, patientMessage: ${_this.patientMessage}, messageTooLong: ${_this.messageTooLong}, isPublishing: ${_this.isPublishing}, publishFailed: ${_this.publishFailed}, isOffline: ${_this.isOffline})';
}


}

/// @nodoc
abstract mixin class $PublicationStateCopyWith<$Res>  {
  factory $PublicationStateCopyWith(PublicationState value, $Res Function(PublicationState) _then) = _$PublicationStateCopyWithImpl;
@useResult
$Res call({
 StepLoadState load, Set<PlanRestrictionCode> restrictions, Set<PlanGuidelineCode> guidelines, List<String> customGuidelines, List<PlanGuidelineCode> suggested, bool suggestedByAi, AiRequestStatus suggestionStatus, String customDraft, bool showCustomField, bool customError, String patientMessage, bool messageTooLong, bool isPublishing, bool publishFailed, bool isOffline
});


$StepLoadStateCopyWith<$Res> get load;

}
/// @nodoc
class _$PublicationStateCopyWithImpl<$Res>
    implements $PublicationStateCopyWith<$Res> {
  _$PublicationStateCopyWithImpl(this._self, this._then);

  final PublicationState _self;
  final $Res Function(PublicationState) _then;

/// Create a copy of PublicationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? load = null,Object? restrictions = null,Object? guidelines = null,Object? customGuidelines = null,Object? suggested = null,Object? suggestedByAi = null,Object? suggestionStatus = null,Object? customDraft = null,Object? showCustomField = null,Object? customError = null,Object? patientMessage = null,Object? messageTooLong = null,Object? isPublishing = null,Object? publishFailed = null,Object? isOffline = null,}) {
  return _then(PublicationState(
load: null == load ? _self.load : load // ignore: cast_nullable_to_non_nullable
as StepLoadState,restrictions: null == restrictions ? _self.restrictions : restrictions // ignore: cast_nullable_to_non_nullable
as Set<PlanRestrictionCode>,guidelines: null == guidelines ? _self.guidelines : guidelines // ignore: cast_nullable_to_non_nullable
as Set<PlanGuidelineCode>,customGuidelines: null == customGuidelines ? _self.customGuidelines : customGuidelines // ignore: cast_nullable_to_non_nullable
as List<String>,suggested: null == suggested ? _self.suggested : suggested // ignore: cast_nullable_to_non_nullable
as List<PlanGuidelineCode>,suggestedByAi: null == suggestedByAi ? _self.suggestedByAi : suggestedByAi // ignore: cast_nullable_to_non_nullable
as bool,suggestionStatus: null == suggestionStatus ? _self.suggestionStatus : suggestionStatus // ignore: cast_nullable_to_non_nullable
as AiRequestStatus,customDraft: null == customDraft ? _self.customDraft : customDraft // ignore: cast_nullable_to_non_nullable
as String,showCustomField: null == showCustomField ? _self.showCustomField : showCustomField // ignore: cast_nullable_to_non_nullable
as bool,customError: null == customError ? _self.customError : customError // ignore: cast_nullable_to_non_nullable
as bool,patientMessage: null == patientMessage ? _self.patientMessage : patientMessage // ignore: cast_nullable_to_non_nullable
as String,messageTooLong: null == messageTooLong ? _self.messageTooLong : messageTooLong // ignore: cast_nullable_to_non_nullable
as bool,isPublishing: null == isPublishing ? _self.isPublishing : isPublishing // ignore: cast_nullable_to_non_nullable
as bool,publishFailed: null == publishFailed ? _self.publishFailed : publishFailed // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of PublicationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StepLoadStateCopyWith<$Res> get load {
  
  return $StepLoadStateCopyWith<$Res>(_self.load, (value) {
    return _then(_self.copyWith(load: value));
  });
}
}


/// Adds pattern-matching-related methods to [PublicationState].
extension PublicationStatePatterns on PublicationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PublicationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PublicationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PublicationState value)  $default,){
final _that = this;
switch (_that) {
case _PublicationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PublicationState value)?  $default,){
final _that = this;
switch (_that) {
case _PublicationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( StepLoadState load,  Set<PlanRestrictionCode> restrictions,  Set<PlanGuidelineCode> guidelines,  List<String> customGuidelines,  List<PlanGuidelineCode> suggested,  bool suggestedByAi,  AiRequestStatus suggestionStatus,  String customDraft,  bool showCustomField,  bool customError,  String patientMessage,  bool messageTooLong,  bool isPublishing,  bool publishFailed,  bool isOffline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PublicationState() when $default != null:
return $default(_that.load,_that.restrictions,_that.guidelines,_that.customGuidelines,_that.suggested,_that.suggestedByAi,_that.suggestionStatus,_that.customDraft,_that.showCustomField,_that.customError,_that.patientMessage,_that.messageTooLong,_that.isPublishing,_that.publishFailed,_that.isOffline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( StepLoadState load,  Set<PlanRestrictionCode> restrictions,  Set<PlanGuidelineCode> guidelines,  List<String> customGuidelines,  List<PlanGuidelineCode> suggested,  bool suggestedByAi,  AiRequestStatus suggestionStatus,  String customDraft,  bool showCustomField,  bool customError,  String patientMessage,  bool messageTooLong,  bool isPublishing,  bool publishFailed,  bool isOffline)  $default,) {final _that = this;
switch (_that) {
case _PublicationState():
return $default(_that.load,_that.restrictions,_that.guidelines,_that.customGuidelines,_that.suggested,_that.suggestedByAi,_that.suggestionStatus,_that.customDraft,_that.showCustomField,_that.customError,_that.patientMessage,_that.messageTooLong,_that.isPublishing,_that.publishFailed,_that.isOffline);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( StepLoadState load,  Set<PlanRestrictionCode> restrictions,  Set<PlanGuidelineCode> guidelines,  List<String> customGuidelines,  List<PlanGuidelineCode> suggested,  bool suggestedByAi,  AiRequestStatus suggestionStatus,  String customDraft,  bool showCustomField,  bool customError,  String patientMessage,  bool messageTooLong,  bool isPublishing,  bool publishFailed,  bool isOffline)?  $default,) {final _that = this;
switch (_that) {
case _PublicationState() when $default != null:
return $default(_that.load,_that.restrictions,_that.guidelines,_that.customGuidelines,_that.suggested,_that.suggestedByAi,_that.suggestionStatus,_that.customDraft,_that.showCustomField,_that.customError,_that.patientMessage,_that.messageTooLong,_that.isPublishing,_that.publishFailed,_that.isOffline);case _:
  return null;

}
}

}

/// @nodoc


class _PublicationState implements PublicationState {
  const _PublicationState({this.load = const StepLoadState(),  Set<PlanRestrictionCode> restrictions = const {},  Set<PlanGuidelineCode> guidelines = const {},  List<String> customGuidelines = const [],  List<PlanGuidelineCode> suggested = const [], this.suggestedByAi = false, this.suggestionStatus = AiRequestStatus.idle, this.customDraft = '', this.showCustomField = false, this.customError = false, this.patientMessage = '', this.messageTooLong = false, this.isPublishing = false, this.publishFailed = false, this.isOffline = false}): _restrictions = restrictions,_guidelines = guidelines,_customGuidelines = customGuidelines,_suggested = suggested;
  

@override@JsonKey() final  StepLoadState load;
 final  Set<PlanRestrictionCode> _restrictions;
@override@JsonKey() Set<PlanRestrictionCode> get restrictions {
  if (_restrictions is EqualUnmodifiableSetView) return _restrictions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_restrictions);
}

 final  Set<PlanGuidelineCode> _guidelines;
@override@JsonKey() Set<PlanGuidelineCode> get guidelines {
  if (_guidelines is EqualUnmodifiableSetView) return _guidelines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_guidelines);
}

 final  List<String> _customGuidelines;
@override@JsonKey() List<String> get customGuidelines {
  if (_customGuidelines is EqualUnmodifiableListView) return _customGuidelines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_customGuidelines);
}

 final  List<PlanGuidelineCode> _suggested;
@override@JsonKey() List<PlanGuidelineCode> get suggested {
  if (_suggested is EqualUnmodifiableListView) return _suggested;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_suggested);
}

@override@JsonKey() final  bool suggestedByAi;
/// The guideline suggestions (AI) arrive after the form: `loading` can last up to a minute, `failed` offers "Retry".
@override@JsonKey() final  AiRequestStatus suggestionStatus;
@override@JsonKey() final  String customDraft;
@override@JsonKey() final  bool showCustomField;
@override@JsonKey() final  bool customError;
@override@JsonKey() final  String patientMessage;
@override@JsonKey() final  bool messageTooLong;
@override@JsonKey() final  bool isPublishing;
/// "We could not publish the plan. What you wrote was not lost".
@override@JsonKey() final  bool publishFailed;
@override@JsonKey() final  bool isOffline;

/// Create a copy of PublicationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PublicationStateCopyWith<_PublicationState> get copyWith => __$PublicationStateCopyWithImpl<_PublicationState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PublicationState&&(identical(other.load, load) || other.load == load)&&const DeepCollectionEquality().equals(other.restrictions, _restrictions)&&const DeepCollectionEquality().equals(other.guidelines, _guidelines)&&const DeepCollectionEquality().equals(other.customGuidelines, _customGuidelines)&&const DeepCollectionEquality().equals(other.suggested, _suggested)&&(identical(other.suggestedByAi, suggestedByAi) || other.suggestedByAi == suggestedByAi)&&(identical(other.suggestionStatus, suggestionStatus) || other.suggestionStatus == suggestionStatus)&&(identical(other.customDraft, customDraft) || other.customDraft == customDraft)&&(identical(other.showCustomField, showCustomField) || other.showCustomField == showCustomField)&&(identical(other.customError, customError) || other.customError == customError)&&(identical(other.patientMessage, patientMessage) || other.patientMessage == patientMessage)&&(identical(other.messageTooLong, messageTooLong) || other.messageTooLong == messageTooLong)&&(identical(other.isPublishing, isPublishing) || other.isPublishing == isPublishing)&&(identical(other.publishFailed, publishFailed) || other.publishFailed == publishFailed)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline));
}


@override
int get hashCode {
    return Object.hash(runtimeType,load,const DeepCollectionEquality().hash(_restrictions),const DeepCollectionEquality().hash(_guidelines),const DeepCollectionEquality().hash(_customGuidelines),const DeepCollectionEquality().hash(_suggested),suggestedByAi,suggestionStatus,customDraft,showCustomField,customError,patientMessage,messageTooLong,isPublishing,publishFailed,isOffline);
}

@override
String toString() {
    return 'PublicationState(load: $load, restrictions: $restrictions, guidelines: $guidelines, customGuidelines: $customGuidelines, suggested: $suggested, suggestedByAi: $suggestedByAi, suggestionStatus: $suggestionStatus, customDraft: $customDraft, showCustomField: $showCustomField, customError: $customError, patientMessage: $patientMessage, messageTooLong: $messageTooLong, isPublishing: $isPublishing, publishFailed: $publishFailed, isOffline: $isOffline)';
}


}

/// @nodoc
abstract mixin class _$PublicationStateCopyWith<$Res> implements $PublicationStateCopyWith<$Res> {
  factory _$PublicationStateCopyWith(_PublicationState value, $Res Function(_PublicationState) _then) = __$PublicationStateCopyWithImpl;
@override @useResult
$Res call({
 StepLoadState load, Set<PlanRestrictionCode> restrictions, Set<PlanGuidelineCode> guidelines, List<String> customGuidelines, List<PlanGuidelineCode> suggested, bool suggestedByAi, AiRequestStatus suggestionStatus, String customDraft, bool showCustomField, bool customError, String patientMessage, bool messageTooLong, bool isPublishing, bool publishFailed, bool isOffline
});


@override $StepLoadStateCopyWith<$Res> get load;

}
/// @nodoc
class __$PublicationStateCopyWithImpl<$Res>
    implements _$PublicationStateCopyWith<$Res> {
  __$PublicationStateCopyWithImpl(this._self, this._then);

  final _PublicationState _self;
  final $Res Function(_PublicationState) _then;

/// Create a copy of PublicationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? load = null,Object? restrictions = null,Object? guidelines = null,Object? customGuidelines = null,Object? suggested = null,Object? suggestedByAi = null,Object? suggestionStatus = null,Object? customDraft = null,Object? showCustomField = null,Object? customError = null,Object? patientMessage = null,Object? messageTooLong = null,Object? isPublishing = null,Object? publishFailed = null,Object? isOffline = null,}) {
  return _then(_PublicationState(
load: null == load ? _self.load : load // ignore: cast_nullable_to_non_nullable
as StepLoadState,restrictions: null == restrictions ? _self._restrictions : restrictions // ignore: cast_nullable_to_non_nullable
as Set<PlanRestrictionCode>,guidelines: null == guidelines ? _self._guidelines : guidelines // ignore: cast_nullable_to_non_nullable
as Set<PlanGuidelineCode>,customGuidelines: null == customGuidelines ? _self._customGuidelines : customGuidelines // ignore: cast_nullable_to_non_nullable
as List<String>,suggested: null == suggested ? _self._suggested : suggested // ignore: cast_nullable_to_non_nullable
as List<PlanGuidelineCode>,suggestedByAi: null == suggestedByAi ? _self.suggestedByAi : suggestedByAi // ignore: cast_nullable_to_non_nullable
as bool,suggestionStatus: null == suggestionStatus ? _self.suggestionStatus : suggestionStatus // ignore: cast_nullable_to_non_nullable
as AiRequestStatus,customDraft: null == customDraft ? _self.customDraft : customDraft // ignore: cast_nullable_to_non_nullable
as String,showCustomField: null == showCustomField ? _self.showCustomField : showCustomField // ignore: cast_nullable_to_non_nullable
as bool,customError: null == customError ? _self.customError : customError // ignore: cast_nullable_to_non_nullable
as bool,patientMessage: null == patientMessage ? _self.patientMessage : patientMessage // ignore: cast_nullable_to_non_nullable
as String,messageTooLong: null == messageTooLong ? _self.messageTooLong : messageTooLong // ignore: cast_nullable_to_non_nullable
as bool,isPublishing: null == isPublishing ? _self.isPublishing : isPublishing // ignore: cast_nullable_to_non_nullable
as bool,publishFailed: null == publishFailed ? _self.publishFailed : publishFailed // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of PublicationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StepLoadStateCopyWith<$Res> get load {
  
  return $StepLoadStateCopyWith<$Res>(_self.load, (value) {
    return _then(_self.copyWith(load: value));
  });
}
}

// dart format on
