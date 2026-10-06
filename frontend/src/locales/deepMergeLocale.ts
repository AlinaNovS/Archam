// Recursively overlays translated strings onto the English locale tree.
// Any key missing from `override` (not yet translated) falls through to the
// English value instead of disappearing, so partial campaign translations
// never blank out untranslated scenarios/resolutions/tooltips.
export function deepMergeLocale<T>(base: T, override: unknown): T {
  if (override === undefined || override === null) return base
  if (typeof override !== 'object' || Array.isArray(override)) return override as T
  if (typeof base !== 'object' || base === null || Array.isArray(base)) return override as T

  const result: Record<string, unknown> = { ...(base as Record<string, unknown>) }
  for (const key of Object.keys(override as Record<string, unknown>)) {
    result[key] = deepMergeLocale(
      (base as Record<string, unknown>)[key],
      (override as Record<string, unknown>)[key],
    )
  }
  return result as T
}
