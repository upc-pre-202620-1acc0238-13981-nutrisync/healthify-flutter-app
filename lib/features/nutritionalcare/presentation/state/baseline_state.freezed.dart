// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'baseline_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BaselineState {

 bool get editing; bool get isLoading; bool get isOffline; DateTime? get birthDate; BiologicalSex? get sex; String get heightText; Set<MedicalCondition> get conditions;/// Age calculated live ("Age: 31 years (updates itself)"), or `null` without a valid date.
 int? get ageYears; Set<BaselineProblem> get problems; bool get isSaving;/// A save that failed for a reason other than form data (network, 5xx...): notice with "Retry".
 bool get saveFailed;
/// Create a copy of BaselineState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BaselineStateCopyWith<BaselineState> get copyWith => _$BaselineStateCopyWithImpl<BaselineState>(this as BaselineState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as BaselineState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BaselineState&&(identical(other.editing, _this.editing) || other.editing == _this.editing)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isOffline, _this.isOffline) || other.isOffline == _this.isOffline)&&(identical(other.birthDate, _this.birthDate) || other.birthDate == _this.birthDate)&&(identical(other.sex, _this.sex) || other.sex == _this.sex)&&(identical(other.heightText, _this.heightText) || other.heightText == _this.heightText)&&const DeepCollectionEquality().equals(other.conditions, _this.conditions)&&(identical(other.ageYears, _this.ageYears) || other.ageYears == _this.ageYears)&&const DeepCollectionEquality().equals(other.problems, _this.problems)&&(identical(other.isSaving, _this.isSaving) || other.isSaving == _this.isSaving)&&(identical(other.saveFailed, _this.saveFailed) || other.saveFailed == _this.saveFailed));
}


@override
int get hashCode {
  final _this = this as BaselineState;
  return Object.hash(runtimeType,_this.editing,_this.isLoading,_this.isOffline,_this.birthDate,_this.sex,_this.heightText,const DeepCollectionEquality().hash(_this.conditions),_this.ageYears,const DeepCollectionEquality().hash(_this.problems),_this.isSaving,_this.saveFailed);
}

@override
String toString() {
  final _this = this as BaselineState;
  return 'BaselineState(editing: ${_this.editing}, isLoading: ${_this.isLoading}, isOffline: ${_this.isOffline}, birthDate: ${_this.birthDate}, sex: ${_this.sex}, heightText: ${_this.heightText}, conditions: ${_this.conditions}, ageYears: ${_this.ageYears}, problems: ${_this.problems}, isSaving: ${_this.isSaving}, saveFailed: ${_this.saveFailed})';
}


}

/// @nodoc
abstract mixin class $BaselineStateCopyWith<$Res>  {
  factory $BaselineStateCopyWith(BaselineState value, $Res Function(BaselineState) _then) = _$BaselineStateCopyWithImpl;
@useResult
$Res call({
 bool editing, bool isLoading, bool isOffline, DateTime? birthDate, BiologicalSex? sex, String heightText, Set<MedicalCondition> conditions, int? ageYears, Set<BaselineProblem> problems, bool isSaving, bool saveFailed
});




}
/// @nodoc
class _$BaselineStateCopyWithImpl<$Res>
    implements $BaselineStateCopyWith<$Res> {
  _$BaselineStateCopyWithImpl(this._self, this._then);

  final BaselineState _self;
  final $Res Function(BaselineState) _then;

/// Create a copy of BaselineState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? editing = null,Object? isLoading = null,Object? isOffline = null,Object? birthDate = freezed,Object? sex = freezed,Object? heightText = null,Object? conditions = null,Object? ageYears = freezed,Object? problems = null,Object? isSaving = null,Object? saveFailed = null,}) {
  return _then(BaselineState(
editing: null == editing ? _self.editing : editing // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as BiologicalSex?,heightText: null == heightText ? _self.heightText : heightText // ignore: cast_nullable_to_non_nullable
as String,conditions: null == conditions ? _self.conditions : conditions // ignore: cast_nullable_to_non_nullable
as Set<MedicalCondition>,ageYears: freezed == ageYears ? _self.ageYears : ageYears // ignore: cast_nullable_to_non_nullable
as int?,problems: null == problems ? _self.problems : problems // ignore: cast_nullable_to_non_nullable
as Set<BaselineProblem>,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,saveFailed: null == saveFailed ? _self.saveFailed : saveFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [BaselineState].
extension BaselineStatePatterns on BaselineState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BaselineState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BaselineState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BaselineState value)  $default,){
final _that = this;
switch (_that) {
case _BaselineState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BaselineState value)?  $default,){
final _that = this;
switch (_that) {
case _BaselineState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool editing,  bool isLoading,  bool isOffline,  DateTime? birthDate,  BiologicalSex? sex,  String heightText,  Set<MedicalCondition> conditions,  int? ageYears,  Set<BaselineProblem> problems,  bool isSaving,  bool saveFailed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BaselineState() when $default != null:
return $default(_that.editing,_that.isLoading,_that.isOffline,_that.birthDate,_that.sex,_that.heightText,_that.conditions,_that.ageYears,_that.problems,_that.isSaving,_that.saveFailed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool editing,  bool isLoading,  bool isOffline,  DateTime? birthDate,  BiologicalSex? sex,  String heightText,  Set<MedicalCondition> conditions,  int? ageYears,  Set<BaselineProblem> problems,  bool isSaving,  bool saveFailed)  $default,) {final _that = this;
switch (_that) {
case _BaselineState():
return $default(_that.editing,_that.isLoading,_that.isOffline,_that.birthDate,_that.sex,_that.heightText,_that.conditions,_that.ageYears,_that.problems,_that.isSaving,_that.saveFailed);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool editing,  bool isLoading,  bool isOffline,  DateTime? birthDate,  BiologicalSex? sex,  String heightText,  Set<MedicalCondition> conditions,  int? ageYears,  Set<BaselineProblem> problems,  bool isSaving,  bool saveFailed)?  $default,) {final _that = this;
switch (_that) {
case _BaselineState() when $default != null:
return $default(_that.editing,_that.isLoading,_that.isOffline,_that.birthDate,_that.sex,_that.heightText,_that.conditions,_that.ageYears,_that.problems,_that.isSaving,_that.saveFailed);case _:
  return null;

}
}

}

/// @nodoc


class _BaselineState implements BaselineState {
  const _BaselineState({this.editing = false, this.isLoading = false, this.isOffline = false, this.birthDate, this.sex, this.heightText = '',  Set<MedicalCondition> conditions = const {}, this.ageYears,  Set<BaselineProblem> problems = const {}, this.isSaving = false, this.saveFailed = false}): _conditions = conditions,_problems = problems;
  

@override@JsonKey() final  bool editing;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isOffline;
@override final  DateTime? birthDate;
@override final  BiologicalSex? sex;
@override@JsonKey() final  String heightText;
 final  Set<MedicalCondition> _conditions;
@override@JsonKey() Set<MedicalCondition> get conditions {
  if (_conditions is EqualUnmodifiableSetView) return _conditions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_conditions);
}

/// Age calculated live ("Age: 31 years (updates itself)"), or `null` without a valid date.
@override final  int? ageYears;
 final  Set<BaselineProblem> _problems;
@override@JsonKey() Set<BaselineProblem> get problems {
  if (_problems is EqualUnmodifiableSetView) return _problems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_problems);
}

