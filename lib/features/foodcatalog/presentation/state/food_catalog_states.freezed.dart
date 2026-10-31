// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_catalog_states.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FoodRow {

 int get id; String get name; double get energyKcalPer100g; bool get isLocal;
/// Create a copy of FoodRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodRowCopyWith<FoodRow> get copyWith => _$FoodRowCopyWithImpl<FoodRow>(this as FoodRow, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FoodRow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FoodRow&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.energyKcalPer100g, _this.energyKcalPer100g) || other.energyKcalPer100g == _this.energyKcalPer100g)&&(identical(other.isLocal, _this.isLocal) || other.isLocal == _this.isLocal));
}


@override
int get hashCode {
  final _this = this as FoodRow;
  return Object.hash(runtimeType,_this.id,_this.name,_this.energyKcalPer100g,_this.isLocal);
}

@override
String toString() {
  final _this = this as FoodRow;
  return 'FoodRow(id: ${_this.id}, name: ${_this.name}, energyKcalPer100g: ${_this.energyKcalPer100g}, isLocal: ${_this.isLocal})';
}


}

/// @nodoc
abstract mixin class $FoodRowCopyWith<$Res>  {
  factory $FoodRowCopyWith(FoodRow value, $Res Function(FoodRow) _then) = _$FoodRowCopyWithImpl;
@useResult
$Res call({
 int id, String name, double energyKcalPer100g, bool isLocal
});




}
/// @nodoc
class _$FoodRowCopyWithImpl<$Res>
    implements $FoodRowCopyWith<$Res> {
  _$FoodRowCopyWithImpl(this._self, this._then);

  final FoodRow _self;
  final $Res Function(FoodRow) _then;

/// Create a copy of FoodRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? energyKcalPer100g = null,Object? isLocal = null,}) {
  return _then(FoodRow(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,energyKcalPer100g: null == energyKcalPer100g ? _self.energyKcalPer100g : energyKcalPer100g // ignore: cast_nullable_to_non_nullable
as double,isLocal: null == isLocal ? _self.isLocal : isLocal // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [FoodRow].
extension FoodRowPatterns on FoodRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FoodRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FoodRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FoodRow value)  $default,){
final _that = this;
switch (_that) {
case _FoodRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FoodRow value)?  $default,){
final _that = this;
switch (_that) {
case _FoodRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  double energyKcalPer100g,  bool isLocal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FoodRow() when $default != null:
return $default(_that.id,_that.name,_that.energyKcalPer100g,_that.isLocal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  double energyKcalPer100g,  bool isLocal)  $default,) {final _that = this;
switch (_that) {
case _FoodRow():
return $default(_that.id,_that.name,_that.energyKcalPer100g,_that.isLocal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  double energyKcalPer100g,  bool isLocal)?  $default,) {final _that = this;
switch (_that) {
case _FoodRow() when $default != null:
return $default(_that.id,_that.name,_that.energyKcalPer100g,_that.isLocal);case _:
  return null;

}
}

}

/// @nodoc


class _FoodRow implements FoodRow {
  const _FoodRow({required this.id, required this.name, required this.energyKcalPer100g, required this.isLocal});
  

@override final  int id;
@override final  String name;
@override final  double energyKcalPer100g;
@override final  bool isLocal;

/// Create a copy of FoodRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodRowCopyWith<_FoodRow> get copyWith => __$FoodRowCopyWithImpl<_FoodRow>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoodRow&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.energyKcalPer100g, energyKcalPer100g) || other.energyKcalPer100g == energyKcalPer100g)&&(identical(other.isLocal, isLocal) || other.isLocal == isLocal));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,energyKcalPer100g,isLocal);
}

@override
String toString() {
    return 'FoodRow(id: $id, name: $name, energyKcalPer100g: $energyKcalPer100g, isLocal: $isLocal)';
}


}

/// @nodoc
abstract mixin class _$FoodRowCopyWith<$Res> implements $FoodRowCopyWith<$Res> {
  factory _$FoodRowCopyWith(_FoodRow value, $Res Function(_FoodRow) _then) = __$FoodRowCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, double energyKcalPer100g, bool isLocal
});




}
/// @nodoc
class __$FoodRowCopyWithImpl<$Res>
    implements _$FoodRowCopyWith<$Res> {
  __$FoodRowCopyWithImpl(this._self, this._then);

  final _FoodRow _self;
  final $Res Function(_FoodRow) _then;

/// Create a copy of FoodRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? energyKcalPer100g = null,Object? isLocal = null,}) {
  return _then(_FoodRow(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,energyKcalPer100g: null == energyKcalPer100g ? _self.energyKcalPer100g : energyKcalPer100g // ignore: cast_nullable_to_non_nullable
as double,isLocal: null == isLocal ? _self.isLocal : isLocal // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$FoodCatalogState {

 String get query; bool get isLoading; bool get isOffline; bool get loadFailed; List<FoodRow>? get results;
/// Create a copy of FoodCatalogState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodCatalogStateCopyWith<FoodCatalogState> get copyWith => _$FoodCatalogStateCopyWithImpl<FoodCatalogState>(this as FoodCatalogState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FoodCatalogState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FoodCatalogState&&(identical(other.query, _this.query) || other.query == _this.query)&&(identical(other.isLoading, _this.isLoading) || other.isLoading == _this.isLoading)&&(identical(other.isOffline, _this.isOffline) || other.isOffline == _this.isOffline)&&(identical(other.loadFailed, _this.loadFailed) || other.loadFailed == _this.loadFailed)&&const DeepCollectionEquality().equals(other.results, _this.results));
}


@override
int get hashCode {
  final _this = this as FoodCatalogState;
  return Object.hash(runtimeType,_this.query,_this.isLoading,_this.isOffline,_this.loadFailed,const DeepCollectionEquality().hash(_this.results));
}

@override
String toString() {
  final _this = this as FoodCatalogState;
  return 'FoodCatalogState(query: ${_this.query}, isLoading: ${_this.isLoading}, isOffline: ${_this.isOffline}, loadFailed: ${_this.loadFailed}, results: ${_this.results})';
}


}

/// @nodoc
abstract mixin class $FoodCatalogStateCopyWith<$Res>  {
  factory $FoodCatalogStateCopyWith(FoodCatalogState value, $Res Function(FoodCatalogState) _then) = _$FoodCatalogStateCopyWithImpl;
@useResult
$Res call({
 String query, bool isLoading, bool isOffline, bool loadFailed, List<FoodRow>? results
});




}
/// @nodoc
class _$FoodCatalogStateCopyWithImpl<$Res>
    implements $FoodCatalogStateCopyWith<$Res> {
  _$FoodCatalogStateCopyWithImpl(this._self, this._then);

  final FoodCatalogState _self;
  final $Res Function(FoodCatalogState) _then;

/// Create a copy of FoodCatalogState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? query = null,Object? isLoading = null,Object? isOffline = null,Object? loadFailed = null,Object? results = freezed,}) {
  return _then(FoodCatalogState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,loadFailed: null == loadFailed ? _self.loadFailed : loadFailed // ignore: cast_nullable_to_non_nullable
as bool,results: freezed == results ? _self.results : results // ignore: cast_nullable_to_non_nullable
as List<FoodRow>?,
  ));
}

}


