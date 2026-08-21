# Operating Sample This!

Everything needed to run a game night and keep the thing alive. **No game code on this
branch** — that lives on `master` (`index.html`, one self-contained file, no build step).

---

## Run a game night

1. Open **https://sample-this-trivia-game.netlify.app** on the screen everyone can see.
2. Name the teams (2–20), pick question set / difficulty / timer, or just hit **🎵 Let's Play**.
3. For phones: **+ Create Room** → **📋 Copy invite link** (`…/?room=CODE`) → send it.
   Players open it, type a name, press Enter. They appear in your lobby.
4. **▶ Start Game.** Guests get a live scoreboard that updates the moment you award points.

**Host controls:** ⏸ Pause freezes the countdown and the music on every device. Clicking a
team's award button a second time undoes that award cleanly, streak bonus included.

**Before a real game night:** test the invite link with an actual phone on cellular, not two
tabs on one machine. Two tabs prove the code path, not two networks.

---

## Deploy

    netlify deploy --prod --dir .

Publishes the whole folder from `master`. `_redirects` keeps housekeeping files from being
served publicly — it only takes effect on the next deploy.

---

## Maintain

Validate the question bank after any content change (checks missing fields, bad option
counts, out-of-range answer indexes, duplicate options, duplicate questions, reversed years):

    node validate-questions.js

Expect it to flag exactly six reversed-year entries — those are known and explained in
`NOTES.md`. Anything beyond six is new and worth a look.

---

## If the machine is gone

Restore from `_RESET-BACKUP-2026-08-20/bundles/sample-this-trivia.bundle` in OneDrive:

    git clone sample-this-trivia.bundle sample-this-trivia

**Clone the bundle, not a branch** — other repos in that backup keep work on
`backup/*-pre-scrub` tags that a branch clone would silently drop. As of 2026-08-20 every
repo also reads truly-unpushed = 0, so GitHub is a valid source too.

---

## Where things are

| Thing | Where |
|---|---|
| Game (single file) | `master` → `index.html` |
| Live site | https://sample-this-trivia-game.netlify.app |
| Repo | github.com/dcleveland65/sample-this-trivia |
| Rooms backend | Firebase Realtime DB, config inline in `index.html` |
| Tomorrow's to-dos | `NOTES.md` on this branch |
