<script setup lang="ts">
import { Menu, MenuButton, MenuItems } from '@headlessui/vue'
import { ChevronDownIcon } from '@heroicons/vue/20/solid'
import { ref } from 'vue'

const buttonRef = ref<InstanceType<typeof MenuButton> | null>(null)
const menuStyle = ref<{ top: string; left: string; right: string }>({ top: '0px', left: '0px', right: 'auto' })

function updatePosition() {
  // MenuButton is a Vue component, so the template ref is its instance, not
  // the DOM node the *as* prop renders; the DOM element lives on $el.
  const el = (buttonRef.value as unknown as { $el?: HTMLElement })?.$el
  if (!el) return
  const rect = el.getBoundingClientRect()
  const viewportWidth = window.innerWidth
  // if the menu would overflow the right edge, anchor it to the right of the button instead
  const estimatedMenuWidth = 220
  if (rect.left + estimatedMenuWidth > viewportWidth) {
    menuStyle.value = { top: `${rect.bottom}px`, left: 'auto', right: `${viewportWidth - rect.right}px` }
  } else {
    menuStyle.value = { top: `${rect.bottom}px`, left: `${rect.left}px`, right: 'auto' }
  }
}
</script>

<template>
  <Menu as="div">
    <MenuButton as="button" ref="buttonRef" @click="updatePosition">
      <slot></slot>
      <ChevronDownIcon aria-hidden="true" />
    </MenuButton>
    <transition name="appear">
      <MenuItems class="menu-items" :style="menuStyle">
        <slot name="items"></slot>
      </MenuItems>
    </transition>
  </Menu>
</template>

<style scoped>
.menu-items {
  background-color: var(--background-mid);
  border-bottom-left-radius: 5px;
  border-bottom-right-radius: 5px;
  position: fixed;
  z-index: var(--z-index-10);
  display: flex;
  flex-direction: column;
}

button {
  background: none;
  border: 0;
  display: flex;
  padding: 5px 10px;
  gap: 5px;
  align-items: center;
  &:hover {
    background: rgba(0,0,0,0.4);
  }
}

svg {
  width: 20px;
}

.appear-enter-active, .appear-leave-active {
  transition: opacity 0.2s ease-in-out;
}

.appear-enter-from, .appear-leave-to {
  opacity: 0;
}

.appear-enter-to, .appear-leave-from {
  opacity: 1;
}
</style>
