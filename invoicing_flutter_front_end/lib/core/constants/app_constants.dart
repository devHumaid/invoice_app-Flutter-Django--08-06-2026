class AppConstants {
  static const String baseUrl = 'http://192.168.1.68:8000/api';
  // For real device on same WiFi, replace with your PC IP e.g. http://192.168.1.5:8000/api

  static const String usersEndpoint = '/users';
  static const String registerEndpoint = '/users/register/';
  static const String loginEndpoint = '/users/login/';
  static const String meEndpoint = '/users/me/';
  static const String itemsEndpoint = '/items/';
  static const String invoicesEndpoint = '/invoices/';
  static const String adminInvoicesEndpoint = '/invoices/admin/all/';

  static const String tokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
}
