import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intargram/resources/resources.dart';
import '../responsive/responsive.dart';
import '../untils/untils.dart';
import '../widgets/widgets.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;  
    });
  // signup user using our authmethodds
  String res = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!);
  // if string returned is sucess, user has been created
  if (res == "success") {
    setState(() {
      _isLoading = false;
    });
  // navigate to the home screen
  // ignore: use_build_context_synchronously
     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
       return const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          );
     }), (route) => false);
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      // ignore: use_build_context_synchronously
      showSnackbar(res,context);
    }
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              SvgPicture.asset(
                'assets/ic_blogger.svg',
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(
                height: 64,
              ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                          backgroundColor: Colors.grey,
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://i.stack.imgur.com/l60Hf.png'),
                          backgroundColor: Colors.grey,
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: CircleAvatar(
                      radius: 21,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 20,
                        child: IconButton(
                          onPressed: () {
                            selectImage();
                          },
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Mời bạn nhập tên',
                labelText: 'Họ và Tên',
                textInputType: TextInputType.text,
                textEditingController: _usernameController,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Mời bạn nhập email',
                labelText: 'Email',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Mời bạn nhập mật khẩu',
                labelText: 'Mật khẩu',
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
                isPass: true,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Mời bạn nhập giới thiệu',
                labelText: 'Giới thiệu',
                textInputType: TextInputType.text,
                textEditingController: _bioController,
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: signUpUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                      gradient: kPrimaryGradientLeftToRightColor,
                      border: Border.all(color: Colors.black12, width: 1),
                      borderRadius: BorderRadius.circular(10)),
                  child: !_isLoading
                      ? const Text(
                          'Đăng kí tài khoản',
                        )
                      : const CircularProgressIndicator(
                          color: primaryColor,
                        ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      'Bạn đã có tài khoản',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        ' Đăng nhập.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
