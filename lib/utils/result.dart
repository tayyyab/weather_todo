class Result<T> {
  final T? data;
  final String? error;

  Result._({this.data, this.error});

  factory Result.success(T data) => Result._(data: data);
  factory Result.failure(String error) => Result._(error: error);

  bool get isSuccess => data != null;
  bool get isFailure => error != null;

  void when({
    required void Function(T data) success,
    required void Function(String error) failure,
  }) {
    if (isSuccess) {
      success(data as T);
    } else if (isFailure) {
      failure(error!);
    }
  }
}
