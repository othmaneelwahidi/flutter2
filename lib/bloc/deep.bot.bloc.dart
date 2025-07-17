import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/deep.model.dart';
import '../repository/deep.repository.dart';

abstract class DeepBotEvent {}

class AskLlmEvent extends DeepBotEvent {
  final String query;

  AskLlmEvent({required this.query});
}

abstract class DeepBotState {
  final List<Message> messages;

  DeepBotState({required this.messages});
}

class DeepBotPendingState extends DeepBotState {
  DeepBotPendingState({required super.messages});
}

class DeepBotSuccessState extends DeepBotState {
  DeepBotSuccessState({required super.messages});
}

class DeepBotErrorState extends DeepBotState {
  final String errorMessage;
  DeepBotErrorState({required super.messages, required this.errorMessage});
}

class DeepBotInitialState extends DeepBotState {
  DeepBotInitialState()
      : super(messages: [
          Message(message: "Hello", type: "user"),
          Message(message: "How can I help you", type: "assistant")
        ]);
}

class DeepBotBloc extends Bloc<DeepBotEvent, DeepBotState> {
  final DeepBotRepository deepBotRepository = DeepBotRepository();
  late DeepBotEvent lastEvent;
  DeepBotBloc() : super(DeepBotInitialState()) {
    on((AskLlmEvent event, emit) async {
      //print("AskLlmEvent occured ofc hh");
      lastEvent = event;
      List<Message> currentMessages = state.messages;
      //emit(DeepBotPendingState(messages: state.messages));
      currentMessages.add(Message(message: event.query, type: "user"));
      emit(DeepBotPendingState(messages: state.messages));
      try {
        Message Responsemessage =
            await deepBotRepository.askLargeLangueModelDeep(event.query);
        currentMessages.add(Responsemessage);
        emit(DeepBotSuccessState(messages: currentMessages));
      } catch (err) {
        //print(err);
        emit(DeepBotErrorState(
            messages: state.messages, errorMessage: err.toString()));
      }
    });
  }
}
