// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_states.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$InboxRow {

 int get id; String? get patientName; SignalType get signal; DateTime? get receivedAt;
/// Create a copy of InboxRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InboxRowCopyWith<InboxRow> get copyWith => _$InboxRowCopyWithImpl<InboxRow>(this as InboxRow, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as InboxRow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InboxRow&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.patientName, _this.patientName) || other.patientName == _this.patientName)&&(identical(other.signal, _this.signal) || other.signal == _this.signal)&&(identical(other.receivedAt, _this.receivedAt) || other.receivedAt == _this.receivedAt));
}


@override
int get hashCode {
  final _this = this as InboxRow;
  return Object.hash(runtimeType,_this.id,_this.patientName,_this.signal,_this.receivedAt);
}

@override
String toString() {
  final _this = this as InboxRow;
  return 'InboxRow(id: ${_this.id}, patientName: ${_this.patientName}, signal: ${_this.signal}, receivedAt: ${_this.receivedAt})';
}


}

/// @nodoc
abstract mixin class $InboxRowCopyWith<$Res>  {
  factory $InboxRowCopyWith(InboxRow value, $Res Function(InboxRow) _then) = _$InboxRowCopyWithImpl;
@useResult
$Res call({
 int id, String? patientName, SignalType signal, DateTime? receivedAt
});




}
/// @nodoc
class _$InboxRowCopyWithImpl<$Res>
    implements $InboxRowCopyWith<$Res> {
  _$InboxRowCopyWithImpl(this._self, this._then);

  final InboxRow _self;
  final $Res Function(InboxRow) _then;

/// Create a copy of InboxRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? patientName = freezed,Object? signal = null,Object? receivedAt = freezed,}) {
  return _then(InboxRow(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,patientName: freezed == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String?,signal: null == signal ? _self.signal : signal // ignore: cast_nullable_to_non_nullable
as SignalType,receivedAt: freezed == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [InboxRow].
extension InboxRowPatterns on InboxRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InboxRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InboxRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InboxRow value)  $default,){
final _that = this;
switch (_that) {
case _InboxRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InboxRow value)?  $default,){
final _that = this;
switch (_that) {
case _InboxRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? patientName,  SignalType signal,  DateTime? receivedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InboxRow() when $default != null:
return $default(_that.id,_that.patientName,_that.signal,_that.receivedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? patientName,  SignalType signal,  DateTime? receivedAt)  $default,) {final _that = this;
switch (_that) {
case _InboxRow():
return $default(_that.id,_that.patientName,_that.signal,_that.receivedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? patientName,  SignalType signal,  DateTime? receivedAt)?  $default,) {final _that = this;
switch (_that) {
case _InboxRow() when $default != null:
return $default(_that.id,_that.patientName,_that.signal,_that.receivedAt);case _:
  return null;

}
}

}

/// @nodoc


class _InboxRow implements InboxRow {
  const _InboxRow({required this.id, required this.patientName, required this.signal, required this.receivedAt});
  

@override final  int id;
@override final  String? patientName;
@override final  SignalType signal;
@override final  DateTime? receivedAt;

/// Create a copy of InboxRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InboxRowCopyWith<_InboxRow> get copyWith => __$InboxRowCopyWithImpl<_InboxRow>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InboxRow&&(identical(other.id, id) || other.id == id)&&(identical(other.patientName, patientName) || other.patientName == patientName)&&(identical(other.signal, signal) || other.signal == signal)&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,patientName,signal,receivedAt);
}

@override
String toString() {
    return 'InboxRow(id: $id, patientName: $patientName, signal: $signal, receivedAt: $receivedAt)';
}


}

/// @nodoc
abstract mixin class _$InboxRowCopyWith<$Res> implements $InboxRowCopyWith<$Res> {
  factory _$InboxRowCopyWith(_InboxRow value, $Res Function(_InboxRow) _then) = __$InboxRowCopyWithImpl;
@override @useResult
$Res call({
 int id, String? patientName, SignalType signal, DateTime? receivedAt
});




}
/// @nodoc
class __$InboxRowCopyWithImpl<$Res>
    implements _$InboxRowCopyWith<$Res> {
  __$InboxRowCopyWithImpl(this._self, this._then);

  final _InboxRow _self;
  final $Res Function(_InboxRow) _then;

/// Create a copy of InboxRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? patientName = freezed,Object? signal = null,Object? receivedAt = freezed,}) {
  return _then(_InboxRow(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,patientName: freezed == patientName ? _self.patientName : patientName // ignore: cast_nullable_to_non_nullable
as String?,signal: null == signal ? _self.signal : signal // ignore: cast_nullable_to_non_nullable
as SignalType,receivedAt: freezed == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$ReviewInboxState {

 bool get isLoading; bool get isOffline; bool get loadFailed; List<InboxRow>? get items;
/// Create a copy of ReviewInboxState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewInboxStateCopyWith<ReviewInboxState> get copyWith => _$ReviewInboxStateCopyWithImpl<ReviewInboxState>(this as ReviewInboxState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ReviewInboxState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewInboxState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isOffline, _this.isOffline) || other.isOffline == _this.isOffline)&&(identical(other.loadFailed, _this.loadFailed) || other.loadFailed == _this.loadFailed)&&const DeepCollectionEquality().equals(other.items, _this.items));
}


@override
int get hashCode {
  final _this = this as ReviewInboxState;
  return Object.hash(runtimeType,_this.isLoading,_this.isOffline,_this.loadFailed,const DeepCollectionEquality().hash(_this.items));
}

@override
String toString() {
  final _this = this as ReviewInboxState;
  return 'ReviewInboxState(isLoading: ${_this.isLoading}, isOffline: ${_this.isOffline}, loadFailed: ${_this.loadFailed}, items: ${_this.items})';
}


}

/// @nodoc
abstract mixin class $ReviewInboxStateCopyWith<$Res>  {
  factory $ReviewInboxStateCopyWith(ReviewInboxState value, $Res Function(ReviewInboxState) _then) = _$ReviewInboxStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool isOffline, bool loadFailed, List<InboxRow>? items
});




}
/// @nodoc
class _$ReviewInboxStateCopyWithImpl<$Res>
    implements $ReviewInboxStateCopyWith<$Res> {
  _$ReviewInboxStateCopyWithImpl(this._self, this._then);

  final ReviewInboxState _self;
  final $Res Function(ReviewInboxState) _then;

/// Create a copy of ReviewInboxState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? isOffline = null,Object? loadFailed = null,Object? items = freezed,}) {
  return _then(ReviewInboxState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,loadFailed: null == loadFailed ? _self.loadFailed : loadFailed // ignore: cast_nullable_to_non_nullable
as bool,items: freezed == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<InboxRow>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewInboxState].
extension ReviewInboxStatePatterns on ReviewInboxState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewInboxState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewInboxState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewInboxState value)  $default,){
final _that = this;
switch (_that) {
case _ReviewInboxState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewInboxState value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewInboxState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool isOffline,  bool loadFailed,  List<InboxRow>? items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewInboxState() when $default != null:
return $default(_that.isLoading,_that.isOffline,_that.loadFailed,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool isOffline,  bool loadFailed,  List<InboxRow>? items)  $default,) {final _that = this;
switch (_that) {
case _ReviewInboxState():
return $default(_that.isLoading,_that.isOffline,_that.loadFailed,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool isOffline,  bool loadFailed,  List<InboxRow>? items)?  $default,) {final _that = this;
switch (_that) {
case _ReviewInboxState() when $default != null:
return $default(_that.isLoading,_that.isOffline,_that.loadFailed,_that.items);case _:
  return null;

}
}

}

/// @nodoc


class _ReviewInboxState extends ReviewInboxState {
  const _ReviewInboxState({this.isLoading = true, this.isOffline = false, this.loadFailed = false,  List<InboxRow>? items}): _items = items,super._();
  

@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isOffline;
@override@JsonKey() final  bool loadFailed;
 final  List<InboxRow>? _items;
@override List<InboxRow>? get items {
  final value = _items;
  if (value == null) return null;
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ReviewInboxState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewInboxStateCopyWith<_ReviewInboxState> get copyWith => __$ReviewInboxStateCopyWithImpl<_ReviewInboxState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewInboxState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline)&&(identical(other.loadFailed, loadFailed) || other.loadFailed == loadFailed)&&const DeepCollectionEquality().equals(other.items, _items));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,isOffline,loadFailed,const DeepCollectionEquality().hash(_items));
}

