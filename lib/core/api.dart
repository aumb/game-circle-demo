class API {
  static final String base = "http://192.168.10.12/api";

  // static final String base = "https://cryptic-eyrie-59950.herokuapp.com/api";

  static final String login = "/login";
  static final String register = "/register";
  static final String user = "/user";
  static final String users = "/users";
  static final String logout = "/logout";
  static final String lounges = "/lounges";
  static final String favorites = "/favorites";
  static final String reviews = "/reviews";
  static final String refreshToken = "/refresh_token";

  static final String favoriteLounges = favorites + lounges;
  static final String userReviews = user + reviews;
  static final String loungeReviews = reviews + lounges;
}
