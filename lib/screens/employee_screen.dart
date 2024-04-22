import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';

class EmployeeScreen extends StatefulWidget {
  const EmployeeScreen({super.key});

  @override
  State<EmployeeScreen> createState() => _EmployeeScreenState();
}

class _EmployeeScreenState extends State<EmployeeScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Employee",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Form",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20, top: 30, right: 20),
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          children: [
            const Text(
              "Name",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(),
              ),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Age",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(),
              ),
              child: TextField(
                controller: ageController,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Location",
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(),
              ),
              child: TextField(
                controller: locationController,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                  onPressed: () async {
                    String Id = randomAlphaNumeric(10);
                    Map<String, dynamic> employeeInfoMap = {
                      "Name": nameController.text,
                      "Age": ageController.text,
                      "Id": Id,
                      "Location": locationController.text,
                    };
                    await DatabaseService().addEmployeeDetails(employeeInfoMap, Id).then((value) {
                      Fluttertoast.showToast(
                        msg: "Employee Details has been uploaded successfully.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    }).whenComplete(() {
                      nameController.clear();
                      ageController.clear();
                      locationController.clear();
                      Navigator.of(context).pop();
                    });
                  },
                  child: const Text(
                    "Add",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