@override
String toString() {
    return 'ReviewInboxState(isLoading: $isLoading, isOffline: $isOffline, loadFailed: $loadFailed, items: $items)';
}


}

/// @nodoc
abstract mixin class _$ReviewInboxStateCopyWith<$Res> implements $ReviewInboxStateCopyWith<$Res> {
  factory _$ReviewInboxStateCopyWith(_ReviewInboxState value, $Res Function(_ReviewInboxState) _then) = __$ReviewInboxStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool isOffline, bool loadFailed, List<InboxRow>? items
});




}
/// @nodoc
class __$ReviewInboxStateCopyWithImpl<$Res>
    implements _$ReviewInboxStateCopyWith<$Res> {
  __$ReviewInboxStateCopyWithImpl(this._self, this._then);

  final _ReviewInboxState _self;
  final $Res Function(_ReviewInboxState) _then;

/// Create a copy of ReviewInboxState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? isOffline = null,Object? loadFailed = null,Object? items = freezed,}) {
  return _then(_ReviewInboxState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,loadFailed: null == loadFailed ? _self.loadFailed : loadFailed // ignore: cast_nullable_to_non_nullable
as bool,items: freezed == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<InboxRow>?,
  ));
}


}

/// @nodoc
mixin _$ReviewItemState {

 bool get isLoading; ReviewLoadError? get loadError; ReviewItem? get item; ProposalSection get proposal; bool get showManualResolution; bool? get adjusted; String get note; bool get showOutcomeError; bool get isResolving; bool get isAccepting; bool get isOpeningPatient; bool get isOffline; ReviewDialog? get dialog;
/// Create a copy of ReviewItemState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewItemStateCopyWith<ReviewItemState> get copyWith => _$ReviewItemStateCopyWithImpl<ReviewItemState>(this as ReviewItemState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ReviewItemState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewItemState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.loadError, _this.loadError) || other.loadError == _this.loadError)&&(identical(other.item, _this.item) || other.item == _this.item)&&(identical(other.proposal, _this.proposal) || other.proposal == _this.proposal)&&(identical(other.showManualResolution, _this.showManualResolution) || other.showManualResolution == _this.showManualResolution)&&(identical(other.adjusted, _this.adjusted) || other.adjusted == _this.adjusted)&&(identical(other.note, _this.note) || other.note == _this.note)&&(identical(other.showOutcomeError, _this.showOutcomeError) || other.showOutcomeError == _this.showOutcomeError)&&(identical(other.isResolving, _this.isResolving) || other.isResolving == _this.isResolving)&&(identical(other.isAccepting, _this.isAccepting) || other.isAccepting == _this.isAccepting)&&(identical(other.isOpeningPatient, _this.isOpeningPatient) || other.isOpeningPatient == _this.isOpeningPatient)&&(identical(other.isOffline, _this.isOffline) || other.isOffline == _this.isOffline)&&(identical(other.dialog, _this.dialog) || other.dialog == _this.dialog));
}


