import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:vipc_app/model/member.dart';
import 'package:vipc_app/view/login/login_view.dart';
import 'package:vipc_app/model/chart_data.dart';
import 'package:vipc_app/model/bar_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:pie_chart/pie_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:vipc_app/view/appbar/appbar_view.dart';
import 'package:vipc_app/view/drawer/drawer_view.dart';
import 'package:vipc_app/controller/search/search_controller.dart';

//This is used for the search bar which will search based on clients.
class DataSearch extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    // actions for app bar
    return [IconButton(icon: Icon(Icons.clear), onPressed: () {})];
    //throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    // leading icon on the left of the app bar
    return IconButton(
        icon: AnimatedIcon(icon: null, progress: null), onPressed: null);
    //throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    // show some result based on the selection
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    // show when someone searches for something
    throw UnimplementedError();
  }
}

// class SearchView extends StatefulWidget {
//   SearchView({key}) : super(key: key);

//   @override
//   _SearchViewState createState() => _SearchViewState();
// }

// class _SearchViewState extends StateMVC {
//   _SearchViewState() : super(SearchController()) {
//     _con = SearchController.con;
//   }

//   SearchController _con;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(),
//       drawer: CustomDrawer(),
//       body: Container(
//         padding: EdgeInsets.all(15),
//         child: Text("No Notifications yet."),
//       ),
//     );
//   }
// }
