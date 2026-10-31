// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sign_up_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SignUpFieldErrors {

 PersonNameProblem? get givenNames; PersonNameProblem? get familyNames; SignUpEmailError? get email; bool get weakPassword; bool get termsNotAccepted;
/// Create a copy of SignUpFieldErrors
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignUpFieldErrorsCopyWith<SignUpFieldErrors> get copyWith => _$SignUpFieldErrorsCopyWithImpl<SignUpFieldErrors>(this as SignUpFieldErrors, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SignUpFieldErrors;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignUpFieldErrors&&(identical(other.givenNames, _this.givenNames) || other.givenNames == _this.givenNames)&&(identical(other.familyNames, _this.familyNames) || other.familyNames == _this.familyNames)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.weakPassword, _this.weakPassword) || other.weakPassword == _this.weakPassword)&&(identical(other.termsNotAccepted, _this.termsNotAccepted) || other.termsNotAccepted == _this.termsNotAccepted));
}


@override
int get hashCode {
  final _this = this as SignUpFieldErrors;
  return Object.hash(runtimeType,_this.givenNames,_this.familyNames,_this.email,_this.weakPassword,_this.termsNotAccepted);
}

@override
String toString() {
  final _this = this as SignUpFieldErrors;
  return 'SignUpFieldErrors(givenNames: ${_this.givenNames}, familyNames: ${_this.familyNames}, email: ${_this.email}, weakPassword: ${_this.weakPassword}, termsNotAccepted: ${_this.termsNotAccepted})';
}


}

