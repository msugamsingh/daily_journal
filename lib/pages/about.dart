import 'package:flutter/material.dart';
import 'package:koukicons/takeNote2.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  static const String id = 'about';

  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(height: 10),
              Container(
                width: 200,
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.grey[300]
                                  : Color(0xFF242634),
                          offset: Offset(4, 4),
                          blurRadius: 20,
                          spreadRadius: 2),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Center(
                    child: KoukiconsTakeNote2(height: 150, width: 150),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Forol Daily Journal',
                style: TextStyle(fontFamily: 'pac', fontSize: 18),
              ),
              Text(
                'Notes & Tasks',
                style: TextStyle(
                    fontFamily: 'pac',
                    fontSize: 16,
                    fontWeight: FontWeight.w100),
              ),
              Text(
                'Version: 0.0.1',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w100
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 38),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: [
                        BoxShadow(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.grey[300]
                                    : Color(0xFF242634),
                            offset: Offset(4, 4),
                            blurRadius: 20,
                            spreadRadius: 2)
                      ],
                      image: DecorationImage(
                        image: AssetImage('assets/images/namecarddes.png'),
                        fit: BoxFit.cover,
                      )),
                  child: ListTile(
                    dense: true,
                    leading: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/images/myavatar.png'),
                      backgroundColor:
                          Theme.of(context).brightness == Brightness.light
                              ? Colors.grey[300]
                              : Color(0xFF242634),
                    ),
                    title: Text(
                      'Sugam Singh',
                    ),
                    subtitle: Text(
                      'Android & iOS Developer',
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.mail_outline),
                      onPressed: () {
                        launchUrl('mailto:singhsugam065@gmail.com');
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              Container(
                alignment: Alignment.bottomCenter,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        launchUrl('https://www.instagram.com/msugamsingh');
                      },
                      child: Image.asset(
                        'assets/images/kwsf.png',
                        height: 75,
                        width: 75,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        launchUrl('https://www.instagram.com/msugamsingh');
                      },
                      child: Image.asset(
                        'assets/images/kwsi.png',
                        height: 75,
                        width: 75,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        launchUrl('https://www.twitter.com/MSugamSingh');
                      },
                      child: Image.asset(
                        'assets/images/kwst.png',
                        height: 75,
                        width: 75,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Made with ❤️ by Sugam Singh',
                style: TextStyle(fontFamily: 'pac', fontSize: 18),
              ),
              SizedBox(height: 10),
            ],
          ),
        ],
      ),
    );
  }

  launchUrl(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'could not open';
    }
  }
}
