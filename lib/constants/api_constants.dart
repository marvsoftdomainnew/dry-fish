class ApiConstants {
  // Base URL
  static const String baseUrl = "https://chavanbrothers.co.in/api";
  static const String imageBaseUrl = "https://chavanbrothers.co.in/";

  // Endpoints
  static const String loginUrl = "$baseUrl/user/login";
  static const String getCategoryUrl = "$baseUrl/user/categories";
  static String placeorderurl = "$baseUrl/user/placeorder";
  static String addtocarturl = "$baseUrl/user/addtocart";
  static String cartUrl = "$baseUrl/user/showcart";
  static String removefromcarturl = "$baseUrl/user/removefromcart";
  static String reducequantityurl = "$baseUrl/user/reduceqty";
  static String increasequantityurl = "$baseUrl/user/increaseqty";
  static String orderListUrl = "$baseUrl/user/orders";
  static String orderDetailUrl = "$baseUrl/user/orders";
  static String cancelOrderurl = "$baseUrl/user/cancelorder";

  static String addnewaddressurl = "$baseUrl/user/addaddress";
  static String deleteaddressurl = "$baseUrl/user/deleteaddress";
  static String updateaddressUrl = "$baseUrl/user/editaddress";
  static String getAddressesUrl = "$baseUrl/user/addresses";

  static String productByCategoryUrl(int categoryId) =>
      "$baseUrl/products/categories/$categoryId";
  static String productsUrl() => "$baseUrl/products";
}