@override
int get hashCode {
  final _this = this as ReviewItemState;
  return Object.hash(runtimeType,_this.isLoading,_this.loadError,_this.item,_this.proposal,_this.showManualResolution,_this.adjusted,_this.note,_this.showOutcomeError,_this.isResolving,_this.isAccepting,_this.isOpeningPatient,_this.isOffline,_this.dialog);
}

@override
String toString() {
  final _this = this as ReviewItemState;
  return 'ReviewItemState(isLoading: ${_this.isLoading}, loadError: ${_this.loadError}, item: ${_this.item}, proposal: ${_this.proposal}, showManualResolution: ${_this.showManualResolution}, adjusted: ${_this.adjusted}, note: ${_this.note}, showOutcomeError: ${_this.showOutcomeError}, isResolving: ${_this.isResolving}, isAccepting: ${_this.isAccepting}, isOpeningPatient: ${_this.isOpeningPatient}, isOffline: ${_this.isOffline}, dialog: ${_this.dialog})';
}


}

/// @nodoc
abstract mixin class $ReviewItemStateCopyWith<$Res>  {
  factory $ReviewItemStateCopyWith(ReviewItemState value, $Res Function(ReviewItemState) _then) = _$ReviewItemStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, ReviewLoadError? loadError, ReviewItem? item, ProposalSection proposal, bool showManualResolution, bool? adjusted, String note, bool showOutcomeError, bool isResolving, bool isAccepting, bool isOpeningPatient, bool isOffline, ReviewDialog? dialog
});




}
/// @nodoc
class _$ReviewItemStateCopyWithImpl<$Res>
    implements $ReviewItemStateCopyWith<$Res> {
  _$ReviewItemStateCopyWithImpl(this._self, this._then);

  final ReviewItemState _self;
  final $Res Function(ReviewItemState) _then;

/// Create a copy of ReviewItemState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? loadError = freezed,Object? item = freezed,Object? proposal = null,Object? showManualResolution = null,Object? adjusted = freezed,Object? note = null,Object? showOutcomeError = null,Object? isResolving = null,Object? isAccepting = null,Object? isOpeningPatient = null,Object? isOffline = null,Object? dialog = freezed,}) {
  return _then(ReviewItemState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,loadError: freezed == loadError ? _self.loadError : loadError // ignore: cast_nullable_to_non_nullable
as ReviewLoadError?,item: freezed == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as ReviewItem?,proposal: null == proposal ? _self.proposal : proposal // ignore: cast_nullable_to_non_nullable
as ProposalSection,showManualResolution: null == showManualResolution ? _self.showManualResolution : showManualResolution // ignore: cast_nullable_to_non_nullable
as bool,adjusted: freezed == adjusted ? _self.adjusted : adjusted // ignore: cast_nullable_to_non_nullable
as bool?,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,showOutcomeError: null == showOutcomeError ? _self.showOutcomeError : showOutcomeError // ignore: cast_nullable_to_non_nullable
as bool,isResolving: null == isResolving ? _self.isResolving : isResolving // ignore: cast_nullable_to_non_nullable
as bool,isAccepting: null == isAccepting ? _self.isAccepting : isAccepting // ignore: cast_nullable_to_non_nullable
as bool,isOpeningPatient: null == isOpeningPatient ? _self.isOpeningPatient : isOpeningPatient // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,dialog: freezed == dialog ? _self.dialog : dialog // ignore: cast_nullable_to_non_nullable
as ReviewDialog?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewItemState].
extension ReviewItemStatePatterns on ReviewItemState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewItemState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewItemState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewItemState value)  $default,){
final _that = this;
switch (_that) {
case _ReviewItemState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewItemState value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewItemState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  ReviewLoadError? loadError,  ReviewItem? item,  ProposalSection proposal,  bool showManualResolution,  bool? adjusted,  String note,  bool showOutcomeError,  bool isResolving,  bool isAccepting,  bool isOpeningPatient,  bool isOffline,  ReviewDialog? dialog)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewItemState() when $default != null:
return $default(_that.isLoading,_that.loadError,_that.item,_that.proposal,_that.showManualResolution,_that.adjusted,_that.note,_that.showOutcomeError,_that.isResolving,_that.isAccepting,_that.isOpeningPatient,_that.isOffline,_that.dialog);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  ReviewLoadError? loadError,  ReviewItem? item,  ProposalSection proposal,  bool showManualResolution,  bool? adjusted,  String note,  bool showOutcomeError,  bool isResolving,  bool isAccepting,  bool isOpeningPatient,  bool isOffline,  ReviewDialog? dialog)  $default,) {final _that = this;
switch (_that) {
case _ReviewItemState():
return $default(_that.isLoading,_that.loadError,_that.item,_that.proposal,_that.showManualResolution,_that.adjusted,_that.note,_that.showOutcomeError,_that.isResolving,_that.isAccepting,_that.isOpeningPatient,_that.isOffline,_that.dialog);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  ReviewLoadError? loadError,  ReviewItem? item,  ProposalSection proposal,  bool showManualResolution,  bool? adjusted,  String note,  bool showOutcomeError,  bool isResolving,  bool isAccepting,  bool isOpeningPatient,  bool isOffline,  ReviewDialog? dialog)?  $default,) {final _that = this;
switch (_that) {
case _ReviewItemState() when $default != null:
return $default(_that.isLoading,_that.loadError,_that.item,_that.proposal,_that.showManualResolution,_that.adjusted,_that.note,_that.showOutcomeError,_that.isResolving,_that.isAccepting,_that.isOpeningPatient,_that.isOffline,_that.dialog);case _:
  return null;

}
}

}

