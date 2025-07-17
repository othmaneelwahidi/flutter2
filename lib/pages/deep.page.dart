import 'package:chatbot_app_bloc/bloc/deep.bot.bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/deep.model.dart';

class DeepSeekPage extends StatelessWidget {
  DeepSeekPage({super.key});
  final TextEditingController queryController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "DeepSeek is here to respond to your demands",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, "/dashboard");
              },
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ))
        ],
      ),
      body: Column(
        children: [
          // Modifié ici : Utilisation d'un Expanded avec BlocBuilder
          Expanded(
            child: BlocBuilder<DeepBotBloc, DeepBotState>(
              builder: (context, state) {
                // Gestion de l'état d'erreur
                if (state is DeepBotErrorState) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${state.errorMessage}",
                        style: TextStyle(color: Colors.red),
                      ),
                      ElevatedButton(onPressed: () {}, child: Text("Retry"))
                    ],
                  );
                }

                // Liste des messages + indicateur de chargement
                List<Message> messages = [];
                bool isLoading = false;

                if (state is DeepBotInitialState ||
                    state is DeepBotSuccessState ||
                    state is DeepBotPendingState) {
                  messages = state.messages;
                  isLoading = state is DeepBotPendingState;
                }

                return ListView.builder(
                  controller: scrollController,
                  itemCount: messages.length + (isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Afficher l'indicateur de chargement à la fin
                    if (isLoading && index == messages.length) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    ;
                    //Scoll ajoutée avec Succès
                    scrollController.jumpTo(
                        scrollController.position.maxScrollExtent + 200);

                    // Affichage normal des messages
                    final message = messages[index];
                    bool isUser = message.type == 'user';

                    return Column(
                      children: [
                        ListTile(
                          trailing: isUser ? Icon(Icons.person) : null,
                          leading: !isUser ? Icon(Icons.support_agent) : null,
                          title: Row(
                            children: [
                              isUser
                                  ? SizedBox(width: 80)
                                  : SizedBox(width: 10),
                              Expanded(
                                child: Card.outlined(
                                  margin: EdgeInsets.all(6),
                                  color: isUser ? Colors.green : Colors.white,
                                  child: ListTile(
                                    title: Text(message.message),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: queryController,
                    decoration: InputDecoration(
                        hintText: ("Your message should be written down here"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                width: 1,
                                color: Theme.of(context).primaryColor))),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      String query = queryController.text;
                      context
                          .read<DeepBotBloc>()
                          .add(AskLlmEvent(query: query));
                      queryController.clear();

                      // Faire défiler vers le bas après l'envoi
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (scrollController.hasClients) {
                          scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        }
                      });
                    },
                    icon: Icon(Icons.send))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
