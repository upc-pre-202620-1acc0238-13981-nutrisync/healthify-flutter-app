// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'practitioner_shell_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PractitionerShellState {

 String get fullName; String get avatarInitial; bool get isMenuOpen;
/// Create a copy of PractitionerShellState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PractitionerShellStateCopyWith<PractitionerShellState> get copyWith => _$PractitionerShellStateCopyWithImpl<PractitionerShellState>(this as PractitionerShellState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PractitionerShellState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PractitionerShellState&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.avatarInitial, _this.avatarInitial) || other.avatarInitial == _this.avatarInitial)&&(identical(other.isMenuOpen, _this.isMenuOpen) || other.isMenuOpen == _this.isMenuOpen));
}


@override
int get hashCode {
  final _this = this as PractitionerShellState;
  return Object.hash(runtimeType,_this.fullName,_this.avatarInitial,_this.isMenuOpen);
}

@override
String toString() {
  final _this = this as PractitionerShellState;
  return 'PractitionerShellState(fullName: ${_this.fullName}, avatarInitial: ${_this.avatarInitial}, isMenuOpen: ${_this.isMenuOpen})';
}


}

/// @nodoc
abstract mixin class $PractitionerShellStateCopyWith<$Res>  {
  factory $PractitionerShellStateCopyWith(PractitionerShellState value, $Res Function(PractitionerShellState) _then) = _$PractitionerShellStateCopyWithImpl;
@useResult
$Res call({
 String fullName, String avatarInitial, bool isMenuOpen
});




}
/// @nodoc
class _$PractitionerShellStateCopyWithImpl<$Res>
    implements $PractitionerShellStateCopyWith<$Res> {
  _$PractitionerShellStateCopyWithImpl(this._self, this._then);

  final PractitionerShellState _self;
  final $Res Function(PractitionerShellState) _then;

/// Create a copy of PractitionerShellState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fullName = null,Object? avatarInitial = null,Object? isMenuOpen = null,}) {
  return _then(PractitionerShellState(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarInitial: null == avatarInitial ? _self.avatarInitial : avatarInitial // ignore: cast_nullable_to_non_nullable
as String,isMenuOpen: null == isMenuOpen ? _self.isMenuOpen : isMenuOpen // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PractitionerShellState].
extension PractitionerShellStatePatterns on PractitionerShellState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PractitionerShellState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PractitionerShellState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PractitionerShellState value)  $default,){
final _that = this;
switch (_that) {
case _PractitionerShellState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PractitionerShellState value)?  $default,){
final _that = this;
switch (_that) {
case _PractitionerShellState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fullName,  String avatarInitial,  bool isMenuOpen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PractitionerShellState() when $default != null:
return $default(_that.fullName,_that.avatarInitial,_that.isMenuOpen);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fullName,  String avatarInitial,  bool isMenuOpen)  $default,) {final _that = this;
switch (_that) {
case _PractitionerShellState():
return $default(_that.fullName,_that.avatarInitial,_that.isMenuOpen);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fullName,  String avatarInitial,  bool isMenuOpen)?  $default,) {final _that = this;
switch (_that) {
case _PractitionerShellState() when $default != null:
return $default(_that.fullName,_that.avatarInitial,_that.isMenuOpen);case _:
  return null;

}
}

}

/// @nodoc


class _PractitionerShellState implements PractitionerShellState {
  const _PractitionerShellState({this.fullName = '', this.avatarInitial = '', this.isMenuOpen = false});
  

@override@JsonKey() final  String fullName;
@override@JsonKey() final  String avatarInitial;
@override@JsonKey() final  bool isMenuOpen;

/// Create a copy of PractitionerShellState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PractitionerShellStateCopyWith<_PractitionerShellState> get copyWith => __$PractitionerShellStateCopyWithImpl<_PractitionerShellState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PractitionerShellState&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.avatarInitial, avatarInitial) || other.avatarInitial == avatarInitial)&&(identical(other.isMenuOpen, isMenuOpen) || other.isMenuOpen == isMenuOpen));
}


@override
int get hashCode {
    return Object.hash(runtimeType,fullName,avatarInitial,isMenuOpen);
}

@override
String toString() {
    return 'PractitionerShellState(fullName: $fullName, avatarInitial: $avatarInitial, isMenuOpen: $isMenuOpen)';
}


}

/// @nodoc
abstract mixin class _$PractitionerShellStateCopyWith<$Res> implements $PractitionerShellStateCopyWith<$Res> {
  factory _$PractitionerShellStateCopyWith(_PractitionerShellState value, $Res Function(_PractitionerShellState) _then) = __$PractitionerShellStateCopyWithImpl;
@override @useResult
$Res call({
 String fullName, String avatarInitial, bool isMenuOpen
});




}
/// @nodoc
class __$PractitionerShellStateCopyWithImpl<$Res>
    implements _$PractitionerShellStateCopyWith<$Res> {
  __$PractitionerShellStateCopyWithImpl(this._self, this._then);

  final _PractitionerShellState _self;
  final $Res Function(_PractitionerShellState) _then;

/// Create a copy of PractitionerShellState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fullName = null,Object? avatarInitial = null,Object? isMenuOpen = null,}) {
  return _then(_PractitionerShellState(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,avatarInitial: null == avatarInitial ? _self.avatarInitial : avatarInitial // ignore: cast_nullable_to_non_nullable
as String,isMenuOpen: null == isMenuOpen ? _self.isMenuOpen : isMenuOpen // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
