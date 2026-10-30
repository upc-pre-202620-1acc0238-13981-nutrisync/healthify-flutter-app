// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'forgot_password_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ForgotPasswordState {

 ForgotPasswordStep get step; String get email; String get code; String get newPassword; bool get invalidEmail; bool get invalidCode; bool get weakPassword; bool get passwordReused; bool get tokenExpired; bool get isSubmitting; bool get isOffline; int get resendInSeconds; bool get codeResent; bool get showErrorDialog;
/// Create a copy of ForgotPasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForgotPasswordStateCopyWith<ForgotPasswordState> get copyWith => _$ForgotPasswordStateCopyWithImpl<ForgotPasswordState>(this as ForgotPasswordState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ForgotPasswordState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ForgotPasswordState&&(identical(other.step, _this.step) || other.step == _this.step)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.newPassword, _this.newPassword) || other.newPassword == _this.newPassword)&&(identical(other.invalidEmail, _this.invalidEmail) || other.invalidEmail == _this.invalidEmail)&&(identical(other.invalidCode, _this.invalidCode) || other.invalidCode == _this.invalidCode)&&(identical(other.weakPassword, _this.weakPassword) || other.weakPassword == _this.weakPassword)&&(identical(other.passwordReused, _this.passwordReused) || other.passwordReused == _this.passwordReused)&&(identical(other.tokenExpired, _this.tokenExpired) || other.tokenExpired == _this.tokenExpired)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&(identical(other.isOffline, _this.isOffline) || other.isOffline == _this.isOffline)&&(identical(other.resendInSeconds, _this.resendInSeconds) || other.resendInSeconds == _this.resendInSeconds)&&(identical(other.codeResent, _this.codeResent) || other.codeResent == _this.codeResent)&&(identical(other.showErrorDialog, _this.showErrorDialog) || other.showErrorDialog == _this.showErrorDialog));
}


@override
int get hashCode {
  final _this = this as ForgotPasswordState;
  return Object.hash(runtimeType,_this.step,_this.email,_this.code,_this.newPassword,_this.invalidEmail,_this.invalidCode,_this.weakPassword,_this.passwordReused,_this.tokenExpired,_this.isSubmitting,_this.isOffline,_this.resendInSeconds,_this.codeResent,_this.showErrorDialog);
}



}

