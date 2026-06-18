import 'package:efg_converter/features/history/domain/entities/conversion_history.dart';
import 'package:efg_converter/features/history/domain/usecases/clear_history_uscase.dart';
import 'package:efg_converter/features/history/domain/usecases/delete_conversion_usecase.dart';
import 'package:efg_converter/features/history/domain/usecases/get_history_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  final GetHistoryUseCase getHistory;
  final DeleteConversionUseCase deleteConversion;
  final ClearHistoryUseCase clearHistory;

  HistoryCubit({
    required this.getHistory,
    required this.deleteConversion,
    required this.clearHistory,
  }) : super(HistoryInitial());

  Future<void> loadHistory() async {
    emit(HistoryLoading());
    final result = await getHistory();
    result.fold(
          (failure) => emit(HistoryError(failure.message)),
          (history) => emit(HistoryLoaded(history)),
    );
  }

  Future<void> deleteItem(String id) async {
    await deleteConversion(id);
    await loadHistory();
  }

  Future<void> clearAll() async {
    await clearHistory();
    emit(const HistoryLoaded([]));
  }
}