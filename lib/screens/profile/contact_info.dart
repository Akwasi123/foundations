import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import '../../env.dart';
import '../../models/user_model.dart';
import '../../widgets/custom_button.dart';
import 'package:http/http.dart' as http;

class ContactInformation extends StatefulWidget {
  const ContactInformation({Key? key}) : super(key: key);

  @override
  State<ContactInformation> createState() => _ContactInformationState();
}

class _ContactInformationState extends State<ContactInformation> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _phonecontroller = TextEditingController();

  String? uid;

  bool isLoading = false;

  // function check if user is logged in
  Future _isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getString("uid");
    });

    // print(uid);
  }

  // User object to use throughout page
  User? user;

  // get user details
  Future _getUserDetails() async {
    var url = Uri.parse("${Env.URL_PREFIX_USERS}/read_single.php?id=$uid");
    var response = await http.get(
      url,
      headers: {"Accept": "application/json"},
    );

    var res = jsonDecode(response.body);

    // get user in user object
    Map<String, dynamic> userMap = res;
    User userObj = User.fromJson(userMap);

    // print(user.email);
    setState(() {
      user = userObj;
    });

    // print(user!.email);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isLoggedIn().whenComplete(() {
      _getUserDetails().whenComplete(() {
        _emailcontroller.text = user!.email!;
        _phonecontroller.text = user!.phone!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: kDefaultBackground,
        ),
        title: const Text(
          'Contact Information',
          style: TextStyle(color: kDefaultBackground),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: TextFormField(
                  controller: _emailcontroller,
                  decoration: InputDecoration(
                    label: const Text('Email'),
                    labelStyle: TextStyle(color: inactiveColor),
                    hintText: 'Email',
                    hintStyle: TextStyle(
                      color: inactiveColor,
                      fontWeight: FontWeight.w600,
                    ),
                    prefixIcon: Icon(
                      Icons.email,
                      color: inactiveColor.withOpacity(0.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: inactiveColor),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: inactiveColor),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kDarkTextColor.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: TextFormField(
                  controller: _phonecontroller,
                  decoration: InputDecoration(
                    label: const Text('Phone Number'),
                    labelStyle: TextStyle(color: inactiveColor),
                    hintText: 'Phone Number',
                    hintStyle: TextStyle(
                      color: inactiveColor,
                      fontWeight: FontWeight.w600,
                    ),
                    prefixIcon: Icon(
                      Icons.phone,
                      color: inactiveColor.withOpacity(0.2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: inactiveColor),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: inactiveColor),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: kDarkTextColor.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ),
              // Spacer(),
              // Spacer(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: CustomButton(
            onPressed: () {}, btnName: 'Update Contact Information'),
      ),
    );
  }
}
