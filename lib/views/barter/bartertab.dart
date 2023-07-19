// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:barterit/models/items.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/myconfig.dart';
import 'package:barterit/views/barter/itemdetailscreen.dart';
import 'package:barterit/views/barter/orderscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BarterTab extends StatefulWidget {
  final User user;
  const BarterTab({super.key, required this.user});

  @override
  State<BarterTab> createState() => _BarterTabState();
}

class _BarterTabState extends State<BarterTab> {
  String maintitle = "Barter";
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  late List<Widget> tabchildren;
  List<Items> itemList = <Items>[];
  int numofpage = 1, curpage = 1;
  int numofresult = 0;
  bool _searchBoolean = false;
  var color;

  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    loadItems(1);
  }

  Future<void> _refreshItems() async {
    loadItems(1);
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
      appBar: AppBar(
        title: !_searchBoolean ? Text(maintitle) : _searchTextField(),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        elevation: 5,
        actions: _searchBoolean
            ? [
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchBoolean = false;
                    });
                  },
                )
              ]
            : [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _searchBoolean = true;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.list_rounded),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (content) =>
                                OrderScreen(user: widget.user)));
                  },
                )
              ],
      ),
      body: itemList.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : Column(children: [
              Container(
                height: 24,
                color: Colors.blueGrey,
                alignment: Alignment.center,
                child: Text(
                  "${itemList.length} Items Found",
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Expanded(
                  child: RefreshIndicator(
                      onRefresh: _refreshItems,
                      child: GridView.count(
                          crossAxisCount: axiscount,
                          children: List.generate(
                            itemList.length,
                            (index) {
                              return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black.withOpacity(0.5),
                                          width: 1.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Card(
                                          child: InkWell(
                                              onTap: () async {
                                                Items seletceditems =
                                                    Items.fromJson(
                                                        itemList[index]
                                                            .toJson());
                                                await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (content) =>
                                                            ItemDetailScreen(
                                                              user: widget.user,
                                                              selecteditems:
                                                                  seletceditems,
                                                            )));
                                                loadItems(1);
                                              },
                                              child: Column(children: [
                                                SizedBox(
                                                  height: 100,
                                                  child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount: 1,
                                                    itemBuilder:
                                                        (context, imageIndex) {
                                                      return Column(children: [
                                                        CachedNetworkImage(
                                                          width: screenWidth,
                                                          fit: BoxFit.cover,
                                                          imageUrl:
                                                              "${MyConfig().SERVER}/barteritphp/assets/items/front/${itemList[index].itemsId}.png",
                                                          placeholder: (context,
                                                                  url) =>
                                                              const LinearProgressIndicator(),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error),
                                                        ),
                                                      ]);
                                                    },
                                                  ),
                                                ),
                                                Text(
                                                  itemList[index]
                                                      .itemsName
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontSize: 20),
                                                ),
                                                Text(
                                                  "${itemList[index].itemsQty} items",
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                                Text(
                                                  "At ${itemList[index].itemsState} ",
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                ),
                                              ])))));
                            },
                          )))),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: numofpage,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    if ((curpage - 1) == index) {
                      color = Colors.brown;
                    } else {
                      color = Colors.grey;
                    }
                    return TextButton(
                        onPressed: () {
                          curpage = index + 1;
                          loadItems(index + 1);
                        },
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(color: color, fontSize: 18),
                        ));
                  },
                ),
              ),
            ]),
    );
  }

  void loadItems(int pg) {
    http.post(Uri.parse("${MyConfig().SERVER}/barteritphp/php/load_items.php"),
        body: {"pageno": pg.toString()}).then((response) {
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          numofpage = int.parse(jsondata['numofpage']);
          numofresult = int.parse(jsondata['numofresult']);
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Items.fromJson(v));
          });
        }
        setState(() {});
      }
    });
  }

  Widget _searchTextField() {
    return TextField(
      autofocus: true,
      cursorColor: Colors.white,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: (search) => searchItems(search),
      decoration: const InputDecoration(
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        hintText: 'Search',
        hintStyle: TextStyle(
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
    );
  }

  void searchItems(String search) {
    http.post(Uri.parse("${MyConfig().SERVER}/barteritphp/php/load_items.php"),
        body: {"search": search}).then((response) {
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          var extractdata = jsondata['data'];
          extractdata['items'].forEach((v) {
            itemList.add(Items.fromJson(v));
          });
        }
        setState(() {});
      }
    });
  }
}
