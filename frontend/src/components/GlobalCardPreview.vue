​<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'

const cardSelector = 'img.card, img.card-front, img.card-back, img.in-hand, img.no-overlay, canvas.card'
const hoverOffset = 24
const previewWidth = 320
const previewHeight = 460
const longPressMs = 600
const moveTolerance = 14

const modalVisible = ref(false)
const hoverVisible = ref(false)
const previewSrc = ref('')
const previewAlt = ref('Card preview')
const previewRotation = ref(0)
const hoverLeft = ref(20)
const hoverTop = ref(20)
const supportsHover = ref(false)
const isTouch = ref(false)

let modalOpenedAt = 0
let pressCard: HTMLElement | null = null
let pressTimer: ReturnType<typeof setTimeout> | null = null
let pressStartX = 0
let pressStartY = 0

const hoverStyle = computed(() => ({
  left: `${hoverLeft.value}px`,
  top: `${hoverTop.value}px`,
}))
const previewImageStyle = computed(() => previewRotation.value ? { transform: `rotate(${previewRotation.value}deg)` } : undefined)

function updateInput() {
  supportsHover.value = window.matchMedia('(hover: hover) and (pointer: fine)').matches
  isTouch.value = window.matchMedia('(pointer: coarse)').matches || 'ontouchstart' in window
}

function toElement(target: EventTarget | null): Element | null {
  return target instanceof Element ? target : null
}

function findCardElement(target: EventTarget | null): HTMLElement | null {
  return (toElement(target)?.closest(cardSelector) as HTMLElement | null) ?? null
}

function getPreviewSrc(el: HTMLElement): string {
  if (el instanceof HTMLImageElement) return el.currentSrc || el.src || ''
  return el.dataset.image || el.getAttribute('data-image') || ''
}

function getPreviewAlt(el: HTMLElement): string {
  if (el instanceof HTMLImageElement) return el.alt || 'Card preview'
  return el.dataset.cardCode || el.getAttribute('data-card-code') || 'Card preview'
}

function setPreviewFromElement(el: HTMLElement): boolean {
  const src = getPreviewSrc(el)
  if (!src) return false
  previewSrc.value = src
  previewAlt.value = getPreviewAlt(el)
  previewRotation.value = Number(el.dataset.previewRotation || 0)
  return true
}

function openPreviewFrom(el: HTMLElement): boolean {
  if (!setPreviewFromElement(el)) return false
  hoverVisible.value = false
  modalVisible.value = true
  modalOpenedAt = Date.now()
  // CardOverlay tracks hover independently (its selector matches in-hand
  // cards too) and won't dismiss itself just because our modal opened —
  // without this it stays rendered behind/beside our modal, showing the
  // same card twice at two different sizes.
  document.dispatchEvent(new CustomEvent('arkham:clear-card-overlay'))
  return true
}

function closePreview() {
  modalVisible.value = false
  hoverVisible.value = false
}

function updateHoverPosition(event: MouseEvent) {
  const maxLeft = Math.max(12, window.innerWidth - previewWidth - 12)
  const maxTop = Math.max(12, window.innerHeight - previewHeight - 12)
  hoverLeft.value = Math.min(event.clientX + hoverOffset, maxLeft)
  hoverTop.value = Math.min(event.clientY + hoverOffset, maxTop)
}

// ---------- Desktop: hover preview (no click interception) ----------

function onDocumentMouseMove(event: MouseEvent) {
  if (!supportsHover.value || modalVisible.value) return

  const card = findCardElement(event.target)
  if (!card || !setPreviewFromElement(card)) {
    hoverVisible.value = false
    return
  }

  // CardOverlay already handles hover for regular game cards (including
  // in-hand cards); skip floating preview to avoid showing the same card
  // image twice.
  if (!card.classList.contains('no-overlay') &&
      (card.classList.contains('card') || card.classList.contains('card-front') ||
       card.classList.contains('card-back') || card.classList.contains('in-hand'))) {
    hoverVisible.value = false
    return
  }

  updateHoverPosition(event)
  hoverVisible.value = true
}

function onDocumentMouseLeave() {
  if (!modalVisible.value) hoverVisible.value = false
}

// Right-click on a card opens the enlarged preview (desktop).
function onContextMenu(event: MouseEvent) {
  const card = findCardElement(event.target)
  if (!card) return
  event.preventDefault()
  if (supportsHover.value && !modalVisible.value) openPreviewFrom(card)
}

// ---------- Touch: tap = game action, long-press = enlarge ----------

function clearPress() {
  if (pressTimer !== null) {
    clearTimeout(pressTimer)
    pressTimer = null
  }
  pressCard = null
}

function onPointerDown(event: PointerEvent) {
  if (!isTouch.value && event.pointerType !== 'touch') return
  if (modalVisible.value) return

  clearPress()
  const card = findCardElement(event.target)
  if (!card) return

  pressCard = card
  pressStartX = event.clientX
  pressStartY = event.clientY

  pressTimer = setTimeout(() => {
    if (!pressCard) return
    // Mark the card so the release click is consumed by us (the user asked
    // for the zoom, not for the game action), then open the enlarged view.
    pressCard.dataset.previewBypass = '1'
    openPreviewFrom(pressCard)
  }, longPressMs)
}

function onPointerMove(event: PointerEvent) {
  if (!pressCard || pressTimer === null) return
  const dx = event.clientX - pressStartX
  const dy = event.clientY - pressStartY
  if (Math.hypot(dx, dy) > moveTolerance) clearPress()
}

