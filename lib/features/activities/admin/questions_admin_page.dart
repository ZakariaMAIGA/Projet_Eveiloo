import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/activity_model.dart';
import '../../../models/question_model.dart';
import '../providers/question_provider.dart';
import 'add_question_page.dart';
import 'edit_question_page.dart';

class QuestionsAdminPage extends ConsumerWidget {
  final ActivityModel activity;

  const QuestionsAdminPage({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions =
        ref.watch(questionsProvider(activity.activityId));

    return Scaffold(
      appBar: AppBar(
        title: Text(activity.title),
      ),

      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("Question"),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddQuestionPage(
                activityId: activity.activityId,
              ),
            ),
          );
        },
      ),

      body: questions.when(

        data: (questions){

          if(questions.isEmpty){
            return const Center(
              child: Text(
                "Aucune question",
              ),
            );
          }

          return ListView.builder(

            padding: const EdgeInsets.all(16),

            itemCount: questions.length,

            itemBuilder: (_,index){

              final question = questions[index];

              return _QuestionCard(
                activityId: activity.activityId,
                question: question,
              );

            },

          );

        },

        loading: ()=>const Center(
          child: CircularProgressIndicator(),
        ),

        error:(e,s)=>Center(
          child: Text(e.toString()),
        ),

      ),
    );
  }
}

class _QuestionCard extends ConsumerWidget {

  final String activityId;

  final QuestionModel question;

  const _QuestionCard({

    required this.activityId,

    required this.question,

  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Card(

      margin: const EdgeInsets.only(bottom: 15),

      child: Padding(

        padding: const EdgeInsets.all(15),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Text(

              question.statement,

              style: const TextStyle(

                fontWeight: FontWeight.bold,

                fontSize: 18,

              ),

            ),

            const SizedBox(height: 10),

            Chip(

              label: Text(

                question.type.name,

              ),

            ),

            const Divider(),

            Row(

              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

              children: [

                TextButton.icon(

                  icon: const Icon(Icons.edit),

                  label: const Text("Modifier"),

                  onPressed: (){

                    Navigator.push(

                      context,

                      MaterialPageRoute(

                        builder:(_)=>EditQuestionPage(

                          activityId: activityId,

                          question: question,

                        ),

                      ),

                    );

                  },

                ),

                TextButton.icon(

                  icon: const Icon(

                    Icons.delete,

                    color: Colors.red,

                  ),

                  label: const Text(

                    "Supprimer",

                    style: TextStyle(

                      color: Colors.red,

                    ),

                  ),

                  onPressed: () async{

                    final confirm =
                        await showDialog<bool>(

                      context: context,

                      builder: (_)=>AlertDialog(

                        title: const Text(
                          "Confirmation",
                        ),

                        content: const Text(
                          "Supprimer cette question ?",
                        ),

                        actions: [

                          TextButton(

                            onPressed: (){

                              Navigator.pop(
                                context,
                                false,
                              );

                            },

                            child: const Text("Non"),

                          ),

                          ElevatedButton(

                            onPressed: (){

                              Navigator.pop(
                                context,
                                true,
                              );

                            },

                            child: const Text("Oui"),

                          )

                        ],

                      ),

                    );

                    if(confirm==true){

                      await ref.read(
                        questionServiceProvider,
                      ).deleteQuestion(

                        activityId,

                        question.questionId,

                      );

                    }

                  },

                )

              ],

            )

          ],

        ),

      ),

    );

  }

}