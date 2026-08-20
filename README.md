# 🎵 Sample This! — 70s & 80s Music Trivia

A group trivia game testing whether you can identify the classic 70s/80s song that was sampled to make a modern hit.

## Features
- **153 questions** across Hip-Hop (39), Soul & Funk (41), Rock (32), Classical (16) and Yacht Rock (25)
- **Difficulty filter** — All / Easy / Med + Hard, independent of the category filter
- **Answer positions reshuffled every game** — the right answer is never always A
- **iTunes 30-second previews** auto-play when each question loads
- **Time-based scoring** — answer faster, score more points
- **Early-round bonus** — first third of questions worth 1.5× points
- **Streak bonuses** — 3 correct in a row earns +50% bonus
- **Speed Round mode** — 15-second timer, double points
- **Points-by-round chart** at game end
- **Tie-breaker round** — guess the year the original was released
- **Up to 20 teams** with 70s/80s band names (Fleetwood Mac, Led Zeppelin, ABBA…)
- **On-screen setup guide** — a "How to set up a game" panel walks a first-time host through it
- **🌐 Firebase multiplayer** — one-tap invite link, guest scoreboards, host pause syncs everywhere

## Running a game

1. Name your teams (2–20), pick a question set / difficulty / timer, hit **🎵 Let's Play**.
2. A 30-second clip of the modern hit plays automatically. Teams shout out the original.
3. Click the answer they call — or **🔓 Reveal Answer** when the clock runs out. Faster = more points.
4. Tap every team that got it right, then **Continue →** and **Next Question →**.
   Tapping a team a second time cleanly undoes the award, streak bonus included.

## Live multiplayer

Firebase is already configured. Hit **+ Create Room**, then **📋 Copy invite link** and send it round —
the link (`…/?room=CODE`) opens the game with the code pre-filled, so players just type a name and
hit Join (or press Enter). On phones a **📤 Share…** button opens the native share sheet.
Watch them appear in the lobby, then **▶ Start Game**. Guest phones show a live scoreboard that
updates the instant you award points; host pause and game-over push to every device.

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
