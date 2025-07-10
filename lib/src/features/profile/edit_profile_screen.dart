import 'dart:io';
import 'package:donate_me_app/src/common_widgets/primary_button.dart';
import 'package:donate_me_app/src/common_widgets/snackbar_util.dart';
import 'package:donate_me_app/src/constants/constants.dart';
import 'package:donate_me_app/src/models/user_model.dart';
import 'package:donate_me_app/src/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _dobController;
  String gender = 'female';
  File? _selectedImage;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    // Get the provider instance
    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );

    // Initialize controllers with current user data
    _nameController = TextEditingController(
      text: authProvider.userModel?.name ?? '',
    );
    _phoneController = TextEditingController(
      text: authProvider.userModel?.phoneNumber ?? '',
    );
    _dobController = TextEditingController(
      text: authProvider.userModel?.dateOfBirth ?? '',
    );
    gender = authProvider.userModel?.gender ?? 'female';
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    try {
      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      String? imgUrl;

      final updatedUser = UserModel(
        id: authProvider.userModel!.id,
        name: _nameController.text,
        email: authProvider.userModel!.email,
        phoneNumber: _phoneController.text,
        dateOfBirth: _dobController.text,
        gender: gender,
        profileImgUrl: imgUrl ?? '',
      );

      await authProvider.updateUser(updatedUser);

      if (mounted) {
        SnackBarUtil.showSuccessSnackBar(
          context,
          'Profile updated successfully!',
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        SnackBarUtil.showErrorSnackBar(
          context,
          'Error updating profile: ${e.toString()}',
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedImage = await _picker.pickImage(source: source);
      if (pickedImage != null) {
        setState(() {
          _selectedImage = File(pickedImage.path);
        });
      }
    } catch (e) {
      SnackBarUtil.showErrorSnackBar(context, 'Failed to pick image: $e');
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => SizedBox(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Choose Image Source',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.photo_library, color: Colors.white),
                  label: const Text('Gallery'),
                  onPressed: () {
                    context.pop();
                    _pickImage(ImageSource.gallery);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt, color: Colors.white),
                  label: const Text('Camera'),
                  onPressed: () {
                    context.pop();
                    _pickImage(ImageSource.camera);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        forceMaterialTransparency: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: kPrimaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: kPrimaryColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Image
                  Center(
                    child: Stack(
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
                              image: _selectedImage != null
                                  ? FileImage(_selectedImage!)
                                  : (authProvider.userModel?.profileImgUrl !=
                                            null &&
                                        authProvider
                                            .userModel!
                                            .profileImgUrl!
                                            .isNotEmpty)
                                  ? NetworkImage(
                                      authProvider.userModel!.profileImgUrl!,
                                    )
                                  : const AssetImage(
                                      'assets/images/profile.png',
                                    ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: _showImageSourceDialog,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey.shade600,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Full Name
                  const Text(
                    'Full Name',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: kSecondaryColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Email
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  // Email (read-only)
                  const SizedBox(height: 8),
                  TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: authProvider.userModel!.email,
                    ),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Mobile Number
                  const Text(
                    'Mobile Number',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: kSecondaryColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Date of Birth
                  const Text(
                    'Date Of Birth',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FormBuilderDateTimePicker(
                    name: 'date_of_birth',
                    controller: _dobController,
                    inputType: InputType.date,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'DD/MM/YYYY',
                      fillColor: kSecondaryColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Gender
                  const Text(
                    'Gender',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Radio(
                        value: 'male',
                        groupValue: gender,
                        activeColor: kPrimaryColor,
                        onChanged: (value) {
                          setState(() {
                            gender = value.toString();
                          });
                        },
                      ),
                      const Text('Male', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 24),
                      Radio(
                        value: 'female',
                        groupValue: gender,
                        activeColor: kPrimaryColor,
                        onChanged: (value) {
                          setState(() {
                            gender = value.toString();
                          });
                        },
                      ),
                      const Text('Female', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: SizedBox(
                      width: size.width * 0.5,
                      child: PrimaryButton(
                        text: 'Save Changes',
                        press: _saveProfile,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