/// @nodoc
abstract mixin class $ForgotPasswordStateCopyWith<$Res>  {
  factory $ForgotPasswordStateCopyWith(ForgotPasswordState value, $Res Function(ForgotPasswordState) _then) = _$ForgotPasswordStateCopyWithImpl;
@useResult
$Res call({
 ForgotPasswordStep step, String email, String code, String newPassword, bool invalidEmail, bool invalidCode, bool weakPassword, bool passwordReused, bool tokenExpired, bool isSubmitting, bool isOffline, int resendInSeconds, bool codeResent, bool showErrorDialog
});




}
/// @nodoc
class _$ForgotPasswordStateCopyWithImpl<$Res>
    implements $ForgotPasswordStateCopyWith<$Res> {
  _$ForgotPasswordStateCopyWithImpl(this._self, this._then);

  final ForgotPasswordState _self;
  final $Res Function(ForgotPasswordState) _then;

/// Create a copy of ForgotPasswordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? step = null,Object? email = null,Object? code = null,Object? newPassword = null,Object? invalidEmail = null,Object? invalidCode = null,Object? weakPassword = null,Object? passwordReused = null,Object? tokenExpired = null,Object? isSubmitting = null,Object? isOffline = null,Object? resendInSeconds = null,Object? codeResent = null,Object? showErrorDialog = null,}) {
  return _then(ForgotPasswordState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as ForgotPasswordStep,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,newPassword: null == newPassword ? _self.newPassword : newPassword // ignore: cast_nullable_to_non_nullable
as String,invalidEmail: null == invalidEmail ? _self.invalidEmail : invalidEmail // ignore: cast_nullable_to_non_nullable
as bool,invalidCode: null == invalidCode ? _self.invalidCode : invalidCode // ignore: cast_nullable_to_non_nullable
as bool,weakPassword: null == weakPassword ? _self.weakPassword : weakPassword // ignore: cast_nullable_to_non_nullable
as bool,passwordReused: null == passwordReused ? _self.passwordReused : passwordReused // ignore: cast_nullable_to_non_nullable
as bool,tokenExpired: null == tokenExpired ? _self.tokenExpired : tokenExpired // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,resendInSeconds: null == resendInSeconds ? _self.resendInSeconds : resendInSeconds // ignore: cast_nullable_to_non_nullable
as int,codeResent: null == codeResent ? _self.codeResent : codeResent // ignore: cast_nullable_to_non_nullable
as bool,showErrorDialog: null == showErrorDialog ? _self.showErrorDialog : showErrorDialog // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ForgotPasswordState].
extension ForgotPasswordStatePatterns on ForgotPasswordState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ForgotPasswordState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ForgotPasswordState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ForgotPasswordState value)  $default,){
final _that = this;
switch (_that) {
case _ForgotPasswordState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ForgotPasswordState value)?  $default,){
final _that = this;
switch (_that) {
case _ForgotPasswordState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ForgotPasswordStep step,  String email,  String code,  String newPassword,  bool invalidEmail,  bool invalidCode,  bool weakPassword,  bool passwordReused,  bool tokenExpired,  bool isSubmitting,  bool isOffline,  int resendInSeconds,  bool codeResent,  bool showErrorDialog)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ForgotPasswordState() when $default != null:
return $default(_that.step,_that.email,_that.code,_that.newPassword,_that.invalidEmail,_that.invalidCode,_that.weakPassword,_that.passwordReused,_that.tokenExpired,_that.isSubmitting,_that.isOffline,_that.resendInSeconds,_that.codeResent,_that.showErrorDialog);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ForgotPasswordStep step,  String email,  String code,  String newPassword,  bool invalidEmail,  bool invalidCode,  bool weakPassword,  bool passwordReused,  bool tokenExpired,  bool isSubmitting,  bool isOffline,  int resendInSeconds,  bool codeResent,  bool showErrorDialog)  $default,) {final _that = this;
switch (_that) {
case _ForgotPasswordState():
return $default(_that.step,_that.email,_that.code,_that.newPassword,_that.invalidEmail,_that.invalidCode,_that.weakPassword,_that.passwordReused,_that.tokenExpired,_that.isSubmitting,_that.isOffline,_that.resendInSeconds,_that.codeResent,_that.showErrorDialog);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ForgotPasswordStep step,  String email,  String code,  String newPassword,  bool invalidEmail,  bool invalidCode,  bool weakPassword,  bool passwordReused,  bool tokenExpired,  bool isSubmitting,  bool isOffline,  int resendInSeconds,  bool codeResent,  bool showErrorDialog)?  $default,) {final _that = this;
switch (_that) {
case _ForgotPasswordState() when $default != null:
return $default(_that.step,_that.email,_that.code,_that.newPassword,_that.invalidEmail,_that.invalidCode,_that.weakPassword,_that.passwordReused,_that.tokenExpired,_that.isSubmitting,_that.isOffline,_that.resendInSeconds,_that.codeResent,_that.showErrorDialog);case _:
  return null;

}
}

}

/// @nodoc