function onPointerUp() {
  clearPress()
}

// ---------- Click: NEVER steal a game action ----------

function onDocumentClick(event: MouseEvent) {
  const card = findCardElement(event.target)

  // A long-press just happened on this card: its release click must not reach
  // the game (the user intentionally asked for the zoom).
  if (card && card.dataset.previewBypass === '1') {
    delete card.dataset.previewBypass
    event.preventDefault()
    event.stopPropagation()
    if (typeof event.stopImmediatePropagation === 'function') {
      event.stopImmediatePropagation()
    }
    return
  }

  // Grace period right after the zoom opened (long-press release lands on the
  // modal backdrop): don't let the backdrop close it instantly.
  if (Date.now() - modalOpenedAt < 350) {
    event.preventDefault()
    event.stopPropagation()
    return
  }

  if (card) {
    console.debug('[GlobalCardPreview] click passed through to the game — the app owns this interaction')
  }
}

function onBackdropClick() {
  // Backdrop clicks during the long-press grace period are swallowed above.
  closePreview()
}

function onKeydown(event: KeyboardEvent) {
  if (event.key === 'Escape') closePreview()
}

onMounted(() => {
  updateInput()
  window.addEventListener('resize', updateInput)
  document.addEventListener('mousemove', onDocumentMouseMove, true)
  document.addEventListener('mouseleave', onDocumentMouseLeave, true)
  document.addEventListener('contextmenu', onContextMenu, true)
  document.addEventListener('pointerdown', onPointerDown, true)
  document.addEventListener('pointermove', onPointerMove, true)
  document.addEventListener('pointerup', onPointerUp, true)
  document.addEventListener('pointercancel', onPointerUp, true)
  document.addEventListener('click', onDocumentClick, true)
  document.addEventListener('keydown', onKeydown)
})

onBeforeUnmount(() => {
  clearPress()
  window.removeEventListener('resize', updateInput)
  document.removeEventListener('mousemove', onDocumentMouseMove, true)
  document.removeEventListener('mouseleave', onDocumentMouseLeave, true)
  document.removeEventListener('contextmenu', onContextMenu, true)
  document.removeEventListener('pointerdown', onPointerDown, true)
  document.removeEventListener('pointermove', onPointerMove, true)
  document.removeEventListener('pointerup', onPointerUp, true)
  document.removeEventListener('pointercancel', onPointerUp, true)
  document.removeEventListener('click', onDocumentClick, true)
  document.removeEventListener('keydown', onKeydown)
})
</script>

<template>
  <Teleport to="body">
    <div v-if="hoverVisible && previewSrc && !modalVisible" class="global-card-preview global-card-preview--hover" :style="hoverStyle" aria-hidden="true">
      <img :src="previewSrc" :alt="previewAlt" :style="previewImageStyle" />
    </div>

    <div v-if="modalVisible && previewSrc" class="global-card-preview-modal" @click.self="onBackdropClick">
      <div class="global-card-preview-modal__content">
        <button class="global-card-preview-modal__close" type="button" aria-label="Close card preview" @click="closePreview">×</button>
        <img :src="previewSrc" :alt="previewAlt" :style="previewImageStyle" class="global-card-preview-modal__image" />
        <div class="global-card-preview-modal__actions">
          <button type="button" class="preview-action" @click="closePreview">Close</button>
        </div>
      </div>
    </div>
  </Teleport>
</template>

<style scoped>
.global-card-preview {
  position: fixed;
  z-index: 1400;
  pointer-events: none;
  width: min(320px, 28vw);
  max-width: calc(100vw - 24px);
  border-radius: 14px;
  overflow: hidden;
  box-shadow: 0 18px 48px rgba(0, 0, 0, 0.48);
  background: rgba(0, 0, 0, 0.82);
  border: 1px solid rgba(255, 255, 255, 0.12);
}

.global-card-preview img {
  display: block;
  width: 100%;
  height: auto;
  border-radius: 12px;
}

.global-card-preview-modal {
  position: fixed;
  z-index: 1500;
  inset: 0;
  background: rgba(0, 0, 0, 0.72);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 16px;
}

.global-card-preview-modal__content {
  position: relative;
  width: min(420px, 94vw);
  max-height: 96vh;
  display: flex;
  flex-direction: column;
  gap: 12px;
  align-items: center;
}

.global-card-preview-modal__image {
  display: block;
  width: 100%;
  height: auto;
  max-height: calc(96vh - 88px);
  object-fit: contain;
  border-radius: 14px;
  box-shadow: 0 18px 54px rgba(0, 0, 0, 0.56);
}

.global-card-preview-modal__close {
  position: absolute;
  top: 8px;
  right: 8px;
  width: 38px;
  height: 38px;
  border: 0;
  border-radius: 999px;
  background: rgba(0, 0, 0, 0.74);
  color: #fff;
  font-size: 28px;
  line-height: 1;
  cursor: pointer;
}

.global-card-preview-modal__actions {
  display: flex;
  gap: 10px;
  width: 100%;
}

.preview-action {
  flex: 1;
  min-height: 44px;
  border-radius: 12px;
  border: 1px solid rgba(147, 212, 109, 0.38);
  background: #2e5e31;
  color: #fff;
  font-size: 0.98rem;
  font-weight: 700;
}

@media (max-width: 900px) {
  .global-card-preview--hover {
    display: none;
  }
}
</style>
