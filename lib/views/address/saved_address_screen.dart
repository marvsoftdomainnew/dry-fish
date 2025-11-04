import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../Constants/app_colors.dart';
import '../../models/responses/get_addresses_response.dart';
import '../../roots/routes.dart';
import '../../viewmodels/get_address_controller.dart';
import '../../viewmodels/delete_address_controller.dart';

class SavedAddressesScreen extends StatelessWidget {
  const SavedAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GetAddressController controller = Get.put(GetAddressController());
    final DeleteAddressController deleteController = Get.put(DeleteAddressController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.3,
        title: Text(
          "Saved Addresses",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.sp),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 3.w),
            child: OutlinedButton(
              onPressed: () async {
                await Get.toNamed(AppRoutes.newAddress);
                controller.fetchAddresses();
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

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.addresses.isEmpty) {
          return const Center(
            child: Text(
              "No saved addresses found",
              style: TextStyle(color: Colors.grey),
            ),
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
                Navigator.pop(context, address);
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
      }),
    );
  }

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
                Text(
                  model.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.6.h),
                Text(
                  "${model.flat}, ${model.street}, ${model.building}, ${model.locality}, ${model.city}, ${model.state} - ${model.zip}",
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                ),
                SizedBox(height: 0.6.h),
                Text(
                  model.phone,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[700]),
                ),
              ],
            ),
          ),

          PopupMenuButton(
            icon: isDeleting
                ? SizedBox(
                    width: 18.sp,
                    height: 18.sp,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(Icons.more_vert, size: 18.sp, color: Colors.grey[600]),
            onSelected: (value) async {
              if (value == "edit") {
                final result = await Get.toNamed(
                  AppRoutes.newAddress,
                  arguments: model,
                );
                if (result == true) {
                  savedController.fetchAddresses();
                }
              } else if (value == "delete") {
                await deleteController.deleteAddress(model.id.toString());
                savedController.addresses.remove(model);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "edit",
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 18, color: AppColors.primary),
                    SizedBox(width: 6),
                    const Text("Edit"),
                  ],
                ),
              ),
              PopupMenuItem(
                value: "delete",
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 6),
                    const Text("Delete"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
