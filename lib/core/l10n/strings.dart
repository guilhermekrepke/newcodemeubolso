import '../../data/store.dart';
import 'pt_strings.dart';
import 'en_strings.dart';
import 'es_strings.dart';
import 'zh_strings.dart';
import 'ru_strings.dart';

const kLangs = {'pt': 'Português', 'en': 'English', 'es': 'Español', 'zh': '中文', 'ru': 'Русский'};

const kStrings = <String, Map<String, String>>{'pt': ptStrings, 'en': enStrings, 'es': esStrings, 'zh': zhStrings, 'ru': ruStrings};

String t(String k) => kStrings[store.lang]![k]!;

List<String> get cats => t('cats').split('|');
