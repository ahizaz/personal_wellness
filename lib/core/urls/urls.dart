class Urls{
  static const String baseUrl = "http://10.10.12.25:5005/api/v1";
  static const String register ="$baseUrl/user/create-user";
  static const String forgetpassword = "$baseUrl/auth/forgot-password";
  static const String resetpassword = "$baseUrl/auth/reset-password";
  static const String verifyemail = "$baseUrl/auth/verify-email";
  static const String googlesignin = "$baseUrl/auth/google-login";
  static const String getallskinconditon = "$baseUrl/skin-condition/get-all";
  static const String imageurl = "http://10.10.12.25:5005";
  static const String getallproduct = "$baseUrl/product/get-all";
  static const String getProductDetails = "$baseUrl/product/details"; // Added product details endpoint
  static const String changepassword = "$baseUrl/auth/change-password";
  static const String personalizationCreate = "$baseUrl/personalisation/create"; // Added personalization endpoint
  static const String photoProgressCreate = "$baseUrl/photo-progress/create"; // Photo progress create endpoint
  static const String photoProgressGetAll = "$baseUrl/photo-progress/get-all"; // Photo progress get all endpoint
  static const String photoProgressTimeline = "$baseUrl/photo-progress/get-timeline"; // Photo progress timeline endpoint
 
}