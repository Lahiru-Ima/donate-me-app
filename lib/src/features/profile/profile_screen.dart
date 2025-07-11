import 'package:donate_me_app/src/common_widgets/safe_auth_actions.dart';
import 'package:donate_me_app/src/constants/constants.dart';
import 'package:donate_me_app/src/providers/auth_provider.dart';
import 'package:donate_me_app/src/router/router_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      if (authProvider.userModel == null) {
        authProvider.loadUser();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        forceMaterialTransparency: true,

        automaticallyImplyLeading: false,

        title: const Text(
          'My Profile',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              context.push(RouterNames.editProfile);
            },
          ),
        ],
      ),
      body: authProvider.userModel == null
          ? const Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Profile Image and Name
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey.shade300,
                              width: 2,
                            ),
                            image: DecorationImage(
                              image:
                                  authProvider.userModel?.profileImgUrl != null
                                  ? NetworkImage(
                                      authProvider.userModel!.profileImgUrl!,
                                    )
                                  : const AssetImage(
                                          'assets/images/profile.png',
                                        )
                                        as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          authProvider.userModel?.name ?? 'User Name',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ROLE',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Profile Tabs
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 24,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildTabItem(Icons.person_outline, 'Profile', () {}),
                        _buildTabItem(
                          Icons.post_add_outlined,
                          'My Posts',
                          () => _showCreatePostDialog(),
                        ),
                        _buildTabItem(
                          Icons.account_balance_wallet_outlined,
                          'Wallet',
                          () {},
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Menu Items
                  _buildMenuItem(
                    Icons.post_add_outlined,
                    'My Posts',
                    () => _showCreatePostDialog(),
                  ),
                  _buildMenuItem(
                    Icons.privacy_tip_outlined,
                    'Privacy Policy',
                    () {},
                  ),
                  _buildMenuItem(
                    Icons.payment_outlined,
                    'Payment Methods',
                    () {},
                  ),
                  _buildMenuItem(
                    Icons.notifications_outlined,
                    'Notification',
                    () {},
                  ),
                  _buildMenuItem(Icons.settings_outlined, 'Settings', () {
                    context.push(RouterNames.settings);
                  }),
                  _buildMenuItem(Icons.help_outline, 'Help', () {}),
                  _buildMenuItem(Icons.logout, 'Logout', () {
                    _logout(context);
                  }),

                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  void _logout(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              const Text('Are you sure you want to logout?'),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kSecondaryColor,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () async {
                      Navigator.pop(context); // Close dialog first
                      await SafeAuthActions.signOut(context);
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCreatePostDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Create Donation Request',
            style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCreatePostOption(
                context,
                'Blood',
                Icons.bloodtype,
                kBloodColor,
                'Request blood donation',
                () => context.push(RouterNames.createBloodPost),
              ),
              const SizedBox(height: 12),
              _buildCreatePostOption(
                context,
                'Hair',
                Icons.content_cut,
                Colors.brown,
                'Request hair donation',
                () => context.push(RouterNames.createHairPost),
              ),
              const SizedBox(height: 12),
              _buildCreatePostOption(
                context,
                'Kidney',
                Icons.favorite,
                Colors.green,
                'Request kidney donation',
                () => context.push(RouterNames.createKidneyPost),
              ),
              const SizedBox(height: 12),
              _buildCreatePostOption(
                context,
                'Fund',
                Icons.attach_money,
                Colors.orange,
                'Request financial assistance',
                () => context.push(RouterNames.createFundPost),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCreatePostOption(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String subtitle,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: () {
        Navigator.pop(context); // Close dialog first
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(IconData icon, String label, Function()? onpressed) {
    return Column(
      children: [
        InkWell(
          onTap: onpressed,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: kPrimaryColor, size: 22),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, Function()? onpressed) {
    return InkWell(
      onTap: onpressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                blurRadius: 1,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