class _ForgotPasswordState extends ForgotPasswordState {
  const _ForgotPasswordState({this.step = ForgotPasswordStep.email, this.email = '', this.code = '', this.newPassword = '', this.invalidEmail = false, this.invalidCode = false, this.weakPassword = false, this.passwordReused = false, this.tokenExpired = false, this.isSubmitting = false, this.isOffline = false, this.resendInSeconds = 0, this.codeResent = false, this.showErrorDialog = false}): super._();
  

@override@JsonKey() final  ForgotPasswordStep step;
@override@JsonKey() final  String email;
@override@JsonKey() final  String code;
@override@JsonKey() final  String newPassword;
@override@JsonKey() final  bool invalidEmail;
@override@JsonKey() final  bool invalidCode;
@override@JsonKey() final  bool weakPassword;
@override@JsonKey() final  bool passwordReused;
@override@JsonKey() final  bool tokenExpired;
@override@JsonKey() final  bool isSubmitting;
@override@JsonKey() final  bool isOffline;
@override@JsonKey() final  int resendInSeconds;
@override@JsonKey() final  bool codeResent;
@override@JsonKey() final  bool showErrorDialog;

/// Create a copy of ForgotPasswordState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ForgotPasswordStateCopyWith<_ForgotPasswordState> get copyWith => __$ForgotPasswordStateCopyWithImpl<_ForgotPasswordState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ForgotPasswordState&&(identical(other.step, step) || other.step == step)&&(identical(other.email, email) || other.email == email)&&(identical(other.code, code) || other.code == code)&&(identical(other.newPassword, newPassword) || other.newPassword == newPassword)&&(identical(other.invalidEmail, invalidEmail) || other.invalidEmail == invalidEmail)&&(identical(other.invalidCode, invalidCode) || other.invalidCode == invalidCode)&&(identical(other.weakPassword, weakPassword) || other.weakPassword == weakPassword)&&(identical(other.passwordReused, passwordReused) || other.passwordReused == passwordReused)&&(identical(other.tokenExpired, tokenExpired) || other.tokenExpired == tokenExpired)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline)&&(identical(other.resendInSeconds, resendInSeconds) || other.resendInSeconds == resendInSeconds)&&(identical(other.codeResent, codeResent) || other.codeResent == codeResent)&&(identical(other.showErrorDialog, showErrorDialog) || other.showErrorDialog == showErrorDialog));
}


@override
int get hashCode {
    return Object.hash(runtimeType,step,email,code,newPassword,invalidEmail,invalidCode,weakPassword,passwordReused,tokenExpired,isSubmitting,isOffline,resendInSeconds,codeResent,showErrorDialog);
}



}

/// @nodoc
abstract mixin class _$ForgotPasswordStateCopyWith<$Res> implements $ForgotPasswordStateCopyWith<$Res> {
  factory _$ForgotPasswordStateCopyWith(_ForgotPasswordState value, $Res Function(_ForgotPasswordState) _then) = __$ForgotPasswordStateCopyWithImpl;
@override @useResult
$Res call({
 ForgotPasswordStep step, String email, String code, String newPassword, bool invalidEmail, bool invalidCode, bool weakPassword, bool passwordReused, bool tokenExpired, bool isSubmitting, bool isOffline, int resendInSeconds, bool codeResent, bool showErrorDialog
});




}
/// @nodoc
class __$ForgotPasswordStateCopyWithImpl<$Res>
    implements _$ForgotPasswordStateCopyWith<$Res> {
  __$ForgotPasswordStateCopyWithImpl(this._self, this._then);

  final _ForgotPasswordState _self;
  final $Res Function(_ForgotPasswordState) _then;

/// Create a copy of ForgotPasswordState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? step = null,Object? email = null,Object? code = null,Object? newPassword = null,Object? invalidEmail = null,Object? invalidCode = null,Object? weakPassword = null,Object? passwordReused = null,Object? tokenExpired = null,Object? isSubmitting = null,Object? isOffline = null,Object? resendInSeconds = null,Object? codeResent = null,Object? showErrorDialog = null,}) {
  return _then(_ForgotPasswordState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as ForgotPasswordStep,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,newPassword: null == newPassword ? _self.newPassword : newPassword // ignore: cast_nullable_to_non_nullable
as String,invalidEmail: null == invalidEmail ? _self.invalidEmail : invalidEmail // ignore: cast_nullable_to_non_nullable
as bool,invalidCode: null == invalidCode ? _self.invalidCode : invalidCode // ignore: cast_nullable_to_non_nullable
as bool,weakPassword: null == weakPassword ? _self.weakPassword : weakPassword // ignore: cast_nullable_to_non_nullable
as bool,passwordReused: null == passwordReused ? _self.passwordReused : passwordReused // ignore: cast_nullable_to_non_nullable
as bool,tokenExpired: null == tokenExpired ? _self.tokenExpired : tokenExpired // ignore: cast_nullable_to_non_nullable
as bool,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,resendInSeconds: null == resendInSeconds ? _self.resendInSeconds : resendInSeconds // ignore: cast_nullable_to_non_nullable
as int,codeResent: null == codeResent ? _self.codeResent : codeResent // ignore: cast_nullable_to_non_nullable
as bool,showErrorDialog: null == showErrorDialog ? _self.showErrorDialog : showErrorDialog // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
