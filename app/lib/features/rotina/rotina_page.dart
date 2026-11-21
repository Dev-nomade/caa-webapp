import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../../data/cards.dart';
import '../../state/app_state.dart';
import '../widgets/card_visual.dart';

/// Rotina do dia para a criança: uma linha do tempo com o passo atual em destaque.
class RotinaPage extends StatelessWidget {
  const RotinaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final passos = s.passosRotina;
    final atual = s.passoAtual;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minha rotina'),
        actions: [
          IconButton(
            tooltip: 'Recomeçar o dia',
            icon: const Icon(Icons.restart_alt),
            onPressed: s.reiniciarRotina,
          ),
        ],
      ),
      body: passos.isEmpty
          ? const Center(child: Text('Nenhum passo. Peça ao cuidador para montar a rotina.'))
          : Column(
              children: [
                if (atual == -1)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('🎉 Tudo feito! Muito bem!',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
                  ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: passos.length,
                    itemBuilder: (_, i) {
                      final c = passos[i];
                      final feito = s.feitos.contains(i);
                      final eAtual = i == atual;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Semantics(
                          button: true,
                          label: '${c.rotulo}${feito ? ", feito" : eAtual ? ", agora" : ", depois"}',
                          child: Material(
                            color: feito ? Colors.grey.shade300 : c.categoria.cor,
                            borderRadius: BorderRadius.circular(24),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(24),
                              onTap: () => s.falarPasso(i),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                constraints: const BoxConstraints(minHeight: 96),
                                decoration: eAtual
                                    ? BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(color: const Color(0xFF3F6E9A), width: 5),
                                      )
                                    : null,
                                child: Row(
                                  children: [
                                    Opacity(
                                      opacity: feito ? 0.4 : 1,
                                      child: CardVisual(c, tamanho: 48),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(c.rotulo,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(color: Colors.black87)),
                                          if (eAtual)
                                            const Text('Agora',
                                                style: TextStyle(fontSize: 18, color: Colors.black87)),
                                        ],
                                      ),
                                    ),
                                    IconButton.filled(
                                      tooltip: feito ? 'Desfazer' : 'Marcar como feito',
                                      iconSize: 36,
                                      onPressed: () => s.concluirPasso(i),
                                      icon: Icon(feito ? Icons.check_circle : Icons.circle_outlined),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
