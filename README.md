# presence-claude-plugins

Personal Claude Code plugin marketplace — cognitive scaffolding, planning, domain learning, and workflow tooling.

## Install

Add this marketplace inside Claude Code:

```
/plugin marketplace add <your-github-user>/<your-repo-name>
```

Then browse and install plugins:

```
/plugin
```

## Plugins

| Name | Description |
| --- | --- |
| `claude-settings` | Personal Claude Code settings, skills, and hooks bundle. |
| `planning-compass` | Adaptive visualization and structured process interventions for complex planning conversations. |
| `domain-xray` | 5-skill cognitive-science-informed pipeline for deeply understanding new domains. |
| `git-worktree` | Git worktree management: merge with structured commits, verification skills. |
| `scaffold` | Context-First Delivery onboarding scaffolding for unfamiliar domains. |

## Repository layout

```
.
├── .claude-plugin/
│   └── marketplace.json         # marketplace manifest (lists all plugins)
├── <plugin-name>/
│   └── .claude-plugin/
│       └── plugin.json          # per-plugin manifest
├── .gitignore
├── publish.sh                   # one-shot: add → commit → push
└── README.md
```

Each plugin is a top-level directory referenced by `marketplace.json` via a relative `./<plugin-name>` source. Adding a new plugin = create its directory with a `.claude-plugin/plugin.json` and add an entry to `marketplace.json`.

## Publishing updates

```sh
./publish.sh "your commit message"
```

The script stages everything, commits, and pushes to the configured `origin` remote.

## Adding a new plugin

1. Create `new-plugin/.claude-plugin/plugin.json` (at minimum: `name`).
2. Add an entry to `.claude-plugin/marketplace.json` under `plugins`:
   ```json
   {
     "name": "new-plugin",
     "source": "./new-plugin",
     "description": "..."
   }
   ```
3. Run `./publish.sh "add new-plugin"`.

Claude Code users who have the marketplace added will see the new plugin after running `/plugin marketplace update <marketplace-name>`.
