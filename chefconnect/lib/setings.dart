import 'package:chefconnect/about.dart';
import 'package:chefconnect/calendar.dart';
import 'package:chefconnect/help.dart';
import 'package:chefconnect/khedmet%20salma/ChatHome.dart';
import 'package:chefconnect/khedmet%20salma/ChatScreen.dart';
import 'package:chefconnect/notification.dart';
import 'package:chefconnect/signout';

import 'package:flutter/material.dart';
import 'people.dart'; // Import the necessary pages
import 'securite.dart';

import 'edit.dart';

class SettingsPage2 extends StatefulWidget {
  const SettingsPage2({Key? key}) : super(key: key);

  @override
  State<SettingsPage2> createState() => _SettingsPage2State();
}


class _SettingsPage2State extends State<SettingsPage2> {
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDark ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
          backgroundColor: const Color.fromARGB(255, 244, 206, 54),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: ListView(
              children: [
                _SingleSection(
                  title: "General",
                  children: [
                    _CustomListTile(
                      title: "Dark Mode",
                      icon: Icons.dark_mode_outlined,
                      trailing: Switch(
                        value: _isDark,
                        onChanged: (value) {
                          setState(() {
                            _isDark = value;
                          });
                        },
                      ),
                    ),
                     _CustomListTile(
                      title: "Notifications",
                      icon: Icons.notifications_none_rounded,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NotificationsPage()),
                        );
                      },
                    ),
                    _CustomListTile(
                      title: "Security Status",
                      icon: Icons.lock,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SecurityPage()),
                        );
                      },
                    ),
                  ],
                ),
                const Divider(),
                _SingleSection(
                  title: "Organization",
                  children: [
                    _CustomListTile(
                      title: "Profile",
                      icon: Icons.person_outline_rounded,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProfileEditPage()),
                        );
                      },
                    ),
                    _CustomListTile(
                      title: "Messaging",
                      icon: Icons.message_outlined,
                       onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ChatHome()),
                        );
                      },

                    ),
                    _CustomListTile(
                      title: "Calling",
                      icon: Icons.phone_outlined,
                    ),
                    _CustomListTile(
                      title: "People",
                      icon: Icons.contacts_outlined,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HeroListPage()),
                        );
                      },
                    ),
                    _CustomListTile(
                      title: "Calendar",
                      icon: Icons.calendar_today_rounded,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CalendarPage()),
                        );
                      },
                    ),
                  ],
                ),
                const Divider(),
                _SingleSection(
                  children: [
                    _CustomListTile(
                      title: "Help & Feedback",
                      icon: Icons.help_outline_rounded,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HelpPage()),
                        );
                      },
                    ),
                    _CustomListTile(
                      title: "About",
                      icon: Icons.info_outline_rounded,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AboutPage()),
                        );
                      },
                    ),
                    _CustomListTile(
                      title: "Sign out",
                      icon: Icons.exit_to_app_rounded,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignOutPage()),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  final Function()? onTap;

  const _CustomListTile({
    Key? key,
    required this.title,
    required this.icon,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const _SingleSection({
    Key? key,
    this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Column(
          children: children,
        ),
      ],
    );
  }
}