@override@JsonKey() final  bool isSaving;
/// A save that failed for a reason other than form data (network, 5xx...): notice with "Retry".
@override@JsonKey() final  bool saveFailed;

/// Create a copy of BaselineState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BaselineStateCopyWith<_BaselineState> get copyWith => __$BaselineStateCopyWithImpl<_BaselineState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BaselineState&&(identical(other.editing, editing) || other.editing == editing)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&(identical(other.sex, sex) || other.sex == sex)&&(identical(other.heightText, heightText) || other.heightText == heightText)&&const DeepCollectionEquality().equals(other.conditions, _conditions)&&(identical(other.ageYears, ageYears) || other.ageYears == ageYears)&&const DeepCollectionEquality().equals(other.problems, _problems)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.saveFailed, saveFailed) || other.saveFailed == saveFailed));
}


@override
int get hashCode {
    return Object.hash(runtimeType,editing,isLoading,isOffline,birthDate,sex,heightText,const DeepCollectionEquality().hash(_conditions),ageYears,const DeepCollectionEquality().hash(_problems),isSaving,saveFailed);
}

@override
String toString() {
    return 'BaselineState(editing: $editing, isLoading: $isLoading, isOffline: $isOffline, birthDate: $birthDate, sex: $sex, heightText: $heightText, conditions: $conditions, ageYears: $ageYears, problems: $problems, isSaving: $isSaving, saveFailed: $saveFailed)';
}


}

/// @nodoc
abstract mixin class _$BaselineStateCopyWith<$Res> implements $BaselineStateCopyWith<$Res> {
  factory _$BaselineStateCopyWith(_BaselineState value, $Res Function(_BaselineState) _then) = __$BaselineStateCopyWithImpl;
@override @useResult
$Res call({
 bool editing, bool isLoading, bool isOffline, DateTime? birthDate, BiologicalSex? sex, String heightText, Set<MedicalCondition> conditions, int? ageYears, Set<BaselineProblem> problems, bool isSaving, bool saveFailed
});




}
/// @nodoc
class __$BaselineStateCopyWithImpl<$Res>
    implements _$BaselineStateCopyWith<$Res> {
  __$BaselineStateCopyWithImpl(this._self, this._then);

  final _BaselineState _self;
  final $Res Function(_BaselineState) _then;

/// Create a copy of BaselineState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? editing = null,Object? isLoading = null,Object? isOffline = null,Object? birthDate = freezed,Object? sex = freezed,Object? heightText = null,Object? conditions = null,Object? ageYears = freezed,Object? problems = null,Object? isSaving = null,Object? saveFailed = null,}) {
  return _then(_BaselineState(
editing: null == editing ? _self.editing : editing // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,birthDate: freezed == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as DateTime?,sex: freezed == sex ? _self.sex : sex // ignore: cast_nullable_to_non_nullable
as BiologicalSex?,heightText: null == heightText ? _self.heightText : heightText // ignore: cast_nullable_to_non_nullable
as String,conditions: null == conditions ? _self._conditions : conditions // ignore: cast_nullable_to_non_nullable
as Set<MedicalCondition>,ageYears: freezed == ageYears ? _self.ageYears : ageYears // ignore: cast_nullable_to_non_nullable
as int?,problems: null == problems ? _self._problems : problems // ignore: cast_nullable_to_non_nullable
as Set<BaselineProblem>,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,saveFailed: null == saveFailed ? _self.saveFailed : saveFailed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
