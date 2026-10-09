import en from '@/locales/en'
import base from '@/locales/ru/base.json'
import cards from '@/locales/ru/cards.json'

type Messages = Record<string, unknown>

const isObject = (value: unknown): value is Messages =>
  typeof value === 'object' && value !== null && !Array.isArray(value)

// Русские строки поверх английских: то, что ещё не переведено, остаётся на английском.
function deepMerge(target: Messages, source: Messages): Messages {
  const result: Messages = { ...target }
  for (const [key, value] of Object.entries(source)) {
    const current = result[key]
    result[key] = isObject(current) && isObject(value) ? deepMerge(current, value) : value
  }
  return result
}

const enMessages = en as Messages
const ruCards = cards as Messages

export default deepMerge(enMessages, {
  ...(base as Messages),
  cards: ruCards,
  label: { cards: ruCards['label'] },
})