/// Adds pattern-matching-related methods to [FoodCatalogState].
extension FoodCatalogStatePatterns on FoodCatalogState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FoodCatalogState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FoodCatalogState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FoodCatalogState value)  $default,){
final _that = this;
switch (_that) {
case _FoodCatalogState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FoodCatalogState value)?  $default,){
final _that = this;
switch (_that) {
case _FoodCatalogState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String query,  bool isLoading,  bool isOffline,  bool loadFailed,  List<FoodRow>? results)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FoodCatalogState() when $default != null:
return $default(_that.query,_that.isLoading,_that.isOffline,_that.loadFailed,_that.results);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String query,  bool isLoading,  bool isOffline,  bool loadFailed,  List<FoodRow>? results)  $default,) {final _that = this;
switch (_that) {
case _FoodCatalogState():
return $default(_that.query,_that.isLoading,_that.isOffline,_that.loadFailed,_that.results);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String query,  bool isLoading,  bool isOffline,  bool loadFailed,  List<FoodRow>? results)?  $default,) {final _that = this;
switch (_that) {
case _FoodCatalogState() when $default != null:
return $default(_that.query,_that.isLoading,_that.isOffline,_that.loadFailed,_that.results);case _:
  return null;

}
}

}

/// @nodoc


class _FoodCatalogState extends FoodCatalogState {
  const _FoodCatalogState({this.query = '', this.isLoading = true, this.isOffline = false, this.loadFailed = false,  List<FoodRow>? results}): _results = results,super._();
  

@override@JsonKey() final  String query;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isOffline;
@override@JsonKey() final  bool loadFailed;
 final  List<FoodRow>? _results;
@override List<FoodRow>? get results {
  final value = _results;
  if (value == null) return null;
  if (_results is EqualUnmodifiableListView) return _results;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of FoodCatalogState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodCatalogStateCopyWith<_FoodCatalogState> get copyWith => __$FoodCatalogStateCopyWithImpl<_FoodCatalogState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoodCatalogState&&(identical(other.query, query) || other.query == query)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline)&&(identical(other.loadFailed, loadFailed) || other.loadFailed == loadFailed)&&const DeepCollectionEquality().equals(other.results, _results));
}


