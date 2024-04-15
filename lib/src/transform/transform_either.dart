import 'dart:async';

typedef Lazy<T> = T Function();

/// Represents a value of one of two possible types.
/// Instances of [TransformEither] are either an instance of [Left] or [Right].
///
/// [Left] is used for "failure".
/// [Right] is used for "success".
sealed class TransformEither<L, R> {
  const TransformEither();

  /// Represents the left side of [TransformEither] class which by convention is a "Failure".
  bool get isLeft => this is Left<L, R>;

  /// Represents the right side of [TransformEither] class which by convention is a "Success"
  bool get isRight => this is Right<L, R>;

  /// Get [Left] value, may throw an exception when the value is [Right]
  L get left => this.fold<L>((value) => value, (right) => throw Exception('Illegal use. You should check isLeft before calling'));

  /// Get [Right] value, may throw an exception when the value is [Left]
  R get right => this.fold<R>((left) => throw Exception('Illegal use. You should check isRight before calling'), (value) => value);

  /// Transform values of [Left] and [Right]
  TransformEither<TL, TR> either<TL, TR>(TL Function(L left) fnL, TR Function(R right) fnR);

  /// Transform value of [Right] when transformation may be finished with an error
  TransformEither<L, TR> then<TR>(TransformEither<L, TR> Function(R right) fnR);

  /// Transform value of [Right] when transformation may be finished with an error
  Future<TransformEither<L, TR>> thenAsync<TR>(FutureOr<TransformEither<L, TR>> Function(R right) fnR);

  /// Transform value of [Left] when transformation may be finished with an [Right]
  TransformEither<TL, R> thenLeft<TL>(TransformEither<TL, R> Function(L left) fnL);

  /// Transform value of [Left] when transformation may be finished with an [Right]
  Future<TransformEither<TL, R>> thenLeftAsync<TL>(FutureOr<TransformEither<TL, R>> Function(L left) fnL);

  /// Transform value of [Right]
  TransformEither<L, TR> map<TR>(TR Function(R right) fnR);

  /// Transform value of [Left]
  TransformEither<TL, R> mapLeft<TL>(TL Function(L left) fnL);

  /// Transform value of [Right]
  Future<TransformEither<L, TR>> mapAsync<TR>(FutureOr<TR> Function(R right) fnR);

  /// Transform value of [Left]
  Future<TransformEither<TL, R>> mapLeftAsync<TL>(FutureOr<TL> Function(L left) fnL);

  /// Fold [Left] and [Right] into the value of one type
  T fold<T>(T Function(L left) fnL, T Function(R right) fnR);

  /// Swap [Left] and [Right]
  TransformEither<R, L> swap() => fold((left) => Right(left), (right) => Left(right));

  /// Constructs a new [TransformEither] from a function that might throw
  static TransformEither<L, R> tryCatch<L, R, Err extends Object>(L Function(Err err) onError, R Function() fnR) {
    try {
      return Right(fnR());
    } on Err catch (e) {
      return Left(onError(e));
    }
  }

  /// Constructs a new [TransformEither] from a function that might throw
  ///
  /// simplified version of [TransformEither.tryCatch]
  ///
  /// ```dart
  /// final fileOrError = Either.tryExcept<FileError>(() => /* maybe throw */);
  /// ```
  static TransformEither<Err, R> tryExcept<Err extends Object, R>(R Function() fnR) {
    try {
      return Right(fnR());
    } on Err catch (e) {
      return Left(e);
    }
  }

  /// If the condition is true then return [rightValue] in [Right] else [leftValue] in [Left]
  static TransformEither<L, R> cond<L, R>(bool test, L leftValue, R rightValue) => test ? Right(rightValue) : Left(leftValue);

  /// If the condition is true then return [rightValue] in [Right] else [leftValue] in [Left]
  static TransformEither<L, R> condLazy<L, R>(bool test, Lazy<L> leftValue, Lazy<R> rightValue) => test ? Right(rightValue()) : Left(leftValue());

  @override
  bool operator ==(Object obj) {
    return this.fold(
      (left) => obj is Left && left == obj.value,
      (right) => obj is Right && right == obj.value,
    );
  }

  @override
  int get hashCode => fold((left) => left.hashCode, (right) => right.hashCode);
}

/// Used for "failure"
class Left<L, R> extends TransformEither<L, R> {
  final L value;

  const Left(this.value);

  @override
  TransformEither<TL, TR> either<TL, TR>(TL Function(L left) fnL, TR Function(R right) fnR) => Left<TL, TR>(fnL(value));

  @override
  TransformEither<L, TR> then<TR>(TransformEither<L, TR> Function(R right) fnR) => Left<L, TR>(value);