/// @nodoc


class _ReviewItemState extends ReviewItemState {
  const _ReviewItemState({this.isLoading = true, this.loadError, this.item, this.proposal = const ProposalNotOffered(), this.showManualResolution = false, this.adjusted, this.note = '', this.showOutcomeError = false, this.isResolving = false, this.isAccepting = false, this.isOpeningPatient = false, this.isOffline = false, this.dialog}): super._();
  

@override@JsonKey() final  bool isLoading;
@override final  ReviewLoadError? loadError;
@override final  ReviewItem? item;
@override@JsonKey() final  ProposalSection proposal;
@override@JsonKey() final  bool showManualResolution;
@override final  bool? adjusted;
@override@JsonKey() final  String note;
@override@JsonKey() final  bool showOutcomeError;
@override@JsonKey() final  bool isResolving;
@override@JsonKey() final  bool isAccepting;
@override@JsonKey() final  bool isOpeningPatient;
@override@JsonKey() final  bool isOffline;
@override final  ReviewDialog? dialog;

/// Create a copy of ReviewItemState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewItemStateCopyWith<_ReviewItemState> get copyWith => __$ReviewItemStateCopyWithImpl<_ReviewItemState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewItemState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.loadError, loadError) || other.loadError == loadError)&&(identical(other.item, item) || other.item == item)&&(identical(other.proposal, proposal) || other.proposal == proposal)&&(identical(other.showManualResolution, showManualResolution) || other.showManualResolution == showManualResolution)&&(identical(other.adjusted, adjusted) || other.adjusted == adjusted)&&(identical(other.note, note) || other.note == note)&&(identical(other.showOutcomeError, showOutcomeError) || other.showOutcomeError == showOutcomeError)&&(identical(other.isResolving, isResolving) || other.isResolving == isResolving)&&(identical(other.isAccepting, isAccepting) || other.isAccepting == isAccepting)&&(identical(other.isOpeningPatient, isOpeningPatient) || other.isOpeningPatient == isOpeningPatient)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline)&&(identical(other.dialog, dialog) || other.dialog == dialog));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,loadError,item,proposal,showManualResolution,adjusted,note,showOutcomeError,isResolving,isAccepting,isOpeningPatient,isOffline,dialog);
}

