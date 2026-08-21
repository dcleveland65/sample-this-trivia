# Sample This! — notes for 2026-08-21

## Where it stands (end of 2026-08-20)

Everything is committed, pushed, and deployed. `git status` clean, `master` in sync with `origin/master`.

- Live: https://sample-this-trivia-game.netlify.app
- 153 questions — Hip-Hop 39, Soul & Funk 41, Rock 32, Classical 16, Yacht Rock 25
- Up to 20 teams
- Two commits today:
  - `e8c6ff4` Fix guest scoreboard, score-undo drift, pause/resume and 8 more defects
  - `5b94dc8` Add 20 songs, 20-team support, invite links and an on-screen setup guide

**Verified working on the live site**, host + guest, zero console errors: create room → copy
invite link → guest joins by name → host starts → guest lands on the live scoreboard → scores
push and re-sort in real time on the guest device.

The guest scoreboard had never worked before today. Cause: `getElementById('gw-spinner')`
returned `null` (the ID didn't exist in the HTML) and threw inside the room-status listener,
one line before `showScreen('guest-scoreboard')`. Guests hung on the waiting screen forever and
every later status message — pause, game over — died on the same listener.

## Do these first

1. **Revoke the GitHub personal access token.** The repo's remote URL had one embedded in
   plaintext. I stripped it from `.git/config` on 2026-08-20, but the token is still valid
   until you revoke it: github.com → Settings → Developer settings → Personal access tokens.
   Delete the one for this repo and, if you still want CLI pushes, let `gh auth login`
   manage credentials instead. This is the only item with a real security clock on it.

2. **Test with an actual phone before game night.** Today's test was two browser tabs on one
   machine — a good proxy, not the same as two networks. Open the site on the laptop, Create
   Room, Copy invite link, text it to yourself, join from cellular (not wifi).

## Worth doing, not urgent

3. **Firebase rules are wide open.** `database.rules.json` is `rooms: {".read": true,
   ".write": true}` — anyone who can guess a 5-character room code can read or delete a game
   in progress. Low stakes for a party game, but a stranger could wipe a live room. Scoping
   writes to the room's own path, or adding a created-at expiry, would close it.

4. **Six questions use the `original` slot for a film or agency, not an older song.**
   Africa, Sailing, Old Time Rock and Roll, You Make My Dreams, Brandenburg Concerto No. 2,
   Also Sprach Zarathustra. Two consequences: the answer overlay labels them
   "✅ The Original Sample" when they aren't one, and **"🎵 Play Original Preview" will not
   find audio** for them — an iTunes search for `Film (Paul Brickman) Risky Business` returns
   nothing. Since the music is the best part of this game, these six are the questions most
   likely to land flat. Either reframe them as real sample pairs or give them their own
   "trivia" flag that swaps the overlay label and hides the preview button.

5. **Clean up stray copies.** `Desktop\sample-this-trivia.html` plus eight
   `sample-this-trivia (N).html` snapshots in Downloads, all from 6/5–6/8. The repo is the
   source of truth; these are just confusing now.

## How to work on it

Single self-contained HTML file, no build step.

Serve and drive it locally:

    py -3 -m http.server 8777 --directory C:\Users\dcleveland\projects\sample-this-trivia

Deploy:

    netlify deploy --prod --dir .

Validate the question bank after any content batch — checks every entry for missing fields,
bad option counts, out-of-range answer indexes, duplicate options, duplicate questions, and
reversed years:

    node validate-questions.js

It currently reports the six reversed-year entries from item 4 and nothing else.
