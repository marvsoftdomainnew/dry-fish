import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:shimmer/shimmer.dart';
import '../../Constants/app_colors.dart';
import '../../constants/app_keys.dart';
import '../../models/guest_address_model.dart';
import '../../models/responses/get_addresses_response.dart';
import '../../roots/routes.dart';
import '../../services/sharedpreferences_service.dart';
import '../../viewmodels/get_address_controller.dart';
import '../../viewmodels/delete_address_controller.dart';
import '../../viewmodels/guest_address_controller.dart';

class SavedAddressesScreen extends StatelessWidget {
  const SavedAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GetAddressController serverController =
    Get.put(GetAddressController(), permanent: false);

    final DeleteAddressController deleteController =
    Get.put(DeleteAddressController(), permanent: false);

    final GuestAddressController guestController =
    Get.put(GuestAddressController(), permanent: false);

    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final bool isLogged = snapshot.data!;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.3,
            title: Text(
              "Saved Addresses",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.sp),
            ),
            actions: [
              if (isLogged)   // ← SHOW ONLY WHEN LOGGED IN
                Padding(
                  padding: EdgeInsets.only(right: 3.w),
                  child: OutlinedButton(
                    onPressed: () async {
                      await Get.toNamed(AppRoutes.newAddress);

                      serverController.fetchAddresses();
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      "+ Add New",
                      style: TextStyle(fontSize: 14.sp, color: Colors.white),
                    ),
                  ),
                ),
            ],

          ),

          body: isLogged
              ? _buildLoggedUserBody(serverController, deleteController)
              : _buildGuestUserBody(guestController),
        );
      },
    );
  }
  // CHECK LOGIN STATUS
  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferencesService.getInstance();
    return prefs.getBool(AppKeys.isLogin) ?? false;
  }

  // LOGGED USER BODY
  Widget _buildLoggedUserBody(
      GetAddressController controller, DeleteAddressController deleteController) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildShimmerList();
      }

      if (controller.addresses.isEmpty) {
        return const Center(
          child: Text("No saved addresses found", style: TextStyle(color: Colors.grey)),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        itemCount: controller.addresses.length,
        itemBuilder: (_, index) {
          final address = controller.addresses[index];

          return GestureDetector(
            onTap: () {
              controller.selectAddress(address.id);
              Navigator.pop(Get.context!, address);
            },
            child: Obx(
                  () => _addressCard(
                address,
                controller.selectedAddressId.value,
                deleteController,
                controller,
              ),
            ),
          );
        },
      );
    });
  }

  // GUEST USER BODY
  Widget _buildGuestUserBody(GuestAddressController controller) {
    return Obx(() {
      final guestAddress = controller.selectedAddress.value;

      if (guestAddress == null) {
        return const Center(
          child: Text("No address found. Add one.", style: TextStyle(color: Colors.grey)),
        );
      }

      return ListView(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        children: [
          _guestAddressCard(guestAddress),
        ],
      );
    });
  }
  // SHIMMER LIST
  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            margin: EdgeInsets.only(bottom: 2.h),
            padding: EdgeInsets.all(2.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Container(width: 22.sp, height: 22.sp, color: Colors.white),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    children: [
                      Container(height: 14.sp, color: Colors.white),
                      SizedBox(height: 1.h),
                      Container(height: 12.sp, color: Colors.white),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
  // ADDRESS CARD (LOGGED USER)
  Widget _addressCard(
      AddressModel model,
      int? selectedId,
      DeleteAddressController deleteController,
      GetAddressController savedController,
      ) {
    final bool isSelected = selectedId == model.id;
    final isDeleting = deleteController.deletingId.value == model.id.toString();

    IconData icon = model.addressType == "home"
        ? Icons.home_outlined
        : model.addressType == "work"
        ? Icons.location_city_outlined
        : Icons.location_on_outlined;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(2.h),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? Colors.green : Colors.grey.shade300,
          width: isSelected ? 1.6 : 0.7,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18.sp, color: Colors.black87),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.name,
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                SizedBox(height: 0.6.h),
                Text(
                  "${model.flat}, ${model.street}, ${model.building}, ${model.locality}, ${model.city}, ${model.state} - ${model.zip}",
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                ),
                SizedBox(height: 0.6.h),
                Text(model.phone,
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[700])),
              ],
            ),
          ),
          PopupMenuButton(
            icon: isDeleting
                ? SizedBox(
                width: 18.sp,
                height: 18.sp,
                child: const CircularProgressIndicator(strokeWidth: 2))
                : Icon(Icons.more_vert, size: 18.sp, color: Colors.grey[600]),
            onSelected: (value) async {
              if (value == "edit") {
                await Get.toNamed(
                  AppRoutes.newAddress,
                  arguments: {"model": model},
                );
                savedController.fetchAddresses();
              } else if (value == "delete") {
                await deleteController.deleteAddress(model.id.toString());
                savedController.addresses.remove(model);
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: "edit", child: Text("Edit")),
              const PopupMenuItem(value: "delete", child: Text("Delete")),
            ],
          ),
        ],
      ),
    );
  }

  // GUEST ADDRESS CARD (NO DELETE SERVER, ONLY EDIT POSSIBLE)
  Widget _guestAddressCard(GuestAddressModel model) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(2.h),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green, width: 1.2),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined, size: 24, color: Colors.black87),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.name,
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600)),
                SizedBox(height: 0.6.h),
                Text(
                  "${model.flat}, ${model.street}, ${model.building}, ${model.locality}, "
                      "${model.pincode}",
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                ),
                SizedBox(height: 0.6.h),
                Text(model.phone,
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[700])),
              ],
            ),
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              if (value == "edit") {
                final prefs = await SharedPreferencesService.getInstance();
                bool isLogged = prefs.getBool(AppKeys.isLogin) ?? false;

                if (isLogged) {
                  // Logged user → normal API model
                  await Get.toNamed(AppRoutes.newAddress, arguments: {
                    "model": model,
                    "isGuest": false,
                  });
                } else {
                  // Guest mode → Hive model
                  await Get.toNamed(AppRoutes.newAddress, arguments: {
                    "guestModel": model,
                    "isGuest": true,
                  });
                }
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: "edit", child: Text("Edit")),
            ],
          ),

        ],
      ),
    );
  }
}
