# Neovim Configuration PRD

## Overview

Custom Neovim configuration built from scratch using **lazy.nvim** as the plugin manager. The configuration follows a modular architecture under the `xjergx` namespace, prioritizing simplicity, clarity, and a keyboard-driven workflow.

## Goals

- **Minimal and Fast**: Load only what's needed, when needed (lazy loading)
- **Keyboard-Centric**: All operations accessible via intuitive keybindings
- **Modern Tooling**: LSP, DAP, Treesitter, and fuzzy finding
- **Consistency**: Unified UI through snacks.nvim
- **Maintainability**: Modular structure with clear separation of concerns

## Architecture

```
nvim/
├── init.lua                    # Entry point
└── lua/xjergx/
    ├── core/
    │   ├── lazy.lua            # Plugin manager bootstrap
    │   ├── keymap.lua          # Global keybindings
    │   └── options.lua         # Vim options
    └── plugins/
        ├── ui.lua              # snacks.nvim - UI framework
        ├── lsp.lua             # Language Server Protocol
        ├── mason.lua           # LSP/DAP installer
        ├── dap.lua             # Debug Adapter Protocol
        ├── editor.lua          # Editor enhancements
        ├── formatting.lua      # Code formatting
        ├── git.lua             # Git integration
        ├── snacks.lua          # Snacks utilities
        ├── utils.lua           # Utility plugins
        └── whichkey.lua        # Keybinding discovery
```

## Core Components

### Plugin Management

- **lazy.nvim**: Modern plugin manager with lazy loading, lockfile support, and automatic UI

### UI Framework

- **snacks.nvim**: Unified UI providing:
  - Pickers (files, buffers, grep, git, GitHub)
  - File explorer
  - Terminal toggle
  - Notifications
  - Zen mode
  - Scratch buffers

### Language Support

| Language      | LSP Server | Features                      |
| ------------- | ---------- | ----------------------------- |
| Lua           | lua_ls     | Neovim API completions        |
| TypeScript/JS | ts_ls      | Inlay hints, type checking    |
| C#            | omnisharp  | Roslyn analyzers, inlay hints |
| Vue 3         | volar      | SFC support                   |
| JSON          | jsonls     | Schema validation             |

### Debugging

- **nvim-dap** with debugmaster UI
- .NET Core debugging via netcoredbg
- Mason auto-installs debug adapters

## Key Workflows

### File Navigation

- `<leader><space>` - Smart file finder
- `<leader>e` - File explorer
- `-` - Oil file browser

### Code Editing

- LSP-powered completions and diagnostics
- Auto-formatting on save
- Auto-close brackets/quotes

### Git Integration

- `<leader>gg` - Lazygit
- `<leader>gs` - Git status picker
- `<leader>gd` - Git diff hunks
- GitHub issues/PR pickers

### Debugging

- `<leader>db` - Toggle breakpoint
- `<leader>dc` - Continue execution
- `<leader>dd` - Toggle debug UI

## Leader Keys

- **Leader**: `<Space>`
- **Local Leader**: `\`

## Dependencies

- Neovim 0.11+
- Git
- Node.js (for some LSP servers)
- .NET SDK (for C# development)
- Nerd Font (for icons)
