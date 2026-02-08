import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mapping_app/business__logic/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:mapping_app/constants/my_colors.dart';
import 'package:mapping_app/constants/strings.dart';
import 'package:url_launcher/url_launcher.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  Widget buildDrawerHeader(BuildContext context) {
    final phoneAuthCubit = context.read<PhoneAuthCubit>();

    return Column(
      children: [
        Container(
          padding: const EdgeInsetsDirectional.fromSTEB(70, 10, 70, 10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.blue[100],
          ),
          child: Image.asset(
            "assets/images/marwan.PNG",
            fit: BoxFit.cover,
            height: 120,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "Marwan Mahmoud",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          phoneAuthCubit.getLoggedUser().phoneNumber ?? "",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget buildDrawerListItem({
    required IconData leadingIcon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(leadingIcon, color: color ?? MyColors.blue),
      title: Text(title),
      trailing: trailing ?? const Icon(Icons.arrow_right, color: MyColors.blue),
      onTap: onTap,
    );
  }

  Widget buildDivider() {
    return const Divider(height: 0, thickness: 1, indent: 18, endIndent: 24);
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  Widget buildIcon(IconData icon, String url) {
    return InkWell(
      onTap: () => _launchURL(url),
      child: Icon(icon, color: MyColors.blue, size: 35),
    );
  }

  Widget buildSocialMediaIcons() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 16),
      child: Row(
        children: [
          buildIcon(
            FontAwesomeIcons.facebook,
            "https://web.facebook.com/marwan.elhoseny.77/",
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final phoneAuthCubit = context.read<PhoneAuthCubit>();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 280,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue[100]),
              child: buildDrawerHeader(context),
            ),
          ),

          buildDrawerListItem(leadingIcon: Icons.person, title: "My Profile"),
          buildDivider(),

          buildDrawerListItem(
            leadingIcon: Icons.history,
            title: "Places History",
            onTap: () {},
          ),
          buildDivider(),

          buildDrawerListItem(leadingIcon: Icons.settings, title: "Settings"),
          buildDivider(),

          buildDrawerListItem(leadingIcon: Icons.help, title: "Help"),
          buildDivider(),

          /// 🔥 Logout (الصحيح)
          buildDrawerListItem(
            leadingIcon: Icons.logout,
            title: "Logout",
            color: Colors.red,
            trailing: const SizedBox(),
            onTap: () async {
              await phoneAuthCubit.logOut();
              Navigator.of(context).pushReplacementNamed(loginScreen);
            },
          ),

          const SizedBox(height: 180),

          ListTile(
            leading: Text(
              "Follow us",
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          buildSocialMediaIcons(),
        ],
      ),
    );
  }
}
