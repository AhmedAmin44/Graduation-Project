class EndPoint {
  static String baseUrl = "https://nextstep.runasp.net/api/";
  static String signIn = "Auth/login-student";
  static const String studentApplications = "Applications/GetAppsForStudent"; 
  static const String decodeToken = "Auth/decode-token"; 

  static String applicationDetailsAndStatus(int applicationId) {
    return "Applications/$applicationId/details";
  }

  static String getUserDataEndPoint(id) {
    return "user/get-user/$id";
  }
}

class ApiKey {
  static String status = "status";
  static String errorMessage = "ErrorMessage";
  static String token = "token";
  static String message = "message";
  static String id = "id";
  static String name = "name";
  static String nIdPassowrd = "nIdPassowrd";
}
