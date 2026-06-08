# 🎵 Sample This! — 70s & 80s Music Trivia

A group trivia game testing whether you can identify the classic 70s/80s song that was sampled to make a modern hit.

## Features
- **76 questions** across Hip-Hop, Soul & Funk, Rock, and Classical categories
- **iTunes 30-second previews** auto-play when each question loads
- **Time-based scoring** — answer faster, score more points
- **Early-round bonus** — first third of questions worth 1.5× points
- **Streak bonuses** — 3 correct in a row earns +50% bonus
- **Speed Round mode** — 15-second timer, double points
- **Points-by-round chart** at game end
- **Tie-breaker round** — guess the year the original was released
- **Up to 15 teams** with 70s/80s band names (Fleetwood Mac, Led Zeppelin, ABBA…)
- **🌐 Firebase multiplayer** — live room codes for head-to-head on separate devices

## Live multiplayer setup (optional)
1. Go to [console.firebase.google.com](https://console.firebase.google.com) → Add project
2. Build → Realtime Database → Create database → Start in test mode
3. Project Settings → Your apps → `</>` Web → copy `firebaseConfig`
4. Paste values into `const FB_CONFIG = {…}` near the bottom of `index.html`
5. Deploy again — a **Live Online Room** panel appears on the setup screen

## Playing the game
Open `index.html` in any modern browser. No install or server required for offline play.

## Built with
- Vanilla HTML/CSS/JavaScript (single-file, zero dependencies for core game)
- [Chart.js](https://www.chartjs.org/) for the end-of-game score chart
- [iTunes Search API](https://developer.apple.com/library/archive/documentation/AudioVideo/Conceptual/iTuneSearchAPI/) for 30-second song previews
- [Firebase Realtime Database](https://firebase.google.com/products/realtime-database) (optional) for multiplayer sync
