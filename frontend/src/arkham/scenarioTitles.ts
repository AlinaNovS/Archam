// Builds an English-title -> Russian-title lookup for scenario display names.
//
// The backend sends scenario names in English only (scenario.name.title). The RU
// locale scenario/standalone JSON files each carry a top-level "title" key holding
// the Russian name; the matching EN locale file holds the English name under the
// same key. We eagerly glob both trees (mirroring the import.meta.glob pattern
// used in src/locales/homebrew.ts) and pair them up by their shared module path
// suffix (e.g. "theCircleUndone/scenarios/atDeathsDoorstep.json").
const ruModules = import.meta.glob('@/locales/ru/**/scenarios/*.json', { eager: true }) as Record<
  string,
  { default: Record<string, unknown> }
>
const ruStandaloneModules = import.meta.glob('@/locales/ru/standalone/*.json', { eager: true }) as Record<
  string,
  { default: Record<string, unknown> }
>
const enModules = import.meta.glob('@/locales/en/**/scenarios/*.json', { eager: true }) as Record<
  string,
  { default: Record<string, unknown> }
>
const enStandaloneModules = import.meta.glob('@/locales/en/standalone/*.json', { eager: true }) as Record<
  string,
  { default: Record<string, unknown> }
>

function keySuffix(path: string, locale: 'ru' | 'en'): string | null {
  const match = path.match(new RegExp(`/locales/${locale}/(.+)\\.json$`))
  return match ? match[1] ?? null : null
}

function buildEnTitlesBySuffix(): Map<string, string> {
  const out = new Map<string, string>()
  for (const [path, mod] of Object.entries({ ...enModules, ...enStandaloneModules })) {
    const suffix = keySuffix(path, 'en')
    const title = mod.default?.title
    if (suffix && typeof title === 'string' && title.length > 0) {
      out.set(suffix, title)
    }
  }
  return out
}

function buildTranslationMap(): Map<string, string> {
  const enBySuffix = buildEnTitlesBySuffix()
  const out = new Map<string, string>()
  for (const [path, mod] of Object.entries({ ...ruModules, ...ruStandaloneModules })) {
    const suffix = keySuffix(path, 'ru')
    const ruTitle = mod.default?.title
    if (!suffix || typeof ruTitle !== 'string' || ruTitle.length === 0) continue
    const enTitle = enBySuffix.get(suffix)
    if (enTitle) {
      out.set(enTitle, ruTitle)
    }
  }
  return out
}

let translationMap: Map<string, string> | null = null

function getTranslationMap(): Map<string, string> {
  if (!translationMap) {
    translationMap = buildTranslationMap()
  }
  return translationMap
}

// A few multi-part scenarios (e.g. "Ice and Death, Part I"/"Part II"/"Part III")
// share a single locale file/title and are sent by the backend as distinct
// strings per part. Strip a trailing ", Part <roman-or-arabic numeral>" and
// retry against the base title, re-appending a Russian "часть N" suffix.
const romanToArabic: Record<string, string> = { I: '1', II: '2', III: '3', IV: '4', V: '5' }
const partSuffix = /,\s*Part\s*([IVX]+|\d+)\s*$/i

function translatePart(title: string, map: Map<string, string>): string | null {
  const match = title.match(partSuffix)
  if (!match || !match[1]) return null
  const base = title.slice(0, match.index).trim()
  const baseRu = map.get(base)
  if (!baseRu) return null
  const numeral = match[1].toUpperCase()
  const num = romanToArabic[numeral] ?? numeral
  return `${baseRu}, часть ${num}`
}

// Returns the Russian translation of a scenario's English display title when the
// current locale is "ru" and a translation is known; otherwise falls back to the
// original (English) title unchanged, matching this project's established
// "never blank, always fall back to English" rule.
export function translatedScenarioTitle(title: string): string {
  if (localStorage.getItem('language') !== 'ru') return title
  const map = getTranslationMap()
  return map.get(title) ?? translatePart(title, map) ?? title
}
