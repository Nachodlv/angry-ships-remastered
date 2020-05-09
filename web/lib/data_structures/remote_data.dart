import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_data.freezed.dart';

@freezed
abstract class RemoteData<E, A> with _$RemoteData<E, A> {
  static RemoteData<E, A> fromEither<E, A>(Either<E, A> either) => either.fold(
      (err) => RemoteData.error(err), (ok) => (RemoteData.success(ok)));

  factory RemoteData.success(A value) = Success<E, A>;
  factory RemoteData.error(E error) = Error<E, A>;
  factory RemoteData.loading() = Loading<E, A>;
  factory RemoteData.notAsked() = Unasked<E, A>;

  @late
  bool get isLoading =>
      this.maybeWhen(loading: () => true, orElse: () => false);

  @late
  bool get isSuccess =>
      this.maybeWhen(success: (ignored) => true, orElse: () => false);

  @late
  bool get isError => this.maybeWhen(
        error: (ignored) => true,
        orElse: () => false,
      );

  @late
  bool get isNotAsked => this.maybeWhen(
        notAsked: () => true,
        orElse: () => false,
      );
}

extension RemoteDataOps<E, A> on RemoteData<E, A> {
  RemoteData<E, B> fmap<B>(B f(A a)) => this.when(
      success: (v) => RemoteData.success(f(v)),
      error: (err) => RemoteData.error(err),
      loading: () => RemoteData.loading(),
      notAsked: () => RemoteData.notAsked());
}
