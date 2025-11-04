// import 'package:dry_fish/roots/routes.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sizer/sizer.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../../Constants/app_colors.dart';
// import '../../widgets/custom_text_app_bar.dart';

// class AccountScreen extends StatefulWidget {
//   const AccountScreen({super.key});

//   @override
//   State<AccountScreen> createState() => _AccountScreenState();
// }
// Future<void> _launchURL(String url) async {
//   final Uri uri = Uri.parse(url);
//   if (!await launchUrl(
//     uri,
//     mode: LaunchMode.externalApplication,
//     webViewConfiguration: const WebViewConfiguration(
//       enableJavaScript: true,
//       enableDomStorage: true,
//     ),
//   )) {
//     throw Exception('Could not launch $url');
//   }
// }

// class _AccountScreenState extends State<AccountScreen> {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: const CustomTextAppBar(title: "Setting"),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric( vertical: 2.h),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// User Info
//               Center(
//                 child: Column(
//                   children: [
//                     Text(
//                       "Hi, Akash",
//                       style: TextStyle(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     SizedBox(height: 0.5.h),
//                     Text(
//                       "9760203435 | Aman576543@gmail.com",
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         color: Colors.grey[600],
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ],
//                 ),
//               ),

//               SizedBox(height: 3.h),

//               /// Menu Items
//               _buildMenuItem(
//                 icon: Icons.shopping_cart_outlined,
//                 title: "Orders",
//                 subtitle: "Check your order status",
//                 onTap: (){Get.toNamed(AppRoutes.order);}
//               ),
//               _buildMenuItem(
//                 icon: Icons.card_giftcard,
//                 title: "Earn Rewards",
//                 subtitle: "Invite friends and earn rewards",
//               ),
//               _buildMenuItem(
//                 icon: Icons.phone_outlined,
//                 title: "Contact Us",
//                 subtitle: "Help regarding your recent purchase",
//                   onTap: (){Get.toNamed(AppRoutes.contact);}
//               ),
//               _buildMenuItem(
//                 icon: Icons.description_outlined,
//                 title: "Terms & Conditions",
//                 subtitle: "",
//                 onTap: () {
//                   _launchURL("https://www.termsfeed.com/blog/privacy-policy-url/");
//                 },
//               ),
//               _buildMenuItem(
//                 icon: Icons.policy_outlined,
//                 title: "Privacy Policy",
//                 subtitle: "",
//                 onTap: () {
//                   _launchURL("https://www.termsfeed.com/blog/privacy-policy-url/");
//                 },
//               ),
//               _buildMenuItem(
//                 icon: Icons.store_outlined,
//                 title: "Seller Information",
//                 subtitle: "",
//               ),
//               _buildMenuItem(
//                 icon: Icons.lock_outline,
//                 title: "Account Privacy",
//                 subtitle: "",
//               ),
//               _buildMenuItem(
//                 icon: Icons.notifications_active_outlined,
//                 title: "Notification Preferences",
//                 subtitle: "",
//               ),
//               _buildMenuItem(
//                 icon: Icons.logout,
//                 title: "Logout",
//                 subtitle: "",
//                 onTap: () {
//                   _showLogoutDialog(context);
//                 },
//               ),

//               SizedBox(height: 5.h),

//               /// App Version Footer
//               Center(
//                 child: Column(
//                   children: [
//                     /// First line with styled text
//                     RichText(
//                       textAlign: TextAlign.center,
//                       text: TextSpan(
//                         style: GoogleFonts.nunito(
//                           fontSize: 20.sp,
//                         ),
//                         children: [
//                           TextSpan(
//                             text: "CHAVAN ",
//                             style: const TextStyle(color: AppColors.black),
//                           ),
//                           TextSpan(
//                             text: "BROTHER'S",
//                             style: TextStyle(color: AppColors.primary),
//                           ),
//                         ],
//                       ),
//                     ),

//                     /// Second line - all caps
//                     Text(
//                       "GROUP OF JEEVAN AGRO",
//                       style: GoogleFonts.nunito(
//                         fontSize: 12.sp,
//                         color: Colors.black,
//                         letterSpacing: 1, // makes it look more formal
//                       ),
//                     ),

//                     SizedBox(height: 0.5.h),

//                     /// Version text
//                     Text(
//                       "v8.0.0.0",
//                       style: TextStyle(
//                         fontSize: 14.sp,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                     SizedBox(height:2.h),
//                   ],
//                 ),
//               )

