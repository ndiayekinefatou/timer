//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:azlistview/azlistview.dart';
//import 'package:azlistview/src/az_listview.dart';
//import 'package:azlistview/src/suspension_view.dart';

class _Azitem extends ISuspensionBean {
  String title;
  String tag;

  _Azitem({required this.title, required this.tag});

  @override
  String getSuspensionTag() => tag;
}

class ScrollPage extends StatefulWidget {
  final List<String> items;
  final ValueChanged<String> onClickedItem;
  const ScrollPage({Key? key, required this.items, required this.onClickedItem})
      : super(key: key);

  @override
  _ScrollPageState createState() => _ScrollPageState();
}

class _ScrollPageState extends State<ScrollPage> {
  //set items(List<_Azitem> items) {}
  List<_Azitem> items = [];

  @override
  void initState() {
    super.initState(); // celui qui est dans le final
    initList(widget.items);
  }

  void initList(List<String> items) {
    this.items = items
        .map((item) => _Azitem(title: item, tag: item[0].toUpperCase()))
        .toList();
    SuspensionUtil.sortListBySuspensionTag(this.items);
    SuspensionUtil.setShowSuspensionStatus(this.items);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => AzListView(
        padding: const EdgeInsets.all(16.0),
        data: items,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          var item = items[index];
          return buildListItem(item);
        },
        indexHintBuilder: (context, hint) => Container(
          alignment: Alignment.center,
          child:
              Text(hint, style: TextStyle(color: Colors.white, fontSize: 30)),
        ),
        indexBarMargin: EdgeInsets.all(10),
        indexBarOptions: IndexBarOptions(
          needRebuild: true,
          selectTextStyle:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          selectItemDecoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
          indexHintAlignment: Alignment.centerRight,
          indexHintOffset: Offset(-20, 0),
        ),
      );
  Widget buildListItem(_Azitem item) {
    final tag = item.getSuspensionTag();
    final offstage = !item.isShowSuspension;

    return Column(
      children: <Widget>[
        Offstage(offstage: offstage, child: buildHeaderTag(tag)),
        Container(
          margin: EdgeInsets.only(right: 16),
          child: ListTile(
              title: Text(item.title),
              onTap: () => widget.onClickedItem(item.title)),
        )
      ],
    );
  }

  Widget buildHeaderTag(String tag) => Container(
        height: 40,
        margin: EdgeInsets.only(right: 16),
        padding: EdgeInsets.only(left: 16),
        color: Colors.grey.shade300,
        alignment: Alignment.centerLeft,
        child: Text(
          '$tag',
          softWrap: false,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
}
