import 'package:dry_fish/Constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../../models/requests/add_new_address_request.dart';
import '../../models/requests/update_address_request.dart';
import '../../models/responses/get_addresses_response.dart';
import '../../roots/routes.dart';
import '../../viewmodels/add_new_addresss_controller.dart';
import '../../viewmodels/get_address_controller.dart';
import '../../viewmodels/update_address_controller.dart';
import '../../widgets/custom_button.dart';

class NewAddressScreen extends StatefulWidget {
  const NewAddressScreen({super.key});

  @override
  State<NewAddressScreen> createState() => _NewAddressScreenState();
}

class _NewAddressScreenState extends State<NewAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _houseController = TextEditingController();
  final _blockController = TextEditingController();
  final _buildingController = TextEditingController();
  final _streetController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _localityController = TextEditingController();

  final AddNewAddressController _addressController = Get.put(
    AddNewAddressController(),
  );
  final UpdateAddressController _updateController = Get.put(
    UpdateAddressController(),
  );
  final controller = Get.put(GetAddressController());

  String selectedTag = "HOME";
  AddressModel? editModel; 
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();

    final args = Get.arguments ?? {};
    editModel = args['model'] as AddressModel?;
    final currentAddress = args['currentAddress'] as String?;

    if (editModel != null) {
      // 🟢 EDIT EXISTING ADDRESS
      isEditMode = true;

      _nameController.text = editModel!.name;
      _mobileController.text = editModel!.phone.replaceAll("+91-", "");
      _houseController.text = editModel!.flat;
      _blockController.text = editModel!.state == "N/A" ? "" : editModel!.state;
      _buildingController.text = editModel!.building;
      _streetController.text = editModel!.street;
      _landmarkController.text = editModel!.landmark;
      _pincodeController.text = editModel!.zip;
      _localityController.text = editModel!.locality;
      selectedTag = editModel!.addressType.toUpperCase();
    } else if (currentAddress != null && currentAddress.isNotEmpty) {
      // 🟡 NEW ADDRESS BASED ON CURRENT LOCATION STRING
      final parts = currentAddress.split(',');

      _nameController.text = " ";
      _mobileController.text = " ";
      _houseController.text = " ";
      _buildingController.text = " ";
      _streetController.text = parts.length > 1 ? parts[1].trim() : "Building";
      _landmarkController.text = " ";
      _localityController.text = parts.length > 0
          ? parts[0].trim()
          : "Building";
      _blockController.text = " ";
      _pincodeController.text = parts.length > 4 ? parts[4].trim() : "000000";
      selectedTag = "HOME";
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _houseController.dispose();
    _blockController.dispose();
    _buildingController.dispose();
    _streetController.dispose();
    _landmarkController.dispose();
    _pincodeController.dispose();
    _localityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final width = size.width;
    final height = size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.extraLightestPrimary,
        elevation: 1,
        centerTitle: true,
        title: Text(
          isEditMode ? "Edit Address" : "Add Address",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: width * 0.05),
          children: [
            _buildTextField(
              "Name",
              "Enter name",
              _nameController,
              validator: (v) =>
                  v == null || v.isEmpty ? "Name is required" : null,
            ),
            _buildMobileField(width, height),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    "House / Flat No",
                    "Flat No",
                    _houseController,
                    validator: (v) =>
                        v == null || v.isEmpty ? "Required" : null,
                  ),
                ),
                SizedBox(width: width * 0.03),
                Expanded(
                  child: _buildTextField(
                    "Block Name (Optional)",
                    "Block Name",
                    _blockController,
                  ),
                ),
              ],
            ),
            _buildTextField(
              "Building Name",
              "Building Name",
              _buildingController,
              validator: (v) => v == null || v.isEmpty ? "Required" : null,
            ),
            _buildTextField(
              "Street",
              "Street",
              _streetController,
              validator: (v) => v == null || v.isEmpty ? "Required" : null,
            ),
            _buildTextField("Landmark", "Landmark", _landmarkController),
            _buildTextField(
              "Pincode",
              "226012",
              _pincodeController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              validator: (v) {
                if (v == null || v.isEmpty) return "Required";
                if (v.length != 6) return "Enter valid 6-digit pincode";
                return null;
              },
            ),
            _buildTextField(
              "Locality",
              "L D A Colony",
              _localityController,
              validator: (v) => v == null || v.isEmpty ? "Required" : null,
            ),
            SizedBox(height: height * 0.02),

            Text(
              "Save As",
              style: TextStyle(fontSize: 14.sp, color: Colors.grey[800]),
            ),
            SizedBox(height: height * 0.001),

            Row(
              children: ["HOME", "WORK", "OTHER"].map((tag) {
                final isSelected = selectedTag == tag;
                IconData icon;
                if (tag == "HOME")
                  icon = Icons.home;
                else if (tag == "WORK")
                  icon = Icons.business_center;
                else
                  icon = Icons.location_on;

                return Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(width * 0.03),
                    onTap: () => setState(() => selectedTag = tag),
                    child: Container(
                      height: height * 0.05,
                      margin: EdgeInsets.only(
                        right: tag != "OTHER" ? width * 0.03 : 0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(width * 0.03),
                        border: Border.all(
                          color: isSelected ? Colors.green : Colors.grey,
                          width: 1,
                        ),
                        color: isSelected
                            ? Colors.green.shade50
                            : Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            icon,
                            size: width * 0.045,
                            color: isSelected ? Colors.green : Colors.grey,
                          ),
                          SizedBox(width: width * 0.01),
                          Text(
                            tag,
                            style: TextStyle(
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.green
                                  : Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: width * 0.08),

            // 🔹 Save Button with loading
            SafeArea(
              minimum: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewPadding.bottom + 12,
              ),
              child: Obx(() {
                final isLoading =
                    _addressController.isLoading.value ||
                    _updateController.isLoading.value;

                return CustomButton(
                  text: isEditMode ? "Update Address" : "Save Address",
                  onTap: isLoading ? null : _onSavePressed,
                  isLoading: isLoading,
                  height: height * 0.055,
                  width: double.infinity,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  shadowColor: Colors.green,
                  borderRadius: width * 0.027,
                );
              }),
            ),
            SizedBox(height: height * 0.03),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint,
    TextEditingController controller, {
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int? maxLength, // optional, only set when needed
  }) {
    final size = MediaQuery.sizeOf(context);
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.01),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: label.split("(").first.trim(), // "Block Name"
                  style: TextStyle(fontSize: 15.sp, color: AppColors.black),
                ),
                if (label.contains("(")) // show only if optional exists
                  TextSpan(
                    text:
                        " (${label.split("(").last.replaceAll(")", "").trim()})", // "
                    style: TextStyle(
                      fontSize: 13.sp, // smaller font
                      color: Colors.grey, // grey color
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(height: size.height * 0.004),
          TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            textInputAction: TextInputAction.next,
            maxLines: 1,
            maxLength: maxLength,
            onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
            decoration: InputDecoration(
              isDense: true,
              // reduces height
              visualDensity: VisualDensity(vertical: -1),
              // make it even more compact
              hintText: hint,
              counterText: maxLength != null ? "" : null,
              hintStyle: TextStyle(
                fontSize: size.width * 0.035,
                color: Colors.grey,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(size.width * 0.02),
                borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(size.width * 0.02),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(size.width * 0.02),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(size.width * 0.02),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileField(double width, double height) {
    return Padding(
      padding: EdgeInsets.only(top: height * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mobile Number",
            style: TextStyle(fontSize: 15.sp, color: AppColors.black),
          ),
          SizedBox(height: height * 0.01),
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.025,
                  vertical: height * 0.013,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(width * 0.02),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.flag, color: AppColors.primary, size: 20),
                    SizedBox(width: 4),
                    Text("+91"),
                  ],
                ),
              ),
              SizedBox(width: width * 0.03),
              Expanded(
                child: TextFormField(
                  maxLength: 10,
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Mobile number required";
                    if (v.length != 10) return "Enter valid 10-digit number";
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                  decoration: InputDecoration(
                    hintText: "9760203435",
                    counterText: "",
                    isDense: true,
                    // reduces height
                    visualDensity: VisualDensity(vertical: -1),
                    hintStyle: TextStyle(
                      fontSize: width * 0.035,
                      color: Colors.grey,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.02),
                      borderSide: BorderSide(
                        color: Colors.grey.shade400,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.02),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.02),
                      borderSide: const BorderSide(color: Colors.red, width: 1),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.02),
                      borderSide: const BorderSide(
                        color: AppColors.primary,
                        width: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onSavePressed() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    if (isEditMode && editModel != null) {
      final request = UpdateAddressRequest(
        name: _nameController.text.trim(),
        phone: "+91-${_mobileController.text.trim()}",
        flat: _houseController.text.trim(),
        street: _streetController.text.trim(),
        building: _buildingController.text.trim(),
        country: "India",
        city: _localityController.text.trim(),
        state: _blockController.text.trim().isEmpty
            ? "N/A"
            : _blockController.text.trim(),
        zip: _pincodeController.text.trim(),
        landmark: _landmarkController.text.trim(),
        locality: _localityController.text.trim(),
        addressType: selectedTag.toLowerCase(),
        isSelected: true,
      );

      final success = await _updateController.updateAddress(
        editModel!.id.toString(),
        request,
      );

      if (success) {
        controller.fetchAddresses();
        Get.until((route) => Get.currentRoute == AppRoutes.savedaddresses);
      }
    } else {
      final request = AddNewAddressRequest(
        name: _nameController.text.trim(),
        phone: "+91-${_mobileController.text.trim()}",
        flat: _houseController.text.trim(),
        street: _streetController.text.trim(),
        building: _buildingController.text.trim(),
        country: "India",
        city: _localityController.text.trim(),
        state: _blockController.text.trim().isEmpty
            ? "N/A"
            : _blockController.text.trim(),
        zip: _pincodeController.text.trim(),
        landmark: _landmarkController.text.trim(),
        locality: _localityController.text.trim(),
        addressType: selectedTag.toLowerCase(),
        isSelected: false,
      );

      await _addressController.addNewAddress(request);

      if (_addressController.addNewAddressResponse?.status == true) {
        Navigator.pop(context);
      }
    }
  }
}
