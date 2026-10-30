// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shell_loading_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShellLoadingState {

 bool get isError; bool get isRetrying;
/// Create a copy of ShellLoadingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShellLoadingStateCopyWith<ShellLoadingState> get copyWith => _$ShellLoadingStateCopyWithImpl<ShellLoadingState>(this as ShellLoadingState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ShellLoadingState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShellLoadingState&&(identical(other.isError, _this.isError) || other.isError == _this.isError)&&(identical(other.isRetrying, _this.isRetrying) || other.isRetrying == _this.isRetrying));
}


@override
int get hashCode {
  final _this = this as ShellLoadingState;
  return Object.hash(runtimeType,_this.isError,_this.isRetrying);
}

@override
String toString() {
  final _this = this as ShellLoadingState;
  return 'ShellLoadingState(isError: ${_this.isError}, isRetrying: ${_this.isRetrying})';
}


}

/// @nodoc
abstract mixin class $ShellLoadingStateCopyWith<$Res>  {
  factory $ShellLoadingStateCopyWith(ShellLoadingState value, $Res Function(ShellLoadingState) _then) = _$ShellLoadingStateCopyWithImpl;
@useResult
$Res call({
 bool isError, bool isRetrying
});




}
/// @nodoc
class _$ShellLoadingStateCopyWithImpl<$Res>
    implements $ShellLoadingStateCopyWith<$Res> {
  _$ShellLoadingStateCopyWithImpl(this._self, this._then);

  final ShellLoadingState _self;
  final $Res Function(ShellLoadingState) _then;

/// Create a copy of ShellLoadingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isError = null,Object? isRetrying = null,}) {
  return _then(ShellLoadingState(
isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,isRetrying: null == isRetrying ? _self.isRetrying : isRetrying // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ShellLoadingState].
extension ShellLoadingStatePatterns on ShellLoadingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShellLoadingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShellLoadingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShellLoadingState value)  $default,){
final _that = this;
switch (_that) {
case _ShellLoadingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShellLoadingState value)?  $default,){
final _that = this;
switch (_that) {
case _ShellLoadingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isError,  bool isRetrying)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShellLoadingState() when $default != null:
return $default(_that.isError,_that.isRetrying);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isError,  bool isRetrying)  $default,) {final _that = this;
switch (_that) {
case _ShellLoadingState():
return $default(_that.isError,_that.isRetrying);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isError,  bool isRetrying)?  $default,) {final _that = this;
switch (_that) {
case _ShellLoadingState() when $default != null:
return $default(_that.isError,_that.isRetrying);case _:
  return null;

}
}

}

/// @nodoc


class _ShellLoadingState implements ShellLoadingState {
  const _ShellLoadingState({this.isError = false, this.isRetrying = false});
  

@override@JsonKey() final  bool isError;
@override@JsonKey() final  bool isRetrying;

/// Create a copy of ShellLoadingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShellLoadingStateCopyWith<_ShellLoadingState> get copyWith => __$ShellLoadingStateCopyWithImpl<_ShellLoadingState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShellLoadingState&&(identical(other.isError, isError) || other.isError == isError)&&(identical(other.isRetrying, isRetrying) || other.isRetrying == isRetrying));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isError,isRetrying);
}

@override
String toString() {
    return 'ShellLoadingState(isError: $isError, isRetrying: $isRetrying)';
}


}

/// @nodoc
abstract mixin class _$ShellLoadingStateCopyWith<$Res> implements $ShellLoadingStateCopyWith<$Res> {
  factory _$ShellLoadingStateCopyWith(_ShellLoadingState value, $Res Function(_ShellLoadingState) _then) = __$ShellLoadingStateCopyWithImpl;
@override @useResult
$Res call({
 bool isError, bool isRetrying
});




}
/// @nodoc
class __$ShellLoadingStateCopyWithImpl<$Res>
    implements _$ShellLoadingStateCopyWith<$Res> {
  __$ShellLoadingStateCopyWithImpl(this._self, this._then);

  final _ShellLoadingState _self;
  final $Res Function(_ShellLoadingState) _then;

/// Create a copy of ShellLoadingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isError = null,Object? isRetrying = null,}) {
  return _then(_ShellLoadingState(
isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as bool,isRetrying: null == isRetrying ? _self.isRetrying : isRetrying // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
