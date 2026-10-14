import { defineStore } from 'pinia'
import api from '@/api';

export interface SiteSettings {
  assetHost: string
}

const cdnUrl = "https://assets.arkhamhorror.app"
export const baseUrl = import.meta.env.VITE_ASSET_HOST !== undefined ? import.meta.env.VITE_ASSET_HOST : cdnUrl

export const useSiteSettingsStore = defineStore("site_settings", {
  state: () => ({
    assetHost: baseUrl,
  } as SiteSettings),

  getters: {
    getAssetHost(state) {
      return state.assetHost
    }
  },

  actions: {
    async init() {
      //const assetHost = localStorage.getItem('asset-host');
      // if (assetHost !== null && assetHost !== undefined) {
      //   this.assetHost = assetHost
      // } else {
        const result = await api.get('/site-settings')
        if (result.status === 200) {
          // Backend returns assetHost: null to explicitly mean "serve images
          // locally" (see web-entrypoint.sh's ASSET_HOST auto-detection) --
          // `?? baseUrl` was wrongly treating that null the same as "no
          // opinion" and substituting the CDN anyway, so any locally-added
          // image not yet synced to assets.arkhamhorror.app (e.g. a new
          // homebrew campaign's box art) silently failed to load even though
          // it existed on disk and the backend said not to use the CDN.
          this.assetHost = result.data.assetHost ?? ''
          //localStorage.setItem('asset-host', this.assetHost)
        } else {
          this.assetHost = baseUrl
          //localStorage.setItem('asset-host', baseUrl)
        }
      //}
    }
  }
})
