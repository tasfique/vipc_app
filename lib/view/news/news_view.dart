// If the role is manager, there should be one more button 'monitor' in the middle.

import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/view/appbar/appbar_view.dart';
import 'package:vipc_app/view/drawer/drawer_view.dart';
import 'package:vipc_app/controller/news/news_controller.dart';

class NewsView extends StatefulWidget {
  NewsView({key}) : super(key: key);

  @override
  _NewsViewState createState() => _NewsViewState();
}

class _NewsViewState extends StateMVC {
  _NewsViewState() : super(NewsController()) {
    _con = NewsController.con;
  }

  NewsController _con;

  @override
  Widget build(BuildContext context) {
    final List<Card> cards = [
      Card(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                title: Text(
                  'CMCO starts from October',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'KUALA LUMPUR (Oct 12): The government has agreed to enforce Conditional Movement Control (CMCO) in Selangor, Kuala Lumpur and Putrajaya effective from 12.01am on Oct 14 to Oct 27, said Senior Minister (Security Cluster) Datuk Seri Ismail Sabri Yaakob.',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const SizedBox(width: 8),
                  FlatButton(
                    child: const Text('Read more...'),
                    onPressed: () {/* ... */},
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
      ),
      Card(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                title: Text(
                  'Crowds throng the iconic Penang ferries as service draws to a close today',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'GEORGE TOWN, Dec 31 — Over the past week, there were long queues to board the Penang ferry at both the Raja Tun Uda Terminal on the island and the Sultan Abdul Halim Terminal on the mainland. Cars lined Weld Quay from early morning to late evening as Penangites and visitors rushed to take the ferry for the last time today. Penang\'s iconic ferries that take foot passengers and cars are on their last day of service today before foot passengers are diverted to the Swettenham Pier Cruise Terminal to take the fast boats to cross the channel. There will no longer be any ferries to take four-wheeled vehicles across the channel between the island and mainland after today.',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const SizedBox(width: 8),
                  FlatButton(
                    child: const Text('Read more...'),
                    onPressed: () {/* ... */},
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
      ),
      Card(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                title: Text(
                  'For 2021 New Year’s wish, Selangor MB looks to ‘unicorn’ firms to drive state economy',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'KUALA LUMPUR, Dec 31 — Selangor is betting large on the digital economy to drive the state economy and is expected to pour huge amounts of money into potential industries like financial technology next year, Mentri Besar Datuk Seri Amirudin Shari said today. The country’s richest state by per capita income has channelled a huge chunk of its budget into a fund set up to help identify and nurture startup firms as it seeks to become the hub for unicorn companies, Amirudin said in a new year’s eve address issued earlier this evening.',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const SizedBox(width: 8),
                  FlatButton(
                    child: const Text('Read more...'),
                    onPressed: () {/* ... */},
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
      ),
      Card(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                title: Text(
                  '‘Bloodstains’ found after Wildlife Dept seized two more gibbons amid court dispute, gibbon rehab centre claims',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'KUALA LUMPUR, Dec 31 — Stains resembling blood were sighted after the Wildlife and National Parks Department (Perhilitan) captured and removed two gibbons in a second raid today at the Gibbon Rehabilitation Project (GReP) in Pahang, the Gibbon Conservation Society (GCS) running the rehab centre said. Just two days ago, on December 29, Perhilitan was reported to have forcibly removed four out of six gibbons undergoing rehabilitation at GReP, despite an ongoing and still unsettled court dispute on whether Perhilitan or its former employee Mariani Ramli — GReP founder and GCS president — should be the ones caring for the six gibbons.',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const SizedBox(width: 8),
                  FlatButton(
                    child: const Text('Read more...'),
                    onPressed: () {/* ... */},
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
      ),
      Card(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                title: Text(
                  'Employers asked to remit mandatory EPF contribution on the 15th of every month',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                subtitle: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'KUALA LUMPUR, Dec 30 ― Employees Provident Fund (EPF) has instructed employers to remit their mandatory EPF contribution on the 15th of every month, starting January next year. In a statement today, EPF said this is in line with the original contribution payment date determined by them. Previously, the EPF provided an extension for contribution payment from the 15th to the 30th of every month from April until December 2020, to ease the burden of employers in light of the uncertainties surrounding the Covid-19 pandemic.',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const SizedBox(width: 8),
                  FlatButton(
                    child: const Text('Read more...'),
                    onPressed: () {/* ... */},
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
      ),
    ];
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: cards.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 25),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "VIPC News",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Container(
                      alignment: Alignment.center,
                      child: cards[index],
                    ),
                  ),
                ],
              );
            } else {
              return Padding(
                padding: EdgeInsets.only(top: 15),
                child: Container(
                  alignment: Alignment.center,
                  child: cards[index],
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: Icon(
          Icons.add,
          size: 35,
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