/// @nodoc
abstract mixin class $SignUpFieldErrorsCopyWith<$Res>  {
  factory $SignUpFieldErrorsCopyWith(SignUpFieldErrors value, $Res Function(SignUpFieldErrors) _then) = _$SignUpFieldErrorsCopyWithImpl;
@useResult
$Res call({
 PersonNameProblem? givenNames, PersonNameProblem? familyNames, SignUpEmailError? email, bool weakPassword, bool termsNotAccepted
});




}
/// @nodoc
class _$SignUpFieldErrorsCopyWithImpl<$Res>
    implements $SignUpFieldErrorsCopyWith<$Res> {
  _$SignUpFieldErrorsCopyWithImpl(this._self, this._then);

  final SignUpFieldErrors _self;
  final $Res Function(SignUpFieldErrors) _then;

/// Create a copy of SignUpFieldErrors
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? givenNames = freezed,Object? familyNames = freezed,Object? email = freezed,Object? weakPassword = null,Object? termsNotAccepted = null,}) {
  return _then(SignUpFieldErrors(
givenNames: freezed == givenNames ? _self.givenNames : givenNames // ignore: cast_nullable_to_non_nullable
as PersonNameProblem?,familyNames: freezed == familyNames ? _self.familyNames : familyNames // ignore: cast_nullable_to_non_nullable
as PersonNameProblem?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as SignUpEmailError?,weakPassword: null == weakPassword ? _self.weakPassword : weakPassword // ignore: cast_nullable_to_non_nullable
as bool,termsNotAccepted: null == termsNotAccepted ? _self.termsNotAccepted : termsNotAccepted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [SignUpFieldErrors].
extension SignUpFieldErrorsPatterns on SignUpFieldErrors {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SignUpFieldErrors value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SignUpFieldErrors() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SignUpFieldErrors value)  $default,){
final _that = this;
switch (_that) {
case _SignUpFieldErrors():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SignUpFieldErrors value)?  $default,){
final _that = this;
switch (_that) {
case _SignUpFieldErrors() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PersonNameProblem? givenNames,  PersonNameProblem? familyNames,  SignUpEmailError? email,  bool weakPassword,  bool termsNotAccepted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SignUpFieldErrors() when $default != null:
return $default(_that.givenNames,_that.familyNames,_that.email,_that.weakPassword,_that.termsNotAccepted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PersonNameProblem? givenNames,  PersonNameProblem? familyNames,  SignUpEmailError? email,  bool weakPassword,  bool termsNotAccepted)  $default,) {final _that = this;
switch (_that) {
case _SignUpFieldErrors():
return $default(_that.givenNames,_that.familyNames,_that.email,_that.weakPassword,_that.termsNotAccepted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PersonNameProblem? givenNames,  PersonNameProblem? familyNames,  SignUpEmailError? email,  bool weakPassword,  bool termsNotAccepted)?  $default,) {final _that = this;
switch (_that) {
case _SignUpFieldErrors() when $default != null:
return $default(_that.givenNames,_that.familyNames,_that.email,_that.weakPassword,_that.termsNotAccepted);case _:
  return null;

}
}

}

/// @nodoc


class _SignUpFieldErrors implements SignUpFieldErrors {
  const _SignUpFieldErrors({this.givenNames, this.familyNames, this.email, this.weakPassword = false, this.termsNotAccepted = false});
  

@override final  PersonNameProblem? givenNames;
@override final  PersonNameProblem? familyNames;
@override final  SignUpEmailError? email;
@override@JsonKey() final  bool weakPassword;
@override@JsonKey() final  bool termsNotAccepted;

/// Create a copy of SignUpFieldErrors
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignUpFieldErrorsCopyWith<_SignUpFieldErrors> get copyWith => __$SignUpFieldErrorsCopyWithImpl<_SignUpFieldErrors>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignUpFieldErrors&&(identical(other.givenNames, givenNames) || other.givenNames == givenNames)&&(identical(other.familyNames, familyNames) || other.familyNames == familyNames)&&(identical(other.email, email) || other.email == email)&&(identical(other.weakPassword, weakPassword) || other.weakPassword == weakPassword)&&(identical(other.termsNotAccepted, termsNotAccepted) || other.termsNotAccepted == termsNotAccepted));
}


@override
int get hashCode {
    return Object.hash(runtimeType,givenNames,familyNames,email,weakPassword,termsNotAccepted);
}

@override
String toString() {
    return 'SignUpFieldErrors(givenNames: $givenNames, familyNames: $familyNames, email: $email, weakPassword: $weakPassword, termsNotAccepted: $termsNotAccepted)';
}


}

/// @nodoc
abstract mixin class _$SignUpFieldErrorsCopyWith<$Res> implements $SignUpFieldErrorsCopyWith<$Res> {
  factory _$SignUpFieldErrorsCopyWith(_SignUpFieldErrors value, $Res Function(_SignUpFieldErrors) _then) = __$SignUpFieldErrorsCopyWithImpl;
@override @useResult
$Res call({
 PersonNameProblem? givenNames, PersonNameProblem? familyNames, SignUpEmailError? email, bool weakPassword, bool termsNotAccepted
});




}
/// @nodoc
class __$SignUpFieldErrorsCopyWithImpl<$Res>
    implements _$SignUpFieldErrorsCopyWith<$Res> {
  __$SignUpFieldErrorsCopyWithImpl(this._self, this._then);

  final _SignUpFieldErrors _self;
  final $Res Function(_SignUpFieldErrors) _then;

/// Create a copy of SignUpFieldErrors
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? givenNames = freezed,Object? familyNames = freezed,Object? email = freezed,Object? weakPassword = null,Object? termsNotAccepted = null,}) {
  return _then(_SignUpFieldErrors(
givenNames: freezed == givenNames ? _self.givenNames : givenNames // ignore: cast_nullable_to_non_nullable
as PersonNameProblem?,familyNames: freezed == familyNames ? _self.familyNames : familyNames // ignore: cast_nullable_to_non_nullable
as PersonNameProblem?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as SignUpEmailError?,weakPassword: null == weakPassword ? _self.weakPassword : weakPassword // ignore: cast_nullable_to_non_nullable
as bool,termsNotAccepted: null == termsNotAccepted ? _self.termsNotAccepted : termsNotAccepted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$SignUpState {

 String get givenNames; String get familyNames; String get email; String get password; bool get acceptedTerms; SignUpFieldErrors get errors; bool get isSubmitting; bool get isOffline; bool get showErrorDialog;
/// Create a copy of SignUpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignUpStateCopyWith<SignUpState> get copyWith => _$SignUpStateCopyWithImpl<SignUpState>(this as SignUpState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SignUpState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignUpState&&(identical(other.givenNames, _this.givenNames) || other.givenNames == _this.givenNames)&&(identical(other.familyNames, _this.familyNames) || other.familyNames == _this.familyNames)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.password, _this.password) || other.password == _this.password)&&(identical(other.acceptedTerms, _this.acceptedTerms) || other.acceptedTerms == _this.acceptedTerms)&&(identical(other.errors, _this.errors) || other.errors == _this.errors)&&(identical(other.isSubmitting, _this.isSubmitting) || other.isSubmitting == _this.isSubmitting)&&(identical(other.isOffline, _this.isOffline) || other.isOffline == _this.isOffline)&&(identical(other.showErrorDialog, _this.showErrorDialog) || other.showErrorDialog == _this.showErrorDialog));
}


@override
int get hashCode {
  final _this = this as SignUpState;
  return Object.hash(runtimeType,_this.givenNames,_this.familyNames,_this.email,_this.password,_this.acceptedTerms,_this.errors,_this.isSubmitting,_this.isOffline,_this.showErrorDialog);
}



}

/// @nodoc
abstract mixin class $SignUpStateCopyWith<$Res>  {
  factory $SignUpStateCopyWith(SignUpState value, $Res Function(SignUpState) _then) = _$SignUpStateCopyWithImpl;
@useResult
$Res call({
 String givenNames, String familyNames, String email, String password, bool acceptedTerms, SignUpFieldErrors errors, bool isSubmitting, bool isOffline, bool showErrorDialog
});


$SignUpFieldErrorsCopyWith<$Res> get errors;

}
/// @nodoc
class _$SignUpStateCopyWithImpl<$Res>
    implements $SignUpStateCopyWith<$Res> {
  _$SignUpStateCopyWithImpl(this._self, this._then);

  final SignUpState _self;
  final $Res Function(SignUpState) _then;

/// Create a copy of SignUpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? givenNames = null,Object? familyNames = null,Object? email = null,Object? password = null,Object? acceptedTerms = null,Object? errors = null,Object? isSubmitting = null,Object? isOffline = null,Object? showErrorDialog = null,}) {
  return _then(SignUpState(
givenNames: null == givenNames ? _self.givenNames : givenNames // ignore: cast_nullable_to_non_nullable
as String,familyNames: null == familyNames ? _self.familyNames : familyNames // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,acceptedTerms: null == acceptedTerms ? _self.acceptedTerms : acceptedTerms // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as SignUpFieldErrors,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,showErrorDialog: null == showErrorDialog ? _self.showErrorDialog : showErrorDialog // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of SignUpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SignUpFieldErrorsCopyWith<$Res> get errors {
  
  return $SignUpFieldErrorsCopyWith<$Res>(_self.errors, (value) {
    return _then(_self.copyWith(errors: value));
  });
}
}


/// Adds pattern-matching-related methods to [SignUpState].
extension SignUpStatePatterns on SignUpState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SignUpState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SignUpState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SignUpState value)  $default,){
final _that = this;
switch (_that) {
case _SignUpState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SignUpState value)?  $default,){
final _that = this;
switch (_that) {
case _SignUpState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String givenNames,  String familyNames,  String email,  String password,  bool acceptedTerms,  SignUpFieldErrors errors,  bool isSubmitting,  bool isOffline,  bool showErrorDialog)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SignUpState() when $default != null:
return $default(_that.givenNames,_that.familyNames,_that.email,_that.password,_that.acceptedTerms,_that.errors,_that.isSubmitting,_that.isOffline,_that.showErrorDialog);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String givenNames,  String familyNames,  String email,  String password,  bool acceptedTerms,  SignUpFieldErrors errors,  bool isSubmitting,  bool isOffline,  bool showErrorDialog)  $default,) {final _that = this;
switch (_that) {
case _SignUpState():
return $default(_that.givenNames,_that.familyNames,_that.email,_that.password,_that.acceptedTerms,_that.errors,_that.isSubmitting,_that.isOffline,_that.showErrorDialog);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String givenNames,  String familyNames,  String email,  String password,  bool acceptedTerms,  SignUpFieldErrors errors,  bool isSubmitting,  bool isOffline,  bool showErrorDialog)?  $default,) {final _that = this;
switch (_that) {
case _SignUpState() when $default != null:
return $default(_that.givenNames,_that.familyNames,_that.email,_that.password,_that.acceptedTerms,_that.errors,_that.isSubmitting,_that.isOffline,_that.showErrorDialog);case _:
  return null;

}
}

}

