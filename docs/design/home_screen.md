# Home Screen — Design Reference

> Source: Stitch project `projects/8651053354437738829` ("K-Trip Spot"), screen
> `921cc26427404bd5b0c3ce3b1443de64` ("Home Screen"), and the project's
> `designTheme.designMd` (DESIGN.md). Spec: `problem/k_trip_spot_홈_스크린_개발.md`.
>
> Stitch is a **layout/structure reference only** — do not copy hex values,
> px sizes, or the `Be Vietnam Pro` / `Plus Jakarta Sans` fonts from the Stitch
> export. This app's font is **Pretendard** (per CLAUDE.md / DESIGN.md §4). Map
> everything to Flutter theme tokens per §3 below.

---

## 1. Screen anatomy (top → bottom)

```
Scaffold
└─ SafeArea
   └─ CustomScrollView / ListView
      ├─ HomeAppBar (SliverAppBar or fixed AppBar)
      │   ├─ leading/title: "K-Trip Spot" wordmark (title-lg style, on_surface)
      │   └─ actions: [ IconButton(Icons.favorite_border) ]  -- favorites entry
      │                (route not built yet this step → onPressed shows a
      │                 disabled affordance or SnackBar placeholder; do not
      │                 wire a real route)
      │
      ├─ HomeSearchBar (component: home_search_bar)
      │   └─ non-interactive TextField-look container:
      │       Icons.search (leading) + hint text (l10n key, EN default:
      │       "Search for spots, hidden gems…") — disabled/read-only this step
      │
      ├─ Section: "Recommended for You"
      │   ├─ SectionHeader(title: recommendedForYou, trailing: "View all" TextButton)
      │   └─ Horizontal ListView (scrollDirection: horizontal) of SpotCard
      │       (card anatomy → §4 component list)
      │       mock items: Gyeongbokgung Palace (Jongno-gu, Low),
      │                    Seongsu-dong Cafe Street (Seongdong-gu, Moderate)
      │
      ├─ Section: "Happening Now"
      │   ├─ SectionHeader(title: happeningNow, trailing: none per Stitch —
      │   │   confirm with slice-builder; spec does not show a "View all" here)
      │   └─ Vertical ListView (shrinkWrap, non-scrollable nested — parent
      │       scroll owns it) of EventCard
      │       mock items: Myeongdong Food Fest (Festival),
      │                    K-Pop Dance Busking (Live / music_note),
      │                    Media Art Expo (Art / palette)
      │
      ├─ Section: "Popular Spots"
      │   ├─ SectionHeader(title: popularSpots, trailing: none observed)
      │   └─ Vertical ListView of PopularSpotCard
      │       mock items: N Seoul Tower (4.8★, Very Busy · 2.4km away),
      │                    Bukchon Hanok Village (rating, Quiet · 3.1km away)
      │
      └─ bottom padding to clear the floating nav (>= nav height + spacing.md)

FloatingBottomNavBar (component, lives outside scroll, anchored via Stack /
Scaffold.bottomNavigationBar with floating margin)
  tabs: Home | Map | Discover (center-emphasized) | Events | Chat
```

Notes:
- The three sections share one vertical scroll (the page itself scrolls);
  only "Recommended for You" scrolls horizontally, per spec §3.
- Favorites route and search behavior are explicitly out of scope this step
  (spec §2.2) — build the widgets but keep them inert.
- The floating bottom nav is **shell-level**, not part of `home_screen.dart`
  — it belongs to the router's `StatefulShellRoute` shell widget (spec §6/§7).
  It's documented here because its visual spec came from this same screen.

---

## 2. DESIGN.md token mapping

All values below come from the actual `designMd` front-matter fetched from
the Stitch project. Do **not** hardcode any hex/px — reference the
`ThemeExtension` / `ColorScheme` role or `TextTheme` slot named here.

### 2.1 Color roles (M3 `ColorScheme`, seed `#EA4A3F`)

| Use in Home Screen | ColorScheme role |
|---|---|
| Scaffold background | `colorScheme.surface` (background) |
| App bar surface | `colorScheme.surface` / `surfaceContainerLowest` |
| Card surface (spot/event/popular cards) | `colorScheme.surfaceContainerLow` / `surfaceContainer` |
| Primary text (titles, on_surface) | `colorScheme.onSurface` |
| Secondary text (location, descriptors) | `colorScheme.onSurfaceVariant` |
| Outline / dividers / card border | `colorScheme.outlineVariant` |
| "View all" link, active/primary accents | `colorScheme.primary` |
| Favorite heart icon (filled state, future) | `colorScheme.primary` / `colorScheme.error`-adjacent per M3 favorite convention — confirm with product; default to `primary` |
| Event category badge background | `colorScheme.tertiaryContainer` (tertiary = amber gold, used for events/highlights per DESIGN.md §3) |
| Event category badge text/icon | `colorScheme.onTertiaryContainer` |
| Discover tab emphasis (center nav item) | `colorScheme.primary` container per DESIGN.md §8 |

