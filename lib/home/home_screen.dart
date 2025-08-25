import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voxta_app/Providers/home_provider.dart';
import 'package:voxta_app/auth/login_screen.dart';
import 'package:voxta_app/home/home_pages.dart/call_list.dart';
import 'package:voxta_app/home/home_pages.dart/chatlist_screen.dart';
import 'package:voxta_app/home/home_pages.dart/group_list.dart';
import 'package:voxta_app/home/home_pages.dart/notifications/notification_screen.dart';
import 'package:voxta_app/home/home_pages.dart/status_list.dart';
import 'package:voxta_app/main.dart';
import 'package:voxta_app/textStyles.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  List<String> sections = ['Chats','Groups','Storys','Calls'];
  final List<Widget> pages = [
    ChatList(),
    GroupList(),
    StatusList(),
    CallList(),
  ];
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();


  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>().currentIndex;
    return Consumer<HomeProvider>(
      builder:(context,provider,child){
        final isHeaderVisible = provider.isHeaderVisible;
        return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              const SizedBox(height: 10),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: isHeaderVisible ? 50: 0,
                child: AnimatedOpacity(
                  opacity: isHeaderVisible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 300),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: ()async{
                            final prefx = await SharedPreferences.getInstance();
                            await prefx.setBool(SAVE_KEY_VALUE, false);
                            Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => LoginScreen()), 
                             (route) => false);
                        }, icon: Icon(Icons.settings)),
                      Text(
                        sections[homeProvider],
                        style: TextStyles.wlcmvoxta,
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: (){
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => NotificationScreen())
                              );
                            }, 
                            icon: Icon(Icons.notifications)),
                          const SizedBox(width: 5),
                          IconButton(
                            onPressed: (){
                                
                            }, icon: Icon(Icons.more_vert)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: isHeaderVisible ? 30:10),
              SizedBox(
                height: 50,
                child: ListView.separated(
                  controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context,index){
                  return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: homeProvider == index ? Color(0xFF22C55E):Colors.white,
                    minimumSize: homeProvider == index ? const Size(120, 50) : const Size(100, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(30),
                    )
                  ), 
                  onPressed: (){
                    provider.onTapButton(
                      context, 
                      index, 
                      _pageController, 
                      _scrollController);
                  }, 
                  child: Text(
                    sections[index],
                    style: TextStyles.blktxt,
                  ));
                },
                itemCount: sections.length,
                separatorBuilder: (context,index){
                  return const SizedBox(width: 15);
                },
                ),
              ),
              const SizedBox(height: 20),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: isHeaderVisible ? 60 : 0,
                child: AnimatedOpacity(
                  opacity: isHeaderVisible ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 200),
                  child: TextFormField(
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search,color: Color(0xFF22C55E)),
                      labelText: 'Search',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: isHeaderVisible ? 20 : 10),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: pages.length,
                  onPageChanged: (index){
                    context.read<HomeProvider>().changeIndex(index);

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final itemWidth = 120.0; // Selected item width
                      final screenWidth = MediaQuery.of(context).size.width;
                      final offset = (itemWidth + 15) * index - (screenWidth / 2) + (itemWidth / 2);
                      _scrollController.animateTo(
                        offset.clamp(0, _scrollController.position.maxScrollExtent),
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    });
                  },
                  itemBuilder: (context,index){
                    return pages[index];
                  },
                ),
              )
            ],
          ),
        ),
      ),
    ); 
      }
    );
  }
}