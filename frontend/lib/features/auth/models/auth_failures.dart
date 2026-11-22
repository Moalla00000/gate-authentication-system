sealed class AuthFailure {
  const AuthFailure();

  const factory AuthFailure.cancelledByUser() = CancelledByUser;
  const factory AuthFailure.serverError([String? message]) = ServerError;
  const factory AuthFailure.emailAlreadyInUse() = EmailAlreadyInUse;
  const factory AuthFailure.invalidEmailAndPasswordCombination() =
      InvalidEmailAndPasswordCombination;
  const factory AuthFailure.weakPassword() = WeakPassword;
  const factory AuthFailure.accountExistsWithDifferentCredential() =
      AccountExistsWithDifferentCredential;
  const factory AuthFailure.invalidCredential() = InvalidCredential;
  const factory AuthFailure.userDisabled() = UserDisabled;
  const factory AuthFailure.tooManyRequests() = TooManyRequests;
}

class CancelledByUser extends AuthFailure {
  const CancelledByUser();
}

class ServerError extends AuthFailure {
  final String? message;
  const ServerError([this.message]);
}

class EmailAlreadyInUse extends AuthFailure {
  const EmailAlreadyInUse();
}

class InvalidEmailAndPasswordCombination extends AuthFailure {
  const InvalidEmailAndPasswordCombination();
}

class WeakPassword extends AuthFailure {
  const WeakPassword();
}

class AccountExistsWithDifferentCredential extends AuthFailure {
  const AccountExistsWithDifferentCredential();
}

class InvalidCredential extends AuthFailure {
  const InvalidCredential();
}

class UserDisabled extends AuthFailure {
  const UserDisabled();
}

class TooManyRequests extends AuthFailure {
  const TooManyRequests();
}
