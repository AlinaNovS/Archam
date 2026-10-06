import { defineStore } from 'pinia'

export interface ArkhamDBCard {
  code: string
  name: string
  xp?: number
  subname?: string
  traits?: string
  text?: string
  back_name?: string
  back_traits?: string
  back_text?: string
  customization_text?: string
  flavor? :string
  back_flavor?: string
  faction_name: string
  faction2_name?: string
  faction3_name?: string
  faction_code?: string
  type_name: string
  pack_name: string
  real_name: string
  real_traits: string
  real_text: string
  type_code: string
  // "weakness" | "basicweakness"; absent on non-weakness cards
  subtype_code?: string
  is_unique: boolean
  double_sided: boolean
  encounter_code?: string
  // Investigator cards only: required signature cards keyed by code, each
  // mapping to its alternate versions (also keyed by code).
  deck_requirements?: {
    size?: number
    card?: Record<string, Record<string, string> | null>
    random?: unknown[]
  }
}

export interface DbCardsState {
  dbCards: ArkhamDBCard[]
  dbCardsIndex: Map<string, ArkhamDBCard>
  lang: string
  loadingLang: string | null
  localizeIndex: Map<string, ArkhamDBCard>
  localizeLang: string
  loadingLocalizeLang: string | null
}

interface LocalOverlay {
  name?: string
  subname?: string | null
  text?: string
  flavor?: string
  traits?: string
  type_name?: string
  faction_name?: string
}

export const useDbCardStore = defineStore("dbCards", {
  state: (): DbCardsState => ({
    dbCards: [],
    dbCardsIndex: new Map(),
    lang: 'en',
    loadingLang: null,
    localizeIndex: new Map(),
    localizeLang: '',
    loadingLocalizeLang: null
  } as DbCardsState),

  actions: {
    getDbCard(code: string): ArkhamDBCard | null {
      if (this.dbCards.length < 1) {
        void this.initDbCards()
      }

      // ArkhamDB stores some split-card fronts with an "a" suffix, while the
      // game runtime refers to the same front using the unsuffixed code.
      return this.dbCardsIndex.get(code) ?? this.dbCardsIndex.get(`${code}a`) ?? null
    },

    getCardName(cardTitle: string, typeCode: string = ""): string {
      if (this.dbCards.length < 1) {
        const language = localStorage.getItem('language') || 'en'
        if (language !== 'en') void this.initDbCards()
      }

      const i = typeCode
        ? this.dbCards.find((c: ArkhamDBCard) =>  c.type_code === typeCode && c.real_name == cardTitle)
        : this.dbCards.find((c: ArkhamDBCard) =>  c.real_name == cardTitle)

      return i ? i.name : cardTitle
    },

    /**
     * Per-card overlay: patches `name`, `subname`, `text`, `flavor`, `traits`,
     * `type_name`, `faction_name` from `/cards/cards_<lang>.json`. Falls back
     * to EN field-by-field when the local dump has no entry / empty value.
     * No-op for `en` / unknown lang / missing dump.
     */
    async localizeCard<T extends { name?: unknown; subname?: unknown; text?: unknown; flavor?: unknown; traits?: unknown; type_name?: unknown; faction_name?: unknown; cardCode?: string; art?: string }>(card: T): Promise<T> {
      const lang = (localStorage.getItem('language') || '').toLowerCase()
      if (!lang || lang.startsWith('en')) return card
      try { await this.fetchLocalize(lang) } catch { return card }
      const code = ((card.art ?? card.cardCode) || '').replace(/^c/, '') || ''
      const e = this.localizeIndex.get(code) as LocalOverlay | undefined
      if (!e) return card
      const nameObj = (card.name && typeof card.name === 'object') ? { ...(card.name as Record<string, unknown>) } : { title: card.name as unknown as string }
      if (e.name != null && e.name !== '') nameObj.title = e.name
      if (e.subname != null && e.subname !== '') nameObj.subtitle = e.subname
      return {
        ...(card as Record<string, unknown>),
        name: nameObj,
        ...(e.text != null && e.text !== '' ? { text: e.text } : {}),
        ...(e.flavor != null && e.flavor !== '' ? { flavor: e.flavor } : {}),
        ...(e.traits != null && e.traits !== '' ? { traits: e.traits } : {}),
        ...(e.type_name != null && e.type_name !== '' ? { type_name: e.type_name } : {}),
        ...(e.faction_name != null && e.faction_name !== '' ? { faction_name: e.faction_name } : {})
      } as unknown as T
    },

    async fetchDbCards(lang: string) {
      const data = await fetch(`/cards/cards_${lang}.json`.replace(/^\//, '')).then(async (cardResponse) => {
        return await cardResponse.json()
      })

      if (this.lang !== lang) return

      this.dbCards = data
      const index = new Map<string, ArkhamDBCard>()
      for (const card of data as ArkhamDBCard[]) {
        index.set(card.code, card)
        index.set(`${card.code}b`, card)
      }
      this.dbCardsIndex = index
    },

    async fetchLocalize(lang: string) {
      if (this.localizeLang === lang && this.localizeIndex.size > 0) return
      if (this.loadingLocalizeLang === lang) return
      this.loadingLocalizeLang = lang
      try {
        const url = `/cards/cards_${lang}.json`.replace(/^\//, '')
        const resp = await fetch(url)
        let arr: LocalOverlay[] = []
        if (resp.ok) {
          arr = await resp.json()
        }
        if (!resp.ok || !Array.isArray(arr) || arr.length === 0) {
          // fall back to EN if dump missing
          if (lang !== 'en') {
            const r2 = await fetch('/cards/cards_en.json'.replace(/^\//, ''))
            if (r2.ok) arr = await r2.json()
          }
        }
        const idx = new Map<string, LocalOverlay>()
        for (const c of arr as Array<LocalOverlay & { code?: string }>) {
          if (c && c.code) idx.set(String(c.code), c)
        }
        this.localizeIndex = idx
        this.localizeLang = lang
      } finally {
        if (this.loadingLocalizeLang === lang) this.loadingLocalizeLang = null
      }
    },

    async initDbCards() {
      const language = localStorage.getItem('language') || 'en'

      if (this.lang === language && this.dbCards.length > 0) return
      if (this.loadingLang === language) return

      this.lang = language
      this.loadingLang = language

      try {
        await this.fetchDbCards(language)
      } finally {
        if (this.loadingLang === language) this.loadingLang = null
      }
    }
  }
})
