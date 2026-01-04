# Crypt Knight Mod - Language Files

This directory contains language files for the Crypt Knight mod. To add support for additional languages, create a new file with the language name (e.g., `french`, `german`, `spanish`, etc.) using the same format as `english`.

## Supported Languages

Currently, only English is provided. To add translations:

1. Copy `english` to a new file named after your language (e.g., `french`, `german`, `spanish`)
2. Translate all the strings on the right side of the `=` sign
3. Keep the keys (left side) unchanged

## Language File Format

The format is simple key-value pairs:
```
key=Translated Text
```

Comments start with `#` and are ignored.

## Available Keys

All translatable strings use the following key patterns:
- `{skill_id}.name` - Skill name
- `{skill_id}.description` - Skill description
- `{class_id}.name` - Class/subclass name
- `{class_id}.description` - Class/subclass description
- `.htitle.{title_id}.desc` - Title description
- `{buff_id}.name` - Buff name
- `{buff_id}.description` - Buff description

## Example Translation

English:
```
raise_dead.name=Raise Dead
raise_dead.description=Raises an undead minion to fight for you.
```

French (example):
```
raise_dead.name=Invoquer les Morts
raise_dead.description=Invoque un serviteur mort-vivant pour combattre à vos côtés.
```

## Notes

- Keep the keys exactly as they appear in the English file
- Maintain the same line structure
- Comments (lines starting with `#`) can be translated or removed
- Some strings may contain special formatting - preserve these when translating

