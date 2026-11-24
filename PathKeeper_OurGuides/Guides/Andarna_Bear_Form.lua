-- Andarna's guide: Bear Form through Darnassus and Moonglade (level 10 and up).
-- A Skyborne druid who has left Zephras Isle can take the Night Elf bear chain from the Darnassus
-- druid trainer instead of going home (confirmed in game 2026-11-24: Mathrengyl Bearwalker gave the
-- Moonglade quest and Teleport: Moonglade to a level 11 Skyborne druid).
-- Quest ids, NPCs and coordinates come from PathKeeper 0.33.29's own Teldrassil and Darkshore guides.
local PK = PathKeeper
if not (PK and PK.RegisterGuide) then return end

local DARNASSUS, MOONGLADE, DARKSHORE = 1457, 1450, 1439
local function note(text) return { class = "DRUID", manual = true, text = "Andarna's guide. " .. text } end

PK:RegisterGuide({
    id = "ours-andarna-bear-form",
    name = "Andarna's guide: Bear Form (Darnassus and Moonglade)",
    kind = "custom", -- load with /pk load ours-andarna-bear-form ; /pk detect returns to your route
    faction = "Alliance",
    minLevel = 10,
    maxLevel = 20,
    map = DARNASSUS,
    rev = "5",
    quests = {
        [5921] = "Heeding the Call",
        [5923] = "Heeding the Call",
        [5924] = "Heeding the Call",
        [5925] = "Heeding the Call",
        [5929] = "Great Bear Spirit",
        [5931] = "Back to Darnassus",
        [6001] = "Body and Heart",
    },
    steps = {
        -- If the chain was started at another trainer (Stormwind, Dolanaar), you hold a "Heeding the Call"
        -- that only sends you to Mathrengyl. Optional: a quest you never took does not block the step.
        { turnin = { 5923, 5924, 5925 }, npc = "Mathrengyl Bearwalker", at = { 35.4, 8.4 }, class = "DRUID", optional = true, text = "If another druid trainer gave you Heeding the Call, hand it in to Mathrengyl Bearwalker in the Cenarion Enclave, north-west Darnassus." },
        { accept = { 5921 }, npc = "Mathrengyl Bearwalker", at = { 35.4, 8.4 }, class = "DRUID", text = "Mathrengyl Bearwalker, the druid trainer in the Cenarion Enclave, north-west Darnassus. He gives the Moonglade quest and teaches Teleport: Moonglade." },

        -- Moonglade
        { accept = { 5929 }, turnin = { 5921 }, npc = "Dendrite Starblaze", at = { 56.2, 30.6 }, map = MOONGLADE, class = "DRUID", text = "Cast Teleport: Moonglade. Dendrite Starblaze is in Nighthaven village, where you arrive." },
        { at = { 52.5, 40.6 }, map = MOONGLADE, class = "DRUID", manual = true, text = "Maître de classe : sorts du niveau 10." },
        { complete = { 5929 }, at = { 39.1, 27.5 }, map = MOONGLADE, class = "DRUID", text = "The Great Bear Spirit, north-west of Nighthaven. Talk through everything it has to say." },
        { accept = { 5931 }, turnin = { 5929 }, npc = "Dendrite Starblaze", at = { 56.2, 30.6 }, map = MOONGLADE, class = "DRUID", text = "Back to Dendrite Starblaze in Nighthaven." },

        -- Darnassus, then Darkshore
        note("Getting back: Moonglade has no road out at your level. Use your hearthstone if it is bound near Darnassus; otherwise take the flight master in Nighthaven, who flies druids to Rut'theran Village below Darnassus."),
        { accept = { 6001 }, turnin = { 5931 }, npc = "Mathrengyl Bearwalker", at = { 35.4, 8.4 }, class = "DRUID", text = "Mathrengyl Bearwalker in the Cenarion Enclave. He gives you Cenarion Moondust for the last step." },
        note("Take the portal down to Rut'theran Village and the boat to Auberdine in Darkshore."),
        { complete = { 6001 }, at = { 43.5, 46.0 }, map = DARKSHORE, class = "DRUID", text = "The Moonkin Stone east of Auberdine: use the Cenarion Moondust on it and defeat Lunaclaw. Bring your warrior if you can; you fight this one before you have Bear Form." },
        { turnin = { 6001 }, npc = "Mathrengyl Bearwalker", at = { 35.4, 8.4 }, class = "DRUID", text = "Back to Mathrengyl Bearwalker in Darnassus: you learn Bear Form." },

        note("Done. Head back to the dwarven lands (the boat from Auberdine reaches Menethil Harbor, or hearth), then type /pk detect to return to your leveling route."),
    },
})
