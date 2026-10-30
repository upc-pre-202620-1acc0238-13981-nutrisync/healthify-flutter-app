// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'practitioner_only_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PractitionerOnlyState {

 bool get isSigningOut;
/// Create a copy of PractitionerOnlyState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PractitionerOnlyStateCopyWith<PractitionerOnlyState> get copyWith => _$PractitionerOnlyStateCopyWithImpl<PractitionerOnlyState>(this as PractitionerOnlyState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PractitionerOnlyState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PractitionerOnlyState&&(identical(other.isSigningOut, _this.isSigningOut) || other.isSigningOut == _this.isSigningOut));
}


@override
int get hashCode {
  final _this = this as PractitionerOnlyState;
  return Object.hash(runtimeType,_this.isSigningOut);
}

@override
String toString() {
  final _this = this as PractitionerOnlyState;
  return 'PractitionerOnlyState(isSigningOut: ${_this.isSigningOut})';
}


}

/// @nodoc
abstract mixin class $PractitionerOnlyStateCopyWith<$Res>  {
  factory $PractitionerOnlyStateCopyWith(PractitionerOnlyState value, $Res Function(PractitionerOnlyState) _then) = _$PractitionerOnlyStateCopyWithImpl;
@useResult
$Res call({
 bool isSigningOut
});




}
/// @nodoc
class _$PractitionerOnlyStateCopyWithImpl<$Res>
    implements $PractitionerOnlyStateCopyWith<$Res> {
  _$PractitionerOnlyStateCopyWithImpl(this._self, this._then);

  final PractitionerOnlyState _self;
  final $Res Function(PractitionerOnlyState) _then;

/// Create a copy of PractitionerOnlyState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isSigningOut = null,}) {
  return _then(PractitionerOnlyState(
isSigningOut: null == isSigningOut ? _self.isSigningOut : isSigningOut // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PractitionerOnlyState].
extension PractitionerOnlyStatePatterns on PractitionerOnlyState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PractitionerOnlyState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PractitionerOnlyState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PractitionerOnlyState value)  $default,){
final _that = this;
switch (_that) {
case _PractitionerOnlyState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PractitionerOnlyState value)?  $default,){
final _that = this;
switch (_that) {
case _PractitionerOnlyState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isSigningOut)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PractitionerOnlyState() when $default != null:
return $default(_that.isSigningOut);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isSigningOut)  $default,) {final _that = this;
switch (_that) {
case _PractitionerOnlyState():
return $default(_that.isSigningOut);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isSigningOut)?  $default,) {final _that = this;
switch (_that) {
case _PractitionerOnlyState() when $default != null:
return $default(_that.isSigningOut);case _:
  return null;

}
}

}

/// @nodoc


class _PractitionerOnlyState implements PractitionerOnlyState {
  const _PractitionerOnlyState({this.isSigningOut = false});
  

@override@JsonKey() final  bool isSigningOut;

/// Create a copy of PractitionerOnlyState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PractitionerOnlyStateCopyWith<_PractitionerOnlyState> get copyWith => __$PractitionerOnlyStateCopyWithImpl<_PractitionerOnlyState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PractitionerOnlyState&&(identical(other.isSigningOut, isSigningOut) || other.isSigningOut == isSigningOut));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isSigningOut);
}

@override
String toString() {
    return 'PractitionerOnlyState(isSigningOut: $isSigningOut)';
}


}

/// @nodoc
abstract mixin class _$PractitionerOnlyStateCopyWith<$Res> implements $PractitionerOnlyStateCopyWith<$Res> {
  factory _$PractitionerOnlyStateCopyWith(_PractitionerOnlyState value, $Res Function(_PractitionerOnlyState) _then) = __$PractitionerOnlyStateCopyWithImpl;
@override @useResult
$Res call({
 bool isSigningOut
});




}
/// @nodoc
class __$PractitionerOnlyStateCopyWithImpl<$Res>
    implements _$PractitionerOnlyStateCopyWith<$Res> {
  __$PractitionerOnlyStateCopyWithImpl(this._self, this._then);

  final _PractitionerOnlyState _self;
  final $Res Function(_PractitionerOnlyState) _then;

/// Create a copy of PractitionerOnlyState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isSigningOut = null,}) {
  return _then(_PractitionerOnlyState(
isSigningOut: null == isSigningOut ? _self.isSigningOut : isSigningOut // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
