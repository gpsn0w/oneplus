# 🦤 Dodo OS

**A privacy-focused, open-source mobile OS based on AOSP.**

Dodo OS is a custom Android distribution built directly on the
[Android Open Source Project (AOSP)](https://source.android.com/). Its goal
is a private, de-Googled-by-default phone experience — with Google services
available only inside a sandbox — inspired by projects like GrapheneOS.

> ⚠️ **Honest scope note:** Dodo OS targets the **OnePlus Nord N100 (BE2013)**.
> This device's bootloader **cannot be re-locked with custom keys**, so Dodo OS
> cannot offer the same verified-boot hardware guarantees as GrapheneOS on Pixel.
> Dodo OS is a strong *privacy* ROM, not a drop-in replacement for Graphene's
> hardware security model. See [`docs/ROADMAP.md`](docs/ROADMAP.md).

## Target device

| | |
|---|---|
| Device | OnePlus Nord N100 |
| Model | BE2013 (North America) |
| SoC | Qualcomm Snapdragon 460 (bengal / SM4250) |
| Base | AOSP |

## Planned features

- 🔒 Privacy-first defaults (no Google telemetry out of the box)
- 📦 **Sandboxed Google Play services** (via microG or Play in a work-profile sandbox)
- 👥 Sandboxed / isolated user profiles
- 🔌 **USB-C data protection** — block USB data when the screen is locked
- 🚨 **Duress / panic code** — a secondary PIN that wipes or locks the device
- 🎨 Custom Dodo OS branding (name, logo, boot animation)

## Repository layout

| Folder | Purpose |
|--------|---------|
| `manifest/` | `repo` manifest — defines which sources to sync (AOSP + device) |
| `overlays/` | Branding & configuration overlays (name, logo, defaults) |
| `patches/`  | Custom patches implementing Dodo OS privacy features |
| `docs/`     | Design docs, roadmap, build instructions |

## Status

🚧 **Early setup.** See [`docs/ROADMAP.md`](docs/ROADMAP.md) for current stage.

## License

Apache License 2.0 — see [`LICENSE`](LICENSE), consistent with AOSP.
