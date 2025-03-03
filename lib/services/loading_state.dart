


class LoadingState {
  final bool isLoading ;
  LoadingState({required this.isLoading});

  LoadingState copyWith({String ? phone ,String ? password, bool ? isLoading}){
    return LoadingState(isLoading: isLoading ?? this.isLoading);
  }
}