  @override
  Future<TransformEither<L, TR>> thenAsync<TR>(FutureOr<TransformEither<L, TR>> Function(R right) fnR) => Future.value(Left<L, TR>(value));

  @override
  TransformEither<TL, R> thenLeft<TL>(TransformEither<TL, R> Function(L left) fnL) => fnL(value);

  @override
  Future<TransformEither<TL, R>> thenLeftAsync<TL>(FutureOr<TransformEither<TL, R>> Function(L left) fnL) => Future.value(fnL(value));

  @override
  TransformEither<L, TR> map<TR>(TR Function(R right) fnR) => Left<L, TR>(value);

  @override
  TransformEither<TL, R> mapLeft<TL>(TL Function(L left) fnL) => Left<TL, R>(fnL(value));

  @override
  Future<TransformEither<L, TR>> mapAsync<TR>(FutureOr<TR> Function(R right) fnR) => Future.value(Left<L, TR>(value));

  @override
  Future<TransformEither<TL, R>> mapLeftAsync<TL>(FutureOr<TL> Function(L left) fnL) => Future.value(fnL(value)).then((value) => Left<TL, R>(value));

  @override
  T fold<T>(T Function(L left) fnL, T Function(R right) fnR) => fnL(value);
}

/// Used for "success"
class Right<L, R> extends TransformEither<L, R> {
  final R value;

  const Right(this.value);

  @override
  TransformEither<TL, TR> either<TL, TR>(TL Function(L left) fnL, TR Function(R right) fnR) => Right<TL, TR>(fnR(value));

  @override
  TransformEither<L, TR> then<TR>(TransformEither<L, TR> Function(R right) fnR) => fnR(value);

  @override
  Future<TransformEither<L, TR>> thenAsync<TR>(FutureOr<TransformEither<L, TR>> Function(R right) fnR) => Future.value(fnR(value));

  @override
  TransformEither<TL, R> thenLeft<TL>(TransformEither<TL, R> Function(L left) fnL) => Right<TL, R>(value);

  @override
  Future<TransformEither<TL, R>> thenLeftAsync<TL>(FutureOr<TransformEither<TL, R>> Function(L left) fnL) => Future.value(Right<TL, R>(value));

  @override
  TransformEither<L, TR> map<TR>(TR Function(R right) fnR) => Right<L, TR>(fnR(value));

  @override
  TransformEither<TL, R> mapLeft<TL>(TL Function(L left) fnL) => Right<TL, R>(value);

  @override
  Future<TransformEither<L, TR>> mapAsync<TR>(FutureOr<TR> Function(R right) fnR) => Future.value(fnR(value)).then((value) => Right<L, TR>(value));

  @override
  Future<TransformEither<TL, R>> mapLeftAsync<TL>(FutureOr<TL> Function(L left) fnL) => Future.value(Right<TL, R>(value));

  @override
  T fold<T>(T Function(L left) fnL, T Function(R right) fnR) => fnR(value);
}

extension FutureEither<L, R> on Future<TransformEither<L, R>> {
  /// Represents the left side of [TransformEither] class which by convention is a "Failure".
  Future<bool> get isLeft => then((either) => either.isLeft);

  /// Represents the right side of [TransformEither] class which by convention is a "Success"
  Future<bool> get isRight => then((either) => either.isRight);

  /// Transform values of [Left] and [Right]
  Future<TransformEither<TL, TR>> either<TL, TR>(TL Function(L left) fnL, TR Function(R right) fnR) => then((either) => either.either(fnL, fnR));

  /// Transform value of [Right]
  Future<TransformEither<L, TR>> mapRight<TR>(FutureOr<TR> Function(R right) fnR) => then((either) => either.mapAsync(fnR));

  /// Transform value of [Left]
  Future<TransformEither<TL, R>> mapLeft<TL>(FutureOr<TL> Function(L left) fnL) => then((either) => either.mapLeftAsync(fnL));

  /// Async transform value of [Right] when transformation may be finished with an error
  Future<TransformEither<L, TR>> thenRight<TR>(FutureOr<TransformEither<L, TR>> Function(R right) fnR) => then((either) => either.thenAsync(fnR));

  /// Async transform value of [Left] when transformation may be finished with an [Right]
  Future<TransformEither<TL, R>> thenLeft<TL>(FutureOr<TransformEither<TL, R>> Function(L left) fnL) => then((either) => either.thenLeftAsync(fnL));

  /// Fold [Left] and [Right] into the value of one type
  Future<T> fold<T>(FutureOr<T> Function(L left) fnL, FutureOr<T> Function(R right) fnR) => then((either) => either.fold(fnL, fnR));

  /// Swap [Left] and [Right]
  Future<TransformEither<R, L>> swap() => this.fold<TransformEither<R, L>>((left) => Right(left), (right) => Left(right));
}
