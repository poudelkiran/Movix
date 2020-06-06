/// Stores either value or the error
class ValueOrError<T> {
  String title;
  String error;
  T value;

  ValueOrError(this.title, this.error, this.value);
}