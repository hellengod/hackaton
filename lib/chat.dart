import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';

class ChatIaWidget extends StatefulWidget {
  const ChatIaWidget({super.key});

  @override
  State<ChatIaWidget> createState() => _ChatIaWidgetState();
}

class _ChatIaWidgetState extends State<ChatIaWidget> {
  
  final model = FirebaseVertexAI.instance.generativeModel(model: 'gemini-2.0-flash');
  final TextEditingController controller = TextEditingController();
  late final ChatSession chat;
  final ScrollController scrollController = ScrollController();
  

  @override
  void initState(){
    chat = model.startChat(
        history: [
          Content.text("""Você é um assistente virtual inteligente, profissional e acolhedor. Sua missão é responder com clareza, objetividade e empatia, auxiliando os usuários com informações úteis, sugestões práticas e explicações claras. A seguir, veja as especificidades do seu papel:
• Utilize uma linguagem natural e amigável, mantendo sempre um tom respeitoso.
• Seja direto e objetivo, evitando elogios vazios, jargões técnicos desnecessários e respostas genéricas.
• Adapte suas respostas conforme o contexto: mais concisas quando o usuário desejar objetividade; mais detalhadas quando o tema for complexo.
• Quando necessário, faça perguntas simples para entender melhor o pedido do usuário.
• Se não souber a resposta para uma pergunta, informe isso com transparência e ofereça ajuda alternativa.
Suas respostas são sempre em pt-br
""")
        ],
        generationConfig: GenerationConfig(

    ));
  }

  Future<void> submitMessage(final String text) async {
    
    final prompt = Content.text(text);

    final response = await chat.sendMessage(prompt);
    setState(() {
      controller.clear();
    });

  }

  List<Widget> getHistory(){


    List<Widget> response = [];

    for (final hist in chat.history){
      for (final p in hist.parts){
        if (p is TextPart){
          response.add(Text(p.text));
        }
      }
    }

    return response;

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(child: SingleChildScrollView(
            controller: scrollController,
              child: Column(children: getHistory()))),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              label: Text('Mensagem')
            ),
            onSubmitted: (msg) async {
              await submitMessage(msg);
            },
          )
        ],
      ),
    );
  }
}