/// @nodoc


class _SignUpState extends SignUpState {
  const _SignUpState({this.givenNames = '', this.familyNames = '', this.email = '', this.password = '', this.acceptedTerms = false, this.errors = const SignUpFieldErrors(), this.isSubmitting = false, this.isOffline = false, this.showErrorDialog = false}): super._();
  

@override@JsonKey() final  String givenNames;
@override@JsonKey() final  String familyNames;
@override@JsonKey() final  String email;
@override@JsonKey() final  String password;
@override@JsonKey() final  bool acceptedTerms;
@override@JsonKey() final  SignUpFieldErrors errors;
@override@JsonKey() final  bool isSubmitting;
@override@JsonKey() final  bool isOffline;
@override@JsonKey() final  bool showErrorDialog;

/// Create a copy of SignUpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignUpStateCopyWith<_SignUpState> get copyWith => __$SignUpStateCopyWithImpl<_SignUpState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignUpState&&(identical(other.givenNames, givenNames) || other.givenNames == givenNames)&&(identical(other.familyNames, familyNames) || other.familyNames == familyNames)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.acceptedTerms, acceptedTerms) || other.acceptedTerms == acceptedTerms)&&(identical(other.errors, errors) || other.errors == errors)&&(identical(other.isSubmitting, isSubmitting) || other.isSubmitting == isSubmitting)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline)&&(identical(other.showErrorDialog, showErrorDialog) || other.showErrorDialog == showErrorDialog));
}


