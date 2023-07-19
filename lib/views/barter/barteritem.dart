import 'dart:convert';

import 'package:barterit/models/items.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/myconfig.dart';
import 'package:barterit/views/barter/confirmscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BarterItem extends StatefulWidget {
  final Items selecteditems;
  final User user;
  const BarterItem(
      {super.key, required this.selecteditems, required this.user});

  @override
  State<BarterItem> createState() => _BarterItemState();
}

class _BarterItemState extends State<BarterItem> {
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  late List<Widget> tabchildren;
  String maintitle = "Select Items to Barter";
  List<Items> itemList = <Items>[];

  @override
  void initState() {
    super.initState();
    loadItems();
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
        title: Text(maintitle),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        elevation: 5,
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
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Card(
                                      child: InkWell(
                                          onTap: () async {
                                            Items useritems = Items.fromJson(
                                                itemList[index].toJson());
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (content) =>
                                                        ConfirmationScreen(
                                                            user: widget.user,
                                                            selecteditems: widget
                                                                .selecteditems,
                                                            useritems:
                                                                useritems)));
                                          },
                                          child: Column(children: [
                                            SizedBox(
                                              height: 100,
                                              child: ListView.builder(
                                                scrollDirection: Axis.vertical,
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
                                                    const SizedBox(height: 10),
                                                    CachedNetworkImage(
                                                      width: screenWidth,
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          "${MyConfig().SERVER}/barteritphp/assets/items/left/${itemList[index].itemsId}.png",
                                                      placeholder: (context,
                                                              url) =>
                                                          const LinearProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    CachedNetworkImage(
                                                      width: screenWidth,
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          "${MyConfig().SERVER}/barteritphp/assets/items/right/${itemList[index].itemsId}.png",
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
                                              style:
                                                  const TextStyle(fontSize: 20),
                                            ),
                                            Text(
                                              "${itemList[index].itemsQty} items",
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                            Text(
                                              "At ${itemList[index].itemsState} ",
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            ),
                                          ])))));
                        },
                      )))
            ]),
    );
  }

  void loadItems() {
    http.post(Uri.parse("${MyConfig().SERVER}/barteritphp/php/load_items.php"),
        body: {"user_id": widget.user.id}).then((response) {
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
