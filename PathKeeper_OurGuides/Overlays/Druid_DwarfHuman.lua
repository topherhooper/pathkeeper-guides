-- Druid overlay for PathKeeper's dwarf and human route:
--   Dun Morogh (6-12) -> Loch Modan (12-18) -> Redridge (17-25).
-- PathKeeper's own guides for these zones have a trainer stop for every class except druid,
-- because druids could not start there before the Skyborne. This file adds druid-only steps
-- into those guides when the game loads: a trainer stop at each point where the other classes
-- train, followed by a short note on what to set up for tanking and healing dungeons.
-- Nothing in PathKeeper's folder is edited, so its updates do not undo this.
--
-- The "Feral" notes are our own short summary of the Icy Veins Feral Druid leveling guide for
-- WoW Forever by Meyra (https://www.icy-veins.com/wow-forever/feral-druid-leveling, read 2026-11-24).
-- That page has the full talent calculator and gear lists by level; the notes only carry the gist.
-- The weapon-type line is from the same author's Feral overview
-- (https://www.icy-veins.com/wow-forever/feral-druid-melee-dps-and-tank-pve-guide).
local PK = PathKeeper
if not (PK and PK.guides) then return end

local REV = "ours10" -- change when the steps below change, so PathKeeper re-finds your place
PK.oursOverlayReport = {}

-- Trainers whose position comes from PathKeeper's own data.
local MOONGLADE = { npc = "Loganaar", at = { 52.5, 40.6 }, map = 1450 }            -- Nighthaven
local STORMWIND = { npc = "Sheldras Moontree", at = { 35.9, 67.4 }, map = 1453 }   -- the Park

-- A trainer step must start with PathKeeper's French "Maître de classe" and name the level:
-- that is how it knows to tick the step off once you have trained.
local function trainer(level, where, fr)
    return { npc = where.npc, at = where.at, map = where.map, class = "DRUID", manual = true, ours = true,
        text = "Maître de classe (niveau " .. level .. ") : " .. fr }
end
local function note(text)
    return { class = "DRUID", manual = true, ours = true, text = "Andarna's guide. " .. text }
end

-- Profession trainers, from PathKeeper's own profession data (ProfData_Forever.lua).
-- A profession stop is a "walk here" step: it clears when you arrive.
local PROF = {
    IF_HERB = { npc = "Reyna Stonebranch", at = { 55.9, 59.1 }, map = 1455 },
    IF_ALCH = { npc = "Vosur Brakthel", at = { 66.3, 55.7 }, map = 1455 },
    IF_AID = { npc = "Nissa Firestone", at = { 55.1, 58.3 }, map = 1455 },
    SW_AID = { npc = "Shaina Fuller", at = { 53.0, 44.7 }, map = 1453 },
    SW_HERB ={ npc = "Tannysa", at = { 54.3, 84.1 }, map = 1453 },
    SW_ALCH = { npc = "Lilyssia Nightbreeze", at = { 55.7, 86.1 }, map = 1453 },
}
-- Notes for questing as Feral (see the source named at the top of this file).
local function feral(level, text) return note("Feral (level " .. level .. "): " .. text) end
local function prof(where, text)
    return { npc = where.npc, at = where.at, map = where.map, class = "DRUID", ours = true, text = "Andarna's guide. " .. text }
end

-- English for the French trainer lines above (PathKeeper shows its text through a translation table).
local EN = {}
local function english(step, en) EN[step.text] = en; return step end

-- Insert `steps` just before the first step of guide `id` whose text matches `pattern`.
local function overlay(id, pattern, steps)
    local g = PK.guides[id]
    if not g then PK.oursOverlayReport[#PK.oursOverlayReport + 1] = { id = id, missing = true }; return end
    local at
    for i, s in ipairs(g.steps) do
        if type(s.text) == "string" and s.text:find(pattern) then at = i; break end
    end
    PK.oursOverlayReport[#PK.oursOverlayReport + 1] = { id = id, pattern = pattern, index = at, count = #steps }
    if not at then return end
    for k = #steps, 1, -1 do table.insert(g.steps, at, steps[k]) end
    if not (g.rev and tostring(g.rev):find(REV, 1, true)) then g.rev = tostring(g.rev or "") .. "+" .. REV end
end

---------------------------------------------------------------------------
-- Level 10, Dun Morogh: where the other classes train at Kharanos
---------------------------------------------------------------------------
overlay("alliance-dunmorogh", "^Maître de classe %(niveau 10%)", {
    english(trainer(10, STORMWIND, "Sheldras Moontree, le parc de Hurlevent (tram depuis Forgefer)."),
        "Druid trainer (level 10): Sheldras Moontree in the Stormwind Park. Take the Deeprun Tram from Ironforge. Learn Teleport: Moonglade here; later stops use it."),
    note("Healer setup (level 10): tell PathKeeper your role with /pk role soigneur (healer), add your warrior as tank in the Group tab (/pk groupe), and turn dungeon quests on with /pk donjon on. Keep Healing Touch, Rejuvenation, Mark of the Wild and Thorns on your caster bar; Mark and Thorns go on the warrior before every pull."),
    note("Healer gear (level 10): from now on pick Intellect and Spirit on quest rewards, in cloth or leather. Buy water every time you pass an innkeeper: drinking is what sets your pace with a warrior."),
    feral(10, "until Cat Form at 20 you quest as a bear. Before a pull, cast Mark of the Wild and Thorns (Thorns lasts 10 minutes), and Regrowth on yourself for a hard enemy so its heal over time carries into the fight. Tag with Moonfire in busy areas, shift to Bear Form, press Enrage for starting Rage, and spend Rage on Maul. Shift out to heal after the fight, or during it if you might die."),
    feral(10, "talents, from the Icy Veins Feral leveling guide: start with Ferocity, which makes your main attacks cheaper. Feral Instinct and Feral Swiftness follow, mostly for Cat Form at 20. The guide's page has a level slider with the exact point order."),
    note("Bear Form quest (level 10): a Skyborne only gets it on Zephras Isle (the Moonglade quest from mainland trainers just teaches the teleport). Type /pk load ours-andarna-bear-form for the overland route back, then /pk detect to return here. Bear Form is your backup, not your job: it keeps you alive when something turns on you."),
})

---------------------------------------------------------------------------
-- Level 12, start of Loch Modan: the Ironforge training trip
---------------------------------------------------------------------------
overlay("alliance-lochmodan", "^Maître de classe %(niveau 12%)", {
    english(trainer(12, MOONGLADE, "Téléportation : Reflet-de-Lune, Loganaar à Havrenuit, puis la pierre de foyer."),
        "Druid trainer (level 12): cast Teleport: Moonglade, train with Loganaar in Nighthaven, then hearth back. (Or the Stormwind Park by tram.)"),
    prof(PROF.IF_HERB, "Herbalism: Reyna Stonebranch in Ironforge (the Great Forge side). Train the next rank if your skill is 50 or more, so it never stops at the cap."),
    prof(PROF.IF_ALCH, "Alchemy: Vosur Brakthel in Ironforge (Tinker Town side). It is the natural second profession for a herbalist healer: your herbs become mana potions and elixirs. Learn it here if you have not, and buy empty vials from the supplier beside him."),
    prof(PROF.IF_AID, "First Aid: Nissa Firestone in Ironforge, near the herbalism trainer. In Forever, healing potions are made with First Aid (the first one is Peacebloom, mild spices and a vial), and it does not use up a profession slot. Learn it and keep it trained."),
    note("Professions: /pk metiers add herbo and /pk metiers add alchi make PathKeeper track both. /pk metiers then shows where to pick herbs and what to brew at your skill. Turn on Find Herbs and pick everything on your route; brew when you are in town."),
    note("Healing (level 12): Regrowth is your second heal, a quick heal plus a heal over time. Open each pull with Rejuvenation on the warrior, use Regrowth when a hit lands hard, and keep Healing Touch for when you have time to cast it. While questing as a duo, Moonfire and Wrath between heals."),
    feral(12, "your form damage comes from weapon DPS, so take the highest-DPS weapon whatever its speed. Two-handed ones have the most: maces, polearms and staves (many staves are made for casters). The guide's first standout for Alliance is the Ironforge Greathammer from clearing Hall of Thanes. On other gear look for Agility, Strength and Stamina. Demoralizing Roar cuts the damage you take when several enemies are on you, and Thorns does more the more of them hit you."),
    feral(12, "at 16 the Aquatic Form quest opens: do it as soon as you can for underwater quests. Carry food and water, because bear fights still cost health and the mana you heal with. Food made with Cooking also adds 5% experience from kills, and the Cozy Sleeping Bag quest chain adds another 3%."),
    note("First dungeon: Hall of Thanes in Ironforge opens at 13 (recommended 13-20). /pk dj lists dungeons at your level and loads their quest guide; /pk lfg writes the group message with you as healer and your warrior as tank."),
})

---------------------------------------------------------------------------
-- Level 18, end of Loch Modan: before leaving for Stormwind
---------------------------------------------------------------------------
overlay("alliance-lochmodan", "^Maître de classe %(niveau 18%)", {
    english(trainer(18, MOONGLADE, "Téléportation : Reflet-de-Lune, Loganaar à Havrenuit, puis la pierre de foyer."),
        "Druid trainer (level 18): Teleport: Moonglade, train with Loganaar, hearth back. (Or wait for the Stormwind Park: you fly there next.)"),
    note("Professions before Deadmines: brew a stack of the best mana potions (Alchemy) and healing potions (First Aid) that /pk metiers lists for your skill, and keep them for dungeons. If Ironforge is on your way, both trainers are there (Reyna Stonebranch and Vosur Brakthel); otherwise Stormwind is your next stop."),
    note("Healing (levels 14-18): Cure Poison (14) matters in Deadmines. Keep Rejuvenation rolling on the warrior, Regrowth for big hits, Healing Touch when things are calm, and drink while the warrior marks the next pull. Faerie Fire (18) on the warrior's target helps the whole group."),
    feral(18, "Faerie Fire lowers the target's armor, so open with it: it is also a ranged tag. Swipe is your filler once you have it, and the main button against several enemies. Collect a dungeon's quests before you run it, since the quests are where the experience is. Log out at an inn for rested experience."),
    note("Dungeons now: Deadmines is recommended 17-26 and Ruins of Lordaeron 15-22. If a pull goes wrong, Hibernate (18, beasts only) on a loose mob buys more time than a heal, and Bash (14) in Bear Form is your emergency stun."),
})

---------------------------------------------------------------------------
-- Level 20, Redridge: the Stormwind training trip
---------------------------------------------------------------------------
overlay("alliance-redridge", "^Maître de classe.-niveau 20", {
    english(trainer(20, STORMWIND, "Sheldras Moontree, le parc de Hurlevent."),
        "Druid trainer (level 20): Sheldras Moontree in the Stormwind Park."),
    prof(PROF.SW_HERB, "Herbalism: Tannysa in Stormwind, in the Mage Quarter. Train the next rank if /pk metiers says your skill is near its cap."),
    prof(PROF.SW_ALCH, "Alchemy: Lilyssia Nightbreeze in Stormwind, a few steps from Tannysa. Train the next rank and any new recipes."),
    prof(PROF.SW_AID, "First Aid: Shaina Fuller in Stormwind. Train the next rank so you can make the next healing potion; /pk metiers add secourisme tracks it."),
    note("Healing (level 20): Rebirth is a resurrection you can cast in combat (it needs a reagent, so carry some). Cat Form is for moving and for damage while the warrior is safe."),
    feral(20, "the Cat Form quest opens now, and with it Prowl for sneaking past packs you do not need to kill. Cat for one enemy, bear for several (cat has no area damage). In cat: open from Prowl with Shred (Ravage later), keep Rake's bleed on the target without refreshing it early, build with Claw when solo or Shred when you can get behind, and finish with Rip at 4 or more combo points if the enemy will live through it."),
    feral(20, "talents: the next five points go to Feral Charge, Savage Fury and Sharpened Claws, on the way to Lacerate (available at 25) and Blood Frenzy. Lacerate becomes your single-target filler in Bear Form; Swipe stays the filler against groups."),
    note("Talents for a healer: PathKeeper's only healing template is its level 60 Restoration build (/pk talents). Use it to see which Restoration talents exist in Forever and take the cheaper-heal and stronger-heal ones first; its order is written for 60, not for leveling."),
})

---------------------------------------------------------------------------
-- Level 30, Duskwood (second part): the next Stormwind training trip
---------------------------------------------------------------------------
overlay("alliance-duskwood-2", "^Maître de classe.-niveau 30", {
    english(trainer(30, STORMWIND, "Sheldras Moontree, le parc de Hurlevent."),
        "Druid trainer (level 30): Sheldras Moontree in the Stormwind Park. Between trips, Teleport: Moonglade every two levels keeps your heals at the top rank."),
    prof(PROF.SW_HERB, "Herbalism: Tannysa in Stormwind, in the Mage Quarter. Train the next rank if your skill is near its cap."),
    prof(PROF.SW_ALCH, "Alchemy: Lilyssia Nightbreeze, beside Tannysa. Train the next rank and new recipes, and restock vials."),
    feral(30, "Travel Form makes questing much faster. Keep taking the damage talents in the Feral tree up to 40, when Dire Bear Form arrives and you can take Primal Bite and Shifting Power. Primal Bite is used on cooldown in bear. Shifting Power turns mana into Energy in cat: use it on cooldown when under 50 Energy. After that the guide goes into the Restoration and Balance trees for passive damage."),
    note("Healing (levels 24-30): Remove Curse (24) and Abolish Poison (26) are yours to cast, so watch debuffs as well as health. Tranquility (30) is your group heal for when everything goes wrong at once. Stockade is recommended 24-32, Excavation Site: Wetlands 26-33, Gnomeregan 29-38."),
})

---------------------------------------------------------------------------
-- English text for the trainer steps
---------------------------------------------------------------------------
local function fill(T) for fr, en in pairs(EN) do if T[fr] == nil then T[fr] = en end end end
if PK.RegisterLocale and PK.LOCALE_PARTS then PK.RegisterLocale("enUS", fill) end -- locale not applied yet
if PK.TRS and PK.TRS.enUS then fill(PK.TRS.enUS) end                              -- locale already applied
