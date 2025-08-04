import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier{
  int _currentIndex = 0;
  bool _isHeaderVisible = true;
  ScrollController? _scrollController;

  int get currentIndex => _currentIndex;
  bool get isHeaderVisible => _isHeaderVisible;
  ScrollController? get scrollController => _scrollController;

  void changeIndex(int index){
    _currentIndex = index;
    _isHeaderVisible = true;
    notifyListeners();
  }

  void setScrollController(ScrollController controller){
    _scrollController = controller;
    _scrollController?.addListener((){
      if(_scrollController == null) return;

      const double threshold = 100.0;
      
      if (_scrollController!.offset > threshold && _isHeaderVisible) {
        _isHeaderVisible = false;
        notifyListeners();
      } else if (_scrollController!.offset <= threshold && !_isHeaderVisible) {
        _isHeaderVisible = true;
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  void onTapButton(BuildContext context,int index,PageController page,ScrollController scroll){

    if(_currentIndex != index){
      changeIndex(index);
    }

    page.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut);

    WidgetsBinding.instance.addPostFrameCallback((_) {
        final itemWidth = 120.0; // Selected item width
        final screenWidth = MediaQuery.of(context).size.width;
        final offset = (itemWidth + 15) * index - (screenWidth / 2) + (itemWidth / 2);
        scroll.animateTo(
          offset.clamp(0, scroll.position.maxScrollExtent),
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });

  }
}