### 2.2 Congestion semantic colors → custom `ThemeExtension`

Per spec §4/§7 and DESIGN.md §3 "커스텀 시맨틱 색상", these are **not** M3
roles — they must be exposed via a dedicated `ThemeExtension` (e.g.
`CongestionColors`) living in `common/theme/` (shared by Home cards and the
future Map screen markers):

| CongestionLevel | Token name | Hex (source value, do not hardcode in widgets) |
|---|---|---|
| `low` ("Low" / "Quiet") | `congestion-low` | `#2E9E5B` |
| `moderate` ("Moderate") | `congestion-medium` | `#F5A623` |
| `high` ("High" / "Very Busy") | `congestion-high` | `#E23B2E` |

The `ThemeExtension` should expose `low`, `moderate`, `high` `Color` getters
(names TBD by slice-builder, e.g. `low`/`medium`/`high` to mirror the token
suffixes). Badge text should use a contrasting on-color (white or
`onSurface` depending on contrast — slice-builder picks per accessibility,
not from Stitch literal).

### 2.3 Typography

Map Stitch's named scale to Flutter's `TextTheme` slots (`Theme.of(context).textTheme.*`).
Font family is **Pretendard**, not the Stitch export fonts — only the scale
*names/sizes/weights* are a reference, and even those should flow through
the app's actual `TextTheme` (Material Theme Builder output), not be
re-hardcoded per widget.

| Stitch token | Used for | Flutter `TextTheme` slot (nearest M3 mapping) |
|---|---|---|
| `title-lg` (22/500) | "K-Trip Spot" app bar title | `titleLarge` |
| `title-md` (16/500) | Section headers ("Recommended for You", etc.), card titles (spot/event name) | `titleMedium` |
| `label-lg` (14/500) | "View all" link, badge labels (congestion, category) | `labelLarge` |
| `label-sm` (11/500) | Small badge text, distance/rating caption if compact | `labelSmall` |
| `body-md` (14/400) | Card descriptors, event subtitle | `bodyMedium` |
| `body-lg` (16/400) | Search bar hint text | `bodyLarge` |

### 2.4 Spacing / radius

| Token | Value | Applied to |
|---|---|---|
| `spacing.md` | 16px | Screen horizontal margin (`margin-mobile`), gutter between cards |
| `spacing.sm` | 8px | Inner card padding between elements (badge ↔ title), badge internal padding |
| `spacing.lg` | 24px | Vertical space between sections |
| `spacing.xs` | 4px | Icon-to-text gap inside badges |
| `radius.md` (`12px` region — DESIGN.md §5 defines `md 12`) | Spot/event/popular card corner radius |
| `radius.lg` (`20px` per §5) | Search bar container radius, larger emphasis surfaces |
| `radius.full` | Floating bottom nav pill shape, badge chips (pill-shaped congestion/category badges) |

Use whichever `ThemeExtension`/`ShapeTheme` the app defines for these
(spacing.dart / radius.dart under `common/theme/` if not already present) —
do not inline `EdgeInsets.all(16)` etc. without going through a shared
constant/token, consistent with "no hardcoded values" (§3 below).

---

## 3. Agent rules restated (DESIGN.md §12 — absolute, non-negotiable)

1. **No hardcoded colors/fonts/spacing/radius.** Everything through
   `Theme.of(context)` or a `ThemeExtension` token (congestion colors, spacing
   scale if modeled as an extension).
2. **Icons: `Icons.*` only** (Material). Concretely for this screen:
   `Icons.favorite_border` (app bar), `Icons.search` (search bar),
   `Icons.location_on` (location badge), `Icons.star` (rating),
   category icons `Icons.festival` (or closest Material icon)/`Icons.music_note`
   (Live)/`Icons.palette` (Art), nav icons `Icons.home`, `Icons.map`,
   `Icons.explore` (Discover), `Icons.event`, `Icons.chat_bubble_outline`
   (exact icon choices are for slice-builder to finalize against the
   Material icon set, but must stay within `Icons.*`).