//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(18),
//           ),
//           title: const Text(
//             "Logout",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           content: const Text(
//             "Are you sure you want to logout?",
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Cancel, just close dialog
//               },
//               child: const Text(
//                 "Cancel",
//                 style: TextStyle(color: Colors.grey),
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text(
//                 "Logout",
//                 style: TextStyle(color: AppColors.primary),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildMenuItem({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     String? trailing,
//     VoidCallback? onTap,
//   }) {
//     return Column(
//       children: [
//         ListTile(
//           contentPadding: EdgeInsets.zero,
//           leading: Padding(
//             padding:  EdgeInsets.only(left: 5.w),child: Icon(icon, color: AppColors.primary, size: 20.sp),),
//           title: Text(
//             title,
//             style: TextStyle(
//               fontSize: 16.sp,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           subtitle: subtitle.isNotEmpty
//               ? Text(
//             subtitle,
//             style: TextStyle(
//               fontSize: 14.sp,
//               color: Colors.grey[600],
//             ),
//           )
//               : null,
//           trailing: trailing != null
//               ? Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Icon(Icons.monetization_on,
//                   color: Colors.amber, size: 14.sp),
//               SizedBox(width: 1.w),
//               Text(
//                 trailing,
//                 style: TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ],
//           )
//               : Padding(
//             padding:  EdgeInsets.only(right: 5.w),
//             child: Icon(Icons.chevron_right, color: AppColors.darkGrey, size: 18.sp),
//           ),
//           onTap: onTap,
//         ),
//         Divider(height: 1.h, thickness: 0.3,color: AppColors.grey,),
//       ],
//     );
//   }
// }

import 'dart:convert';
import 'package:dry_fish/roots/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Constants/app_colors.dart';
import '../../constants/app_keys.dart';
import '../../widgets/custom_text_app_bar.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

Future<void> _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
    webViewConfiguration: const WebViewConfiguration(
      enableJavaScript: true,
      enableDomStorage: true,
    ),
  )) {
    throw Exception('Could not launch $url');
  }
}

class _AccountScreenState extends State<AccountScreen> {
  String? userName;
  String? userPhone;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(AppKeys.user);

    if (userJson != null) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      setState(() {
        userName = userMap['name'] ?? '';
        userPhone = userMap['phone'] ?? '';
        userEmail = userMap['email'] ?? '';
      });
      print("🧾 Loaded user data → $userMap");
    } else {
      print("⚠️ No user data found in prefs");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomTextAppBar(title: "Setting"),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      "Hi, ${userName ?? 'Guest'}",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      "${userPhone ?? '-'} | ${userEmail ?? '-'}",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 3.h),

              _buildMenuItem(
                icon: Icons.shopping_cart_outlined,
                title: "Orders",
                subtitle: "Check your order status",
                onTap: () => Get.toNamed(AppRoutes.orderHistory),
              ),
              _buildMenuItem(
                icon: Icons.card_giftcard,
                title: "Earn Rewards",
                subtitle: "Invite friends and earn rewards",
              ),
              _buildMenuItem(
                icon: Icons.phone_outlined,
                title: "Contact Us",
                subtitle: "Help regarding your recent purchase",
                onTap: () => Get.toNamed(AppRoutes.contact),
              ),
              _buildMenuItem(
                icon: Icons.location_on_outlined,
                title: "Saved Addresses",
                subtitle: "Manage your delivery addresses",
                onTap: () =>
                    Get.toNamed(AppRoutes.savedaddresses),
              ),

              _buildMenuItem(
                icon: Icons.description_outlined,
                title: "Terms & Conditions",
                subtitle: "",
                onTap: () {
                  _launchURL(
                    "https://www.termsfeed.com/blog/privacy-policy-url/",
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.policy_outlined,
                title: "Privacy Policy",
                subtitle: "",
                onTap: () {
                  _launchURL(
                    "https://www.termsfeed.com/blog/privacy-policy-url/",
                  );
                },
              ),
              _buildMenuItem(
                icon: Icons.store_outlined,
                title: "Seller Information",
                subtitle: "",
              ),
              _buildMenuItem(
                icon: Icons.lock_outline,
                title: "Account Privacy",
                subtitle: "",
              ),
              _buildMenuItem(
                icon: Icons.notifications_active_outlined,
                title: "Notification Preferences",
                subtitle: "",
              ),
              _buildMenuItem(
                icon: Icons.logout,
                title: "Logout",
                subtitle: "",
                onTap: () {
                  _showLogoutDialog(context);
                },
              ),

              SizedBox(height: 5.h),

              Center(
                child: Column(
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: GoogleFonts.nunito(fontSize: 20.sp),
                        children: [
                          TextSpan(
                            text: "CHAVAN ",
                            style: const TextStyle(color: AppColors.black),
                          ),
                          TextSpan(
                            text: "BROTHER'S",
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "GROUP OF JEEVAN AGRO",
                      style: GoogleFonts.nunito(
                        fontSize: 12.sp,
                        color: Colors.black,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      "v8.0.0.0",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            "Logout",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove(AppKeys.token);
                await prefs.remove(AppKeys.isLogin);
                await prefs.remove(AppKeys.user);
                print("👋 User logged out from AccountScreen");
                Get.offAllNamed(AppRoutes.login);
              },
              child: const Text(
                "Logout",
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    String? trailing,
    VoidCallback? onTap,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Padding(
            padding: EdgeInsets.only(left: 5.w),
            child: Icon(icon, color: AppColors.primary, size: 20.sp),
          ),
          title: Text(
            title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
          subtitle: subtitle.isNotEmpty
              ? Text(
                  subtitle,
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                )
              : null,
          trailing: trailing != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.monetization_on,
                      color: Colors.amber,
                      size: 14.sp,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      trailing,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              : Padding(
                  padding: EdgeInsets.only(right: 5.w),
                  child: Icon(
                    Icons.chevron_right,
                    color: AppColors.darkGrey,
                    size: 18.sp,
                  ),
                ),
          onTap: onTap,
        ),
        Divider(height: 1.h, thickness: 0.3, color: AppColors.grey),
      ],
    );
  }
}
