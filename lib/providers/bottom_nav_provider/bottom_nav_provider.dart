import 'package:riverpod/riverpod.dart';


 final bottomNavProvider = StateNotifierProvider<BottomNavNotifier,BottomNavState>((ref){
   return BottomNavNotifier();
 });



class BottomNavNotifier extends StateNotifier<BottomNavState>{
  BottomNavNotifier():super(BottomNavState(currentIndex: 0));
  void changeIndex({required int index}){
    state = state.copyWith(currentIndex: index);
  }
}






class BottomNavState {
  final int currentIndex;
  BottomNavState({required this.currentIndex});
  BottomNavState copyWith ({int ? currentIndex}){
    return BottomNavState(currentIndex: currentIndex ?? this.currentIndex);
  }
}