import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../core/l10n/strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/store.dart';
import '../../../widgets/common.dart';
import '../../../data/models/ai_item.dart';
import '../../../services/spreadsheet_service.dart';

class AiCard extends StatefulWidget {
  const AiCard({super.key});
  @override
  State<AiCard> createState() => _AiCardState();
}

class _AiCardState extends State<AiCard> {
  final ctl = TextEditingController(), kc = TextEditingController();
  final sp = stt.SpeechToText();
  bool listening = false, busy = false;
  String? fileName, fileText;

  @override
  void dispose() {
    ctl.dispose();
    kc.dispose();
    sp.cancel();
    super.dispose();
  }

  void _snack(String m) {
    if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  Future<void> _mic() async {
    if (listening) {
      await sp.stop();
      if (mounted) setState(() => listening = false);
      return;
    }
    final ok = await sp.initialize(
      onStatus: (s) {
        if ((s == 'done' || s == 'notListening') && mounted) setState(() => listening = false);
      },
      onError: (_) {
        if (mounted) {
          setState(() => listening = false);
          _snack(t('aiMic'));
        }
      },
    );
    if (!ok) {
      _snack(t('aiMic'));
      return;
    }
    final base = ctl.text.trim();
    setState(() => listening = true);
    await sp.listen(
      localeId: const {'pt': 'pt_BR', 'en': 'en_US', 'es': 'es_ES', 'zh': 'zh_CN', 'ru': 'ru_RU'}[store.lang],
      onResult: (r) {
        if (mounted) setState(() => ctl.text = base.isEmpty ? r.recognizedWords : '$base ${r.recognizedWords}');
      },
    );
  }

  Future<void> _pick() async {
    final r = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['xlsx', 'csv'], withData: true);
    if (r == null || r.files.isEmpty) return;
    final f = r.files.first, b = f.bytes;
    if (b == null) {
      _snack(t('aiErr'));
      return;
    }
    try {
      final txt = (f.extension ?? '').toLowerCase() == 'csv' ? utf8.decode(b, allowMalformed: true) : xlsxToText(b);
      setState(() {
        fileName = f.name;
        fileText = txt;
      });
    } catch (e) {
      _snack('${t('aiErr')} $e');
    }
  }

  Future<void> _send() async {
    final txt = ctl.text.trim();
    if ((txt.isEmpty && fileText == null) || busy) return;
    if (listening) {
      await sp.stop();
      listening = false;
    }
    setState(() => busy = true);
    try {
      var input = 'Texto do usuário:\n$txt';
      if (fileText != null) input += '\n\nPlanilha "$fileName":\n$fileText';
      final res = await aiAsk(input);
      final items = <AiItem>[];
      for (final e in (res['items'] as List? ?? [])) {
        final x = e is Map<String, dynamic> ? AiItem.from(e) : null;
        if (x != null) items.add(x);
      }
      final skipped = [for (final e in (res['skipped'] as List? ?? [])) '$e'];
      if (!mounted) return;
      if (items.isEmpty) {
        _snack(skipped.isEmpty ? t('aiNone') : '${t('aiNone')} ${skipped.first}');
      } else {
        final ok = await showAiReview(context, items, skipped);
        if (ok == true) {
          setState(() {
            ctl.clear();
            fileName = null;
            fileText = null;
          });
        }
      }
    } catch (e) {
      _snack('${t('aiErr')}${e is String ? ' ($e)' : ''}');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final noKey = store.apiKey.isEmpty;
    return appCard(Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Row(children: [
        const Icon(Icons.auto_awesome_outlined, size: 18, color: kAccent),
        const SizedBox(width: 8),
        Expanded(child: Text(t('ai'), style: kHeading)),
        if (!noKey) IconButton(tooltip: t('aiKey'), icon: const Icon(Icons.key_outlined, size: 18, color: kMuted), onPressed: () => store.setKey('')),
      ]),
      const SizedBox(height: 8),
      if (noKey) ...[
        TextField(controller: kc, obscureText: true, autocorrect: false, decoration: InputDecoration(hintText: t('aiKey'), border: const OutlineInputBorder())),
        const SizedBox(height: 8),
        FilledButton(onPressed: () => store.setKey(kc.text.trim()), child: Text(t('save'))),
      ] else ...[
        TextField(
          controller: ctl,
          minLines: 2,
          maxLines: 5,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: t('aiHint'),
            helperText: '${t('income')} · ${t('expense')} · ${t('mkList')}',
            border: const OutlineInputBorder(),
          ),
        ),
        if (fileName != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                avatar: const Icon(Icons.table_chart_outlined, size: 18),
                label: Text(fileName!, overflow: TextOverflow.ellipsis),
                onDeleted: () => setState(() {
                  fileName = null;
                  fileText = null;
                }),
              ),
            ),
          ),
        const SizedBox(height: 8),
        Row(children: [
          IconButton(onPressed: busy ? null : _mic, icon: Icon(listening ? Icons.stop_circle_outlined : Icons.mic_none_outlined, color: listening ? kBad : kAccent)),
          IconButton(onPressed: busy ? null : _pick, icon: const Icon(Icons.attach_file, color: kAccent)),
          const Spacer(),
          FilledButton.icon(
            onPressed: busy ? null : _send,
            icon: busy ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.auto_awesome_outlined, size: 18),
            label: Text(t('aiSend')),
          ),
        ]),
      ],
    ]));
  }
}
