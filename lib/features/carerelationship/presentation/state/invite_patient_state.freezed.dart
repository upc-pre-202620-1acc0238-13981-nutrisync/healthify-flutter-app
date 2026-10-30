// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invite_patient_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InvitePatientState {

 InvitationValidity get validity; bool get isGenerating; InvitationToken? get token; Duration? get remaining; bool get isExpired; bool get isOffline; InviteError? get error;
/// Create a copy of InvitePatientState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvitePatientStateCopyWith<InvitePatientState> get copyWith => _$InvitePatientStateCopyWithImpl<InvitePatientState>(this as InvitePatientState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as InvitePatientState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvitePatientState&&(identical(other.validity, _this.validity) || other.validity == _this.validity)&&(identical(other.isGenerating, _this.isGenerating) || other.isGenerating == _this.isGenerating)&&(identical(other.token, _this.token) || other.token == _this.token)&&(identical(other.remaining, _this.remaining) || other.remaining == _this.remaining)&&(identical(other.isExpired, _this.isExpired) || other.isExpired == _this.isExpired)&&(identical(other.isOffline, _this.isOffline) || other.isOffline == _this.isOffline)&&(identical(other.error, _this.error) || other.error == _this.error));
}


@override
int get hashCode {
  final _this = this as InvitePatientState;
  return Object.hash(runtimeType,_this.validity,_this.isGenerating,_this.token,_this.remaining,_this.isExpired,_this.isOffline,_this.error);
}



}

/// @nodoc
abstract mixin class $InvitePatientStateCopyWith<$Res>  {
  factory $InvitePatientStateCopyWith(InvitePatientState value, $Res Function(InvitePatientState) _then) = _$InvitePatientStateCopyWithImpl;
@useResult
$Res call({
 InvitationValidity validity, bool isGenerating, InvitationToken? token, Duration? remaining, bool isExpired, bool isOffline, InviteError? error
});




}
/// @nodoc
class _$InvitePatientStateCopyWithImpl<$Res>
    implements $InvitePatientStateCopyWith<$Res> {
  _$InvitePatientStateCopyWithImpl(this._self, this._then);

  final InvitePatientState _self;
  final $Res Function(InvitePatientState) _then;

/// Create a copy of InvitePatientState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? validity = null,Object? isGenerating = null,Object? token = freezed,Object? remaining = freezed,Object? isExpired = null,Object? isOffline = null,Object? error = freezed,}) {
  return _then(InvitePatientState(
validity: null == validity ? _self.validity : validity // ignore: cast_nullable_to_non_nullable
as InvitationValidity,isGenerating: null == isGenerating ? _self.isGenerating : isGenerating // ignore: cast_nullable_to_non_nullable
as bool,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as InvitationToken?,remaining: freezed == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as Duration?,isExpired: null == isExpired ? _self.isExpired : isExpired // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as InviteError?,
  ));
}

}


/// Adds pattern-matching-related methods to [InvitePatientState].
extension InvitePatientStatePatterns on InvitePatientState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvitePatientState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvitePatientState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvitePatientState value)  $default,){
final _that = this;
switch (_that) {
case _InvitePatientState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvitePatientState value)?  $default,){
final _that = this;
switch (_that) {
case _InvitePatientState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( InvitationValidity validity,  bool isGenerating,  InvitationToken? token,  Duration? remaining,  bool isExpired,  bool isOffline,  InviteError? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvitePatientState() when $default != null:
return $default(_that.validity,_that.isGenerating,_that.token,_that.remaining,_that.isExpired,_that.isOffline,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( InvitationValidity validity,  bool isGenerating,  InvitationToken? token,  Duration? remaining,  bool isExpired,  bool isOffline,  InviteError? error)  $default,) {final _that = this;
switch (_that) {
case _InvitePatientState():
return $default(_that.validity,_that.isGenerating,_that.token,_that.remaining,_that.isExpired,_that.isOffline,_that.error);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( InvitationValidity validity,  bool isGenerating,  InvitationToken? token,  Duration? remaining,  bool isExpired,  bool isOffline,  InviteError? error)?  $default,) {final _that = this;
switch (_that) {
case _InvitePatientState() when $default != null:
return $default(_that.validity,_that.isGenerating,_that.token,_that.remaining,_that.isExpired,_that.isOffline,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _InvitePatientState extends InvitePatientState {
  const _InvitePatientState({this.validity = InvitationValidity.defaultValidity, this.isGenerating = true, this.token, this.remaining, this.isExpired = false, this.isOffline = false, this.error}): super._();
  

@override@JsonKey() final  InvitationValidity validity;
@override@JsonKey() final  bool isGenerating;
@override final  InvitationToken? token;
@override final  Duration? remaining;
@override@JsonKey() final  bool isExpired;
@override@JsonKey() final  bool isOffline;
@override final  InviteError? error;

/// Create a copy of InvitePatientState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvitePatientStateCopyWith<_InvitePatientState> get copyWith => __$InvitePatientStateCopyWithImpl<_InvitePatientState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvitePatientState&&(identical(other.validity, validity) || other.validity == validity)&&(identical(other.isGenerating, isGenerating) || other.isGenerating == isGenerating)&&(identical(other.token, token) || other.token == token)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.isExpired, isExpired) || other.isExpired == isExpired)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode {
    return Object.hash(runtimeType,validity,isGenerating,token,remaining,isExpired,isOffline,error);
}



}

/// @nodoc
abstract mixin class _$InvitePatientStateCopyWith<$Res> implements $InvitePatientStateCopyWith<$Res> {
  factory _$InvitePatientStateCopyWith(_InvitePatientState value, $Res Function(_InvitePatientState) _then) = __$InvitePatientStateCopyWithImpl;
@override @useResult
$Res call({
 InvitationValidity validity, bool isGenerating, InvitationToken? token, Duration? remaining, bool isExpired, bool isOffline, InviteError? error
});




}
/// @nodoc
class __$InvitePatientStateCopyWithImpl<$Res>
    implements _$InvitePatientStateCopyWith<$Res> {
  __$InvitePatientStateCopyWithImpl(this._self, this._then);

  final _InvitePatientState _self;
  final $Res Function(_InvitePatientState) _then;

/// Create a copy of InvitePatientState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? validity = null,Object? isGenerating = null,Object? token = freezed,Object? remaining = freezed,Object? isExpired = null,Object? isOffline = null,Object? error = freezed,}) {
  return _then(_InvitePatientState(
validity: null == validity ? _self.validity : validity // ignore: cast_nullable_to_non_nullable
as InvitationValidity,isGenerating: null == isGenerating ? _self.isGenerating : isGenerating // ignore: cast_nullable_to_non_nullable
as bool,token: freezed == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as InvitationToken?,remaining: freezed == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as Duration?,isExpired: null == isExpired ? _self.isExpired : isExpired // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as InviteError?,
  ));
}


}

// dart format on
