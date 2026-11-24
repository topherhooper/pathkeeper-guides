-- Runs after every guide file has been loaded against the stub in check.mjs.
-- Checks each registered guide the way PathKeeper will read it, and fails loudly on mistakes.
local STEP_KEYS = {
    accept = "quests", complete = "quests", turnin = "quests", needs = "quests", unless = "quests",
    level = "number", at = "coords", map = "number", npc = "string", text = "string",
    class = "class", race = "any", bind = "any",
    manual = "boolean", optional = "boolean", normal = "boolean", dungeon = "any", deathskip = "any", block = "any",
    ours = "boolean", -- marks a step an overlay added to one of PathKeeper's own guides
}
local CLASSES = { WARRIOR = 1, PALADIN = 1, HUNTER = 1, ROGUE = 1, PRIEST = 1, SHAMAN = 1, MAGE = 1, WARLOCK = 1, DRUID = 1 }
local problems, warnings = {}, {}
local function bad(g, i, msg) problems[#problems + 1] = string.format("%s step %s: %s", g.id, tostring(i), msg) end
local function warn(g, i, msg) warnings[#warnings + 1] = string.format("%s step %s: %s", g.id, tostring(i), msg) end

for _, id in ipairs(PathKeeper.guideOrder) do
    local g = PathKeeper.guides[id]
    local mine = type(g.id) == "string" and g.id:find("^ours%-") ~= nil -- otherwise: one of PathKeeper's guides
    if type(g.id) ~= "string" then bad(g, "-", "id must be a string") end
    if type(g.name) ~= "string" then bad(g, "-", "name is missing") end
    if g.faction and g.faction ~= "Alliance" and g.faction ~= "Horde" then bad(g, "-", "faction must be Alliance or Horde") end
    if mine and g.next and not PathKeeper.guides[g.next] then
        warn(g, "-", "next = '" .. g.next .. "' is not in this pack (fine if it is one of PathKeeper's own guide ids)")
    end
    local quests, used, added = g.quests or {}, 0, 0
    for i, step in ipairs(g.steps) do
        if type(step) == "table" and step.ours then added = added + 1 end
        if type(step) ~= "table" then bad(g, i, "step is not a table")
        elseif mine or step.ours then
            for k, v in pairs(step) do
                local kind = STEP_KEYS[k]
                if not kind then bad(g, i, "unknown field '" .. tostring(k) .. "'")
                elseif kind == "quests" then
                    if type(v) ~= "table" then bad(g, i, k .. " must be a list like { 12345 }") else
                        for _, q in ipairs(v) do
                            if type(q) ~= "number" then bad(g, i, k .. " has a non-number quest id")
                            elseif not quests[q] then warn(g, i, "quest " .. q .. " has no name in the guide's quests table") end
                            used = used + 1
                        end
                    end
                elseif kind == "coords" then
                    if type(v) ~= "table" or type(v[1]) ~= "number" or type(v[2]) ~= "number"
                        or v[1] < 0 or v[1] > 100 or v[2] < 0 or v[2] > 100 then
                        bad(g, i, "at must be { x, y } with both between 0 and 100")
                    end
                elseif kind == "class" then
                    for _, c in ipairs(type(v) == "table" and v or { v }) do
                        if not CLASSES[c] then bad(g, i, "class '" .. tostring(c) .. "' is not a class token like DRUID") end
                    end
                elseif kind ~= "any" and type(v) ~= kind then bad(g, i, k .. " must be a " .. kind) end
            end
            if not step.text and not (step.accept or step.complete or step.turnin) then warn(g, i, "no text and no quest: nothing to show") end
            if step.at and not (step.map or g.map) then bad(g, i, "has coordinates but neither the step nor the guide names a map") end
            if not mine then
                local kind = (step.manual and step.text:find("^Maître de classe") and "trainer stop") or "note"
                print(string.format("      + step %3d of %-20s %-12s %s", i, g.id, kind, (step.text:gsub("^(.-[%.:]).*$", "%1"))))
            end
        end
    end
    if mine then
        print(string.format("ok  %-34s %2d steps, %d quest references, kind=%s", g.id, #g.steps, used, tostring(g.kind)))
    elseif added > 0 then
        print(string.format("ok  %-34s %d of our steps added to its %d, rev=%s", g.id, added, #g.steps, tostring(g.rev)))
    end
end

-- Overlays: every anchor must have been found in the PathKeeper guide it targets.
for _, r in ipairs(PathKeeper.oursOverlayReport or {}) do
    if r.missing then
        warnings[#warnings + 1] = "overlay target '" .. r.id .. "' was not loaded, so that overlay was not tested"
    elseif not r.index then
        problems[#problems + 1] = "overlay for '" .. r.id .. "' found no step matching " .. r.pattern .. " (PathKeeper changed? pick a new anchor)"
    end
end

for _, w in ipairs(warnings) do print("warning: " .. w) end
if #PathKeeper.guideOrder == 0 then error("no guide was registered", 0) end
if #problems > 0 then error(#problems .. " problem(s):\n  " .. table.concat(problems, "\n  "), 0) end
