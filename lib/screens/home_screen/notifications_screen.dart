import 'package:dd_app/api/all_notifications_api.dart';
import 'package:dd_app/api/user_info_api.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  static const String id = "notificationScreen";

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  //For API Call
  AllNotificationsAPI notificationsAPI = AllNotificationsAPI();
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Notifications",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        height: _height,
        width: _width,
        child: FutureBuilder<dynamic>(
          future: notificationsAPI.getNotification(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.all(12),
                  itemCount: snapshot.data['data'].length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    var notification = snapshot.data["data"][index];

                    return NotificationCard(
                      title: "${notification["dateTime"]}",
                      subtitle: "${notification["notification_text"]}",
                    );
                  });
            } else if (snapshot.hasError) {
              return Center(child: Text("${snapshot.error.toString()}"));
            } else {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(child: CircularProgressIndicator()),
              );
            }
          },
        ),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isNew;

  const NotificationCard(
      {Key key, this.title, this.subtitle, this.isNew = false})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Card(
        child: ListTile(
          title: Text("$title"),
          subtitle: Text("$subtitle"),
          trailing: Icon(
            Icons.remove_red_eye,
            color: isNew ? Colors.red : Colors.grey,
            size: 12,
          ),
        ),
      ),
    );
  }
}
