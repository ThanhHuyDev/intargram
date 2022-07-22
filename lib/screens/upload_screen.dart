import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intargram/resources/resources.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../untils/untils.dart';
import '../widgets/widgets.dart';

class UploadPostScreen extends StatefulWidget {
  const UploadPostScreen({Key? key}) : super(key: key);

  @override
  State<UploadPostScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<UploadPostScreen> {
  Uint8List? _file;
  bool _isLoading = false;
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _file = im;
    });
  }

  void selectCamera() async {
    Uint8List im = await pickImage(ImageSource.camera);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _file = im;
    });
  }

  void postImage(
    String uid,
    String username,
    String profImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          _descriptionController.text, _file!, uid, username, profImage);
      if (res == 'success') {
        setState(() {
          _isLoading = false;
        });
        // ignore: use_build_context_synchronously
        showSnackbar('Đăng bài thành công', context);
        clearImage();
      } else {
        // ignore: use_build_context_synchronously
        showSnackbar(res, context);
      }
    } catch (e) {
      showSnackbar(e.toString(), context);
    }
  }
  void clearImage(){
    setState(() {
      _file = null;
      _descriptionController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            var dialog = CustomAlertDialog(
                  message: "Chưa tạo bài đăng xong. Thoát khỏi trang này?",
                  onPostivePressed: () {},
                  positiveBtnText: 'Thoát',
                  negativeBtnText: 'Ở lại');
              showDialog(
                  context: context, builder: (BuildContext context) => dialog);
          },
        ),
        title: const Text(
          'Tạo Bài Viết',
        ),
        centerTitle: true,
        actions: <Widget>[
          TextButton(
            onPressed: () => postImage(
              userProvider.getUser.uid,
              userProvider.getUser.username,
              userProvider.getUser.imageAvatar,
            ),
            child: Container(
              width: 70,
              padding: const EdgeInsets.only(bottom: 2, left: 3),
              margin: const EdgeInsets.only(top: 2, bottom: 2, right: 2),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  borderRadius: BorderRadius.circular(9)),
              child: const Center(
                  child: Text(
                'Đăng',
                style: TextStyle(fontSize: 17),
              )),
            ),
          )
        ],
      ),
      // POST FORM
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _isLoading
                      ? const LinearProgressIndicator()
                      : const Padding(padding: EdgeInsets.only(top: 0.0)),
                  const Divider(),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 30, right: 10),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(
                            userProvider.getUser.imageAvatar,
                          ),
                        ),
                      ),
                      Text(
                        userProvider.getUser.username,
                        style: const TextStyle(fontSize: 17),
                      )
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextField(
                      autofocus: true,
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 10, right: 10, top: 20),
                          hintText: "Bạn đang nghỉ gì ?",
                          border: InputBorder.none),
                      minLines: 1,
                      maxLines: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: AspectRatio(
                      aspectRatio: 487 / 451,
                      child: _file != null
                          ? Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                fit: BoxFit.fill,
                                alignment: FractionalOffset.topCenter,
                                image: MemoryImage(_file!),
                              )),
                            )
                          : Container(),
                    ),
                  ),
                  const Divider(),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.7),
                            blurRadius: 7,
                            spreadRadius: 2,
                            offset: const Offset(2, 2)),
                      ],
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          selectCamera();
                        },
                        child: SvgPicture.asset('assets/icons/ic_camera.svg',
                            height: 25, color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () {
                          selectImage();
                        },
                        child: SvgPicture.asset(
                          'assets/icons/ic_image.svg',
                          height: 30,
                          color: Colors.grey,
                        ),
                      ),
                      SvgPicture.asset('assets/icons/ic_user.svg',
                          height: 25, color: Colors.grey),
                      SvgPicture.asset('assets/icons/ic_location.svg',
                          color: Colors.grey, height: 25),
                      SvgPicture.asset('assets/icons/ic_mess.svg',
                          height: 25, color: Colors.grey),
                    ],
                  ))),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Divider(height: 0.1, color: Colors.grey),
          )
        ],
      ),
    );
  }
}
