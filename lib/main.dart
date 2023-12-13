import 'dart:io';
import 'package:contact_book/contect_add.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:path_provider/path_provider.dart';
import 'contect_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  Hive.registerAdapter(ContectDataAdapter());

  await Hive.openBox("Contect");
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: contect_list(),
  ));
}

class contect_list extends StatefulWidget {
  const contect_list({super.key});

  static var contect = Hive.box("Contect");

  @override
  State<contect_list> createState() => _contect_listState();
}

class _contect_listState extends State<contect_list> {
  List found_user = [];
  List User = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (int i = 0; i < contect_list.contect.length; i++) {
      Contect_Data cd = contect_list.contect.getAt(i);
      found_user.addAll([
        {
          "name": cd.name,
          "contect": cd.contect,
          "email": cd.email,
          "gender": cd.gender,
          "image": cd.cropImage,
          "password": cd.password,
        }
      ]);
      User = found_user;
    }
  }

  Search(String keyword) {
    var result;
    if (keyword.isEmpty) {
      result = found_user;
    } else {
      result = found_user
          .where((user) => user["name"]
              .toString()
              .toLowerCase()
              .contains(keyword.toLowerCase()))
          .toList();
    }
    setState(() {
      User = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: SafeArea(child: (found_user.isEmpty)
              ? Center(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(
                              "pic/corporate-business-communication-business-team-big-smartphone-business-people-trendy-vector_985641-305-removebg-preview.png")),
                    ),
                  ),
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      color: Colors.white54,
                      shape: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(
                            MediaQuery.of(context).size.height * 0.05),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.95,
                        height: MediaQuery.of(context).size.height * 0.067,
                        decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(
                              MediaQuery.of(context).size.height * 0.05),
                        ),
                        child: TextField(
                          onChanged: (value) {},
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.black87,
                                  size: 30,
                                ),
                              ),
                              hintText: "Search Contects",
                              hintStyle: TextStyle(color: Colors.black54),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(
                                      MediaQuery.of(context).size.height *
                                          0.05))),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                        child: ListView.builder(
                      itemCount: User.length,
                      itemBuilder: (context, index) {
                        Contect_Data cd = contect_list.contect.getAt(index);
                        return Slidable(
                          startActionPane:
                              ActionPane(motion: ScrollMotion(), children: [
                            SlidableAction(
                              onPressed: (context) {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return contect_add(cd);
                                  },
                                ));
                              },
                              backgroundColor: Colors.green,
                              icon: Icons.edit,
                            ),
                          ]),
                          endActionPane:
                              ActionPane(motion: ScrollMotion(), children: [
                            SlidableAction(
                              onPressed: (context) {
                                contect_list.contect.deleteAt(index);
                                User.removeAt(index);
                                setState(() {});
                              },
                              backgroundColor: Colors.red,
                              icon: Icons.delete,
                            ),
                          ]),
                          child: ListTile(
                            leading: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: (User[index]["image"] != null)
                                    ? DecorationImage(
                                        image: FileImage(
                                            File(User[index]["image"])))
                                    : null,
                              ),
                              child: (User[index]["image"] == "null")
                                  ? Icon(
                                      Icons.account_circle,
                                      color: Colors.grey,
                                      size: 50,
                                    )
                                  : Text(""),
                            ),
                            title: Text("${User[index]["name"]}",style: TextStyle(fontSize: 20,color: Colors.black),),
                            subtitle: Text("+91 ${found_user[index]["contect"]}",style: TextStyle(color: Colors.black),),
                          ),
                        );
                      },
                    )),
                  ],
                ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black,
            isExtended: true,
            elevation: 10,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return contect_add();
              },));
          },
            child: Icon(
              Icons.add,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