@override
String toString() {
    return 'ReviewItemState(isLoading: $isLoading, loadError: $loadError, item: $item, proposal: $proposal, showManualResolution: $showManualResolution, adjusted: $adjusted, note: $note, showOutcomeError: $showOutcomeError, isResolving: $isResolving, isAccepting: $isAccepting, isOpeningPatient: $isOpeningPatient, isOffline: $isOffline, dialog: $dialog)';
}


}

/// @nodoc
abstract mixin class _$ReviewItemStateCopyWith<$Res> implements $ReviewItemStateCopyWith<$Res> {
  factory _$ReviewItemStateCopyWith(_ReviewItemState value, $Res Function(_ReviewItemState) _then) = __$ReviewItemStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, ReviewLoadError? loadError, ReviewItem? item, ProposalSection proposal, bool showManualResolution, bool? adjusted, String note, bool showOutcomeError, bool isResolving, bool isAccepting, bool isOpeningPatient, bool isOffline, ReviewDialog? dialog
});




}
/// @nodoc
class __$ReviewItemStateCopyWithImpl<$Res>
    implements _$ReviewItemStateCopyWith<$Res> {
  __$ReviewItemStateCopyWithImpl(this._self, this._then);

  final _ReviewItemState _self;
  final $Res Function(_ReviewItemState) _then;

/// Create a copy of ReviewItemState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? loadError = freezed,Object? item = freezed,Object? proposal = null,Object? showManualResolution = null,Object? adjusted = freezed,Object? note = null,Object? showOutcomeError = null,Object? isResolving = null,Object? isAccepting = null,Object? isOpeningPatient = null,Object? isOffline = null,Object? dialog = freezed,}) {
  return _then(_ReviewItemState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,loadError: freezed == loadError ? _self.loadError : loadError // ignore: cast_nullable_to_non_nullable
as ReviewLoadError?,item: freezed == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as ReviewItem?,proposal: null == proposal ? _self.proposal : proposal // ignore: cast_nullable_to_non_nullable
as ProposalSection,showManualResolution: null == showManualResolution ? _self.showManualResolution : showManualResolution // ignore: cast_nullable_to_non_nullable
as bool,adjusted: freezed == adjusted ? _self.adjusted : adjusted // ignore: cast_nullable_to_non_nullable
as bool?,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,showOutcomeError: null == showOutcomeError ? _self.showOutcomeError : showOutcomeError // ignore: cast_nullable_to_non_nullable
as bool,isResolving: null == isResolving ? _self.isResolving : isResolving // ignore: cast_nullable_to_non_nullable
as bool,isAccepting: null == isAccepting ? _self.isAccepting : isAccepting // ignore: cast_nullable_to_non_nullable
as bool,isOpeningPatient: null == isOpeningPatient ? _self.isOpeningPatient : isOpeningPatient // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,dialog: freezed == dialog ? _self.dialog : dialog // ignore: cast_nullable_to_non_nullable
as ReviewDialog?,
  ));
}


}

/// @nodoc
mixin _$AdjustProposalState {

 bool get isLoading; ReviewLoadError? get loadError; String? get patientFirstName; double? get previousEnergyKcal; String get energy; String get protein; String get carb; String get fat; Set<PlanGuidelineCode> get guidelines; String get message; Set<ProposalEditField> get invalidFields;/// `422 PlanProposalOutOfSafetyBounds`: the energy falls below the patient's calorie floor.
 bool get belowSafetyFloor; bool get isAssigning; bool get isOffline; ReviewDialog? get dialog;
/// Create a copy of AdjustProposalState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdjustProposalStateCopyWith<AdjustProposalState> get copyWith => _$AdjustProposalStateCopyWithImpl<AdjustProposalState>(this as AdjustProposalState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AdjustProposalState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdjustProposalState&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.loadError, _this.loadError) || other.loadError == _this.loadError)&&(identical(other.patientFirstName, _this.patientFirstName) || other.patientFirstName == _this.patientFirstName)&&(identical(other.previousEnergyKcal, _this.previousEnergyKcal) || other.previousEnergyKcal == _this.previousEnergyKcal)&&(identical(other.energy, _this.energy) || other.energy == _this.energy)&&(identical(other.protein, _this.protein) || other.protein == _this.protein)&&(identical(other.carb, _this.carb) || other.carb == _this.carb)&&(identical(other.fat, _this.fat) || other.fat == _this.fat)&&const DeepCollectionEquality().equals(other.guidelines, _this.guidelines)&&(identical(other.message, _this.message) || other.message == _this.message)&&const DeepCollectionEquality().equals(other.invalidFields, _this.invalidFields)&&(identical(other.belowSafetyFloor, _this.belowSafetyFloor) || other.belowSafetyFloor == _this.belowSafetyFloor)&&(identical(other.isAssigning, _this.isAssigning) || other.isAssigning == _this.isAssigning)&&(identical(other.isOffline, _this.isOffline) || other.isOffline == _this.isOffline)&&(identical(other.dialog, _this.dialog) || other.dialog == _this.dialog));
}


