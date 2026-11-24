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

local HILLSBRAD, ALTERAC, ISLE = 1424, 1416, 2521
local function note(text) return { class = "DRUID", manual = true, text = "Andarna's guide. " .. text } end
local function go(map, x, y, text, danger)
    return { at = { x, y }, map = map, class = "DRUID", text = "Andarna's guide. " .. text, danger = danger }
end

PK:RegisterGuide({
    id = "ours-andarna-bear-form",
    name = "Andarna's guide: back to Zephras Isle for Bear Form (by boat)",
    kind = "custom", -- load with /pk load ours-andarna-bear-form ; /pk detect returns to your route
    faction = "Alliance",
    minLevel = 10,
    maxLevel = 25,
    map = ISLE,
    rev = "8",
    quests = {
        [94006] = "The Great Ursera Spirit",
        [94638] = "Strength and Mercy",
    },
    steps = {
        -- By boat to Southshore (Topher's route, 2026-11-24). If there is no Southshore boat, the walk is:
        -- Menethil, east then north-east across the Wetlands to the Thandol Span, north to Refuge Pointe
        -- in Arathi, west through Thoradin's Wall, then the southern Hillsbrad road to Southshore.
        note("The trip is by boat: get to Auberdine in Darkshore (boat from Stormwind Harbor, or from Rut'theran below Darnassus), then take the boat to Menethil Harbor from the Auberdine dock."),
        note("At Menethil Harbor, stay aboard: the boat carries on to Southshore in the Hillsbrad Foothills. Press next when you land in Southshore."),
        go(HILLSBRAD, 49.3, 52.3, "Southshore: take the flight point (Darla Harris). From now on you can fly here from Ironforge."),
        note("Southshore is the last safe town. Repair, buy water and food here. Do not bind your hearthstone yet: you will bind it on the isle."),

        -- Dalaran
        go(ALTERAC, 12.2, 56.6, "This is the one stretch on foot. Go with your warrior, do not fight, and keep running if chased; dying only sends you to the nearest graveyard. From Southshore go west, then north along the shore of Lordamere Lake to Dalaran, in the south-west corner of the Alterac Mountains. The skycutter dock is where you first arrived from the isle, on the north side of the city (fan guides say about 12.5, 51.8).", "Arcane elementals in groups roam the Dalaran ruins, and guides warn of hostile guards nearby. Keep to the edge and do not fight."),
        go(ALTERAC, 12.5, 51.8, "Skycutter dock: the north side of Dalaran, where fan guides place it (one describes it as an outer balcony of the Violet Citadel, up on the second floor near a mailbox). If the ship is not here, try the previous spot, where you first landed from the isle."),
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
