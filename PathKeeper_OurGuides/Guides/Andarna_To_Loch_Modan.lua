-- Andarna's guide: leaving Dun Morogh early for Loch Modan, doing only the quests that carry on
-- into Loch Modan, Ironforge or the first dungeon. Everything else in Dun Morogh is skipped.
--
-- What carries on (from PathKeeper 0.33.29's own Dun Morogh, Loch Modan and Hall of Thanes data):
--   * Earthseer Farsen's Dark Iron chain (A Visitor to Dun Morogh -> Farsen's Watch -> Nip 'Em in
--     the Bud) ends in Old Ironforge Incursion, a Hall of Thanes dungeon quest. PathKeeper's gear
--     data lists the Ironforge Greathammer (two-hander, 16 DPS) as its reward. PathKeeper's own
--     guide says not to take that quest; we do.
--   * Shimmer Stout (from Brewnall Village) is handed in at the Loch Modan gate for Stout to
--     Kadrell, which is handed in at Thelsamar.
--   * The Reports (after Frostmane Hold) is handed in in Ironforge on the Loch Modan guide's
--     first town trip.
-- Not checked in game yet (written 2026-11-24): that Farsen offers Old Ironforge Incursion right
-- after Nip 'Em in the Bud, and its level requirement.
local PK = PathKeeper
if not (PK and PK.RegisterGuide) then return end

local FARSEN = { 64.9, 58.5 }
local function note(text) return { manual = true, text = "Andarna's guide. " .. text } end

PK:RegisterGuide({
    id = "ours-andarna-to-loch-modan",
    name = "Andarna's guide: Dun Morogh to Loch Modan, key quests only",
    kind = "custom", -- load with /pk load ours-andarna-to-loch-modan
    faction = "Alliance",
    minLevel = 9,
    maxLevel = 13,
    map = 1426, -- Dun Morogh
    next = "alliance-lochmodan",
    rev = "1",
    quests = {
        [96408] = "A Visitor to Dun Morogh",
        [96392] = "Farsen's Watch",
        [96390] = "Nip 'Em in the Bud",
        [96391] = "Underground Map",
        [96393] = "Old Ironforge Incursion",
        [413] = "Shimmer Stout",
        [414] = "Stout to Kadrell",
        [291] = "The Reports",
    },
    steps = {
        note("Only the quests that lead somewhere are here. Skipped on purpose, because they end in Dun Morogh: Father Gavin's refuge, the Amberstill ranch, the Gol'Bolar quarry troggs, the blasting powder and the lost pilot. Hand in what you have already finished if you pass the quest giver."),
        { accept = { 96408 }, optional = true, unless = { 96392, 96390, 96393 }, npc = "Beldin Steelgrill", at = { 50.4, 49.1 }, text = "Andarna's guide. Only if you do not have A Visitor to Dun Morogh yet: Beldin Steelgrill at Steelgrill's Depot, just east of Kharanos, gives it. It starts the chain that ends with a two-handed mace." },
        { accept = { 96392 }, turnin = { 96408 }, npc = "Earthseer Farsen", at = FARSEN, text = "Andarna's guide. Earthseer Farsen, at the camp overlooking the Gol'Bolar Quarry, south of the east road." },
        { complete = { 96392 }, at = FARSEN, text = "Andarna's guide. Talk to Farsen again to see the Dark Iron threat through his eyes." },
        { accept = { 96390 }, turnin = { 96392 }, npc = "Earthseer Farsen", at = FARSEN, text = "Andarna's guide. Earthseer Farsen: take Nip 'Em in the Bud." },
        { complete = { 96390 }, at = { 77.5, 61.2 }, text = "Andarna's guide. 10 Dark Iron spies to the south-east, on the shore of Helm's Bed Lake. If a Dark Iron map drops, right-click it for a bonus quest.", danger = "The spies stand in groups and Captain Beld (level 11) is among them. Pull one at a time, in Bear Form." },
        { accept = { 96391 }, optional = true, at = { 77.5, 61.2 }, text = "Andarna's guide. Optional: the Underground Map quest, if the map dropped." },
        { turnin = { 96390 }, npc = "Earthseer Farsen", at = FARSEN, text = "Andarna's guide. Back to Earthseer Farsen." },
        { accept = { 96393 }, optional = true, npc = "Earthseer Farsen", at = FARSEN, text = "Andarna's guide. Take the follow-up, Old Ironforge Incursion. It is a Hall of Thanes dungeon quest (from level 13, in Ironforge) and PathKeeper's data lists the Ironforge Greathammer as its reward: the first strong weapon for a Feral druid. Keep it in your log until you run the dungeon. If Farsen does not offer it, press next and tell Claude." },
        { turnin = { 96391 }, optional = true, npc = "Earthseer Farsen", at = FARSEN, text = "Andarna's guide. Earthseer Farsen: hand in the map, if you had it." },
        { accept = { 414 }, turnin = { 413 }, optional = true, npc = "Mountaineer Barleybrew", at = { 86.3, 48.8 }, text = "Andarna's guide. Follow the road east to the Loch Modan gate. Mountaineer Barleybrew takes Shimmer Stout and gives Stout to Kadrell, which you hand in at Thelsamar. If you never got Shimmer Stout, skip this: it comes from Brewnall Village far to the west and is not worth going back for." },
        note("Keep The Reports in your log: it is handed in to Senator Barin Redstone in Ironforge, on the first town trip in the Loch Modan guide. Loch Modan is written for level 12, so if you are 10 or 11, fight what you meet on the road and pull carefully at first. Press next and go through the tunnel: the Loch Modan guide takes over."),
    },
})
