
class ServiceException implements Exception {
  final String message;
  ServiceException(this.message);
}

class UnAuthorizedException extends ServiceException {
    UnAuthorizedException(): super("Unauthorized exception");
}

class UnknownResponseException extends ServiceException {
  UnknownResponseException(): super("An unexpected error ocurred");
}

class NotFoundException extends ServiceException {
  NotFoundException(): super("The resource was not found");
}