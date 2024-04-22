import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/employee_screen.dart';
import 'package:flutter_firebase/services/database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Stream? EmployeeStream;
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  getontheload() async {
    EmployeeStream = await DatabaseService().getEmployeeDetails();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }

  Future EditEmployeeDetail(String id) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(Icons.cancel),
                    ),
                    const SizedBox(width: 60),
                    const Text(
                      "Edit",
                      style: TextStyle(fontSize: 24, color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Details",
                      style: TextStyle(fontSize: 24, color: Colors.orange, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic> updateInfo = {
                            "Name": nameController.text,
                            "Age": ageController.text,
                            "Id": id,
                            "Location": locationController.text,
                          };
                          await DatabaseService().updateEmployeeDetail(id, updateInfo).then((value) {
                            Navigator.of(context).pop();
                          });
                        },
                        child: const Text("Update"))),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return const EmployeeScreen();
            },
          ));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Flutter",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Firebase",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
      body: allEmployeeDetails(),
    );
  }

  Widget allEmployeeDetails() {
    return StreamBuilder(
      stream: EmployeeStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
                    child: Column(
                      children: [
                        Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Name : ${ds["Name"]}",
                                      style: const TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            nameController.text = ds["Name"];
                                            ageController.text = ds["Age"];
                                            locationController.text = ds["Location"];
                                            EditEmployeeDetail(ds['Id']);
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.orange,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            DatabaseService().deleteEmployeeDetail(ds["Id"]);
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                                Text(
                                  "Age : ${ds["Age"]}",
                                  style: const TextStyle(color: Colors.orange, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Location : ${ds["Location"]}",
                                  style: const TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              )
            : Container();
      },
    );
  }
}
