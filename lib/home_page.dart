import 'package:BasswoodChurch/navigationDrawer/NavigationDrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'brc_days_list.dart';
import 'util.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key, this.title,}) : super(key: key);

  final String title;
  

  void _onItemTapped(int index) {
    if (index == 1) {
      launchURL('https://www.basswoodchurch.net/sermons/');
      // } else if (index == 2) {
      //   _launchURL('https://www.basswoodchurch.net/give');
    } else if (index == 2) {
      launchURL('https://www.basswoodchurch.net/bulletin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to the Feast'),
      ),
      body: FutureBuilder<List<BrcDay>>(
          future: fetchBrcDays(http.Client()),
          builder:
              (BuildContext context, AsyncSnapshot<List<BrcDay>> snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }

            return snapshot.hasData
                ? BrcDaysList(brcDays: snapshot.data)
                : const Center(child: CircularProgressIndicator());
          }),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            title: Text('Reading'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.headset),
            title: Text('Sermons'),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.card_giftcard),
          //   title: Text('Giving'),
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.picture_as_pdf),
            title: Text('Bulletin'),
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.blueGrey,
        onTap: _onItemTapped,
      ),
      drawer: NavigationDrawer(),
    );
  }
}
