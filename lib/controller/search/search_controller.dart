// import 'package:mvc_pattern/mvc_pattern.dart';
// import 'package:flutter/material.dart';

// class SearchController extends Stateful {
//   final List<String> list = List.generate(10, (index) => "Text $index");

//   @override
//   _SearchControllerState createState() => _SearchControllerState();
// }

// class _SearchControllerState extends State<SearchController> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: <Widget>[
//           IconButton(
//             onPressed: () {
//               showSearch(context: context, delegate: Search(widget.list));
//             },
//             icon: Icon(Icons.search),
//           )
//         ],
//         centerTitle: true,
//         title: Text('Search Bar'),
//       ),
//       body: ListView.builder(
//         itemCount: widget.list.length,
//         itemBuilder: (context, index) => ListTile(
//           title: Text(
//             widget.list[index],
//           ),
//         ),
//       ),
//     );
//   }
// }
