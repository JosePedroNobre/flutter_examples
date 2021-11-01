import 'dart:convert';

import 'package:customer/constants/styles.dart';
import 'package:customer/network/model/country.dart';
import 'package:flutter/material.dart';

class CountryCodeScreen extends StatefulWidget {
  final Function(Country) onCountrySelected;
  final Country selectedCountry;

  CountryCodeScreen({this.onCountrySelected, this.selectedCountry});

  @override
  _CountryCodeScreenState createState() => _CountryCodeScreenState();
}

class _CountryCodeScreenState extends State<CountryCodeScreen> {
  List<Country> originalList = [];
  List<Country> items = [];
  bool isLoading = true;
  int perPage = 10;
  int present = 0;

  @override
  void initState() {
    getCountryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            actions: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Icon(Icons.close, color: Colors.black),
                ),
              )
            ],
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text("Choose a country",
                style: font2(
                    size: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600))),
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: isLoading
              ? Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 10),
                      child: Text("SEARCH",
                          style: font2(
                              size: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w400)),
                    ),
                    _buildSearch(),
                    SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 10),
                      child: Text("LAST PICK",
                          style: font2(
                              size: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w400)),
                    ),
                    _buildLastSearched(),
                    SizedBox(height: 20),
                    _buildList()
                  ],
                ),
        ));
  }

  _buildList() {
    return Expanded(
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            if (originalList.length != items.length) {
              loadMore();
            }
          }
        },
        child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return _buildItem(items[index], index);
          },
        ),
      ),
    );
  }

  _buildSearch() {
    return Container(
      color: Colors.white,
      child: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
          child: TextField(
            onChanged: (value) {
              if (value.isNotEmpty) {
                items.clear();
                var filtered = originalList
                    .where((element) => element.name
                        .toLowerCase()
                        .contains(value.toLowerCase()))
                    .toList();

                setState(() {
                  items.addAll(filtered);
                });
              } else {
                setState(() {
                  items.clear();
                  items.addAll(
                      originalList.getRange(present, present + perPage));
                  present = present + perPage;
                });
              }
            },
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              fillColor: Colors.white,
              filled: true,
              labelStyle: font2(
                  fontWeight: FontWeight.w400,
                  color: Color(0xff6A7178),
                  size: 16),
              labelText: "Search...",
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
          )),
    );
  }

  _buildLastSearched() {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
        child: Row(
          children: [
            Image.asset(widget.selectedCountry.flag, width: 40, height: 40),
            SizedBox(width: 4),
            Text(widget.selectedCountry.name),
            Spacer(),
            Icon(Icons.check, color: Colors.green)
          ],
        ),
      ),
    );
  }

  _buildItem(Country country, int position) {
    return InkWell(
      onTap: () {
        widget.onCountrySelected(country);
        Navigator.pop(context);
      },
      child: Container(
        color: Colors.white,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 5, bottom: 5, left: 15, right: 15),
          child: Row(
            children: [
              // put is selected in json
              Image.asset(country.flag, width: 40, height: 40),
              SizedBox(width: 4),
              Container(
                  width: MediaQuery.of(context).size.width * 0.60,
                  child: Text(country.name))
            ],
          ),
        ),
      ),
    );
  }

  getCountryList() async {
    String rawData = await DefaultAssetBundle.of(context)
        .loadString('raw/country_codes.json');
    if (rawData == null) {
      return [];
    }
    final parsed = json.decode(rawData.toString()).cast<Map<String, dynamic>>();
    originalList = await parsed
        .map<Country>((json) => new Country.fromJson(json))
        .toList();
    setState(() {
      isLoading = false;
      items.addAll(originalList.getRange(present, present + perPage));
      present = present + perPage;
    });
  }

  void loadMore() {
    setState(() {
      if ((present + perPage) > originalList.length) {
        items.addAll(originalList.getRange(present, originalList.length));
      } else {
        items.addAll(originalList.getRange(present, present + perPage));
      }
      present = present + perPage;
    });
  }
}
