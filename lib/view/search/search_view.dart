// import 'package:flutter/material.dart';
// import 'package:mvc_pattern/mvc_pattern.dart';
// import 'package:vipc_app/model/member.dart';
// import 'package:vipc_app/view/login/login_view.dart';
// import 'package:vipc_app/model/chart_data.dart';
// import 'package:vipc_app/model/bar_chart.dart';
// import 'package:charts_flutter/flutter.dart' as charts;
// import 'package:pie_chart/pie_chart.dart';
// import 'package:percent_indicator/percent_indicator.dart';
// import 'package:vipc_app/view/appbar/appbar_view.dart';
// import 'package:vipc_app/view/drawer/drawer_view.dart';
// import 'package:vipc_app/controller/search/search_controller.dart';

// //This is used for the search bar which will search based on clients.
// class Search extends SearchDelegate {
//   @override
//   //The commented code is an old code used for testing, can be removed for final release.
//   // List<Widget> buildActions(BuildContext context) {
//   //   // TODO: implement buildActions
//   //   // actions for app bar
//   //   return [IconButton(icon: Icon(Icons.clear), onPressed: () {})];
//   //   //throw UnimplementedError();
//   // }
//   List<Widget> buildActions(BuildContext context) {
//     return <Widget>[
//       IconButton(
//         icon: Icon(Icons.close),
//         onPressed: () {
//           query = "";
//         },
//       ),
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: Icon(Icons.arrow_back),
//       onPressed: () {
//         Navigator.pop(context);
//       },
//     );
//   }

//   String selectedResult = "";

//   @override
//   Widget buildResults(BuildContext context) {
//     return Container(
//       child: Center(
//         child: Text(selectedResult),
//       ),
//     );
//   }

//   final List<String> listExample;
//   Search(this.listExample);

//   List<String> recentList = ["Text 4", "Text 3"];

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     // TODO: implement buildSuggestions
//     // show when someone searches for something
//     List<String> suggestionList = [];
//     query.isEmpty
//         ? suggestionList = recentList //In the true case
//         : suggestionList.addAll(listExample.where(
//             // In the false case
//             (element) => element.contains(query),
//           ));

//     return ListView.builder(
//       itemCount: suggestionList.length,
//       itemBuilder: (context, index) {
//         return ListTile(
//           title: Text(
//             suggestionList[index],
//           ),
//           leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
//           onTap: () {
//             selectedResult = suggestionList[index];
//             showResults(context);
//           },
//         );
//       },
//     );
//     //throw UnimplementedError();
//   }
// }

// // class SearchView extends StatefulWidget {
// //   SearchView({key}) : super(key: key);

// //   @override
// //   _SearchViewState createState() => _SearchViewState();
// // }

// // class _SearchViewState extends StateMVC {
// //   _SearchViewState() : super(SearchController()) {
// //     _con = SearchController.con;
// //   }

// //   SearchController _con;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: CustomAppBar(),
// //       drawer: CustomDrawer(),
// //       body: Container(
// //         padding: EdgeInsets.all(15),
// //         child: Text("No Notifications yet."),
// //       ),
// //     );
// //   }
// // }
