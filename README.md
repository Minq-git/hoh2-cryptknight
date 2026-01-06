# Crypt Knight Class Mod

An undead knight class raised to serve again. Master of death, decay, and shadow magic with three unique specializations.

## Overview

The Crypt Knight is a tanky melee class that combines defensive capabilities with undead minion summoning. With high Strength and Vitality, the Crypt Knight excels at close-quarters combat while commanding an army of undead minions to fight alongside them.

## Base Stats

- **Primary Attributes**: Strength (10 base, +2 per level), Vitality (10 base, +2 per level)
- **Secondary Attributes**: Dexterity (5 base, +1 per level), Focus (5 base, +1 per level), Intelligence (3 base)
- **Health**: 100 base, +10 per level
- **Mana**: 60 base, +2 per level
- **Health Regen**: 1.5 base, +0.1 per level
- **Mana Regen**: 0.5 base, +0.05 per level
- **Armor**: 5 base, +0.5 per level
- **Resistances**: +10 Ice, +10 Poison (base)
- **Spell Power**: Scales with Strength (1:1 ratio)

## Core Skills

### Bone Shield
**Type**: Spell | **Mana Cost**: 20 | **Cooldown**: 45s (scales down to 25s)

Reduces damage taken by consuming stacks. Each stack provides damage reduction, and you can hold multiple stacks (3-7 depending on level). Stacks are consumed when you take damage.

- **Level 1**: 30% damage reduction, 3 max stacks
- **Level 5**: 50% damage reduction, 7 max stacks

#### Skill Orbs

- **Bone Armor** - Bone Shield stacks grant additional Armor (+5/+10/+15 per stack)
- **Serrated Marrow** - Bone Shield stacks deal Thorns damage to attackers (50%/75%/100% Str)
- **Thick Skulls** - Bone Shield stacks are hardier and require additional hits to break (+1/+2/+3 hits per stack)

### Raise Dead
**Type**: Spell | **Mana Cost**: 50 (scales down to 30) | **Cooldown**: 5s (scales down to 3s)

Raises an undead minion to fight for you. Available minion types depend on your Stronger Together skill level. You can summon multiple minions, with each type having its own cap.

- **Defender**: Basic melee minion (always available)
- **Footman**: Unlocked at Stronger Together Level 2
- **Sentry**: Unlocked at Stronger Together Level 3
- **Mage**: Unlocked at Stronger Together Level 4
- **Knight**: Unlocked at Stronger Together Level 5

#### Skill Orbs

- **Volatile Remains** - When your minions die, they explode dealing damage based on your Strength (100%/150%/200% Str, radius 64/80/96)
- **Undead Legion** - Each active minion reduces damage you take (2%/3%/4% per minion)
- **Minion Mastery** - Your minions deal increased damage and have increased maximum Health (+25%/+50%/+75%)

### Death Grip
**Type**: Spell | **Mana Cost**: 15 (scales up to 50) | **Cooldown**: 8s

Pulls all nearby monsters towards you with chains, dealing Physical damage.

- **Level 1**: 100 damage
- **Level 5**: 200 damage

#### Skill Orbs

- **Contagious Grasp** - Death Grip applies Vulnerability to enemies it hits (20%/30%/40%)
- **Grasping Chains** - Death Grip deals additional Physical damage to enemies it hits (+25%/+50%/+75% Str)
- **Soul Rend** - Death Grip chains have a chance to inflict Weakness on enemies (25%/50%/100% chance)

## Specializations

### Plaguebearer
**Master of disease and decay**

**Skills:**
- **Pestilence** - Turn into a fast-moving plague cloud with damage reduction (6-22s duration, 10-50% damage reduction)
- **Sickly** - Melee attacks apply Bleeding and Vulnerability to enemies (1-3 bleed stacks, 15% chance for 20% Vulnerability at level 5)

#### Pestilence Skill Orbs

- **Plague Cloud** - While in Pestilence form, you apply Poison to enemies you touch (1/2/3 stacks)
- **Pestilent Strike** - While in Pestilence form, taking damage causes you to deal Strength-based damage to nearby enemies (100%/150%/200% Str, radius 48/64/80)

### Void Knight
**Empowered by Shadow Curse**

**Skills:**
- **Soul Vortex** - Channel a frontal cone of void magic that grants Shadow Curse (1-5s duration, 10-80% damage)
- **Cursed** - Gain Strength and Vitality based on Shadow Curse stacks (0.5-2.5x multiplier)

#### Soul Vortex Skill Orbs

- **Void Eruption** - Soul Vortex projectiles explode on impact, dealing additional Strength-based damage (50%/75%/100% Str, radius 32/48/64)
- **Soul Siphon** - Soul Vortex deals damage, restoring a portion of your maximum Mana (10%/20%/30%)

### Armoured Husk
**An unstoppable undead juggernaut**

**Skills:**
- **Unwavering Oath** - Upon taking lethal damage, transform into a zombie for a short time before dying (30-50s duration)
- **Stronger Together** - Strengthens minions and unlocks new types
  - Level 1: +50% minion stats
  - Level 2: Unlocks Footman, cap 2
  - Level 3: Unlocks Sentry, cap 3
  - Level 4: Unlocks Mage, cap 4
  - Level 5: Unlocks Knight, cap 5, +60% minion stats

#### Unwavering Oath Skill Orbs

- **Eternal Undeath** - Unwavering Oath duration is increased and you deal more damage while transformed (+10s/+15s/+20s duration, +25%/+50%/+75% damage)
- **Zombie Rage** - While transformed by Unwavering Oath, killing enemies extends the transformation duration (+2s/+3s/+5s per kill)

## Installation

1. Download the latest release from the [Releases](https://github.com/Minq-git/hoh2-cryptknight/releases) page
2. Extract the mod folder to your Heroes of Hammerwatch 2 mods directory:
   - **Steam**: `Steam/steamapps/common/Heroes of Hammerwatch 2/mods/`
   - **Standalone**: `Documents/My Games/Heroes of Hammerwatch 2/mods/`
3. The mod should appear in the game's mod list. Enable it and restart the game.

## Localization

The mod includes full localization support for:
- English
- German
- Spanish
- French
- Italian
- Japanese
- Korean
- Ukrainian
- Chinese (Simplified)

## Technical Details

### Multiplayer Support
- Fully compatible with multiplayer
- Each player has individual minion ownership and tracking
- Network-synchronized minion spawning and management

### Mod Compatibility
- Uses base game modifier system exclusively
- No custom AngelScript required for core functionality
- Follows base game patterns for skill orbs and modifiers

### File Structure
```
CryptKnight/
├── info.xml                    # Mod metadata
├── players/
│   └── cryptknight/           # Class definition and skills
│       ├── skills/            # All skill definitions
│       ├── units/             # Minion unit definitions
│       ├── buffs/             # Buff definitions
│       └── stacks_*.sval      # Stackable buff definitions
├── scripts/                   # Custom AngelScript hooks
├── res/
│   └── language/              # Localization files
└── tweak/                     # Game tweaks
```

## Credits

- **Author**: Minq (@Minq-git)
- **Game**: Heroes of Hammerwatch 2 by Crackshell
- **Modding Community**: Special thanks to the HoH2 modding community for documentation and support

## License

This mod is provided as-is for use with Heroes of Hammerwatch 2. All game assets and code remain property of their respective owners.

## Changelog

### Version 1.0.0
- Initial release
- Complete class implementation with 3 specializations
- 15 skill orbs across all skills
- Full multiplayer support
- Complete localization support

