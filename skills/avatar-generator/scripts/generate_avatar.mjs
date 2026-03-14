#!/usr/bin/env node
import fs from "node:fs";
import path from "node:path";

const STYLE_SPEC = [
  "Flat portrait illustration, square format, circular crop.",
  "Warm cream background (#FAF7F2).",
  "Minimal stylized face, friendly expression.",
  "Color palette limited to cream, warm neutrals, and amber (#C8860A) as accent.",
  "No gradients.",
  "No outlines.",
  "Soft flat shapes.",
  "Style: modern editorial avatar, Mailchimp Freddie meets Notion avatar.",
].join(" ");

function parseArgs(argv) {
  const args = {
    model: "gpt-image-1",
    size: "1024x1024",
    quality: "high",
    out: "output/avatar.png",
  };

  for (let i = 0; i < argv.length; i += 1) {
    const token = argv[i];

    if (token === "--subject") {
      args.subject = argv[++i];
    } else if (token === "--out") {
      args.out = argv[++i];
    } else if (token === "--model") {
      args.model = argv[++i];
    } else if (token === "--size") {
      args.size = argv[++i];
    } else if (token === "--quality") {
      args.quality = argv[++i];
    } else if (token === "--help" || token === "-h") {
      args.help = true;
    } else {
      throw new Error(`Unknown argument: ${token}`);
    }
  }

  return args;
}

function printHelp() {
  console.log(`Generate a stylized avatar with a fixed house style.

Usage:
  node scripts/generate_avatar.mjs --subject "person with messy hair" [options]

Required:
  --subject   Subject description

Options:
  --out       Output PNG path (default: output/avatar.png)
  --model     OpenAI image model (default: gpt-image-1)
  --size      Image size (default: 1024x1024)
  --quality   low|medium|high|auto (default: high)
  --help      Show this help message

Environment:
  OPENAI_API_KEY must be set.
`);
}

async function main() {
  let args;
  try {
    args = parseArgs(process.argv.slice(2));
  } catch (error) {
    console.error(error.message);
    printHelp();
    process.exit(1);
  }

  if (args.help) {
    printHelp();
    return;
  }

  if (!args.subject) {
    console.error("Missing required argument: --subject");
    printHelp();
    process.exit(1);
  }

  const apiKey = process.env.OPENAI_API_KEY;
  if (!apiKey) {
    console.error("OPENAI_API_KEY is not set.");
    process.exit(1);
  }

  const prompt = `${STYLE_SPEC} Subject: ${args.subject}`;

  const response = await fetch("https://api.openai.com/v1/images/generations", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${apiKey}`,
    },
    body: JSON.stringify({
      model: args.model,
      prompt,
      size: args.size,
      quality: args.quality,
      n: 1,
      output_format: "png",
    }),
  });

  if (!response.ok) {
    const errText = await response.text();
    console.error(`Image generation failed (${response.status}): ${errText}`);
    process.exit(1);
  }

  const payload = await response.json();
  const b64 = payload?.data?.[0]?.b64_json;
  if (!b64) {
    console.error("Image generation response did not contain data[0].b64_json");
    process.exit(1);
  }

  const outputPath = path.resolve(args.out);
  fs.mkdirSync(path.dirname(outputPath), { recursive: true });
  fs.writeFileSync(outputPath, Buffer.from(b64, "base64"));

  console.log(`Wrote ${outputPath}`);
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
