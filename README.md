# pathkeeper-guides

Our own guides for the PathKeeper leveling addon (WoW Forever). They live in a separate
addon, `PathKeeper_OurGuides`, so updating PathKeeper never overwrites them.

This is an unofficial companion to [PathKeeper](https://www.curseforge.com/wow/addons/pathkeeper-free-lvl-1-60-multi-lang)
by Malik, and needs it installed. Quest ids, NPC names and coordinates here are taken from PathKeeper's own
guide and profession data (version 0.33.29).

## Install (just to use the guides)

1. Install PathKeeper for WoW Forever.
2. On this page: Code > Download ZIP, and unzip it.
3. Copy the `PathKeeper_OurGuides` folder into `World of Warcraft\_forever_\Interface\AddOns`.
4. Restart WoW and tick "PathKeeper: Andarna's Guide" on the AddOns screen.

To update, download the ZIP again and replace that folder. Nothing else in this repository is needed
to play; the rest is for editing and checking guides.

## Use it in game

- `/pk guides` lists every guide; ours have ids that start with `ours-`.
- `/pk load ours-andarna-bear-form` loads one (the overland route back to Zephras Isle for Bear Form, for a Skyborne druid who left without it). `/pk detect` goes back to PathKeeper's own route.
- `/pk load ours-andarna-to-loch-modan` is the short way out of Dun Morogh: only the quests that carry on into Loch Modan, Ironforge or the Hall of Thanes dungeon (including the one PathKeeper tells you to skip, whose reward is the Ironforge Greathammer). It hands over to PathKeeper's Loch Modan guide when finished.
- Our guides set `kind = "custom"`, so PathKeeper's auto-detect never switches to them by itself.

## The druid overlay (dwarf and human route)

`Overlays\Druid_DwarfHuman.lua` does not register a guide. It adds druid-only steps into three of
PathKeeper's own guides when the game loads: Dun Morogh (6-12), Loch Modan (12-18) and Redridge
(17-25). PathKeeper has no druid trainer stops there, so the overlay adds one wherever the other
classes train (levels 10, 12, 18, 20 and 30), each followed by notes on the bear and healer kit for
dungeons at that level. Notes clear with the next-step button.

Each stop also carries one or two notes that start "Feral (level N)": how to quest as a Feral
druid at that level (bear and cat rotation, gear, talents to take, what unlocks next). They are our own short
summary of the [Icy Veins Feral Druid leveling guide for WoW Forever](https://www.icy-veins.com/wow-forever/feral-druid-leveling)
by Meyra, read on 2026-11-24. The same author's [Feral overview](https://www.icy-veins.com/wow-forever/feral-druid-melee-dps-and-tank-pve-guide)
links the rest (talents, rotation, stats, gear, class quests). The exact talent order and the gear lists are on that page (it has a
level slider); the notes only carry the gist, so re-read the page if it is updated.

To follow that route on a Skyborne druid:

- `/pk route` lists the routes; pick the dwarf one (it starts in Dun Morogh) with `/pk route <number>`.
- `/pk donjon on` shows dungeon quests inside the zone guides; `/pk dj` lists dungeons at your level.
- `/pk role tank` or `/pk role soigneur` (healer) sets the role used in the group-finder message (`/pk lfg`).
- `/pk talents` shows PathKeeper's druid builds.

Each overlay is anchored to a line of PathKeeper's guide (the first trainer stop for a given level).
If a PathKeeper update moves or removes that line, the check fails and names the anchor to fix.

## Change or add a guide

1. Edit a file in `PathKeeper_OurGuides\Guides\`, or add a new one and list it in `PathKeeper_OurGuides.toc`.
2. When you change a guide's steps, change its `rev` too. PathKeeper then re-finds your place instead of trusting the old step number.
3. Run the install script. It checks every guide first and copies nothing if the check fails.

```powershell
powershell -ExecutionPolicy Bypass -File install.ps1
```

4. In game: `/reload` after editing an existing file; fully restart WoW after adding a new file.

The check (`npm run check`, needs `npm install` once) runs the guide files in a real Lua
interpreter with a stand-in for PathKeeper. It proves the files load and the fields are
well formed. It cannot prove a quest id or coordinate is right; only playing does that.

## Guide format

```lua
PathKeeper:RegisterGuide({
    id = "ours-something",        -- unique; used by /pk load
    name = "Shown in the guide list",
    kind = "custom",              -- keeps auto-detect away from it
    faction = "Alliance",         -- optional
    minLevel = 1, maxLevel = 14,
    map = 2521,                   -- default map id for every step's coordinates
    next = "alliance-westfall",   -- optional: guide id to chain into when finished
    rev = "1",
    quests = { [92485] = "A Student of Nature" },  -- fallback names for quests not in your log
    steps = { ... },
})
```

A step is one table. It is done when all of its conditions are true:

| Field | Meaning |
|---|---|
| `accept = { id }` | pick up these quests |
| `complete = { id }` | finish these quests' objectives |
| `turnin = { id }` | hand these quests in |
| `level = 10` | reach this level |
| `at = { x, y }` | where the arrow points; a step with only `at` is done on arrival |
| `map = 1453` | map id for this step, when it differs from the guide's |
| `npc`, `text` | who to talk to, and the line shown |
| `class = "DRUID"`, `race = { "NightElf", "Skyborne" }` | only for that class or race |
| `optional = true` | a quest you never took does not block the step |
| `needs = { id }`, `unless = { id }` | show only if, or hide if, one of those quests is done or in your log |
| `manual = true` | never completes by itself (see below) |

## Things that are easy to get wrong

- **Trainer stops.** PathKeeper recognises a class-trainer step by its French text: `manual = true`
  plus text starting `Maître de classe` and containing `niveau N`. Only then does it tick the
  step off once you have trained. Copy the exact French line from PathKeeper's own guide and it
  is shown in English in game. Any other `manual` step clears only with the next-step button.
- **Text language.** PathKeeper's own text is French with a translation table. Text we write in
  English is shown as written.
- **Where the data comes from.** PathKeeper's guides in `Interface\AddOns\PathKeeper\GuidesForever`
  are the easiest source of quest ids, NPC names, coordinates and map ids. Questie's database
  (`Interface\AddOns\QuestieDB`) has the rest.
