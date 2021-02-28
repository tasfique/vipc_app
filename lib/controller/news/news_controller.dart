import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:vipc_app/model/user_list.dart';

class NewsController extends ControllerMVC {
  factory NewsController() {
    if (_this == null) _this = NewsController._();
    return _this;
  }
  static NewsController _this;
  NewsController._();

  static NewsController get con => _this;

  int selectedIndex = 0;
  int selectedNewsIndex = 0;
  List<String> newsTitles = [
    'CMCO starts from October',
    'Crowds throng the iconic Penang ferries as service draws to a close today',
    'For 2021 New Year’s wish, Selangor MB looks to ‘unicorn’ firms to drive state economy',
    '‘Bloodstains’ found after Wildlife Dept seized two more gibbons amid court dispute, gibbon rehab centre claims',
    'Employers asked to remit mandatory EPF contribution on the 15th of every month'
  ];
  List<String> newsContents = [
    'KUALA LUMPUR (Oct 12): The government has agreed to enforce Conditional Movement Control (CMCO) in Selangor, Kuala Lumpur and Putrajaya effective from 12.01am on Oct 14 to Oct 27, said Senior Minister (Security Cluster) Datuk Seri Ismail Sabri Yaakob.',
    'GEORGE TOWN, Dec 31 — Over the past week, there were long queues to board the Penang ferry at both the Raja Tun Uda Terminal on the island and the Sultan Abdul Halim Terminal on the mainland. Cars lined Weld Quay from early morning to late evening as Penangites and visitors rushed to take the ferry for the last time today. Penang\'s iconic ferries that take foot passengers and cars are on their last day of service today before foot passengers are diverted to the Swettenham Pier Cruise Terminal to take the fast boats to cross the channel. There will no longer be any ferries to take four-wheeled vehicles across the channel between the island and mainland after today.',
    'KUALA LUMPUR, Dec 31 — Selangor is betting large on the digital economy to drive the state economy and is expected to pour huge amounts of money into potential industries like financial technology next year, Mentri Besar Datuk Seri Amirudin Shari said today. The country’s richest state by per capita income has channelled a huge chunk of its budget into a fund set up to help identify and nurture startup firms as it seeks to become the hub for unicorn companies, Amirudin said in a new year’s eve address issued earlier this evening.',
    'KUALA LUMPUR, Dec 31 — Stains resembling blood were sighted after the Wildlife and National Parks Department (Perhilitan) captured and removed two gibbons in a second raid today at the Gibbon Rehabilitation Project (GReP) in Pahang, the Gibbon Conservation Society (GCS) running the rehab centre said. Just two days ago, on December 29, Perhilitan was reported to have forcibly removed four out of six gibbons undergoing rehabilitation at GReP, despite an ongoing and still unsettled court dispute on whether Perhilitan or its former employee Mariani Ramli — GReP founder and GCS president — should be the ones caring for the six gibbons.',
    'KUALA LUMPUR, Dec 30 ― Employees Provident Fund (EPF) has instructed employers to remit their mandatory EPF contribution on the 15th of every month, starting January next year. In a statement today, EPF said this is in line with the original contribution payment date determined by them. Previously, the EPF provided an extension for contribution payment from the 15th to the 30th of every month from April until December 2020, to ease the burden of employers in light of the uncertainties surrounding the Covid-19 pandemic.'
  ];
  List<Card> newsCards = [];

  /// [User Type has 'Advisor' and 'Manager']
  List<User> userList = [
    User("Eugene Lim", "eugene_l104", "Advisor"),
    User("Tasfique Enam", "taz_e110", "Manager"),
    User("Chen Ming Kwok", "chen_m118", "Advisor"),
    User("Satomi Ishihara", "satomi_i102", "Advisor"),
    User("Ji Eun Lee", "ji_e105", "Advisor"),
    User("David Ponder", "david_p115", "Advisor"),
    User("Eric Wilson", "eric_109", "Advisor"),
  ];

  TextEditingController newsContentController = TextEditingController();
}
