import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../../data/cards.dart';
import '../../state/app_state.dart';
import '../widgets/card_visual.dart';

/// Lista dos cartões criados pela família.
class CartoesPersonalizadosPage extends StatelessWidget {
  const CartoesPersonalizadosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppState>();
    final lista = s.personalizados;
    return Scaffold(
      appBar: AppBar(title: const Text('Cartões da família')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NovoCartaoPage()),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Novo cartão'),
      ),
      body: lista.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Crie cartões com a foto de pessoas, lugares e objetos da vida da criança, '
                  'e grave a voz de quem ela conhece.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.only(bottom: 96),
              children: [
                for (final c in lista)
                  ListTile(
                    leading: SizedBox(
                      width: 64,
                      child: Center(child: CardVisual(c, tamanho: 30)),
                    ),
                    title: Text(c.rotulo),
                    subtitle: Text(
                      '${c.categoria.nome}${c.audioPath != null ? ' • com voz gravada' : ''}',
                    ),
                    trailing: IconButton(
                      tooltip: 'Apagar cartão',
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _confirmar(context, c),
                    ),
                    onTap: () => s.tocarCartaoSemFrase(c),
                  ),
              ],
            ),
    );
  }

  void _confirmar(BuildContext context, PecsCard c) {
    showDialog(
      context: context,
      builder: (d) => AlertDialog(
        title: Text('Apagar "${c.rotulo}"?'),
        content: const Text('A foto e a voz gravada também serão apagadas.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              context.read<AppState>().removerPersonalizado(c.id);
              Navigator.pop(d);
            },
            child: const Text('Apagar'),
          ),
        ],
      ),
    );
  }
}

/// Formulário: nome, frase, categoria, emoji, foto e voz.
class NovoCartaoPage extends StatefulWidget {
  const NovoCartaoPage({super.key});
  @override
  State<NovoCartaoPage> createState() => _NovoCartaoPageState();
}

class _NovoCartaoPageState extends State<NovoCartaoPage> {
  final _nome = TextEditingController();
  final _emoji = TextEditingController();
  CardCategory _cat = CardCategory.acoes;
  String? _foto;
  String? _audio;
  bool _gravando = false;

  @override
  void dispose() {
    _nome.dispose();
    _emoji.dispose();
    super.dispose();
  }

  void _aviso(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _escolherFoto(ImageSource origem) async {
    final s = context.read<AppState>();
    try {
      final caminho = await s.media.escolherFoto(origem);
      if (caminho != null) {
        await s.media.apagar(_foto);
        setState(() => _foto = caminho);
      }
    } catch (_) {
      _aviso('Não foi possível abrir a câmera ou a galeria.');
    }
  }

  Future<void> _alternarGravacao() async {
    final s = context.read<AppState>();
    try {
      if (_gravando) {
        final caminho = await s.media.pararGravacao();
        setState(() {
          _gravando = false;
          if (caminho != null) _audio = caminho;
        });
      } else {
        final ok = await s.media.iniciarGravacao();
        if (!ok) {
          _aviso('Permita o uso do microfone para gravar a voz.');
          return;
        }
        setState(() => _gravando = true);
      }
    } catch (_) {
      setState(() => _gravando = false);
      _aviso('Não foi possível gravar.');
    }
  }

  void _salvar() {
    final nome = _nome.text.trim();
    if (nome.isEmpty) return;
    final emoji = _emoji.text.trim().isEmpty ? '⭐' : _emoji.text.trim();
    context.read<AppState>().adicionarPersonalizado(
      PecsCard(
        'c_${DateTime.now().millisecondsSinceEpoch}',
        nome,
        nome,
        emoji,
        _cat,
        fotoPath: _foto,
        audioPath: _audio,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.read<AppState>();
    return Scaffold(
      appBar: AppBar(title: const Text('Novo cartão')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _nome,
            textCapitalization: TextCapitalization.sentences,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'Nome do cartão (ex.: Vovó)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          SegmentedButton<CardCategory>(
            segments: [
              for (final c in CardCategory.values)
                ButtonSegment(value: c, label: Text(c.nome)),
            ],
            selected: {_cat},
            onSelectionChanged: (v) => setState(() => _cat = v.first),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emoji,
            decoration: const InputDecoration(
              labelText: 'Emoji (opcional, usado se não houver foto)',
              border: OutlineInputBorder(),
            ),
          ),
          if (!kIsWeb) ...[
            const Divider(height: 32),
            Text('Foto', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: () => _escolherFoto(ImageSource.camera),
                  icon: const Icon(Icons.photo_camera),
                  label: const Text('Câmera'),
                ),
                FilledButton.icon(
                  onPressed: () => _escolherFoto(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Galeria'),
                ),
              ],
            ),
            if (_foto != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Center(
                  child: CardVisual(
                    PecsCard('x', '', '', '⭐', _cat, fotoPath: _foto),
                    tamanho: 60,
                  ),
                ),
              ),
            const Divider(height: 32),
            Text(
              'Voz da família',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                FilledButton.icon(
                  style: _gravando
                      ? FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFD9534F),
                        )
                      : null,
                  onPressed: _alternarGravacao,
                  icon: Icon(_gravando ? Icons.stop : Icons.mic),
                  label: Text(
                    _gravando
                        ? 'Parar'
                        : (_audio == null ? 'Gravar' : 'Gravar de novo'),
                  ),
                ),
                if (_audio != null && !_gravando)
                  OutlinedButton.icon(
                    onPressed: () => s.media.tocar(_audio!),
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Ouvir'),
                  ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('Sem gravação, o app fala com a voz do celular.'),
            ),
          ] else
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('Foto e voz gravada só funcionam no app Android.'),
            ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _nome.text.trim().isEmpty || _gravando ? null : _salvar,
            child: const Text('Salvar cartão'),
          ),
        ],
      ),
    );
  }
}