@override
int get hashCode {
  final _this = this as AdjustProposalState;
  return Object.hash(runtimeType,_this.isLoading,_this.loadError,_this.patientFirstName,_this.previousEnergyKcal,_this.energy,_this.protein,_this.carb,_this.fat,const DeepCollectionEquality().hash(_this.guidelines),_this.message,const DeepCollectionEquality().hash(_this.invalidFields),_this.belowSafetyFloor,_this.isAssigning,_this.isOffline,_this.dialog);
}

@override
String toString() {
  final _this = this as AdjustProposalState;
  return 'AdjustProposalState(isLoading: ${_this.isLoading}, loadError: ${_this.loadError}, patientFirstName: ${_this.patientFirstName}, previousEnergyKcal: ${_this.previousEnergyKcal}, energy: ${_this.energy}, protein: ${_this.protein}, carb: ${_this.carb}, fat: ${_this.fat}, guidelines: ${_this.guidelines}, message: ${_this.message}, invalidFields: ${_this.invalidFields}, belowSafetyFloor: ${_this.belowSafetyFloor}, isAssigning: ${_this.isAssigning}, isOffline: ${_this.isOffline}, dialog: ${_this.dialog})';
}


}

/// @nodoc
abstract mixin class $AdjustProposalStateCopyWith<$Res>  {
  factory $AdjustProposalStateCopyWith(AdjustProposalState value, $Res Function(AdjustProposalState) _then) = _$AdjustProposalStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, ReviewLoadError? loadError, String? patientFirstName, double? previousEnergyKcal, String energy, String protein, String carb, String fat, Set<PlanGuidelineCode> guidelines, String message, Set<ProposalEditField> invalidFields, bool belowSafetyFloor, bool isAssigning, bool isOffline, ReviewDialog? dialog
});




}
/// @nodoc
class _$AdjustProposalStateCopyWithImpl<$Res>
    implements $AdjustProposalStateCopyWith<$Res> {
  _$AdjustProposalStateCopyWithImpl(this._self, this._then);

  final AdjustProposalState _self;
  final $Res Function(AdjustProposalState) _then;

/// Create a copy of AdjustProposalState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? loadError = freezed,Object? patientFirstName = freezed,Object? previousEnergyKcal = freezed,Object? energy = null,Object? protein = null,Object? carb = null,Object? fat = null,Object? guidelines = null,Object? message = null,Object? invalidFields = null,Object? belowSafetyFloor = null,Object? isAssigning = null,Object? isOffline = null,Object? dialog = freezed,}) {
  return _then(AdjustProposalState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,loadError: freezed == loadError ? _self.loadError : loadError // ignore: cast_nullable_to_non_nullable
as ReviewLoadError?,patientFirstName: freezed == patientFirstName ? _self.patientFirstName : patientFirstName // ignore: cast_nullable_to_non_nullable
as String?,previousEnergyKcal: freezed == previousEnergyKcal ? _self.previousEnergyKcal : previousEnergyKcal // ignore: cast_nullable_to_non_nullable
as double?,energy: null == energy ? _self.energy : energy // ignore: cast_nullable_to_non_nullable
as String,protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as String,carb: null == carb ? _self.carb : carb // ignore: cast_nullable_to_non_nullable
as String,fat: null == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as String,guidelines: null == guidelines ? _self.guidelines : guidelines // ignore: cast_nullable_to_non_nullable
as Set<PlanGuidelineCode>,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,invalidFields: null == invalidFields ? _self.invalidFields : invalidFields // ignore: cast_nullable_to_non_nullable
as Set<ProposalEditField>,belowSafetyFloor: null == belowSafetyFloor ? _self.belowSafetyFloor : belowSafetyFloor // ignore: cast_nullable_to_non_nullable
as bool,isAssigning: null == isAssigning ? _self.isAssigning : isAssigning // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,dialog: freezed == dialog ? _self.dialog : dialog // ignore: cast_nullable_to_non_nullable
as ReviewDialog?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdjustProposalState].
extension AdjustProposalStatePatterns on AdjustProposalState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdjustProposalState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdjustProposalState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdjustProposalState value)  $default,){
final _that = this;
switch (_that) {
case _AdjustProposalState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdjustProposalState value)?  $default,){
final _that = this;
switch (_that) {
case _AdjustProposalState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  ReviewLoadError? loadError,  String? patientFirstName,  double? previousEnergyKcal,  String energy,  String protein,  String carb,  String fat,  Set<PlanGuidelineCode> guidelines,  String message,  Set<ProposalEditField> invalidFields,  bool belowSafetyFloor,  bool isAssigning,  bool isOffline,  ReviewDialog? dialog)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdjustProposalState() when $default != null:
return $default(_that.isLoading,_that.loadError,_that.patientFirstName,_that.previousEnergyKcal,_that.energy,_that.protein,_that.carb,_that.fat,_that.guidelines,_that.message,_that.invalidFields,_that.belowSafetyFloor,_that.isAssigning,_that.isOffline,_that.dialog);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  ReviewLoadError? loadError,  String? patientFirstName,  double? previousEnergyKcal,  String energy,  String protein,  String carb,  String fat,  Set<PlanGuidelineCode> guidelines,  String message,  Set<ProposalEditField> invalidFields,  bool belowSafetyFloor,  bool isAssigning,  bool isOffline,  ReviewDialog? dialog)  $default,) {final _that = this;
switch (_that) {
case _AdjustProposalState():
return $default(_that.isLoading,_that.loadError,_that.patientFirstName,_that.previousEnergyKcal,_that.energy,_that.protein,_that.carb,_that.fat,_that.guidelines,_that.message,_that.invalidFields,_that.belowSafetyFloor,_that.isAssigning,_that.isOffline,_that.dialog);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  ReviewLoadError? loadError,  String? patientFirstName,  double? previousEnergyKcal,  String energy,  String protein,  String carb,  String fat,  Set<PlanGuidelineCode> guidelines,  String message,  Set<ProposalEditField> invalidFields,  bool belowSafetyFloor,  bool isAssigning,  bool isOffline,  ReviewDialog? dialog)?  $default,) {final _that = this;
switch (_that) {
case _AdjustProposalState() when $default != null:
return $default(_that.isLoading,_that.loadError,_that.patientFirstName,_that.previousEnergyKcal,_that.energy,_that.protein,_that.carb,_that.fat,_that.guidelines,_that.message,_that.invalidFields,_that.belowSafetyFloor,_that.isAssigning,_that.isOffline,_that.dialog);case _:
  return null;

}
}

}