3. **All text via l10n keys**, EN default, extended to KO/JA/ZH. No literal
   strings in widgets — includes section titles, "View all", search hint,
   congestion labels (Low/Moderate/High), category labels (Festival/Live/Art),
   distance/rating strings, nav tab labels.
4. **Stitch export = layout/structure reference only.** Card composition,
   section order, and grouping are authoritative; specific colors, fonts,
   and pixel values from the Stitch HTML/screenshot are NOT to be copied
   literally — always resolve through the theme.
5. State management: **Riverpod**. Routing: **GoRouter** (per spec §5/§6).

---

## 4. Components to extract

All under `lib/domain/home/component/` unless noted (floating nav is
shell-level, likely `common/widget/` or `router/` per spec §7).

### `home_search_bar`
- **Inputs:** none required (static/disabled this step); optionally
  `onTap` callback (unused/no-op for now) for future wiring.
- **Renders:** rounded container, `Icons.search` leading, l10n hint text,
  `radius.lg`-ish shape, `surfaceContainer`-family background.

### `section_header`
- **Inputs:** `title` (String, from l10n at call site), `onViewAll`
  (`VoidCallback?`, null hides the trailing link).
- **Renders:** row with `titleMedium`-styled title + optional "View all"
  `TextButton` in `primary`.

### `spot_card` (horizontal — "Recommended for You")
- **Inputs:** `TouristSpot` — `imageUrl` (or placeholder), `name`,
  `locationLabel` (e.g. "Seoul, Jongno-gu"), `congestion` (`CongestionLevel`).
- **Renders:** fixed-width card, top image (or color-block placeholder per
  spec §4 "이미지는 목은 자산 placeholder 또는 색 블록"), title, location
  badge (`Icons.location_on` + text), congestion badge (pill, colored via
  `CongestionColors` extension, label text from l10n).

### `event_card` ("Happening Now")
- **Inputs:** `TourEvent` — `imageUrl`/placeholder, `title`, `category`
  (enum or string: Festival/Live/Art), category icon derived from category.
- **Renders:** list-row card, category badge (icon + label, `tertiaryContainer`
  background), title, optional subtitle/time if present in model.

### `popular_spot_card` ("Popular Spots")
- **Inputs:** `TouristSpot` — `imageUrl`/placeholder, `name`, `descriptor`
  (short text), `rating` (double, e.g. 4.8), `congestion` (`CongestionLevel`),
  `distanceKm` (double).
- **Renders:** vertical card, image, title, `Icons.star` + rating, descriptor
  text, combined congestion+distance line (e.g. "Very Busy · 2.4km away")
  where the congestion word maps to `CongestionLevel` label (l10n) and color
  (extension), distance formatted from `distanceKm`.

### `floating_bottom_nav` (shell-level component)
- **Inputs:** `currentIndex` (int, 0–4), `onTap(int)` callback.
- **Renders:** floating rounded `NavigationBar`-style container, 5 items
  (Home/Map/Discover/Events/Chat) with `Icons.*`, Discover visually
  emphasized (center, larger icon/container or elevated background using
  `primary`/`primaryContainer`) per DESIGN.md §8. Labels via l10n.
- Lives outside `domain/home/` — belongs to the router shell per spec §6/§7,
  but documented here since it's visually specified on this same screen.

### Supporting shared piece (not a UI component, but implied by cards above)
- `CongestionColors` `ThemeExtension` in `common/theme/` exposing colors for
  `low`/`moderate`/`high`, reused by Home cards and (later) Map markers.

---

## 5. Gaps / open questions for slice-builder

- Stitch export shows no "View all" trailing link on "Happening Now" or
  "Popular Spots" sections — only "Recommended for You" has one. Confirm
  before adding one to the other two (spec doesn't call for it either).
- Favorite heart icon in the app bar has no destination screen yet (spec
  §2.2 explicitly excludes it) — implement as inert/disabled or a toast,
  not a real route.
- Event card subtitle/time field is not detailed in the spec's mock examples
  (only title + category given) — `TourEvent` model should stay minimal per
  spec §4 unless product adds fields.
- Exact spacing/radius numeric values in §2.4 are carried over from the
  Stitch `designMd` front-matter as the closest available token reference;
  slice-builder should resolve them against whatever `ThemeExtension`/
  constants already exist in `lib/common/theme/` (or create them if absent)
  rather than inlining literals.
