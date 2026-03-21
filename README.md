# 🔥 Daily Rituals — Streak Tracker for Rainmeter

![Version](https://img.shields.io/badge/version-1.0.0-EF9F27?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)
![Rainmeter](https://img.shields.io/badge/Rainmeter-4.5%2B-blue?style=flat-square)
![Author](https://img.shields.io/badge/author-Subhasis%20Biswal-FAC775?style=flat-square)

A beautiful **warm amber/gold glassmorphism** daily habit tracker skin for Rainmeter, featuring persistent streak counting and daily **Bhagavad Gita** motivational quotes.

> *"You have a right to perform your prescribed duties, but you are not entitled to the fruits of your actions."*
> — Bhagavad Gita 2.47

---

## ✨ Features

- **Click to check off** daily habits with visual feedback
- **Individual streak counters** — tracks consecutive days per habit
- **Overall streak counter** — counts consecutive days with ALL habits completed (Streak 1, Streak 2...)
- **Edit mode** — add new rituals or remove existing ones on the fly
- **Daily progress bar** showing today's completion percentage
- **30 Bhagavad Gita quotes** — one new quote per day, cycling sequentially through all verses
- **Persistent data** — streaks and check-offs survive restarts and reboots
- **Supports up to 8 custom habits**
- **Warm Amber/Gold color palette** — no generic blue, fully custom warm theme
- **Glassmorphism design** — frosted glass panels on a deep dark background

---

## 📸 Screenshots

<!-- Add your screenshots here -->
<!-- ![Screenshot](screenshots/screenshot1.png) -->

| Normal Mode | Edit Mode | Streak Active |
|:-----------:|:---------:|:-------------:|
| *Click habits to check off* | *Add/remove rituals* | *All habits done = Streak!* |

---

## 📦 Installation

### Prerequisites
- [Rainmeter 4.5+](https://www.rainmeter.net/) installed on Windows

### Steps

1. **Download** the skin files from this repository (or from DeviantArt)

2. **Copy** the `StreakTracker` folder into your Rainmeter Skins directory:
   ```
   C:\Users\<YourName>\Documents\Rainmeter\Skins\
   ```

3. Your folder structure should look like this:
   ```
   Documents/
   └── Rainmeter/
       └── Skins/
           └── StreakTracker/
               ├── StreakTracker.ini
               └── @Resources/
                   ├── StreakTracker.lua
                   ├── habits.txt
                   └── data.txt
   ```

4. **Right-click** the Rainmeter tray icon → **Manage**

5. In the left panel, find **StreakTracker** → **StreakTracker.ini** → Click **Load**

---

## 🎮 How to Use

### Checking Off Habits
Click on any habit name or the circle on the right to mark it as done for today. The circle fills with amber gold and the habit text dims. Click again to uncheck.

### Viewing Streaks
Each habit shows its individual streak count below the name (e.g., "12 day streak"). The **Overall Streak** panel between habits and progress shows consecutive days where you completed ALL habits.

### Edit Mode — Adding Habits
1. Click the **Edit** button (top area, next to the date)
2. Click **"+ Add new ritual"** at the bottom of the habits list
3. A text input box appears — type the name of your new habit
4. Press **Enter** to add it
5. Click **Done** to exit edit mode

### Edit Mode — Removing Habits
1. Click **Edit** to enter edit mode
2. Click the red **x** next to any habit you want to remove
3. Click **Done** to exit edit mode

### Daily Quotes
The Bhagavad Gita quote at the bottom changes automatically each day, cycling sequentially through all 30 verses. No manual navigation needed — a fresh quote greets you every morning.

---

## 🎨 Design Details

### Color Palette

| Element | Color | Hex |
|---------|-------|-----|
| Gold Bright | Amber Gold | `#EF9F27` |
| Gold Light | Light Gold | `#FAC775` |
| Text Primary | Warm White | `#FFF0D4` |
| Background | Deep Brown-Black | `#1A0E05` |
| Glass Panel | Frosted Warm | `rgba(255,248,238,0.05)` |
| Panel Border | Amber Glow | `rgba(239,159,39,0.14)` |

### Typography
- **Headers**: Georgia (serif) — warm, classic feel
- **Body**: Segoe UI — clean, modern readability
- **Quotes**: Georgia Italic — elegant verse presentation

---

## 🛠 Customization

### Changing Default Habits
Edit `@Resources/habits.txt` — one habit name per line:
```
Hit the Gym
Study 4 Hours
Take Medicines
Face Care Routine
Drink 3L Water
Read 30 Minutes
```
Then right-click the skin → **Refresh Skin**.

### Changing Skin Width
In `StreakTracker.ini`, find `[Variables]` and change `W=340` to your preferred width. The Lua script will adapt all panel widths automatically.

### Resetting All Data
Delete the contents of `@Resources/data.txt` and refresh the skin. All streaks and check-offs will be reset.

---

## 📁 File Structure

```
StreakTracker/
├── StreakTracker.ini          # Main Rainmeter skin definition
└── @Resources/
    ├── StreakTracker.lua       # Core logic — positioning, streaks, state management
    ├── habits.txt             # Your habit names (one per line, editable)
    └── data.txt               # Streak/check-off data (auto-generated, don't edit)
```

---

## 📜 Bhagavad Gita Quotes Included

The skin includes 30 carefully selected verses covering:

- **Karma Yoga** — duty, action, and working without attachment to results
- **Self-Mastery** — conquering the mind, discipline, and inner strength
- **Detachment** — freedom from desire, equanimity in success and failure
- **Inner Peace** — meditation, serenity, and finding absolute peace
- **Faith & Devotion** — trust, surrender, and spiritual awareness
- **Overcoming Fear** — courage, arising, and slaying doubt with knowledge

---

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Submit bug reports or feature requests via Issues
- Fork the repo and submit Pull Requests
- Share your customized versions

---

## 📄 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Subhasis Biswal**

---

## 🙏 Acknowledgments

- [Rainmeter](https://www.rainmeter.net/) — the desktop customization platform
- The timeless wisdom of the **Bhagavad Gita**
- Inspired by the discipline of building daily rituals

---

*Built with dedication and Krishna's wisdom* 🙏
