-- Andarna's guide: the trip back home to Zephras Isle for the level 10 druid quest (Bear Form),
-- and back to the mainland afterwards.
-- Quest ids, NPCs and coordinates on the isle and in Dalaran come from PathKeeper 0.33.29's own
-- Zephras guide. The way back TO the isle is not described in any addon data: PathKeeper only
-- documents leaving (skycutter Valanaar -> Dalaran, then the Skyborne Portal -> Stormwind), so
-- the return legs below assume the same portal and skycutter also run the other way.
local PK = PathKeeper
if not (PK and PK.RegisterGuide) then return end

local function note(text) return { class = "DRUID", manual = true, text = "Andarna's guide. " .. text } end

PK:RegisterGuide({
    id = "ours-andarna-bear-form",
    name = "Andarna's guide: home for Bear Form (level 10)",
    kind = "custom", -- load with /pk load ours-andarna-bear-form ; /pk detect returns to your route
    faction = "Alliance",
    minLevel = 10,
    maxLevel = 20,
    map = 2521, -- Zephras Isle
    rev = "3",
    quests = {
        [94006] = "The Great Ursera Spirit",
        [94638] = "Strength and Mercy",
    },
    steps = {
        { level = 10, class = "DRUID", text = "Reach level 10: the Bear Form quest opens at your trainer in Valanaar." },

        -- Getting home
        note("Check your hearthstone first: if it is still bound to Zephras Isle (Shen'dar or Valanaar), use it and press next until the Valanaar step. Otherwise follow the next steps."),
        note("In Stormwind, take the Skyborne Portal back to Dalaran. It should be where you first arrived from Dalaran; no addon records its position, so this step has no arrow. Press next once you are in Dalaran."),
        { at = { 12.2, 56.6 }, map = 1416, class = "DRUID", text = "Dalaran: the skycutter dock next to the Skyborne Portal. Board the skycutter to Zephras Isle; it lands at the Valanaar Skydocks." },
        { at = { 64.9, 80.9 }, class = "DRUID", text = "Valanaar Skydocks. Your trainer is a short walk north-west." },

        -- The quest
        { at = { 64.0, 75.0 }, class = "DRUID", manual = true, text = "Maître de classe : sorts du niveau 10 (Valanaar)." },
        { accept = { 94006 }, npc = "Lotheluum Starbreeze", at = { 64.0, 75.0 }, class = "DRUID", text = "Lotheluum Starbreeze, the druid trainer in Valanaar, starts the bear spirit quest." },
        { accept = { 94638 }, turnin = { 94006 }, npc = "Urs'endris", at = { 69.8, 61.5 }, class = "DRUID", text = "Urs'endris, the great bear spirit, near the falls north-east of Valanaar, just north of the east watchtower." },
        { complete = { 94638 }, at = { 54.0, 65.4 }, class = "DRUID", text = "Find Ur'endra, the mate of Urs'endris, west of Valanaar (54, 65)." },
        { turnin = { 94638 }, npc = "Urs'endris", at = { 69.8, 61.5 }, class = "DRUID", text = "Back to Urs'endris: you receive Bear Form." },

        -- While you are home: a second profession
        { npc = "Iaadaria Bitterwind", at = { 66.3, 79.5 }, class = "DRUID", text = "Andarna's guide. Alchemy: Iaadaria Bitterwind in Valanaar teaches the apprentice rank. It pairs with your Herbalism and makes mana potions and elixirs for dungeons (in Forever, healing potions come from First Aid instead). Skip with the next button if you would rather choose later." },

        -- Back to the mainland
        { at = { 64.9, 80.9 }, class = "DRUID", manual = true, text = "Quais aériens de Valanaar : prends le skycutter de gauche, vers Dalaran." },
        { at = { 12.0, 56.2 }, map = 1416, class = "DRUID", text = "Dalaran: take the Skyborne Portal to Stormwind, right next to where you land." },
        note("You are back in Stormwind. Ironforge is one Deeprun Tram ride away. Type /pk detect to return to your leveling route."),
    },
})
