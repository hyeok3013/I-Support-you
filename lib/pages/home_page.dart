import 'package:flutter/material.dart';
import 'package:i_support_you/models/subscriber_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:i_support_you/models/task_model.dart';

final Uri _url = Uri.parse(
    'https://www.youtube.com/c/%ED%95%98%EB%A3%A8%EC%9A%94%EC%95%BD'); //이거 추후 업데이트해서 받아오기
int indexNum = 2;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavigationBarSelected = 0;
  Box<TaskModel> box = Hive.box<TaskModel>("TaskBox");

  TextEditingController _titleController = TextEditingController();
  String? title;

  Future openBox() async {
    var tasksBox = await Hive.openBox("TaskBox");
  }

  void CreatDialog() {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                new Text("ToDo"),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _titleController,
                  onChanged: (_) {
                    title = _titleController.text;
                  },
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text("확인"),
                onPressed: () {
                  box.add(TaskModel(title!, false));
                  Navigator.pop(context);
                  _titleController.clear();
                  setState(() {});
                },
              ),
            ],
          );
        });
  }

  void UpdateDialog(int index) {
    showDialog(
        context: context,
        //barrierDismissible - Dialog를 제외한 다른 화면 터치 x
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            // RoundedRectangleBorder - Dialog 화면 모서리 둥글게 조절
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            //Dialog Main Title
            title: Column(
              children: <Widget>[
                new Text("Dialog Title"),
              ],
            ),
            //
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _titleController,
                  onChanged: (_) {
                    title = _titleController.text;
                  },
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text("확인"),
                onPressed: () {
                  box.putAt(index, TaskModel(title!, false));
                  Navigator.pop(context);
                  _titleController.clear();
                  setState(() {});
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    openBox();

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _bottomNavigationBarSelected,
        onTap: (index) {
          _bottomNavigationBarSelected = index;
          setState(() {});
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.thumb_up_outlined),
              label: "응원보기",
              activeIcon: Icon(Icons.thumb_up),
              tooltip: "클릭 시 새로운 카드로 변경됩니다."),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none_outlined),
            label: "채널보기",
            activeIcon: Icon(Icons.notifications_active_rounded),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            label: "구독자보기",
            activeIcon: Icon(Icons.chat),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_outlined),
            label: "ToDo",
            activeIcon: Icon(Icons.list_rounded),
          ),
        ],
      ),
      appBar: AppBar(
        title: const Text('당신을 응원합니다'),
        automaticallyImplyLeading: false,
      ),
      body: IndexedStack(
        index: _bottomNavigationBarSelected,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                indexNum = Random().nextInt(subscriberCommentList.length);
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SizedBox(),
                    flex: 1,
                  ),
                  Expanded(
                    child: ListView(children: [
                      Text(
                        subscriberCommentList[indexNum],
                        style: TextStyle(fontSize: 30),
                        textAlign: TextAlign.center,
                      ),
                    ]),
                    flex: 6,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        "-" + subscriberList[indexNum],
                        style: TextStyle(fontSize: 25),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        "화면 클릭 시 다른 응원으로 변합니다!",
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            child: Center(
                child: ElevatedButton(
              onPressed: () {
                _launchUrl();
              },
              child: Text("채널 확인하기"),
            )),
          ),
          Column(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    '응원을 남겨주신 구독자 명단',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              Divider(
                thickness: 1,
              ),
              Expanded(
                flex: 9,
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          subscriberSet.toList()[index],
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        thickness: 1,
                      );
                    },
                    itemCount: subscriberSet.length),
              ),
            ],
          ),
          ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              itemBuilder: (context, index) {
                return ListTile(
                  trailing: IconButton(
                      onPressed: () {
                        box.deleteAt(index);
                        setState(() {});
                      },
                      icon: Icon(Icons.delete)),
                  title: Text(
                    box.getAt(index)!.title,
                  ),
                  onTap: () {
                    box.deleteAt(index);
                    setState(() {});
                  },
                  onLongPress: () {
                    UpdateDialog(index);
                  },
                );
              },
              separatorBuilder: (context, index) {
                return Divider(
                  color: Colors.black,
                );
              },
              itemCount: box.length),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          CreatDialog();
        },
      ),
    );
  }
}

Future<void> _launchUrl() async {
  if (await canLaunchUrl(_url)) {
    launchUrl(_url);
  } else if (!await launchUrl(_url)) {
    throw 'Could not launch $_url';
  }
}
