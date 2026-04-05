# proj

A CLI for browsing and tagging your local projects. Scans a sandbox directory for git repos and `.project.toml` files, lets you filter by tag, and shows what you've been working on recently.

```
proj ls --recent 10
```

```
curiate        *  today
golden-angle      today
ratios-seq     *  yesterday
spotify-slayer *  yesterday
midiquiz       *  2d ago
quant-self     *  2d ago
energydata-art    2d ago
macroservice   *  4d ago
wip-stream        4d ago    [tooling] [sessions] [dashboard]
devlog-tools   *  4d ago
```

A `*` means the project has no `.project.toml` yet. Sorted by last git commit.


## Install

```sh
bash <(curl -fsSL https://raw.githubusercontent.com/dnewcome/techno-forge/main/project-manager/install.sh)
```

Or from source:

```sh
bash project-manager/install.sh
```

Requires Python 3.11+. No dependencies beyond the standard library.

By default installs to `~/.local/bin/`. Override with `--dir`:

```sh
bash install.sh --dir /usr/local/bin
```


## Usage

### List projects

```sh
proj ls                  # all projects, sorted by recent git activity
proj ls --recent 15      # 15 most recently touched
proj ls --tag music      # filter by tag (case-insensitive substring)
proj ls --verbose        # include descriptions
```

### Show a project

```sh
proj show mmt8
```

```
Name:        mmt8
Slug:        mmt8
Path:        /home/dan/sandbox/dnewcome/mmt8
Last commit: 1w ago
Description: Reverse engineering and porting of the Alesis MMT-8 MIDI sequencer firmware
Tags:        embedded, 8051, reverse-engineering, MIDI, C, firmware, Ghidra
```

### Add tags

```sh
proj tag mmt8 music hardware
```

Writes the updated `tags` array back into the project's `.project.toml`, preserving all other content.

### Browse tags

```sh
proj tags
```

```
  2  music
  2  sequencer
  1  embedded
  1  tooling
  ...
```


## Configuration

`proj` looks for projects in `~/sandbox/dnewcome/`. To change this, edit the `SANDBOX` variable at the top of the script.


## .project.toml

`proj` reads the `name`, `slug`, `description`, and `tags` fields from `.project.toml` in each project directory. All fields are optional — projects without a `.project.toml` are still listed, marked with `*`.

Minimal example:

```toml
name = "my-project"
description = "What it does"
tags = ["music", "cli", "python"]
```

See [devlog-tools](https://github.com/dnewcome/devlog-tools) for tooling to create and maintain `.project.toml` files.


## License

MIT
