---
name: avatar-generator
description: Generate a flat editorial avatar image from a subject description using a JavaScript CLI and the OpenAI Images API. Use when a user asks for this specific avatar style (cream background, amber accent, no gradients/outlines, soft flat shapes) and wants to vary only the subject details.
---

# Avatar Generator

Generate one avatar image using a fixed house style and a user-provided subject description.

## Workflow

1. Collect the subject description from the user.
2. Ensure `OPENAI_API_KEY` is set in the current shell.
3. Run the JS script in this skill.
4. Return the output path and offer one targeted iteration if needed.

## Command

Run from the repo root:

```bash
node skills/avatar-generator/scripts/generate_avatar.mjs \
  --subject "person with messy hair, wearing headphones around their neck, slightly amused" \
  --out output/avatar.png
```

## Defaults

- Model: `gpt-image-1`
- Size: `1024x1024`
- Quality: `high`
- Output format: PNG

## Options

- `--subject` (required): subject details only
- `--out`: output file path
- `--model`: override model
- `--size`: override size
- `--quality`: `low|medium|high|auto`

## Prompt Policy

The script always includes this fixed style:

- Flat portrait illustration, square format, circular crop
- Warm cream background `#FAF7F2`
- Minimal stylized face, friendly expression
- Palette limited to cream, warm neutrals, amber `#C8860A` accent
- No gradients, no outlines, soft flat shapes
- Modern editorial avatar, Mailchimp Freddie meets Notion avatar

Only append the user subject description after the fixed style.

## Notes

- Do not ask the user for broader style input unless they explicitly want to override this house style.
- If output misses the subject details, rerun with a more explicit subject sentence.