/// @nodoc


class _AdjustProposalState implements AdjustProposalState {
  const _AdjustProposalState({this.isLoading = true, this.loadError, this.patientFirstName, this.previousEnergyKcal, this.energy = '', this.protein = '', this.carb = '', this.fat = '',  Set<PlanGuidelineCode> guidelines = const <PlanGuidelineCode>{}, this.message = '',  Set<ProposalEditField> invalidFields = const <ProposalEditField>{}, this.belowSafetyFloor = false, this.isAssigning = false, this.isOffline = false, this.dialog}): _guidelines = guidelines,_invalidFields = invalidFields;
  

@override@JsonKey() final  bool isLoading;
@override final  ReviewLoadError? loadError;
@override final  String? patientFirstName;
@override final  double? previousEnergyKcal;
@override@JsonKey() final  String energy;
@override@JsonKey() final  String protein;
@override@JsonKey() final  String carb;
@override@JsonKey() final  String fat;
 final  Set<PlanGuidelineCode> _guidelines;
@override@JsonKey() Set<PlanGuidelineCode> get guidelines {
  if (_guidelines is EqualUnmodifiableSetView) return _guidelines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_guidelines);
}

@override@JsonKey() final  String message;
 final  Set<ProposalEditField> _invalidFields;
@override@JsonKey() Set<ProposalEditField> get invalidFields {
  if (_invalidFields is EqualUnmodifiableSetView) return _invalidFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_invalidFields);
}

/// `422 PlanProposalOutOfSafetyBounds`: the energy falls below the patient's calorie floor.
@override@JsonKey() final  bool belowSafetyFloor;
@override@JsonKey() final  bool isAssigning;
@override@JsonKey() final  bool isOffline;
@override final  ReviewDialog? dialog;

