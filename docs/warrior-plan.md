# Plan: add a friend's warrior to the guide

Status: not started. Written 2026-11-24. Waiting on the warrior's race and role.

## Needed first

- Race: decides the starting zone and whether PathKeeper already has warrior trainer stops on this
  route (dwarf, gnome and human warriors do; a Skyborne warrior would need them added).
- Role: tanking for the druid healer in dungeons is the assumption; confirm it.
- Professions, if profession stops are wanted.
- Client language (PathKeeper shows English on an English client).

## Build

- A warrior-only overlay beside the druid one, using the same anchors (levels 10, 12, 18, 20, 30)
  so both characters make each town trip together.
- Tank notes matched to the healer notes (for example at 18: pulling and marking for Deadmines
  while the healer drinks).
- Warrior class quests: PathKeeper has them for the classic races; for a Skyborne warrior add the
  isle ones (PathKeeper lists a shield quest in Valanaar), as a trip guide like the Bear Form one
  if they have already left the isle.
- Trainer stops only where PathKeeper's guides for that race lack them.

## Duo setup

- Rename the pack for two characters and prefix each note with the character's name.
- README section: add each other in `/pk groupe`, pick the same route, set roles, `/pk donjon on`.
- Check how our added class steps appear to the teammate (PathKeeper can show a teammate's class
  steps) before relying on it.

## Check and ship

- Extend `tools/validate.lua` output to cover the warrior steps.
- Commit and push; the friend re-downloads the ZIP; both restart WoW.
- First test: the level 10 or 12 stop, whichever comes first.

## Open questions

- If the warrior is not in the dwarf starting zone, where and at what level do the two meet?
- Does the friend want to edit their own notes? If so, invite them to the repository.
