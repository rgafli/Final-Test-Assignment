import 'package:barterit/models/items.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/myconfig.dart';
import 'package:barterit/views/barter/barteritem.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemDetailScreen extends StatefulWidget {
  final Items selecteditems;
  final User user;
  const ItemDetailScreen(
      {super.key, required this.selecteditems, required this.user});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int qty = 0;
  int userqty = 1;

  @override
  void initState() {
    super.initState();
    qty = int.parse(widget.selecteditems.itemsQty.toString());
  }

  final df = DateFormat('dd-MM-yyyy hh:mm a');

  late double screenHeight, screenWidth, cardwitdh;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
        title: Text(
          widget.selecteditems.itemsName.toString(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: screenWidth * 0.6,
                child: PageView(
                  children: [
                    buildImageCard(
                      imageUrl:
                          "${MyConfig().SERVER}/barteritphp/assets/items/front/${widget.selecteditems.itemsId}.png",
                    ),
                    buildImageCard(
                      imageUrl:
                          "${MyConfig().SERVER}/barteritphp/assets/items/right/${widget.selecteditems.itemsId}.png",
                    ),
                    buildImageCard(
                      imageUrl:
                          "${MyConfig().SERVER}/barteritphp/assets/items/left/${widget.selecteditems.itemsId}.png",
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
            ),
            buildTable(),
            const SizedBox(height: 8.0),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  itemCheck();
                },
                child:
                    const Text("Barter", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildImageCard({required String imageUrl}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        child: CachedNetworkImage(
          width: screenWidth,
          fit: BoxFit.cover,
          imageUrl: imageUrl,
          placeholder: (context, url) => const LinearProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
    );
  }

  Widget buildTable() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(4),
          1: FlexColumnWidth(6),
        },
        children: [
          buildTableRow(
              "Description", widget.selecteditems.itemsDesc.toString()),
          buildTableRow(
              "Quantity Available", widget.selecteditems.itemsQty.toString()),
          buildTableRow(
            "Location",
            "${widget.selecteditems.itemsLocality}/${widget.selecteditems.itemsState}",
          ),
          buildTableRow(
            "Date",
            df.format(
                DateTime.parse(widget.selecteditems.itemsDate.toString())),
          ),
        ],
      ),
    );
  }

  TableRow buildTableRow(String title, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(value),
        ),
      ],
    );
  }

  void itemCheck() {
    if (widget.selecteditems.userId == widget.user.id) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Can't Barter with your own item")));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BarterItem(
                user: widget.user, selecteditems: widget.selecteditems)),
      );
    }
  }
}
