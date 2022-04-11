// 앱의 메인이 되는 방탈출 테마 리스트를 그리드형태로 보여주는 페이지
// 하단 NavigationBar 도 포함.
// 상단 검색조건은 searchConditionMenuWidget 으로, 중간의 그리드뷰는 themaGridViewWidget 으로 연결.

import 'package:bangmoa/src/const/mainViewConst.dart';
import 'package:bangmoa/src/models/themaModel.dart';
import 'package:bangmoa/src/provider/serchTextProvider.dart';
import 'package:bangmoa/src/provider/themaProvider.dart';
import 'package:bangmoa/src/view/searchResultView.dart';
import 'package:bangmoa/src/view/userProfileView.dart';
import 'package:bangmoa/src/widget/recommendThemaWidget.dart';
import 'package:bangmoa/src/widget/searchConditionMenuWidget.dart';
import 'package:bangmoa/src/widget/themaGridViewWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class mainView extends StatefulWidget {
  const mainView({Key? key}) : super(key: key);

  @override
  _mainViewState createState() => _mainViewState();
}

class _mainViewState extends State<mainView> {
  List<Thema> recommendList = [];
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Thema> _themaList = Provider.of<ThemaProvider>(context).getThemaList;
    var rng = Random();
    for (var i = 0; i < 7; i++) {
      recommendList.add(_themaList[rng.nextInt(_themaList.length)]);
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfileView()));
        },
        child: Icon(Icons.person),
      ),
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("asset/image/bangmoaLogo.png", height: 40, width: 40, fit: BoxFit.fill,),
                  Text("방탈출 모아", style: TextStyle(fontSize: 17, fontFamily: 'POP'),),
                ],
              ),
            ),
            Container(
              child: TextField(
                controller: textController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "테마 검색",
                  border: InputBorder.none,
                  icon: Padding(
                    padding: EdgeInsets.only(left: 13),
                    child: Icon(Icons.search),
                  )
                ),
                onEditingComplete: () {
                  if (textController.value.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text("정확한 검색어를 입력해주세요."),
                          actions: [
                            TextButton(onPressed: () {Navigator.pop(context);}, child: Text("close"))
                          ],
                        );
                      }
                    );
                  } else {
                    Provider.of<SearchTextProvider>(context, listen: false).setSearchText(textController.value.text);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchResultView(),));
                    textController.clear();
                  }
                },
              ),
            ),
            RecommendThemaWidget(context, recommendList),
            ThemaGridViewWidget(themaList: _themaList, viewHeight: MediaQuery.of(context).size.height*0.8, viewText: "전체 테마"),
          ],
        ),
        scrollDirection: Axis.vertical,
      ),
    );
  }
}
