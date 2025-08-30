class AuthClient {
  Future<bool> login(String username, String password) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));
    // Simulate a successful login
    return username == 'test' && password == '1234';
  }
}
