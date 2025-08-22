class UrlConst {
  static const baseUrl = 'https://admin.reachifymedia.com';

  /// APP LISTS
  static const getCategories = '$baseUrl/api/v1/categories';
  static const getCountries = '$baseUrl/api/v1/location/country-state-city';
  static const getBusinessType = '$baseUrl/api/v1/categories/business';
  static const getCity = '$baseUrl/api/v2/location/country-state-city';

  /// AUTH
  static const checkPhone = '$baseUrl/api/v1/auth/check-phone';
  static const verifyPhone = '$baseUrl/api/v1/auth/verify-phone';
  static const resendOtp = '$baseUrl/api/v1/auth/resend-otp-check-phone';

  /// USER
  static const getUser = '$baseUrl/api/v1/customer/info';
  static const updateUser = '$baseUrl/api/v1/customer/update-profile';
  static const deleteAccount = '$baseUrl/';

  //   HOME GETS
  static const getBanners = '$baseUrl/api/v1/banners';
  static const getHomeProduct = '$baseUrl/api/v1/products/home-categories';
}
