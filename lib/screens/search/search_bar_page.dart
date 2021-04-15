import 'package:dd_app/utilities/vendor_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dd_app/api/all_vendors_api.dart';

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
  List filteredLocation = [];
  List filteredCategory = [];
  bool isSearchedDataFound = false;
  List searchItemList = [];
  String accountType;
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
  void dispose() {
    super.dispose();
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
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    if ((_searchText.isNotEmpty)) {
      List tempList = [];
      for (int i = 0; i < filteredNames.length; i++) {
        if (filteredNames[i]
                .toLowerCase()
                .contains(_searchText.toLowerCase()) ||
            filteredLocation[i]
                .toLowerCase()
                .contains(_searchText.toLowerCase()) ||
            filteredCategory[i]
                .toLowerCase()
                .contains(_searchText.toLowerCase())) {
          tempList.add(i);
          isSearchedDataFound = true;
        }
      }
      searchItemList = tempList;
    }
    return FutureBuilder<dynamic>(
        future: allVendorsAPI.getAVData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: isSearchedDataFound ? searchItemList.length : 1,
              itemBuilder: (BuildContext context, int index) {
                if (isSearchedDataFound == false) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        "No Data Found",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                } else {
                  return VendorCard(
                    context: context,
                    snapshot: snapshot,
                    index: searchItemList[index],
                    accountType: arguments['accountType'],
                  );
                }
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

    List tempListName = [];
    List tempListLocation = [];
    List tempListCategory = [];
    for (int i = 0; i < dataFromAPI['data'].length; i++) {
      tempListName.add(dataFromAPI['data'][i]['vendor_name']);
      tempListLocation.add(dataFromAPI['data'][i]['location_name']);
      tempListCategory.add(dataFromAPI['data'][i]['category_name']);
    }
    print(tempListName);
    print(tempListLocation);
    setState(() {
      names = tempListName;
      filteredNames = names;
      filteredLocation = tempListLocation;
      filteredCategory = tempListCategory;
    });
  }
}
