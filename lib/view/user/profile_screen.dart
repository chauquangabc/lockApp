import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: .all(0),
        children: [
          Stack(
            clipBehavior: .none,
            children: [
              Container(
                height: MediaQuery.sizeOf(context).height * 0.3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: .centerLeft,
                    end: .centerRight,
                    colors: [Color(0xFFA1C4FD), Color(0xFFC2E9FB)],
                  ),
                ),
              ),
              Positioned(
                bottom: -50,
                left: 0,
                right: 0,
                child: Align(
                  alignment: .center,
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: .all(width: 2, color: Colors.grey),
                      borderRadius: .circular(60),
                      image: DecorationImage(
                        image: NetworkImage(
                          'https://static.vecteezy.com/system/resources/thumbnails/048/216/761/small/modern-male-avatar-with-black-hair-and-hoodie-illustration-free-png.png',
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 60,),
          Center(child: Text('Trần Minh Châu',style: TextStyle(fontSize: 24),)),
          SizedBox(height: 15,),
          Container(
            margin: .symmetric(horizontal: 15),
            padding: .all(15),
            decoration: BoxDecoration(
              borderRadius: .circular(10),
              border: .all(width: 1)
            ),
            child: Column(
              children: [
                _informationPersonal(
                  FontAwesomeIcons.envelope,
                  'Email',
                  'nguyenvana@gmail.com',
                  Colors.cyan,
                ),
                _informationPersonal(
                  FontAwesomeIcons.phone,
                  'Điện thoại',
                  '+84 393023122',
                  Colors.deepOrangeAccent,
                ),
                _informationPersonal(
                  FontAwesomeIcons.locationDot,
                  'Địa chỉ',
                  'Hà Nội , Việt Nam',
                  Colors.greenAccent,
                ),
                _informationPersonal(
                  FontAwesomeIcons.calendar,
                  'Tham gia từ',
                  'Tháng 12 , 2024',
                  Colors.blueAccent,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _informationPersonal(
      IconData icon,
      String label,
      var information,
      Color color,
      ) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: .only(bottom: 10),
        child: Row(
          children: [
            Container(
              padding: .all(10),
              decoration: BoxDecoration(
                borderRadius: .circular(30),
                color: color,
              ),
              child: Icon(icon),
            ),
            SizedBox(width: 15),
            Column(
              crossAxisAlignment: .start,
              children: [
                Text(label, style: TextStyle(fontSize: 18, color: Colors.grey)),
                Text(information, style: TextStyle(fontSize: 20)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
