-- Skyborne druid: class quests and trainer stops on Zephras Isle (levels 2-12).
-- Quest ids, NPC names and coordinates come from PathKeeper 0.33.29's own Zephras guide
-- (the druid-only steps, which are the same in its Alliance and Horde versions).
local PK = PathKeeper
if not (PK and PK.RegisterGuide) then return end

PK:RegisterGuide({
    id = "ours-skyborne-druid-zephras",
    name = "Andarna's guide: Skyborne druid class quests (2-12)",
    kind = "custom", -- never picked by auto-detect; load it with /pk load ours-skyborne-druid-zephras
    minLevel = 1,
    maxLevel = 14,
    map = 2521, -- Zephras Isle
    rev = "1", -- change this whenever the steps change, so PathKeeper re-finds your place
    quests = {
        [92485] = "A Student of Nature",
        [94006] = "The Great Ursera Spirit",
        [94638] = "Strength and Mercy",
    },
    steps = {
        -- Thendal: first class quest
        { level = 2, class = "DRUID", text = "Reach level 2: Rorian's class quest opens." },
        { accept = { 92485 }, npc = "Rorian the Dayseeker", at = { 42.0, 23.5 }, class = "DRUID", text = "Rorian the Dayseeker, in the middle of Thendal, sends you to your druid trainer." },
        { turnin = { 92485 }, npc = "Xyton Silverwind", at = { 41.6, 23.4 }, class = "DRUID", text = "Xyton Silverwind, just west of Rorian." },

        -- Trainer stops. The text of a trainer step must stay in PathKeeper's own French wording
        -- ("Maître de classe ... niveau N"): that is how it recognises the step and ticks it off
        -- once you have trained. It is shown translated in game.
        { level = 4, class = "DRUID", text = "Reach level 4 before leaving Thendal." },
        { at = { 41.6, 23.4 }, class = "DRUID", manual = true, text = "Maître de classe : sorts du niveau 4 (avant de partir de Thendal)." },
        { level = 6, class = "DRUID", text = "Reach level 6 on the way south to Shen'dar." },
        { at = { 45.2, 44.2 }, class = "DRUID", manual = true, text = "Maître de classe : sorts du niveau 6 (Shen'dar)." },

        -- Valanaar: bear form
        { level = 10, class = "DRUID", text = "Reach level 10, then head to Valanaar for the bear form quests." },
        { at = { 64.0, 75.0 }, class = "DRUID", manual = true, text = "Maître de classe : sorts du niveau 10 (Valanaar)." },
        { accept = { 94006 }, npc = "Lotheluum Starbreeze", at = { 64.0, 75.0 }, class = "DRUID", text = "Lotheluum Starbreeze, the druid trainer in Valanaar, starts the bear spirit quest." },
        { accept = { 94638 }, turnin = { 94006 }, npc = "Urs'endris", at = { 69.8, 61.5 }, class = "DRUID", text = "Urs'endris, the great bear spirit, east of Valanaar just north of the tower." },
        { complete = { 94638 }, at = { 54.0, 65.4 }, class = "DRUID", text = "Find Ur'endra, the mate of Urs'endris, a little way south-west (54, 65)." },
        { turnin = { 94638 }, npc = "Urs'endris", at = { 69.8, 61.5 }, class = "DRUID", text = "Back to Urs'endris: you receive Bear Form." },

        -- Last stop before leaving the island
        { level = 12, class = "DRUID", text = "Reach level 12 before you leave the island." },
        { at = { 64.0, 75.0 }, class = "DRUID", manual = true, text = "Maître de classe : sorts du niveau 12 avant de quitter l'île." },
    },
})
