-- Andarna's guide: overland back to Zephras Isle for Bear Form, for a Skyborne druid who left the
-- isle without it.
--
-- What is known (2026-11-24):
--   * Skyborne Bear Form comes ONLY from the Valanaar chain on Zephras Isle. The "Moonglade" quest
--     from mainland druid trainers only teaches Teleport: Moonglade and has no follow-up
--     (found out in game; the Blizzard forums and fan guides say the same).
--   * The Stormwind portal to Dalaran that some guides mention was not there in game.
--   * The skycutter between Valanaar and Dalaran is how you left; guides say it also runs back.
-- Where the waypoints come from: PathKeeper 0.33.29's own guides (Loch Modan, Wetlands, Arathi,
-- Hillsbrad, the Dalaran arrival point, and the isle quest steps). The Dalaran dock position is
-- PathKeeper's arrival point for the skycutter; fan guides put the dock at about 12.5, 51.8.
-- NOT yet confirmed in game: the walk itself at level 11, and boarding the skycutter in Dalaran.
local PK = PathKeeper
if not (PK and PK.RegisterGuide) then return end

local LOCH, WETLANDS, ARATHI, HILLSBRAD, ALTERAC, ISLE = 1432, 1437, 1417, 1424, 1416, 2521
local function note(text) return { class = "DRUID", manual = true, text = "Andarna's guide. " .. text } end
local function go(map, x, y, text, danger)
    return { at = { x, y }, map = map, class = "DRUID", text = "Andarna's guide. " .. text, danger = danger }
end

PK:RegisterGuide({
    id = "ours-andarna-bear-form",
    name = "Andarna's guide: overland to Zephras Isle for Bear Form",
    kind = "custom", -- load with /pk load ours-andarna-bear-form ; /pk detect returns to your route
    faction = "Alliance",
    minLevel = 10,
    maxLevel = 25,
    map = ISLE,
    rev = "6",
    quests = {
        [94006] = "The Great Ursera Spirit",
        [94638] = "Strength and Mercy",
    },
    steps = {
        note("This is a long run through zones 10 to 25 levels above you. Go with your warrior, stay on the road, do not fight: if something chases you, keep running. Dying is fine; you come back at the nearest graveyard, usually further along. Take every flight point on the way so you never have to walk this again."),

        -- Loch Modan
        go(LOCH, 33.9, 50.9, "Thelsamar in Loch Modan (tram or road from Ironforge, then east through the tunnels). Take the flight point here if you do not have it."),
        go(LOCH, 20.0, 17.0, "North out of Loch Modan: Algaz Station, then the Dun Algaz tunnels into the Wetlands.", "Dragonmaw orcs around level 22 stand near the Dun Algaz road. Run straight through the tunnels and do not stop."),

        -- Wetlands
        go(ARATHI, 48.8, 88.0, "Wetlands: follow the road north, then north-east, to the Thandol Span, the great bridge into the Arathi Highlands. The arrow points at the far (Arathi) end.", "Crocolisks and raptors level 25 to 30 sit right beside the Wetlands road. On the bridge itself, Dark Iron dwarves are elite: cross when their backs are turned."),

        -- Arathi Highlands
        go(ARATHI, 45.7, 46.1, "Arathi Highlands: follow the road north to Refuge Pointe in the middle of the zone and take the flight point (Cedrik Prose).", "Everything here is level 30 or more. Stay in the middle of the road."),
        go(ARATHI, 20.0, 30.0, "West along the road through Thoradin's Wall into the Hillsbrad Foothills."),

        -- Hillsbrad Foothills
        go(HILLSBRAD, 49.3, 52.3, "Hillsbrad: keep to the southern road, south-west to Southshore, and take the flight point (Darla Harris). From now on you can fly here from Ironforge.", "Tarren Mill to the north is a Horde town: stay on the southern road."),
        note("Southshore is the last safe town. Repair, buy water and food here. Do not bind your hearthstone yet: you will bind it on the isle."),

        -- Dalaran
        go(ALTERAC, 12.2, 56.6, "From Southshore go west, then north along the shore of Lordamere Lake to Dalaran, in the south-west corner of the Alterac Mountains. The skycutter dock is where you first arrived from the isle, on the north side of the city (fan guides say about 12.5, 51.8).", "Arcane elementals in groups roam the Dalaran ruins, and guides warn of hostile guards nearby. Keep to the edge and do not fight."),
        note("Wait for the skycutter to Valanaar (every 5 to 10 minutes) and board it. Press next once you land on Zephras Isle. If it will not take you, tell Claude what you see."),

        -- Zephras Isle
        go(ISLE, 62.2, 72.6, "Valanaar. Bind your hearthstone at the inn here first, so a death or a mistake does not cost you the trip."),
        { at = { 64.0, 75.0 }, class = "DRUID", manual = true, text = "Maître de classe : sorts du niveau 10 (Valanaar)." },
        { accept = { 94006 }, npc = "Lotheluum Starbreeze", at = { 64.0, 75.0 }, class = "DRUID", text = "Lotheluum Starbreeze, the druid trainer in Valanaar, gives The Great Ursera Spirit." },
        { accept = { 94638 }, turnin = { 94006 }, npc = "Urs'endris", at = { 69.8, 61.5 }, class = "DRUID", text = "Urs'endris, the great bear spirit, on the islet by the falls north-east of Valanaar, just north of the east watchtower." },
        { complete = { 94638 }, at = { 54.0, 65.4 }, class = "DRUID", text = "Kill Ur'endra, his mate, in the Shen'dar Highlands west of Valanaar (about 54, 65; guides say she is in or near a hillside cave)." },
        { turnin = { 94638 }, npc = "Urs'endris", at = { 69.8, 61.5 }, class = "DRUID", text = "Back to Urs'endris. Talk through everything he says: you learn Bear Form, Growl and Maul." },
        { npc = "Iaadaria Bitterwind", at = { 66.3, 79.5 }, class = "DRUID", text = "Andarna's guide. Optional while you are here: Iaadaria Bitterwind in Valanaar teaches Alchemy." },

        -- Leaving again
        { at = { 64.9, 80.9 }, class = "DRUID", manual = true, text = "Quais aériens de Valanaar : prends le skycutter de gauche, vers Dalaran." },
        go(ALTERAC, 12.0, 56.2, "Dalaran: take the Skyborne Portal to Stormwind, right next to where you land."),
        note("You are back in Stormwind with Bear Form. Bind your hearthstone wherever you are leveling, then type /pk detect to return to your route."),
    },
})
