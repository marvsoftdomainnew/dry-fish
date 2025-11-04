import 'dart:ui';
import 'package:dry_fish/services/sharedpreferences_service.dart';
import 'package:dry_fish/views/account/account_screen.dart';
import 'package:dry_fish/views/cart/cart_screen.dart';
import 'package:dry_fish/views/dashboard/widgets/cart_badge_icon.dart';
import 'package:dry_fish/views/dashboard/widgets/dashboard_header.dart';
import 'package:dry_fish/views/dashboard/widgets/location_bottom_sheet.dart';
import 'package:dry_fish/views/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../Constants/app_colors.dart';
import '../../constants/app_keys.dart';
import '../../utils/logger.dart';
import '../../viewmodels/cart_item_controller.dart';
import '../../viewmodels/dashboard_controller.dart';
import '../../viewmodels/get_address_controller.dart';
import 'home_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardController _dashboardController = Get.put(DashboardController());
  final CartItemController _cartItemController = Get.put(CartItemController());
  final GetAddressController getAddressController = Get.put(GetAddressController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final RxBool isBottomSheetVisible = false.obs;
  final RxBool _isLoadingCurrentLocation = false.obs;

  String currentAddress = "Fetching your location...";
  String street = "Fetching street...";
  Position? currentPosition;
  final Rxn<DateTime> _lastBackPressed = Rxn<DateTime>();

  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    CartScreen(showAppBar: false),
    AccountScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await getAddressController.fetchAddresses();
      // 🔹 If user already has saved addresses → skip location sheet
      if (getAddressController.addresses.isNotEmpty) {
        final selected = getAddressController.selectedAddress;
        if (selected != null) {
          setState(() {
            currentAddress =
            "${selected.flat}, ${selected.street}, ${selected.locality}, ${selected.city}";
            street = selected.street;
          });
        }
      } else {
        // 🔹 No address found → ask location
        _showLocationBottomSheet();
      }

      _cartItemController.fetchItems();
    });
  }

  /// 🔹 Location Bottom Sheet
  void _showLocationBottomSheet() {
    isBottomSheetVisible.value = true;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Obx(() => LocationBottomSheet(
        isLoading: _isLoadingCurrentLocation.value,
        onUseCurrentLocation: () async {
          _isLoadingCurrentLocation.value = true;
          await _requestPermissions();
          await _getCurrentLocation();
          _isLoadingCurrentLocation.value = false;
          Navigator.pop(context);
        },
        onSelectManual: () {
          Navigator.pop(context);
          _requestPermissions();
        },
      )),
    ).whenComplete(() {
      isBottomSheetVisible.value = false;
    });
  }
  /// 🔹 Request permissions
  Future<void> _requestPermissions() async {
    var locationStatus = await Permission.locationWhenInUse.request();
    if (locationStatus.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location permission is required")),
      );
    }
    // if (locationStatus.isDenied || locationStatus.isPermanentlyDenied) {
    //   // 🔹 If user denies → open map view for manual select
    //   _openMapView();
    //   return;
    // }

    var notificationStatus = await Permission.notification.request();
    if (notificationStatus.isDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Notification permission is required")),
      );
    }
  }
  // void _openMapView() {
  //   Navigator.pop(context); // close bottom sheet if open
  //
  //   // 🔹 Navigate to your map view page (replace with your actual screen)
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => MapViewScreen()),
  //   );
  // }
  /// 🔹 Get current location & convert to address
  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() => currentAddress = "Location permission denied");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() => currentPosition = position);
      appLog("📍 Current Position fetched successfully");
      appLog("Latitude: ${position.latitude}");
      appLog("Longitude: ${position.longitude}");
      appLog("Accuracy: ${position.accuracy} meters");
      appLog("Timestamp: ${position.timestamp}");

      final prefs = await SharedPreferencesService.getInstance();
      await prefs.setDouble(AppKeys.latitude, position.latitude);
      await prefs.setDouble(AppKeys.longitude, position.longitude);
      appLog("✅ Saved to SharedPreferences: lat=${position.latitude}, long=${position.longitude}");

      final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        // Log each address component separately
        appLog("🏠 Address Details ↓");
        appLog("Street: ${place.street}");
        appLog("SubLocality: ${place.subLocality}");
        appLog("Locality: ${place.locality}");
        appLog("SubAdministrativeArea: ${place.subAdministrativeArea}");
        appLog("AdministrativeArea: ${place.administrativeArea}");
        appLog("PostalCode: ${place.postalCode}");
        appLog("Country: ${place.country}");
        appLog("ISO Country Code: ${place.isoCountryCode}");
        appLog("Name: ${place.name}");
        appLog("Thoroughfare: ${place.thoroughfare}");
        appLog("SubThoroughfare: ${place.subThoroughfare}");
        setState(() {
          final streetAddress = "${place.street}";
          final formattedAddress = "${place.subLocality}, ${place.thoroughfare}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}";

          setState(() {
            street = streetAddress;
            currentAddress = formattedAddress;});
        });
      }
    } catch (e) {
      setState(() => currentAddress = "Error getting location: $e");
    }
  }
  /// 🔹 Handle back press
  Future<bool> _onWillPop() async {
    if (_scaffoldKey.currentState?.isDrawerOpen == true) {
      Navigator.of(context).pop();
      return false;
    }

    if (_dashboardController.selectedIndex.value != 0) {
      _dashboardController.changeTab(0);
      return false;
    }

    DateTime now = DateTime.now();
    if (_lastBackPressed.value == null ||
        now.difference(_lastBackPressed.value!) > const Duration(seconds: 3)) {
      _lastBackPressed.value = now;
      Fluttertoast.showToast(msg: "Press back again to exit");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    final statusBarHeight = mediaQuery.padding.top;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.bgColor,
        body: Stack(
          children: [
            Obx(() => Column(
              children: [
                if (_dashboardController.selectedIndex.value == 0)
                  DashboardHeader(
                    address: currentAddress,
                    street: street,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    statusBarHeight: statusBarHeight,
                  ),
                Expanded(
                  child: _screens[_dashboardController.selectedIndex.value],
                ),
              ],
            )),
            Obx(() => isBottomSheetVisible.value
                ? BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(color: Colors.black.withOpacity(0.1)),
            )
                : const SizedBox.shrink()),
          ],
        ),
        bottomNavigationBar: Obx(() => BottomNavigationBar(
          backgroundColor: AppColors.white,
          currentIndex: _dashboardController.selectedIndex.value,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.darkGrey,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 14,
          unselectedFontSize: 12,
          iconSize: 24,
          onTap: _dashboardController.selectedIndex,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(LucideIcons.house),
              label: "Home",
            ),
            const BottomNavigationBarItem(
              icon: Icon(LucideIcons.search),
              label: "Search",
            ),
            BottomNavigationBarItem(
              icon: CartBadgeIcon(controller: _cartItemController),
              label: "Cart",
            ),
            const BottomNavigationBarItem(
              icon: Icon(LucideIcons.user),
              label: "Account",
            ),
          ],
        )),
      ),
    );
  }
}

