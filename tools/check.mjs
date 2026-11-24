// Loads every file listed in the .toc into a real Lua VM (fengari) with a stand-in for PathKeeper,
// then runs tools/validate.lua on what got registered. Exit code 1 means something is wrong.
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import fengari from 'fengari';

const { lua, lauxlib, lualib, to_luastring } = fengari;
const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const addon = path.join(root, 'PathKeeper_OurGuides');
const tocPath = path.join(addon, 'PathKeeper_OurGuides.toc');

const L = lauxlib.luaL_newstate();
lualib.luaL_openlibs(L);

// asAddonFile: run the chunk the way WoW runs an addon file, with (addonName, privateTable) as its arguments.
function run(code, name, asAddonFile = false) {
  const buf = to_luastring(code.replace(/^﻿/, ''));
  let ok = lauxlib.luaL_loadbuffer(L, buf, buf.length, to_luastring('@' + name)) === lua.LUA_OK;
  if (ok && asAddonFile) {
    lua.lua_pushstring(L, to_luastring('PathKeeper'));
    lua.lua_getglobal(L, to_luastring('PathKeeper'));
  }
  ok = ok && lua.lua_pcall(L, asAddonFile ? 2 : 0, 0, 0) === lua.LUA_OK;
  if (!ok) {
    console.error('FAILED ' + name + '\n' + lua.lua_tojsstring(L, -1));
    process.exit(1);
  }
}

run(
  `PathKeeper = { guides = {}, guideOrder = {} }
   function PathKeeper:RegisterGuide(g)
     assert(type(g) == "table" and g.id and type(g.steps) == "table", "invalid guide (id and steps are required)")
     assert(not self.guides[g.id], "two guides share the id " .. tostring(g.id))
     self.guides[g.id] = g
     table.insert(self.guideOrder, g.id)
   end`,
  'stub'
);

const files = fs
  .readFileSync(tocPath, 'utf8')
  .split(/\r?\n/)
  .map((l) => l.trim())
  .filter((l) => l && !l.startsWith('#'));

for (const dir of ['Guides', 'Overlays']) {
  if (!fs.existsSync(path.join(addon, dir))) continue;
  for (const f of fs.readdirSync(path.join(addon, dir)).filter((f) => f.endsWith('.lua'))) {
    if (!files.some((t) => t.replace(/\\/g, '/') === dir + '/' + f)) {
      console.error(`FAILED ${dir}/${f} exists but is not listed in the .toc, so the game would never load it`);
      process.exit(1);
    }
  }
}

// Overlays change PathKeeper's own guides, so load the installed ones first (if PathKeeper is installed here).
const pkGuides =
  process.env.PATHKEEPER_GUIDES ||
  'C:\\Program Files (x86)\\World of Warcraft\\_forever_\\Interface\\AddOns\\PathKeeper\\GuidesForever';
if (fs.existsSync(pkGuides)) {
  const real = fs.readdirSync(pkGuides).filter((f) => f.endsWith('.lua'));
  for (const f of real) run(fs.readFileSync(path.join(pkGuides, f), 'utf8'), 'PathKeeper/' + f, true);
  console.log(`Loaded ${real.length} of PathKeeper's own guide files from ${pkGuides}`);
} else {
  console.log('PathKeeper is not installed at the usual path, so overlays are not tested against its guides.');
}

for (const rel of files) {
  const p = path.join(addon, ...rel.split(/[\\/]/));
  if (!fs.existsSync(p)) {
    console.error('FAILED the .toc lists a file that does not exist: ' + rel);
    process.exit(1);
  }
  run(fs.readFileSync(p, 'utf8'), rel);
}

run(fs.readFileSync(path.join(root, 'tools', 'validate.lua'), 'utf8'), 'validate.lua');
console.log('All guides loaded and passed the checks.');
