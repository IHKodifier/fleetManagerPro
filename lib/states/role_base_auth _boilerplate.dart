enum Role {
  admin,
  user,
  manager,
  guest,
}

class AuthenticatedUser {
  final String id;
  final String email;
  final Role role;

  AuthenticatedUser({required this.id, required this.email, required this.role});
}

class AuthorizationService {
  static final AuthorizationService _instance = AuthorizationService._internal();

  factory AuthorizationService() => _instance;

  AuthorizationService._internal();

  bool isAuthorized(AuthenticatedUser user, String resource, Permission permission) {
    switch (user.role) {
      case Role.admin:
        return true;
      case Role.user:
        return _checkUserPermissions(resource, permission);
      case Role.manager:
        return _checkManagerPermissions(resource, permission);
      case Role.guest:
        return _checkGuestPermissions(resource, permission);
      default:
        return false;
    }
  }

  bool _checkUserPermissions(String resource, Permission permission) {
    switch (permission) {
      case Permission.read:
        return true;
      case Permission.create:
      case Permission.update:
      case Permission.delete:
        return false;
      default:
        return false;
    }
  }

  bool _checkManagerPermissions(String resource, Permission permission) {
    switch (permission) {
      case Permission.read:
      case Permission.create:
      case Permission.update:
      case Permission.delete:
        return true;
      default:
        return false;
    }
  }

  bool _checkGuestPermissions(String resource, Permission permission) {
    switch (permission) {
      case Permission.read:
        return true;
      case Permission.create:
      case Permission.update:
      case Permission.delete:
        return false;
      default:
        return false;
    }
  }
}

enum Permission {
  create,
  read,
  update,
  delete,
}

// void main() {
//   final user = AuthenticatedUser(id: '1', email: 'user@example.com', role: Role.user);
//   final authorizationService = AuthorizationService();
//   final isAuthorized = authorizationService.isAuthorized(user, 'books', Permission.read);
//   print('User is authorized to read books: $isAuthorized');
// }
