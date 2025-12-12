import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: .only(right: 15,left: 15,bottom: 20),
          children: [
            Center(child: Text('Cài đặt', style: TextStyle(fontSize: 30))),
            SizedBox(height: 20),
            Text('Gia đình', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: .circular(10),
                  border: .all(width: 1, color: Colors.black12),
                ),
                child: Row(
                  children: [
                    Icon(FontAwesomeIcons.users),
                    SizedBox(width: 10),
                    Text('Quản lý thành viên'),
                    Spacer(),
                    Icon(FontAwesomeIcons.angleRight),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text('Tài khoản', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: .circular(10),
                border: .all(width: 1, color: Colors.black12),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.bell),
                        SizedBox(width: 10),
                        Text('Thông báo'),
                        Spacer(),
                        Icon(FontAwesomeIcons.angleRight),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.shield),
                        SizedBox(width: 10),
                        Text('Quyền riêng tư'),
                        Spacer(),
                        Icon(FontAwesomeIcons.angleRight),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text('Tùy chỉnh', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: .circular(10),
                border: .all(width: 1, color: Colors.black12),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(FontAwesomeIcons.moon),
                      SizedBox(width: 10),
                      Text('Chế độ tối'),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isDark = !isDark;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 250),
                          width: 55,
                          height: 28,
                          padding: EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: isDark ? Colors.black : Colors.grey.shade300,
                          ),
                          child: AnimatedAlign(
                            duration: Duration(milliseconds: 250),
                            alignment: isDark
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: isDark ? Colors.white : Colors.black,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15,),
                  Row(
                    children: [
                      Icon(FontAwesomeIcons.globe),
                      SizedBox(width: 10),
                      Text('Ngôn ngữ'),
                      Spacer(),
                      GestureDetector(onTap: () {}, child: Text('Tiếng việt')),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Text('Hỗ trợ', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: .circular(10),
                border: .all(width: 1, color: Colors.black12),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.question),
                        SizedBox(width: 10),
                        Text('Trung tâm trợ giúp'),
                        Spacer(),
                        Icon(FontAwesomeIcons.angleRight),
                      ],
                    ),
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.info),
                        SizedBox(width: 10),
                        Text('Về ứng dụng'),
                        Spacer(),
                        Icon(FontAwesomeIcons.angleRight),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: .circular(10),
                  color: Colors.deepOrangeAccent.withValues(alpha: 0.4),
                ),
                child: Row(
                  mainAxisAlignment: .center,
                  children: [
                    Icon(FontAwesomeIcons.arrowRightFromBracket,color: Colors.red,),
                    SizedBox(width: 10,),
                    Text('Đăng xuất',style: TextStyle(fontSize: 20,color: Colors.red),),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }
}
