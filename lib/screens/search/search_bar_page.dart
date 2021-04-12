import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dd_app/api/all_vendors_api.dart';
import '../../utilities/claim_now_alert_dialog.dart';

SharedPreferences localStorage;
var dataFromAPI;
AllVendorsAPI allVendorsAPI = AllVendorsAPI();

class SearchBarPage extends StatefulWidget {
  static const String id = "search_bar_page";

  @override
  _SearchBarPageState createState() => _SearchBarPageState();
}

class _SearchBarPageState extends State<SearchBarPage> {
  final TextEditingController _filter = TextEditingController();
  String _searchText = "";
  List names = [];
  List filteredNames = [];
  int selectedSearchIndex;
  Widget _searchBarTitle = Text(
    'Search your Deals',
    style: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14.0,
      color: Colors.white,
    ),
  );
  Icon _searchIcon = Icon(
    Icons.search,
    color: Colors.white,
  );

  _SearchBarPageState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          filteredNames = names;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  void initState() {
    _searchPressed();
    this._getVendorNames();
    allVendorsAPI.getAVData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildBar(context),
        body: Container(
          child: _buildList(),
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: _searchBarTitle,
      leading: IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    );
  }

  Widget _buildList() {
    if ((_searchText.isNotEmpty)) {
      List tempList = [];
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(filteredNames[i]);
          selectedSearchIndex = i;
        }
      }
      filteredNames = tempList;
    }
    return FutureBuilder<dynamic>(
        future: allVendorsAPI.getAVData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: names == null ? 0 : filteredNames.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(filteredNames[index]),
                  leading: Icon(Icons.house),
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return claimNowAlertDialog(snapshot, index, context);
                        });
                  },
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = Icon(
          Icons.arrow_back,
          color: Colors.white,
        );
        this._searchBarTitle = TextField(
          controller: _filter,
          decoration: InputDecoration(hintText: 'Search...'),
        );
      } else {
        Navigator.pop(context);
        filteredNames = names;
        _filter.clear();
      }
    });
  }

  void _getVendorNames() async {
    localStorage = await SharedPreferences.getInstance();
    var url = Uri.parse('https://apps.dd.limited/api/v1/vendor/0');
    http.Response response = await http.get(
      url,
      headers: <String, String>{
        'Authorization': 'Bearer ${localStorage.get('Authorization')}',
        'Customer-ID': '${localStorage.get('Customer-ID')}',
      },
    );
    dataFromAPI = json.decode(response.body);
    print(dataFromAPI['data'][1]['vendor_name']);
    List tempList = [];
    for (int i = 0; i < dataFromAPI['data'].length; i++) {
      tempList.add(dataFromAPI['data'][i]['vendor_name']);
    }
    print(tempList);
    setState(() {
      names = tempList;
      filteredNames = names;
    });
  }
}
