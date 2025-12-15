import 'dart:ui';
import 'package:chavan_brothers/services/sharedpreferences_service.dart';
import 'package:chavan_brothers/views/account/account_screen.dart';
import 'package:chavan_brothers/views/cart/cart_screen.dart';
import 'package:chavan_brothers/views/dashboard/widgets/cart_badge_icon.dart';
import 'package:chavan_brothers/views/dashboard/widgets/dashboard_header.dart';
import 'package:chavan_brothers/views/dashboard/widgets/location_bottom_sheet.dart';
import 'package:chavan_brothers/views/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../Constants/app_colors.dart';
import '../../constants/app_keys.dart';
import '../../models/guest_address_model.dart';
import '../../roots/routes.dart';
import '../../viewmodels/cart_item_controller.dart';
import '../../viewmodels/dashboard_controller.dart';
import '../../viewmodels/get_address_controller.dart';
import '../../viewmodels/category_controller.dart';
import '../../viewmodels/products_controller.dart';
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
  final CategoryController categoryController = Get.put(CategoryController());
  final ProductsController productsController = Get.put(ProductsController());

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
      await checkForUpdate();

      final prefs = await SharedPreferencesService.getInstance();
      bool isLogged = prefs.getBool(AppKeys.isLogin) ?? false;

      print("🔵 DEBUG → isLogged: $isLogged");

      // Always load PUBLIC APIs
      productsController.getProducts();
      categoryController.getCategory();

      if (isLogged) {
        print("🟢 USER MODE → Loading server addresses...");

        await getAddressController.fetchAddresses();

        print("🟢 SERVER ADDRESSES:");
        if (getAddressController.addresses.isNotEmpty) {
          for (var a in getAddressController.addresses) {
            print("➡ Address: ${a.flat}, ${a.street}, ${a.locality}, ${a.city}");
          }
        } else {
          print("⚠ No server addresses found.");
        }

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
          _showLocationBottomSheet();
        }
        await _cartItemController.fetchItems();
      }

      // 🟡 GUEST MODE LOGIC
      else {
        print("🟡 GUEST MODE ACTIVE → Checking Hive guest_address box...");

        try {
          final box = Hive.box<GuestAddressModel>(AppKeys.guestAddress);

          if (box.isNotEmpty) {
            final guestAddress = box.getAt(0);

            print("🟡 GUEST ADDRESS FOUND IN HIVE:");
            // print("Name: ${guestAddress?.name}");
            // print("Flat: ${guestAddress?.flat}");
            // print("Street: ${guestAddress?.street}");
            // print("Locality: ${guestAddress?.locality}");
            // print("Pincode: ${guestAddress?.pincode}");

            setState(() {
              currentAddress =
              "${guestAddress?.flat}, ${guestAddress?.street}, ${guestAddress?.locality} - ${guestAddress?.pincode}";
              street = guestAddress?.street ?? "";
            });
          } else {
            print("⚠ Hive guest_address is empty → Opening location bottom sheet...");
            _showLocationBottomSheet();
          }
        } catch (e) {
          print("❌ ERROR reading guest Hive data: $e");
          _showLocationBottomSheet();
        }
      }
    });

  }

  // APP UPDATE HANDLERS
  Future<void> checkForUpdate() async {
    try {
      final info = await InAppUpdate.checkForUpdate();
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        if (info.flexibleUpdateAllowed) {
          await startFlexibleUpdate();
        } else if (info.immediateUpdateAllowed) {
          await startImmediateUpdate();
        }
      }
    } catch (_) {}
  }

  Future<void> startFlexibleUpdate() async {
    try {
      final result = await InAppUpdate.startFlexibleUpdate();
      if (result == AppUpdateResult.success) {
        await InAppUpdate.completeFlexibleUpdate();
      }
    } catch (_) {}
  }

  Future<void> startImmediateUpdate() async {
    try {
      await InAppUpdate.performImmediateUpdate();
    } catch (_) {}
  }
  // LOCATION BOTTOM SHEET
  void _showLocationBottomSheet() {
    isBottomSheetVisible.value = true;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Obx(
            () => LocationBottomSheet(
          isLoading: _isLoadingCurrentLocation.value,
          onUseCurrentLocation: () async {
            _isLoadingCurrentLocation.value = true;
            await _requestPermissions();
            await _getCurrentLocation();
            _isLoadingCurrentLocation.value = false;
            Navigator.pop(context);
          },
          onSelectManual: () {
            Fluttertoast.showToast(msg: "Coming soon, please select current location");
            // Navigator.pop(context);
          },
        ),
      ),
    ).whenComplete(() {
      isBottomSheetVisible.value = false;
    });
  }

  Future<void> _requestPermissions() async {
    await Permission.locationWhenInUse.request();
  }

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
      // print("📍 POSITION → lat: ${position.latitude}, lng: ${position.longitude}");
      final prefs = await SharedPreferencesService.getInstance();
      await prefs.setDouble(AppKeys.latitude, position.latitude);
      await prefs.setDouble(AppKeys.longitude, position.longitude);
      // print("💾 SAVED → latitude: ${prefs.getDouble(AppKeys.latitude)}");
      // print("💾 SAVED → longitude: ${prefs.getDouble(AppKeys.longitude)}");
      final placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);


      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        final formattedAddress =
            "${place.subLocality}, ${place.thoroughfare}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}";
        final streetAddress = place.street ?? "";
        // print("📍 FORMATTED ADDRESS → $formattedAddress");
        // print("📍 STREET → $streetAddress");
        await prefs.setString(AppKeys.currentAddress, formattedAddress);
        await prefs.setString(AppKeys.street, streetAddress);
        // print("💾 SAVED currentAddress → ${prefs.getString(AppKeys.currentAddress)}");
        // print("💾 SAVED street → ${prefs.getString(AppKeys.street)}");
        setState(() {
          street = streetAddress;
          currentAddress = formattedAddress;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Get.offAllNamed(
            AppRoutes.newAddress,
            arguments: {"currentAddress": formattedAddress,
              "place": place, },
          );
        });
      }
    } catch (e) {
      print("❌ ERROR in _getCurrentLocation → $e");
      setState(() => currentAddress = "Error getting location: $e");
    }
  }
  // BACK PRESSED
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
            Obx(
                  () => Column(
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
              ),
            ),

            Obx(
                  () => isBottomSheetVisible.value
                  ? BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(color: Colors.black.withOpacity(0.1)),
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),

        bottomNavigationBar: Obx(
              () => BottomNavigationBar(
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
          ),
        ),
      ),
    );
  }
}