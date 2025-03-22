


class GenericLoadingState {
  final bool isLoading ;
  GenericLoadingState({required this.isLoading});

  GenericLoadingState copyWith({bool ? isLoading}){
    return GenericLoadingState(isLoading: isLoading ?? this.isLoading);
  }
}