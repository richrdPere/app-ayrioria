abstract class Resource<T> {
  const Resource();
}

class Initial<T> extends Resource<T> {
  const Initial();
}

class Loading<T> extends Resource<T> {
  const Loading();
}

class Success<T> extends Resource<T> {
  final T data;
  Success(this.data);
}

class ErrorData<T> extends Resource<T> {
  final String error;
  ErrorData(this.error);

  @override
  String toString() => 'Error: $error';
}
