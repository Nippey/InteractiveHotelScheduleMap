## Hotel Interactive Map

A responsive, multilingual hotel map showing food/drink and activity opening times together with interactive locations on a hotel map.

### Usage and features

Open the hosted web app in a browser. The app automatically selects a configured language matching the browser language when possible; use the language buttons to switch manually. Food/drink and activity timelines show the configured daily time ranges. Click an entry, time block, or map marker to keep the corresponding location highlighted and display available time details. A blue line marks the current local browser time. The layout adapts to narrow screens.

### Developer reference

#### Files
- index.html: user interface, rendering, localization, selection, current-time marker, and debug editor.
- mapData.json: all hotel-specific text, entries, positions, and opening times.
- map.png: hotel map image used by the UI.
- manifest.webmanifest: installable web-app metadata.
- service-worker.js: application-shell caching/offline fallback.

#### JSON structure

Top level: `hotelName`, `languages`, and `entries`.

Each language supports `lang`, `code`, `flag`, `foodTitle`, `activityTitle`, and `footnote`. Array ordering is significant: `entries[].names` and `entries[].times[].tag` use the same language order.

Each entry supports `names`, normalized `pos: [x,y]`, `times`, and `type` (`food` or `activity`). Time objects support `time`, optional localized `tag`, `showTimeInCell`, `showTimeInTag`, and optional `short`.

#### #debug mode and visual JSON editor

Append `#debug` to the page URL. The map cursor changes to a crosshair and clicking the map shows normalized coordinates.

The debug page also contains a visual editor for the loaded `mapData.json`, rather than a raw JSON text field. Languages and activities/entries are shown row by row and one row can be edited at a time. Form controls include text fields, text areas, selects and checkboxes. Activities/entries and time windows can be added or removed dynamically. Selecting **Done** rebuilds the visible map and timelines from the edited data.

While an activity/entry row is in **Edit** mode, click the hotel map to copy the clicked normalized coordinates directly into that row's **Position X** and **Position Y** fields. The editor displays a reminder for this function.

Use **Download mapData.json** to download the modified configuration for deployment on the server.

### Example AI prompt for completing and validating translations

```text
You are reviewing and completing the JSON below.

Tasks:
1. Complete ONLY missing translations in `languages[].foodTitle`, `languages[].activityTitle`, `languages[].footnote`, every `entries[].names` array, and every existing `entries[].times[].tag` array.
2. Cross-check translations that already exist in the different languages for mutual semantic plausibility.
3. If existing translations appear inconsistent, contradictory, mistranslated, or unexpectedly different in meaning, preserve the existing values and output a warning identifying the JSON path, languages/values involved, and suspected mismatch.

Rules:
1. Target languages and exact array order are defined by the top-level `languages` array (`code`/`lang`).
2. Use available plausible translations as the semantic source for missing positions.
3. A value is missing if its language position does not exist, is empty, or is clearly a placeholder such as `todo`.
4. Preserve already valid translations exactly. Do not translate proper names unless a localized form is clearly appropriate.
5. Preserve `\n`, `*`, punctuation, time strings, emojis, JSON types, key names, entry order, `pos`, `type`, `short`, `showTimeInCell`, and `showTimeInTag`.
6. Do not add a `tag` where none exists.
7. Ensure every completed `names` and existing `tag` array has exactly one value per item in `languages`, in the same order.
8. Return two sections: `WARNINGS` (or `None`) followed by `JSON` containing the complete valid JSON.
9. Do not silently correct an existing questionable translation merely because it triggered a plausibility warning.

JSON:
<PASTE mapData.json HERE>
```