@override
int get hashCode {
    return Object.hash(runtimeType,givenNames,familyNames,email,password,acceptedTerms,errors,isSubmitting,isOffline,showErrorDialog);
}



}

/// @nodoc
abstract mixin class _$SignUpStateCopyWith<$Res> implements $SignUpStateCopyWith<$Res> {
  factory _$SignUpStateCopyWith(_SignUpState value, $Res Function(_SignUpState) _then) = __$SignUpStateCopyWithImpl;
@override @useResult
$Res call({
 String givenNames, String familyNames, String email, String password, bool acceptedTerms, SignUpFieldErrors errors, bool isSubmitting, bool isOffline, bool showErrorDialog
});


@override $SignUpFieldErrorsCopyWith<$Res> get errors;

}
/// @nodoc
class __$SignUpStateCopyWithImpl<$Res>
    implements _$SignUpStateCopyWith<$Res> {
  __$SignUpStateCopyWithImpl(this._self, this._then);

  final _SignUpState _self;
  final $Res Function(_SignUpState) _then;

/// Create a copy of SignUpState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? givenNames = null,Object? familyNames = null,Object? email = null,Object? password = null,Object? acceptedTerms = null,Object? errors = null,Object? isSubmitting = null,Object? isOffline = null,Object? showErrorDialog = null,}) {
  return _then(_SignUpState(
givenNames: null == givenNames ? _self.givenNames : givenNames // ignore: cast_nullable_to_non_nullable
as String,familyNames: null == familyNames ? _self.familyNames : familyNames // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,acceptedTerms: null == acceptedTerms ? _self.acceptedTerms : acceptedTerms // ignore: cast_nullable_to_non_nullable
as bool,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as SignUpFieldErrors,isSubmitting: null == isSubmitting ? _self.isSubmitting : isSubmitting // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,showErrorDialog: null == showErrorDialog ? _self.showErrorDialog : showErrorDialog // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SignUpState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SignUpFieldErrorsCopyWith<$Res> get errors {
  
  return $SignUpFieldErrorsCopyWith<$Res>(_self.errors, (value) {
    return _then(_self.copyWith(errors: value));
  });
}
}

// dart format on
