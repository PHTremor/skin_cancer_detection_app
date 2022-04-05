import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

import '../components/app_bar.dart';

class TensorFlowScreen extends StatefulWidget {
  const TensorFlowScreen({Key? key}) : super(key: key);

  @override
  State<TensorFlowScreen> createState() => _TensorFlowScreenState();
}

class _TensorFlowScreenState extends State<TensorFlowScreen> {
  List? _outputs;
  File? _image;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _isLoading = true;

    loadModel().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitPopUp,
      child: Scaffold(
        appBar: CustomAppBar(height: 150),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            !_isLoading
                ? isNotLoaded()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _image == null
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height / 2,
                                padding: const EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  image: DecorationImage(
                                      image: FileImage(_image!),
                                      fit: BoxFit.fill),
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      _image == null
                          ? Container()
                          : _outputs != null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height /
                                                8,
                                        padding: const EdgeInsets.all(20.0),
                                        decoration: const BoxDecoration(
                                          color: Colors.purple,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                        ),
                                        child: Text(
                                          "Cancer Type: ${_outputs![0]["label"]}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0),
                                        ),
                                      ),
                                    ),
                                    // Text(
                                    //   "confidence : ${_outputs![0]["confidence"]}",
                                    //   style: const TextStyle(
                                    //       color: Colors.black, fontSize: 20.0),
                                    // ),
                                    const SizedBox(height: 10),
                                    addPhotoButtons(),
                                  ],
                                )
                              : Container(
                                  child: const Text(""),
                                )
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget isNotLoaded() {
    return Expanded(
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 1,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: SvgPicture.asset("assets/images/empty_image.svg"),
              ),
            ),
            const Text(
              "Upload an Image from the Camera or Gallery",
              style: TextStyle(fontSize: 15),
            ),
            addPhotoButtons()
          ],
        ),
      ),
    );
  }

  Widget addPhotoButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 60.0,
          child: ElevatedButton(
              onPressed: pickCameraImage,
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  minimumSize: const Size(88, 36),
                  primary: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2.0)))),
              child: Row(
                children: const [Icon(Icons.add_a_photo, color: Colors.purple)],
              )),
        ),
        const SizedBox(width: 10.0),
        SizedBox(
          width: 60.0,
          child: ElevatedButton(
              onPressed: pickGalleryImage,
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  minimumSize: const Size(88, 36),
                  primary: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2.0)))),
              child: Row(
                children: const [
                  Icon(Icons.photo_library_outlined, color: Colors.purple)
                ],
              )),
        ),
      ],
    );
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/sample_tffiles/model_unquant.tflite",
        labels: "assets/sample_tffiles/labels.txt",
        numThreads: 1);
  }

  Future classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 2,
        threshold: 0.2,
        asynch: true);

    setState(() {
      _isLoading = true;
      _outputs = output!;
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  pickGalleryImage() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _isLoading = true;
      _image = File(image.path);
    });
    await classifyImage(_image!);
  }

  pickCameraImage() async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _isLoading = true;
      _image = File(image.path);
    });
    await classifyImage(_image!);
  }

  Future<bool> showExitPopUp() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Do you want to exit the App?'),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.green, shadowColor: Colors.purple),
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: const Text('No'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.grey, shadowColor: Colors.purple),
                onPressed: () => Navigator.of(context).pop(true),
                //return true when click on "Yes"
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }
}
