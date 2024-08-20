import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:redirect_icon/redirect_icon.dart';

class ProfileScreen extends StatelessWidget {
  static const routeName = '/profile';

  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: GestureDetector(
                  onDoubleTap: () {
                    {
                      const SnackBar(content: Text('Mr. Robot is hacking your smartphone right now.'));
                    }
                  },
                  child: const CircleAvatar(
                    backgroundImage: ExactAssetImage('assets/myPhoto.jpg'),
                    radius: 80,
                  ),
                ),
              ),
              const Text(
                'Abd El Rahman Mohamed',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25
                ),
              ),
              const Text(
                'Flutter Developer',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const Text(
                'Follow me on:',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: RedirectSocialIcon(
                          url: "https://www.facebook.com/AbdElRahamnMohamed2000/",
                          icon: FontAwesomeIcons.facebook,
                          radius: 25,
                          size: 35,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: RedirectSocialIcon(
                          url: "https://twitter.com/Abdelrahman5T",
                          icon: FontAwesomeIcons.xTwitter,
                          radius: 25,
                          size: 35,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: RedirectSocialIcon(
                          url: "https://www.instagram.com/abd_el_rahman.mohammed.3152/",
                          icon: FontAwesomeIcons.instagram,
                          radius: 25,
                          size: 35
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
