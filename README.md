# 🎵 Sample This! — 70s & 80s Music Trivia

A group trivia game testing whether you can identify the classic 70s/80s song that was sampled to make a modern hit.

## Features
- **134 questions** across Hip-Hop (31), Soul & Funk (35), Rock (30), Classical (15) and Yacht Rock (23)
- **Difficulty filter** — All / Easy / Med + Hard, independent of the category filter
- **Answer positions reshuffled every game** — the right answer is never always A
- **iTunes 30-second previews** auto-play when each question loads
- **Time-based scoring** — answer faster, score more points
- **Early-round bonus** — first third of questions worth 1.5× points
- **Streak bonuses** — 3 correct in a row earns +50% bonus
- **Speed Round mode** — 15-second timer, double points
- **Points-by-round chart** at game end
- **Tie-breaker round** — guess the year the original was released
- **Up to 15 teams** with 70s/80s band names (Fleetwood Mac, Led Zeppelin, ABBA…)
- **🌐 Firebase multiplayer** — live room codes, guest scoreboards, host pause syncs to every device

## Live multiplayer
Firebase is already configured for this project — hit **+ Create Room** on the setup screen and
share the 5-letter code. Guests open the same URL, enter the code, and get a live scoreboard that
updates the moment the host awards points. Host pause and game-over both push to every device.

If the Firebase CDN is unreachable (offline, restricted wifi) the panel hides itself and
local pass-and-play carries on normally.

To point it at a different Firebase project: Build → Realtime Database → Create database, then
copy `firebaseConfig` into `const FB_CONFIG = {…}` near the bottom of `index.html`.

## Playing the game
Open `index.html` in any modern browser. No install or server required for offline play —
though the iTunes previews and the Rumours background art do need a connection.

## Built with
- Vanilla HTML/CSS/JavaScript (single-file, zero dependencies for core game)
- [Chart.js](https://www.chartjs.org/) for the end-of-game score chart
- [iTunes Search API](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/) for 30-second song previews
- [Firebase Realtime Database](https://firebase.google.com/products/realtime-database) (optional) for multiplayer sync
