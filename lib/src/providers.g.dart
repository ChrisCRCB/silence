// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sharedPreferencesHash() => r'e607f7351fa94c298e3676fa14ad95aac093f433';

/// Provide the shared preferences.
///
/// Copied from [sharedPreferences].
@ProviderFor(sharedPreferences)
final sharedPreferencesProvider =
    AutoDisposeFutureProvider<SharedPreferences>.internal(
  sharedPreferences,
  name: r'sharedPreferencesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sharedPreferencesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SharedPreferencesRef = AutoDisposeFutureProviderRef<SharedPreferences>;
String _$sentencesContextHash() => r'e13d34470794d9892fe9dea6eb7266791fe731cc';

/// Provide sentences.
///
/// Copied from [sentencesContext].
@ProviderFor(sentencesContext)
final sentencesContextProvider = AutoDisposeFutureProvider<Sentences>.internal(
  sentencesContext,
  name: r'sentencesContextProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sentencesContextHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef SentencesContextRef = AutoDisposeFutureProviderRef<Sentences>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
