// lib/admin_state.dart

class AdminState {
  static final AdminState _instance = AdminState._internal();

  factory AdminState() {
    return _instance;
  }

  AdminState._internal();

  bool isAdmin = true; // Set to true to simulate admin access
}