@override
int get hashCode {
    return Object.hash(runtimeType,query,isLoading,isOffline,loadFailed,const DeepCollectionEquality().hash(_results));
}

@override
String toString() {
    return 'FoodCatalogState(query: $query, isLoading: $isLoading, isOffline: $isOffline, loadFailed: $loadFailed, results: $results)';
}


}

/// @nodoc
abstract mixin class _$FoodCatalogStateCopyWith<$Res> implements $FoodCatalogStateCopyWith<$Res> {
  factory _$FoodCatalogStateCopyWith(_FoodCatalogState value, $Res Function(_FoodCatalogState) _then) = __$FoodCatalogStateCopyWithImpl;
@override @useResult
$Res call({
 String query, bool isLoading, bool isOffline, bool loadFailed, List<FoodRow>? results
});




}
/// @nodoc
class __$FoodCatalogStateCopyWithImpl<$Res>
    implements _$FoodCatalogStateCopyWith<$Res> {
  __$FoodCatalogStateCopyWithImpl(this._self, this._then);

  final _FoodCatalogState _self;
  final $Res Function(_FoodCatalogState) _then;

/// Create a copy of FoodCatalogState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? query = null,Object? isLoading = null,Object? isOffline = null,Object? loadFailed = null,Object? results = freezed,}) {
  return _then(_FoodCatalogState(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,loadFailed: null == loadFailed ? _self.loadFailed : loadFailed // ignore: cast_nullable_to_non_nullable
as bool,results: freezed == results ? _self._results : results // ignore: cast_nullable_to_non_nullable
as List<FoodRow>?,
  ));
}


}

/// @nodoc
mixin _$AddLocalFoodState {

 String get name; String get energy; String get protein; String get carb; String get fat; Set<LocalFoodField> get invalidFields; bool get duplicatedName; bool get isSaving; bool get showServerError; bool get isOffline;
/// Create a copy of AddLocalFoodState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddLocalFoodStateCopyWith<AddLocalFoodState> get copyWith => _$AddLocalFoodStateCopyWithImpl<AddLocalFoodState>(this as AddLocalFoodState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AddLocalFoodState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddLocalFoodState&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.energy, _this.energy) || other.energy == _this.energy)&&(identical(other.protein, _this.protein) || other.protein == _this.protein)&&(identical(other.carb, _this.carb) || other.carb == _this.carb)&&(identical(other.fat, _this.fat) || other.fat == _this.fat)&&const DeepCollectionEquality().equals(other.invalidFields, _this.invalidFields)&&(identical(other.duplicatedName, _this.duplicatedName) || other.duplicatedName == _this.duplicatedName)&&(identical(other.isSaving, _this.isSaving) || other.isSaving == _this.isSaving)&&(identical(other.showServerError, _this.showServerError) || other.showServerError == _this.showServerError)&&(identical(other.isOffline, _this.isOffline) || other.isOffline == _this.isOffline));
}


@override
int get hashCode {
  final _this = this as AddLocalFoodState;
  return Object.hash(runtimeType,_this.name,_this.energy,_this.protein,_this.carb,_this.fat,const DeepCollectionEquality().hash(_this.invalidFields),_this.duplicatedName,_this.isSaving,_this.showServerError,_this.isOffline);
}

