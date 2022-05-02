// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:skin_cancer_detector/screens/cancer_prevention_screen.dart';
import 'package:skin_cancer_detector/screens/cancer_types_screen.dart';
import 'package:skin_cancer_detector/screens/tensorflow_screen.dart';

import '../components/app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: WillPopScope(
        onWillPop: () => showExitPopUp(context),
        child: Scaffold(
          appBar: CustomAppBar(height: 150),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Wrap(
                runSpacing: 30,
                spacing: 40,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CancerTypesScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: height / 9,
                      width: width / 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.purple,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.sick,
                            color: Colors.white,
                          ),
                          const Flexible(
                            child: Text(
                              "Skin Cancer Types",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CancerPrevention(),
                        ),
                      );
                    },
                    child: Container(
                      height: height / 9,
                      width: width / 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.purple,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.health_and_safety,
                              color: Colors.white),
                          const Flexible(
                            child: Text(
                              "Skin Cancer \nPrevantion",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TensorFlowScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: height / 9,
                      width: width / 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.purple,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.settings_overscan,
                            color: Colors.white,
                          ),
                          const Flexible(
                            child: Text(
                              "Scan Skin",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 15.0),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> showExitPopUp(BuildContext context) async {
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
                    primary: Colors.purple, shadowColor: Colors.purple),
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
