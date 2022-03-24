library g2x_popup_menu_multiselect;

import 'package:flutter/material.dart';

class G2xPopupMenuMultiSelectModel {
  final String id;
  final String text;
  final bool selected;
  G2xPopupMenuMultiSelectModel(this.id, this.text, { this.selected = false });

  G2xPopupMenuMultiSelectModel copyWith({
    String? id,
    String? text,
    bool? selected
  }) {
    return G2xPopupMenuMultiSelectModel(
      id ?? this.id,
      text ?? this.text,
      selected: selected ?? this.selected,
    );
  }
}

class G2xPopupMenuMultiSelect extends StatefulWidget {
  final List<G2xPopupMenuMultiSelectModel> children;
  final Function(List<G2xPopupMenuMultiSelectModel>) onSelected;
  final Widget child;
  final String? selectAll;
  final double? maxHeight;
  const G2xPopupMenuMultiSelect({
    Key? key,
    required this.children,
    required this.onSelected,
    required this.child,
    this.selectAll,
    this.maxHeight
  }) : super(key: key);

  @override
  _G2xPopupMenuMultiSelectState createState() => _G2xPopupMenuMultiSelectState();
}

class _G2xPopupMenuMultiSelectState extends State<G2xPopupMenuMultiSelect> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        RenderBox renderBox = context.findRenderObject()! as RenderBox;
        var size = renderBox.size;
        var offset = renderBox.localToGlobal(Offset.zero);
        Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (_, __, ___) => _G2xPopupMenuMultiSelectContainer(
              children: widget.children,
              parentOffset: offset,
              parentSize: size,
              onSelected: widget.onSelected,
              selectAll: widget.selectAll,
              maxHeight: widget.maxHeight,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}

class _G2xPopupMenuMultiSelectContainer extends StatefulWidget {
  final List<G2xPopupMenuMultiSelectModel> children;
  final Function(List<G2xPopupMenuMultiSelectModel>) onSelected;
  final Offset parentOffset;
  final Size parentSize;
  final String? selectAll;
  final double? maxHeight;
  const _G2xPopupMenuMultiSelectContainer({
    Key? key,
    required this.children,
    required this.onSelected,
    required this.parentOffset,
    required this.parentSize,
    this.selectAll,
    this.maxHeight
  }) : super(key: key);

  @override
  __G2xPopupMenuMultiSelectContainerState createState() => __G2xPopupMenuMultiSelectContainerState();
}

class __G2xPopupMenuMultiSelectContainerState extends State<_G2xPopupMenuMultiSelectContainer> {
  late double widthLargerText;
  late String largeText;
  late List<G2xPopupMenuMultiSelectModel> newList;

  update(int index){
    setState(() {
      newList[index] = newList[index].copyWith(selected: !newList[index].selected);
      if(newList[index].id == "g2xSelectAll"){
        for (var i = 1; i < newList.length; i++) {
          newList[i] = newList[i].copyWith(selected: newList[0].selected);
        }
      }
      else if(newList[index].selected == false && newList[0].id == "g2xSelectAll"){
        newList[0] = newList[0].copyWith(selected: false);
      }
      widget.onSelected(newList.where((e) => e.selected).toList());
    });
  }

  Size textSize(String text, TextStyle? style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style), maxLines: 1, textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  calculateLargeTextSize(){
    var l = List.from(newList);
    l.sort((a, b) => a.text.length > b.text.length ? 1 : 0);
    largeText = l.last.text;
    widthLargerText = textSize(largeText, null).width;
  }

  @override
  void initState() {
    newList = List.from(widget.children);
    if(widget.selectAll != null && widget.selectAll != "" ) {
      newList.insert(0, G2xPopupMenuMultiSelectModel("g2xSelectAll", widget.selectAll!));
    }
    calculateLargeTextSize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widthLargerText > MediaQuery.of(context).size.width * 0.3){
      widthLargerText = MediaQuery.of(context).size.width * 0.3;
    }
    var right = widget.parentOffset.dx + widget.parentSize.width/2;
    var left = widget.parentOffset.dx - (widthLargerText + 5) - widget.parentSize.width/2;
    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
      },
      child: Container(
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Positioned(
              left: left < 10 ? right : left,
              top: widget.parentOffset.dy + widget.parentSize.height/2.2,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 2,
                        offset: Offset(0, 3),
                        spreadRadius: 2,
                        color: Colors.black12
                      )
                    ]
                  ),
                  child: SizedBox(
                    height: widget.maxHeight,
                    //width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(newList.length, (index)
                          => InkWell(
                            onTap: (){
                              update(index);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8, left: 10),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: widthLargerText,
                                    child: Text(newList[index].text)),
                                  SizedBox(width: 40),
                                  SizedBox(
                                    height: 30,
                                    width: 30,
                                    child: Checkbox(
                                      value: newList[index].selected,
                                      onChanged: (_){
                                        update(index);
                                      },
                                    ),
                                  )
                                ]
                              ),
                            ),
                          )
                        )
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
