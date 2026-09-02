import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/activity_model.dart';
import '../../../models/proposition.dart';
import '../../../models/question_model.dart';
import '../child/activity_play_page.dart';
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ActivityPlayPage(activity: activity),
                ),
              );
            },
            tooltip: 'Tester comme un enfant',
            icon: const Icon(Icons.play_circle_outline),
          ),
        ],
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

            const SizedBox(height: 10),

            // Aperçu des réponses avec leurs vignettes d'image éventuelles.
            if (question.options.isNotEmpty)
              ...question.options.map(
                (option) => _OptionPreview(option: option),
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
                      try {
                        await ref.read(questionServiceProvider).deleteQuestion(
                          activityId,
                          question.questionId,
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Question supprimée')),
                          );
                        }
                      } catch (error) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Impossible de supprimer : $error')),
                          );
                        }
                      }
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

/// Ligne d'aperçu d'une proposition : vignette d'image (si URL) + texte.
class _OptionPreview extends StatelessWidget {
  final Proposition option;

  const _OptionPreview({required this.option});

  bool get hasImage =>
      option.imageUrl != null && option.imageUrl!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            "${option.id}.",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          if (hasImage) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                option.imageUrl!.trim(),
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (_, error, stackTrace) => Container(
                  width: 48,
                  height: 48,
                  color: const Color(0xFFDDF4FB),
                  child: const Icon(
                    Icons.broken_image_outlined,
                    size: 20,
                    color: Color(0xFF2D8DD5),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(child: Text(option.texte)),
        ],
      ),
    );
  }
}