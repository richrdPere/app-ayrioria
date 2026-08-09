abstract class Resource<T> {
  const Resource();
}

// 1. Initial
class Initial<T> extends Resource<T> {
  const Initial();
}

// 2. Loading
class Loading<T> extends Resource<T> {
  const Loading();
}

// 3. Success
class Success<T> extends Resource<T> {
  final T data;

  const Success(this.data);
}

//4. Error data
class ErrorData<T> extends Resource<T> {
  final String message;
  final String? error;
  final int? statusCode;

  const ErrorData(this.message, {this.error, this.statusCode});

  /// Mensaje recomendado para mostrar en UI.
  String get displayMessage {
    if (error != null && error!.trim().isNotEmpty) {
      return error!;
    }

    return message;
  }

  @override
  String toString() {
    return 'ErrorData('
        'message: $message, '
        'error: $error, '
        'statusCode: $statusCode'
        ')';
  }
}
