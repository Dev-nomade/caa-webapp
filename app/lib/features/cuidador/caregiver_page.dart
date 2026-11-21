import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';
import '../../data/cards.dart';
import '../../state/app_state.dart';
import '../rotina/rotina_editor_page.dart';
import 'cartoes_personalizados_page.dart';

/// Pede o PIN antes de abrir a área do cuidador (evita mudanças sem querer).
class CaregiverGate extends StatefulWidget {
  const CaregiverGate({super.key});
  @override
  State<CaregiverGate> createState() => _CaregiverGateState();
}

class _CaregiverGateState extends State<CaregiverGate> {
  final _ctrl = TextEditingController();
  bool _liberado = false;
  bool _erro = false;

  @override
  Widget build(BuildContext context) {
    if (_liberado) return const CaregiverPage();
    return Scaffold(
      appBar: AppBar(title: const Text('Área do cuidador')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          const Text('Digite o PIN (padrão: 1234)', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 16),
          TextField(
            controller: _ctrl,
            obscureText: true,
            keyboardType: TextInputType.number,
            maxLength: 4,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              errorText: _erro ? 'PIN incorreto' : null,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              final ok = _ctrl.text == context.read<AppState>().pin;
              setState(() {
                _liberado = ok;
                _erro = !ok;
              });
            },
            child: const Text('Entrar'),
          ),
        ]),
      ),
    );
  }
}

class CaregiverPage extends StatelessWidget {
  const CaregiverPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final uso = s.contagem;
    final ranking = uso.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(title: const Text('Área do cuidador')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Aparência', style: Theme.of(context).textTheme.titleMedium),
          SwitchListTile(
            title: const Text('Alto contraste'),
            value: s.altoContraste,
            onChanged: s.definirAltoContraste,
          ),
          ListTile(
            title: const Text('Cartões por linha'),
            trailing: SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 1, label: Text('1')),
                ButtonSegment(value: 2, label: Text('2')),
                ButtonSegment(value: 3, label: Text('3')),
              ],
              selected: {s.colunas},
              onSelectionChanged: (v) => s.definirColunas(v.first),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add_photo_alternate_outlined),
            title: const Text('Cartões da família (foto e voz)'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CartoesPersonalizadosPage())),
          ),
          ListTile(
            leading: const Icon(Icons.checklist_rtl),
            title: const Text('Editar rotina visual'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const RotinaEditorPage())),
          ),
          const Divider(height: 32),
          Text('Cartões visíveis', style: Theme.of(context).textTheme.titleMedium),
          for (final c in s.todos)
            CheckboxListTile(
              secondary: Text(c.emoji, style: const TextStyle(fontSize: 28)),
              title: Text('${c.rotulo}  •  ${c.categoria.nome}'),
              value: !s.ocultos.contains(c.id),
              onChanged: (_) => s.alternarCartao(c.id),
            ),
          const Divider(height: 32),
          Text('Uso nos últimos 7 dias', style: Theme.of(context).textTheme.titleMedium),
          if (ranking.isEmpty) const Padding(padding: EdgeInsets.all(8), child: Text('Ainda sem registros.')),
          for (final e in ranking)
            if (s.buscar(e.key) != null)
              ListTile(
                leading: Text(s.buscar(e.key)!.emoji, style: const TextStyle(fontSize: 28)),
                title: Text(s.buscar(e.key)!.rotulo),
                trailing: Text('${e.value}x', style: const TextStyle(fontSize: 18)),
              ),
          if (ranking.isNotEmpty)
            TextButton(onPressed: s.limparHistorico, child: const Text('Apagar histórico')),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.pin_outlined),
            title: const Text('Trocar PIN'),
            onTap: () => _trocarPin(context),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text('Todos os dados ficam só neste aparelho. Nada é enviado pela internet.'),
          ),
        ],
      ),
    );
  }

  void _trocarPin(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (d) => AlertDialog(
        title: const Text('Novo PIN (4 números)'),
        content: TextField(controller: ctrl, keyboardType: TextInputType.number, maxLength: 4),
        actions: [
          TextButton(onPressed: () => Navigator.pop(d), child: const Text('Cancelar')),
          FilledButton(
            onPressed: () {
              if (RegExp(r'^\d{4}$').hasMatch(ctrl.text)) {
                context.read<AppState>().definirPin(ctrl.text);
                Navigator.pop(d);
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