@override
String toString() {
  final _this = this as AddLocalFoodState;
  return 'AddLocalFoodState(name: ${_this.name}, energy: ${_this.energy}, protein: ${_this.protein}, carb: ${_this.carb}, fat: ${_this.fat}, invalidFields: ${_this.invalidFields}, duplicatedName: ${_this.duplicatedName}, isSaving: ${_this.isSaving}, showServerError: ${_this.showServerError}, isOffline: ${_this.isOffline})';
}


}

/// @nodoc
abstract mixin class $AddLocalFoodStateCopyWith<$Res>  {
  factory $AddLocalFoodStateCopyWith(AddLocalFoodState value, $Res Function(AddLocalFoodState) _then) = _$AddLocalFoodStateCopyWithImpl;
@useResult
$Res call({
 String name, String energy, String protein, String carb, String fat, Set<LocalFoodField> invalidFields, bool duplicatedName, bool isSaving, bool showServerError, bool isOffline
});




}
/// @nodoc
class _$AddLocalFoodStateCopyWithImpl<$Res>
    implements $AddLocalFoodStateCopyWith<$Res> {
  _$AddLocalFoodStateCopyWithImpl(this._self, this._then);

  final AddLocalFoodState _self;
  final $Res Function(AddLocalFoodState) _then;

/// Create a copy of AddLocalFoodState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? energy = null,Object? protein = null,Object? carb = null,Object? fat = null,Object? invalidFields = null,Object? duplicatedName = null,Object? isSaving = null,Object? showServerError = null,Object? isOffline = null,}) {
  return _then(AddLocalFoodState(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,energy: null == energy ? _self.energy : energy // ignore: cast_nullable_to_non_nullable
as String,protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as String,carb: null == carb ? _self.carb : carb // ignore: cast_nullable_to_non_nullable
as String,fat: null == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as String,invalidFields: null == invalidFields ? _self.invalidFields : invalidFields // ignore: cast_nullable_to_non_nullable
as Set<LocalFoodField>,duplicatedName: null == duplicatedName ? _self.duplicatedName : duplicatedName // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,showServerError: null == showServerError ? _self.showServerError : showServerError // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AddLocalFoodState].
extension AddLocalFoodStatePatterns on AddLocalFoodState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddLocalFoodState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddLocalFoodState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddLocalFoodState value)  $default,){
final _that = this;
switch (_that) {
case _AddLocalFoodState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddLocalFoodState value)?  $default,){
final _that = this;
switch (_that) {
case _AddLocalFoodState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String energy,  String protein,  String carb,  String fat,  Set<LocalFoodField> invalidFields,  bool duplicatedName,  bool isSaving,  bool showServerError,  bool isOffline)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddLocalFoodState() when $default != null:
return $default(_that.name,_that.energy,_that.protein,_that.carb,_that.fat,_that.invalidFields,_that.duplicatedName,_that.isSaving,_that.showServerError,_that.isOffline);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String energy,  String protein,  String carb,  String fat,  Set<LocalFoodField> invalidFields,  bool duplicatedName,  bool isSaving,  bool showServerError,  bool isOffline)  $default,) {final _that = this;
switch (_that) {
case _AddLocalFoodState():
return $default(_that.name,_that.energy,_that.protein,_that.carb,_that.fat,_that.invalidFields,_that.duplicatedName,_that.isSaving,_that.showServerError,_that.isOffline);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String energy,  String protein,  String carb,  String fat,  Set<LocalFoodField> invalidFields,  bool duplicatedName,  bool isSaving,  bool showServerError,  bool isOffline)?  $default,) {final _that = this;
switch (_that) {
case _AddLocalFoodState() when $default != null:
return $default(_that.name,_that.energy,_that.protein,_that.carb,_that.fat,_that.invalidFields,_that.duplicatedName,_that.isSaving,_that.showServerError,_that.isOffline);case _:
  return null;

}
}

}

/// @nodoc


class _AddLocalFoodState implements AddLocalFoodState {
  const _AddLocalFoodState({this.name = '', this.energy = '', this.protein = '', this.carb = '', this.fat = '',  Set<LocalFoodField> invalidFields = const <LocalFoodField>{}, this.duplicatedName = false, this.isSaving = false, this.showServerError = false, this.isOffline = false}): _invalidFields = invalidFields;
  

@override@JsonKey() final  String name;
@override@JsonKey() final  String energy;
@override@JsonKey() final  String protein;
@override@JsonKey() final  String carb;
@override@JsonKey() final  String fat;
 final  Set<LocalFoodField> _invalidFields;
@override@JsonKey() Set<LocalFoodField> get invalidFields {
  if (_invalidFields is EqualUnmodifiableSetView) return _invalidFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_invalidFields);
}

