class FacadeException implements Exception {
  const FacadeException(this.message);

  final String message;

  @override
  String toString() => 'FacadeException: $message';
}

class ResolverNotConfiguredException extends FacadeException {
  const ResolverNotConfiguredException()
      : super(
          'FacadeRuntime has no resolver configured. '
          'Call FacadeRuntime.setRootResolver(...) before using facades or helpers.',
        );
}

class BindingNotFoundException extends FacadeException {
  const BindingNotFoundException(Type type)
      : super('No binding registered for type $type.');
}

class InvalidBindingTypeException extends FacadeException {
  const InvalidBindingTypeException({
    required Type expected,
    required Object? actual,
  }) : super(
          'Resolved binding has invalid type. '
          'Expected: $expected, actual value: $actual.',
        );
}
