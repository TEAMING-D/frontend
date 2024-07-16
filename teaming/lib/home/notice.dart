import 'package:flutter/material.dart';

// 알림 Drawer 위젯
class NotificationDrawer extends StatelessWidget {
  final List<Map<String, String>> notifications;
  final Function(int) onAccept;
  final Function(int) onReject;

  const NotificationDrawer({
    super.key,
    required this.notifications,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.85,
      backgroundColor: Colors.white,
      child: Column(
        children: [
          SizedBox(height: 30),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              '알림',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: Color(0xff404040),
              ),
            ),
          ),
          Divider(
            color: Color(0xffd2d2d2),
            thickness: 1,
            indent: 40,
            endIndent: 40,
          ),
          notifications.isEmpty
              ? Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/icon/no_alert_message.png'),
                        SizedBox(height: 16),
                        Text(
                          '알림 메시지가 없습니다',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            fontSize: 15,
                            color: Color(0xff797979),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      var notification = notifications[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification['title']!,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: Color(0xffa0a0a0),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              notification['message']!,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: Color(0xff5a5a5a),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        backgroundColor: Colors.white,
                                        side: BorderSide(
                                            color: Color(0xff5a5a5a)),
                                        minimumSize: Size(0, 33),),
                                    onPressed: () => onReject(index),
                                    child: Text(
                                      '거절',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13,
                                        color: Color(0xff5a5a5a),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor: Colors.white,
                                      side:
                                          BorderSide(color: Color(0xff5a5a5a)),
                                      minimumSize: Size(0, 33),
                                    ),
                                    onPressed: () => onAccept(index),
                                    child: Text(
                                      '승인',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13,
                                        color: Color(0xff5a5a5a),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              color: Color(0xffd2d2d2),
                              thickness: 1,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