@override@JsonKey() final  bool duplicatedName;
@override@JsonKey() final  bool isSaving;
@override@JsonKey() final  bool showServerError;
@override@JsonKey() final  bool isOffline;

/// Create a copy of AddLocalFoodState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddLocalFoodStateCopyWith<_AddLocalFoodState> get copyWith => __$AddLocalFoodStateCopyWithImpl<_AddLocalFoodState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddLocalFoodState&&(identical(other.name, name) || other.name == name)&&(identical(other.energy, energy) || other.energy == energy)&&(identical(other.protein, protein) || other.protein == protein)&&(identical(other.carb, carb) || other.carb == carb)&&(identical(other.fat, fat) || other.fat == fat)&&const DeepCollectionEquality().equals(other.invalidFields, _invalidFields)&&(identical(other.duplicatedName, duplicatedName) || other.duplicatedName == duplicatedName)&&(identical(other.isSaving, isSaving) || other.isSaving == isSaving)&&(identical(other.showServerError, showServerError) || other.showServerError == showServerError)&&(identical(other.isOffline, isOffline) || other.isOffline == isOffline));
}


@override
int get hashCode {
    return Object.hash(runtimeType,name,energy,protein,carb,fat,const DeepCollectionEquality().hash(_invalidFields),duplicatedName,isSaving,showServerError,isOffline);
}

@override
String toString() {
    return 'AddLocalFoodState(name: $name, energy: $energy, protein: $protein, carb: $carb, fat: $fat, invalidFields: $invalidFields, duplicatedName: $duplicatedName, isSaving: $isSaving, showServerError: $showServerError, isOffline: $isOffline)';
}


}

/// @nodoc
abstract mixin class _$AddLocalFoodStateCopyWith<$Res> implements $AddLocalFoodStateCopyWith<$Res> {
  factory _$AddLocalFoodStateCopyWith(_AddLocalFoodState value, $Res Function(_AddLocalFoodState) _then) = __$AddLocalFoodStateCopyWithImpl;
@override @useResult
$Res call({
 String name, String energy, String protein, String carb, String fat, Set<LocalFoodField> invalidFields, bool duplicatedName, bool isSaving, bool showServerError, bool isOffline
});




}
/// @nodoc
class __$AddLocalFoodStateCopyWithImpl<$Res>
    implements _$AddLocalFoodStateCopyWith<$Res> {
  __$AddLocalFoodStateCopyWithImpl(this._self, this._then);

  final _AddLocalFoodState _self;
  final $Res Function(_AddLocalFoodState) _then;

/// Create a copy of AddLocalFoodState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? energy = null,Object? protein = null,Object? carb = null,Object? fat = null,Object? invalidFields = null,Object? duplicatedName = null,Object? isSaving = null,Object? showServerError = null,Object? isOffline = null,}) {
  return _then(_AddLocalFoodState(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,energy: null == energy ? _self.energy : energy // ignore: cast_nullable_to_non_nullable
as String,protein: null == protein ? _self.protein : protein // ignore: cast_nullable_to_non_nullable
as String,carb: null == carb ? _self.carb : carb // ignore: cast_nullable_to_non_nullable
as String,fat: null == fat ? _self.fat : fat // ignore: cast_nullable_to_non_nullable
as String,invalidFields: null == invalidFields ? _self._invalidFields : invalidFields // ignore: cast_nullable_to_non_nullable
as Set<LocalFoodField>,duplicatedName: null == duplicatedName ? _self.duplicatedName : duplicatedName // ignore: cast_nullable_to_non_nullable
as bool,isSaving: null == isSaving ? _self.isSaving : isSaving // ignore: cast_nullable_to_non_nullable
as bool,showServerError: null == showServerError ? _self.showServerError : showServerError // ignore: cast_nullable_to_non_nullable
as bool,isOffline: null == isOffline ? _self.isOffline : isOffline // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
