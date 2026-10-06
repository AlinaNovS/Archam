import en from "@/locales/en"
import { deepMergeLocale } from "@/locales/deepMergeLocale"
import { homebrewMessages } from "@/locales/homebrew"
import enEventRaw from "@/locales/en/event.json"
import enCampaignLogRaw from "@/locales/en/campaignLog.json"
import enGameBoardRaw from "@/locales/en/gameBoard/gameBoard"
import ruBase from "@/locales/ru/base.json"
import ruCards from "@/locales/ru/cards.json"
import ruEvent from "@/locales/ru/event.json"
import ruCampaignLog from "@/locales/ru/campaignLog.json"
import ruGameBoard from "@/locales/ru/gameBoard/gameBoard"
import ruInvestigators from "@/locales/ru/investigators.json"
import ruLog from "@/locales/ru/log.json"
import ruXp from "@/locales/ru/xp.json"
import ruLabel from "@/locales/ru/label.json"
import ruTheLabyrinthsOfLunacyLog from "@/locales/ru/theLabyrinthsOfLunacy.json"
import ruNightOfTheZealot from "@/locales/ru/nightOfTheZealot"
import ruTheDunwichLegacy from "@/locales/ru/theDunwichLegacy"
import ruThePathToCarcosa from "@/locales/ru/thePathToCarcosa"
import ruTheForgottenAge from "@/locales/ru/theForgottenAge"
import ruTheInnsmouthConspiracy from "@/locales/ru/theInnsmouthConspiracy"
import ruTheCircleUndone from "@/locales/ru/theCircleUndone"
import ruTheDreamEaters from "@/locales/ru/theDreamEaters"
import ruEdgeOfTheEarth from "@/locales/ru/edgeOfTheEarth"
import ruBrethrenOfAsh from "@/locales/ru/brethrenOfAsh"
import ruTheScarletKeys from "@/locales/ru/theScarletKeys"
import ruTheFeastOfHemlockVale from "@/locales/ru/theFeastOfHemlockVale"
import ruTheDrownedCity from "@/locales/ru/theDrownedCity"
import ruStandalone from "@/locales/ru/standalone"

const enHomebrew = homebrewMessages('en')
const ruHomebrewRaw = homebrewMessages('ru')
const mergedHomebrew: Record<string, unknown> = {}
for (const scope of new Set([...Object.keys(enHomebrew), ...Object.keys(ruHomebrewRaw)])) {
  mergedHomebrew[scope] = deepMergeLocale(enHomebrew[scope], ruHomebrewRaw[scope])
}

const mergedCardLabel = { ...(en.label?.cards ?? {}), ...ruCards.label }
const mergedCards = {
  ...(en.cards ?? {}),
  label: mergedCardLabel,
  tooltips: { ...(en.cards?.tooltips ?? {}), ...ruCards.tooltips },
}

export default {
  ...en,
  ...ruBase,
  ...deepMergeLocale(enEventRaw, ruEvent),
  ...deepMergeLocale(enCampaignLogRaw, ruCampaignLog),
  ...deepMergeLocale(enGameBoardRaw, ruGameBoard),
  ...mergedHomebrew,
  cards: mergedCards,
  label: {
    ...deepMergeLocale(en.label, ruLabel),
    cards: mergedCardLabel,
  },
  investigators: deepMergeLocale(en.investigators, ruInvestigators),
  log: deepMergeLocale(en.log, ruLog),
  xp: deepMergeLocale(en.xp, ruXp),
  theLabyrinthsOfLunacy: deepMergeLocale(en.theLabyrinthsOfLunacy, ruTheLabyrinthsOfLunacyLog),
  nightOfTheZealot: deepMergeLocale(en.nightOfTheZealot, ruNightOfTheZealot),
  theDunwichLegacy: deepMergeLocale(en.theDunwichLegacy, ruTheDunwichLegacy),
  thePathToCarcosa: deepMergeLocale(en.thePathToCarcosa, ruThePathToCarcosa),
  theForgottenAge: deepMergeLocale(en.theForgottenAge, ruTheForgottenAge),
  returnToTheForgottenAge: deepMergeLocale(en.theForgottenAge, ruTheForgottenAge),
  theInnsmouthConspiracy: deepMergeLocale(en.theInnsmouthConspiracy, ruTheInnsmouthConspiracy),
  theCircleUndone: deepMergeLocale(en.theCircleUndone, ruTheCircleUndone),
  theDreamEaters: deepMergeLocale(en.theDreamEaters, ruTheDreamEaters),
  edgeOfTheEarth: deepMergeLocale(en.edgeOfTheEarth, ruEdgeOfTheEarth),
  brethrenOfAsh: deepMergeLocale(en.brethrenOfAsh, ruBrethrenOfAsh),
  theScarletKeys: deepMergeLocale(en.theScarletKeys, ruTheScarletKeys),
  theFeastOfHemlockVale: deepMergeLocale(en.theFeastOfHemlockVale, ruTheFeastOfHemlockVale),
  theDrownedCity: deepMergeLocale(en.theDrownedCity, ruTheDrownedCity),
  standalone: deepMergeLocale(en.standalone, ruStandalone),
}
