import 'package:chavan_brothers/views/address/new_address_screen.dart';
import 'package:chavan_brothers/views/address/saved_address_screen.dart';
import 'package:chavan_brothers/views/auth/login_screen.dart';
// import 'package:chavan_brothers/views/auth/otp_verification_screen.dart';
import 'package:chavan_brothers/views/cart/cart_screen.dart';
import 'package:chavan_brothers/views/cart/check_out_screen.dart';
import 'package:chavan_brothers/views/contact_us_screen.dart';
import 'package:chavan_brothers/views/dashboard/dasboard_screen.dart';
import 'package:chavan_brothers/views/onboarding/onboarding_screen.dart';
import 'package:chavan_brothers/views/order/order_confirmation_screen.dart';
import 'package:chavan_brothers/views/order/order_history_screen.dart';
import 'package:chavan_brothers/views/products/product_detail_screen.dart';
import 'package:chavan_brothers/views/products/product_list_screen.dart';
import 'package:chavan_brothers/views/search_screen.dart';
import 'package:chavan_brothers/views/splash_screen.dart';
import 'package:get/get.dart';
import '../views/auth/signup_screen.dart';

class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const signup = '/signup';
  // static const otpVerification = '/otpVerification';
  static const onboarding = '/onboarding';
  static const dashBoard = '/dashBoard';
  static const cart = '/cart';
  static const orderConfirmer = '/orderConfirmer';
  static const newAddress = '/newAddress';
  static const search = '/search';
  static const Checkout = '/Checkout';
  static const orderHistory = '/orderHistory';
  static const contact = '/contact';
  static const productScreen = '/productScreen';
  static const productDetail = '/productDetail';
  static const savedaddresses = '/savedaddresses';

  static const _defaultTransition = Transition.cupertino;
  static const _transitionDuration = Duration(milliseconds: 500);

  static GetPage _buildPage({
    required String name,
    required GetPageBuilder page,
  }) {
    return GetPage(
      name: name,
      page: page,
      transition: _defaultTransition,
      transitionDuration: _transitionDuration,
    );
  }

  static List<GetPage> getRoutes() {
    return [
      _buildPage(name: splash, page: () => SplashScreen()),
      _buildPage(name: login, page: () => LoginScreen()),
      _buildPage(name: signup, page: () => SignupScreen()),
      // _buildPage(name: otpVerification, page: () {final args = Get.arguments as Map<String, dynamic>;return OtpVerificationScreen(phoneNumber: args['phoneNumber']);},),
      _buildPage(name: dashBoard, page: () => DashboardScreen()),
      _buildPage(name: onboarding, page: () => OnboardingScreen()),
      _buildPage(name: cart, page: () => CartScreen()),
      _buildPage(name: orderConfirmer, page: () => OrderConfirmationScreen()),
      _buildPage(name: newAddress, page: () => NewAddressScreen()),
      _buildPage(name: search, page: () => SearchScreen()),
      _buildPage(name: Checkout, page: () => CheckoutScreen()),
      _buildPage(name: orderHistory, page: () => OrderHistoryScreen()),
      _buildPage(name: contact, page: () => ContactUsScreen()),
      _buildPage(name: productScreen, page: () => ProductListScreen()),
      _buildPage(name: productDetail, page: () => ProductDetailScreen()),
      _buildPage(name: savedaddresses, page: () => SavedAddressesScreen()),
    ];
  }
}
