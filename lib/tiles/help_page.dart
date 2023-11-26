import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import '../blocs/select_page_bloc.dart';
import '../events/select_page_events.dart';

class HelpPage extends StatelessWidget {
  HelpPage({
    Key? key,
  }) : super(key: key);

  void refresh(BuildContext context) {
    context.read<SelectPageBloc>().add(SelectPage().setData("custom"));
  }

  @override
  Widget build(BuildContext context) {

    Text bannerText = Text(
      "Programmers lives matter",
      textAlign: TextAlign.center,
      style: TextStyle(
          color: Colors.blue.shade900, fontWeight: FontWeight.w800, fontSize: 42,
        shadows: const [
          Shadow(
            offset: Offset(2.0, 2.0),
            blurRadius: 3.0,
            color: Colors.white60,
          ),
        ],
      ),
    );

    final visitButtonLinkedIn = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: const Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
        onPressed: () {
          visitLinkedIn(context);
        },
        child: const Text("Visit LinkedIn",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
    );

    final visitButtonToit = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: const Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
        onPressed: () {
          visitLinkedToitIo(context);
        },
        child: const Text("Visit Toit.io",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
    );

    Container helpPage = Container(
        color: Colors.grey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                bannerText,
                const SizedBox(height: 48.0),
                SizedBox(
                  height: 196.0,
                  child: Image.asset(
                    "assets/help.png",
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 96.0),
                visitButtonLinkedIn,
                const SizedBox(height: 16.0),
                //ApplicationHolder.holder()!.isLogged() ?
                visitButtonToit
                //    :
                //const SizedBox(height: 16.0,
                //),
              ],
            ),
          ),
        ));




    return Scaffold(
      body: helpPage,

      // body: Listener(
      //   onPointerDown: (e) {},
      //   onPointerMove: (e) {},
      //   onPointerUp: (e) {
      //     // print ("SimpleTile.Up");
      //     // refresh(context);
      //   },
      //   onPointerCancel: (e) {},
      //   child:
      //
      //   BlocBuilder<SelectPageBloc, SelectState>(builder: (ctx, state) {
      //
      //     return Center(
      //
      //       child: Icon(
      //           icon,
      //           size: min<double>(width.toDouble(), height.toDouble()) * 3 / 5,
      //           color: Colors.deepOrange//getColor(state.data()),
      //       ),
      //     );
      //   }),
      // ),




    );
  }
}

void visitLinkedIn(BuildContext context) {
  _launchURL(context, 'https://www.linkedin.com/in/michael-kanzieper-52931612/');
}

void visitLinkedToitIo(BuildContext context) {
  _launchURL(context, 'http://toit.io');
}

Future<void> _launchURL(BuildContext context, String link) async {
  final theme = Theme.of(context);
  try {
    await launch(
      //'https://flutter.dev',
      //'https://www.linkedin.com/in/michael-kanzieper-52931612/',
      link,
      customTabsOption: CustomTabsOption(
        toolbarColor: theme.primaryColor,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        animation: CustomTabsSystemAnimation.slideIn(),
        extraCustomTabs: const <String>[
          // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
          'org.mozilla.firefox',
          // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
          'com.microsoft.emmx',
        ],
      ),
      safariVCOption: SafariViewControllerOption(
        preferredBarTintColor: theme.primaryColor,
        preferredControlTintColor: Colors.white,
        barCollapsingEnabled: true,
        entersReaderIfAvailable: false,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
  } catch (e) {
    // An exception is thrown if browser app is not installed on Android device.
    debugPrint(e.toString());
  }
}