/// Create a copy of AdjustProposalState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdjustProposalStateCopyWith<_AdjustProposalState> get copyWith => __$AdjustProposalStateCopyWithImpl<_AdjustProposalState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdjustProposalState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.loadError, loadError) || other.loadError == loadError)&&(identical(other.patientFirstName, patientFirstName) || other.patientFirstName == patientFirstName)&&(identical(other.previousEnergyKcal, previousEnergyKcal) || other.previousEnergyKcal == previousEnergyKcal)&&(identical(other.energy, energy) || other.energy == energy)&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.carb, carb) || other.carb == carb)&&(identical(other.fat, fat) || other.fat == fat)&&const DeepCollectionEquality().equals(other.guidelines, _guidelines)&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.invalidFields, _invalidFields)&&(identical(other.belowSafetyFloor, belowSafetyFloor) || other.belowSafetyFloor == belowSafetyFloor)&&(identical(other.isAssigning, isAssigning) || other.isAssigning == isAssigning)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline)&&(identical(other.dialog, dialog) || other.dialog == dialog));
}


@override
int get hashCode {
    return Object.hash(runtimeType,isLoading,loadError,patientFirstName,previousEnergyKcal,energy,protein,carb,fat,const DeepCollectionEquality().hash(_guidelines),message,const DeepCollectionEquality().hash(_invalidFields),belowSafetyFloor,isAssigning,isOffline,dialog);
}

@override
String toString() {
    return 'AdjustProposalState(isLoading: $isLoading, loadError: $loadError, patientFirstName: $patientFirstName, previousEnergyKcal: $previousEnergyKcal, energy: $energy, protein: $protein, carb: $carb, fat: $fat, guidelines: $guidelines, message: $message, invalidFields: $invalidFields, belowSafetyFloor: $belowSafetyFloor, isAssigning: $isAssigning, isOffline: $isOffline, dialog: $dialog)';
}


}

/// @nodoc
abstract mixin class _$AdjustProposalStateCopyWith<$Res> implements $AdjustProposalStateCopyWith<$Res> {
  factory _$AdjustProposalStateCopyWith(_AdjustProposalState value, $Res Function(_AdjustProposalState) _then) = __$AdjustProposalStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, ReviewLoadError? loadError, String? patientFirstName, double? previousEnergyKcal, String energy, String protein, String carb, String fat, Set<PlanGuidelineCode> guidelines, String message, Set<ProposalEditField> invalidFields, bool belowSafetyFloor, bool isAssigning, bool isOffline, ReviewDialog? dialog
});




}
/// @nodoc
class __$AdjustProposalStateCopyWithImpl<$Res>
    implements _$AdjustProposalStateCopyWith<$Res> {
  __$AdjustProposalStateCopyWithImpl(this._self, this._then);

  final _AdjustProposalState _self;
  final $Res Function(_AdjustProposalState) _then;

/// Create a copy of AdjustProposalState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? loadError = freezed,Object? patientFirstName = freezed,Object? previousEnergyKcal = freezed,Object? energy = null,Object? protein = null,Object? carb = null,Object? fat = null,Object? guidelines = null,Object? message = null,Object? invalidFields = null,Object? belowSafetyFloor = null,Object? isAssigning = null,Object? isOffline = null,Object? dialog = freezed,}) {
  return _then(_AdjustProposalState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,loadError: freezed == loadError ? _self.loadError : loadError // ignore: cast_nullable_to_non_nullable
as ReviewLoadError?,patientFirstName: freezed == patientFirstName ? _self.patientFirstName : patientFirstName // ignore: cast_nullable_to_non_nullable
as String?,previousEnergyKcal: freezed == previousEnergyKcal ? _self.previousEnergyKcal : previousEnergyKcal // ignore: cast_nullable_to_non_nullable
as double?,energy: null == energy ? _self.energy : energy // ignore: cast_nullable_to_non_nullable
as String,protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as String,carb: null == carb ? _self.carb : carb // ignore: cast_nullable_to_non_nullable
as String,fat: null == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as String,guidelines: null == guidelines ? _self._guidelines : guidelines // ignore: cast_nullable_to_non_nullable
as Set<PlanGuidelineCode>,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,invalidFields: null == invalidFields ? _self._invalidFields : invalidFields // ignore: cast_nullable_to_non_nullable
as Set<ProposalEditField>,belowSafetyFloor: null == belowSafetyFloor ? _self.belowSafetyFloor : belowSafetyFloor // ignore: cast_nullable_to_non_nullable
as bool,isAssigning: null == isAssigning ? _self.isAssigning : isAssigning // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,dialog: freezed == dialog ? _self.dialog : dialog // ignore: cast_nullable_to_non_nullable
as ReviewDialog?,
  ));
}


}

// dart format on
