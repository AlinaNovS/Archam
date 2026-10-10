// `side-stories.json`'s per-scenario `deckRequirements` array holds plain
// English display strings with no i18n key at all (unlike the matching
// `requiredInvestigator` field, which already goes through
// `$t('create.requiresInvestigator', ...)`). Found 2026-10-10: these English
// requirement lines showed up untranslated in the new-game "challenge
// scenario" picker even though everything else on the page was Russian.
// Only 2 distinct strings exist in side-stories.json today (grep
// 'deckRequirements' there before adding a 3rd).
const deckRequirementTitles: Record<string, string> = {
  "Daisy Walker's deck must include at least 4 non-weakness Tome assets.":
    'Колода Дейзи Уокер должна включать не менее 4 активов типа «Том» без характеристики «слабость».',
  'Requires investigator with parallel content':
    'Требуется сыщик с альтернативным дополнением',
}

export function translatedDeckRequirement(text: string): string {
  if (localStorage.getItem('language') !== 'ru') return text
  return deckRequirementTitles[text] ?? text
}
