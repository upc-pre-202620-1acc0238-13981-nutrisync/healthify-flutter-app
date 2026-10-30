// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'practitioner_settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PractitionerSettingsState {

 String get fullName; String get email; PreferredLanguage get language; bool get isOffline;
/// Create a copy of PractitionerSettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PractitionerSettingsStateCopyWith<PractitionerSettingsState> get copyWith => _$PractitionerSettingsStateCopyWithImpl<PractitionerSettingsState>(this as PractitionerSettingsState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PractitionerSettingsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PractitionerSettingsState&&(identical(other.fullName, _this.fullName) || other.fullName == _this.fullName)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.isOffline, _this.isOffline) || other.isOffline == _this.isOffline));
}


@override
int get hashCode {
  final _this = this as PractitionerSettingsState;
  return Object.hash(runtimeType,_this.fullName,_this.email,_this.language,_this.isOffline);
}

@override
String toString() {
  final _this = this as PractitionerSettingsState;
  return 'PractitionerSettingsState(fullName: ${_this.fullName}, email: ${_this.email}, language: ${_this.language}, isOffline: ${_this.isOffline})';
}


}

/// @nodoc
abstract mixin class $PractitionerSettingsStateCopyWith<$Res>  {
  factory $PractitionerSettingsStateCopyWith(PractitionerSettingsState value, $Res Function(PractitionerSettingsState) _then) = _$PractitionerSettingsStateCopyWithImpl;
@useResult
$Res call({
 String fullName, String email, PreferredLanguage language, bool isOffline
});




}
/// @nodoc
class _$PractitionerSettingsStateCopyWithImpl<$Res>
    implements $PractitionerSettingsStateCopyWith<$Res> {
  _$PractitionerSettingsStateCopyWithImpl(this._self, this._then);

  final PractitionerSettingsState _self;
  final $Res Function(PractitionerSettingsState) _then;

/// Create a copy of PractitionerSettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fullName = null,Object? email = null,Object? language = null,Object? isOffline = null,}) {
  return _then(PractitionerSettingsState(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as PreferredLanguage,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PractitionerSettingsState].
extension PractitionerSettingsStatePatterns on PractitionerSettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PractitionerSettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PractitionerSettingsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PractitionerSettingsState value)  $default,){
final _that = this;
switch (_that) {
case _PractitionerSettingsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PractitionerSettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _PractitionerSettingsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String fullName,  String email,  PreferredLanguage language,  bool isOffline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PractitionerSettingsState() when $default != null:
return $default(_that.fullName,_that.email,_that.language,_that.isOffline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String fullName,  String email,  PreferredLanguage language,  bool isOffline)  $default,) {final _that = this;
switch (_that) {
case _PractitionerSettingsState():
return $default(_that.fullName,_that.email,_that.language,_that.isOffline);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String fullName,  String email,  PreferredLanguage language,  bool isOffline)?  $default,) {final _that = this;
switch (_that) {
case _PractitionerSettingsState() when $default != null:
return $default(_that.fullName,_that.email,_that.language,_that.isOffline);case _:
  return null;

}
}

}

/// @nodoc


class _PractitionerSettingsState implements PractitionerSettingsState {
  const _PractitionerSettingsState({this.fullName = '', this.email = '', this.language = PreferredLanguage.defaultLanguage, this.isOffline = false});
  

@override@JsonKey() final  String fullName;
@override@JsonKey() final  String email;
@override@JsonKey() final  PreferredLanguage language;
@override@JsonKey() final  bool isOffline;

/// Create a copy of PractitionerSettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PractitionerSettingsStateCopyWith<_PractitionerSettingsState> get copyWith => __$PractitionerSettingsStateCopyWithImpl<_PractitionerSettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PractitionerSettingsState&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.language, language) || other.language == language)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline));
}


@override
int get hashCode {
    return Object.hash(runtimeType,fullName,email,language,isOffline);
}

@override
String toString() {
    return 'PractitionerSettingsState(fullName: $fullName, email: $email, language: $language, isOffline: $isOffline)';
}


}

/// @nodoc
abstract mixin class _$PractitionerSettingsStateCopyWith<$Res> implements $PractitionerSettingsStateCopyWith<$Res> {
  factory _$PractitionerSettingsStateCopyWith(_PractitionerSettingsState value, $Res Function(_PractitionerSettingsState) _then) = __$PractitionerSettingsStateCopyWithImpl;
@override @useResult
$Res call({
 String fullName, String email, PreferredLanguage language, bool isOffline
});




}
/// @nodoc
class __$PractitionerSettingsStateCopyWithImpl<$Res>
    implements _$PractitionerSettingsStateCopyWith<$Res> {
  __$PractitionerSettingsStateCopyWithImpl(this._self, this._then);

  final _PractitionerSettingsState _self;
  final $Res Function(_PractitionerSettingsState) _then;

/// Create a copy of PractitionerSettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fullName = null,Object? email = null,Object? language = null,Object? isOffline = null,}) {
  return _then(_PractitionerSettingsState(
fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as PreferredLanguage,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
