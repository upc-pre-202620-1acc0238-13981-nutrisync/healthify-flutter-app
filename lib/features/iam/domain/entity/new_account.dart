import '../valueobject/email_address.dart';
import '../valueobject/password.dart';
import '../valueobject/person_name.dart';
import '../valueobject/user_role.dart';

/// An account to create. Signing up grants access to nothing: clinical access comes with the care link.
final class NewAccount {
  const NewAccount({required this.name, required this.email, required this.password, required this.role});

  final PersonName name;
  final EmailAddress email;
  final Password password;
  final UserRole role;
}

/// A sign-up form field with a problem, with its matching backend code.
sealed class SignUpProblem {
  const SignUpProblem();
}

final class GivenNamesProblem extends SignUpProblem {
  const GivenNamesProblem(this.problem);

  final PersonNameProblem problem;

  @override
  bool operator ==(Object other) => other is GivenNamesProblem && other.problem == problem;

  @override
  int get hashCode => Object.hash(GivenNamesProblem, problem);
}

final class FamilyNamesProblem extends SignUpProblem {
  const FamilyNamesProblem(this.problem);

  final PersonNameProblem problem;

  @override
  bool operator ==(Object other) => other is FamilyNamesProblem && other.problem == problem;

  @override
  int get hashCode => Object.hash(FamilyNamesProblem, problem);
}

/// `InvalidEmail`.
final class InvalidEmailProblem extends SignUpProblem {
  const InvalidEmailProblem();

  @override
  bool operator ==(Object other) => other is InvalidEmailProblem;

  @override
  int get hashCode => (InvalidEmailProblem).hashCode;
}

/// `WeakPassword`.
final class WeakPasswordProblem extends SignUpProblem {
  const WeakPasswordProblem();

  @override
  bool operator ==(Object other) => other is WeakPasswordProblem;

  @override
  int get hashCode => (WeakPasswordProblem).hashCode;
}

/// `RoleNotDeclared`.
final class RoleNotDeclaredProblem extends SignUpProblem {
  const RoleNotDeclaredProblem();

  @override
  bool operator ==(Object other) => other is RoleNotDeclaredProblem;

  @override
  int get hashCode => (RoleNotDeclaredProblem).hashCode;
}

/// Result of validating the sign-up form: the account ready to send, or all its problems.
sealed class SignUpValidation {
  const SignUpValidation();
}

final class ValidSignUp extends SignUpValidation {
  const ValidSignUp(this.account);

  final NewAccount account;
}

final class InvalidSignUp extends SignUpValidation {
  const InvalidSignUp(this.problems);

  final Set<SignUpProblem> problems;
}

/// Validates the whole form with the value object rules (the same as the backend's).
SignUpValidation validateNewAccount({
  required String givenNames,
  required String familyNames,
  required String email,
  required String password,
  required UserRole? role,
}) {
  final givenProblem = PersonName.problemOf(givenNames);
  final familyProblem = PersonName.problemOf(familyNames);
  final problems = <SignUpProblem>{
    if (givenProblem != null) GivenNamesProblem(givenProblem),
    if (familyProblem != null) FamilyNamesProblem(familyProblem),
    if (EmailAddress.parse(email) == null) const InvalidEmailProblem(),
    if (!Password.isStrong(password)) const WeakPasswordProblem(),
    if (role == null) const RoleNotDeclaredProblem(),
  };
  if (problems.isNotEmpty || role == null) return InvalidSignUp(problems);
  return ValidSignUp(
    NewAccount(
      name: PersonName.forSignUp(givenNames, familyNames),
      email: EmailAddress(email),
      password: Password(password),
      role: role,
    ),
  );
}
