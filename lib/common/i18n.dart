enum Language { en }

Map<Language, Map<String, String>> translations = {
  Language.en: {
    'SoftObjectType.log': 'Log',
    'SoftObjectType.leaves': 'Leaves',
    'SoftObjectType.snake': 'Snake',
    'SoftObjectType.cookedSnake': 'Cooked snake'
  }
};

Language currentLanguage = Language.en;

String t(String name) {
  return translations[currentLanguage][name] == null
      ? name
      : translations[currentLanguage][name];
}
