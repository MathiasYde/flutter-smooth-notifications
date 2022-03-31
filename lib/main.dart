import 'package:flutter/material.dart';

void main() {
  runApp(Application());
}

class Application extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Smooth Notifications Demo",
      theme: ThemeData.dark(),
      home: NotificationsPage(),
    );
  }
}

class Notification {
  String title;
  int id;

  Notification({this.title, this.id});
}

class NotificationsPage extends StatefulWidget {
  NotificationsPageState createState() => new NotificationsPageState();
}

class NotificationsPageState extends State<NotificationsPage> {
  List<Notification> notifications;
  final double rounding = 12;
  final Duration duration = Duration(milliseconds: 400);

  @override
  void initState() {
    notifications = List<Notification>.generate(
      8,
      (index) => Notification(title: "Item $index"),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: DismissibleListView(
          curve: Curves.fastOutSlowIn,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          items: notifications,
          onDismissed: (direction, index) {
            setState(() {
              notifications.removeAt(index);
            });
          },
          duration: duration,
          rounding: rounding,
          keyBuilder: (item, index) => ValueKey(item),
          itemBuilder: (context, index, notification) {
            return ListTile(
              title: Text(
                notification.title,
                style: TextStyle(color: Colors.black),
              ),
            );
          },
        ),
      ),
    );
  }
}

class DismissibleListView extends StatelessWidget {
  List items;
  double rounding;
  Duration duration;
  Function onDismissed;
  Function itemBuilder;
  Function keyBuilder;
  EdgeInsets padding;
  Curve curve;

  DismissibleListView({
    this.items,
    this.onDismissed,
    this.itemBuilder,
    this.keyBuilder,
    this.rounding = 16,
    this.duration = const Duration(milliseconds: 200),
    this.padding,
    this.curve = Curves.linear,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return SizedBox(height: 6);
      },
      padding: padding,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final bool isLast = index == items.length - 1;
        final bool isFirst = index == 0;

        BorderRadiusGeometry _borderRadius = BorderRadius.vertical(
          top: isFirst ? Radius.circular(rounding) : Radius.circular(0),
          bottom: isLast ? Radius.circular(rounding) : Radius.circular(0),
        );

        return Dismissible(
          key: keyBuilder(item, index),
          onDismissed: (direction) => onDismissed(direction, index),
          background: null,
          child: AnimatedContainer(
            curve: curve,
            duration: duration,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: _borderRadius,
            ),
            child: itemBuilder(context, index, item),
          ),
        );
      },
    );
  }
}
