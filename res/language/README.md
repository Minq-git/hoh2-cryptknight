# Crypt Knight Mod - Language Files

This directory contains language files for the Crypt Knight mod. Language files use ISO 639 language codes (e.g., `en.lang`, `fr.lang`, `de.lang`) and follow a standard XML dictionary format.

## Supported Languages

The mod currently supports the following languages:
- English (`en.lang`)
- Simplified Chinese (`zh-CN.lang`)
- Japanese (`ja.lang`)
- Korean (`ko.lang`)
- Spanish (`es.lang`)
- French (`fr.lang`)
- German (`de.lang`)
- Ukrainian (`uk.lang`)
- Italian (`it.lang`)

I welcome suggestions from any native language speakers for the above, or any additional languages!

## How to Add Translations

1.  **Copy `en.lang`** to a new file using the appropriate ISO 639 language code (e.g., `pt-BR.lang` for Brazilian Portuguese).
2.  **Edit the file** using a text editor (VS Code, Notepad++, Sublime Text).
3.  **Translate** the text content between the opening and closing tags.
    * *Original:* `<string name="key">Original Text</string>`
    * *Translated:* `<string name="key">Translated Text</string>`
4.  **Do not change** the `name="..."` attribute inside the tag. This is the ID used by the game to find the text.
5.  **Save the file with UTF-8 Encoding.** This is critical for characters like `é`, `ñ`, `あ`, or `汉` to display correctly.

## Language File Format

The files use a simple XML structure enclosed in a `<dict>` tag.

**Structure:**
```xml
<dict>
    <string name="unique_key_id">Translated Text Goes Here</string>
</dict>
```
* **Tags:** Each line must be wrapped in `<string name="KEY">TEXT</string>`.
* **Comments:** Use `` for notes. Do not use `#`.

## Available Keys

All translatable strings generally follow these key patterns:
- `{skill_id}.name` - Skill name
- `{skill_id}.description` - Skill description
- `{class_id}.name` - Class/subclass name
- `{class_id}.description` - Class/subclass description
- `.htitle.{title_id}.desc` - Title description
- `{buff_id}.name` - Buff name
- `{buff_id}.description` - Buff description

## Example Translation

**English (`en.lang`):**
```xml
<string name="raise_dead.name">Raise Dead</string>
<string name="raise_dead.description">Raises an undead minion to fight for you. Available minion types depend on your Stronger Together skill level.</string>
```
**Francais (`fr.lang`):**
```xml
<string name="raise_dead.name">Ressusciter les Morts</string>
<string name="raise_dead.description">Ressuscite un serviteur mort-vivant pour combattre à vos côtés. Les types de serviteurs disponibles dépendent du niveau de votre compétence "Plus Forts Ensemble".</string>
```

## Notes
* Keep the keys exactly as they appear in the English file (the text inside `name=""`).
* **Formatting:** Some strings may contain special formatting or variables. Try to preserve the sentence structure relative to those variables.
* **Encoding:** Always ensure your editor saves in UTF-8.