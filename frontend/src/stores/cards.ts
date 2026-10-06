import { defineStore } from 'pinia'
import * as Api from '@/arkham/api'
import type { CardDef } from '@/arkham/types/CardDef'

export interface CardsState {
  cards: CardDef[]
  loaded: boolean
  lang: string
}

let fetchCardsPromise: Promise<CardDef[]> | null = null

export function resetCardsFetch() {
  fetchCardsPromise = null
}

export const useCardStore = defineStore("cards", {
  state: () => ({
    cards: [],
    loaded: false
  } as CardsState),
  getters: {
    getCards(state) {
      return state.cards
    }
  },
  actions: {
    async fetchCards() {
      const currentLang = (localStorage.getItem('language') || 'en').toLowerCase()
      if (this.lang !== currentLang) {
        this.lang = currentLang
        this.loaded = false
        fetchCardsPromise = null
      }
      if (this.loaded) return this.cards

      fetchCardsPromise ??= Api.fetchCards(true)

      try {
        const data = await fetchCardsPromise
        this.cards = data
        this.loaded = true
        return data
      } catch (error) {
        fetchCardsPromise = null
        console.log(error)
      }
    }
  }
})
