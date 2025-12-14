# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a LazyVim-based Neovim configuration written entirely in Lua. It extends the [LazyVim](https://lazyvim.github.io/) framework with custom plugins and TypeScript language support.

## Architecture

```
init.lua                    → Entry point, loads config.lazy
lua/config/
├── lazy.lua               → Plugin manager setup & plugin specs
├── options.lua            → Custom Neovim options (loaded before startup)
├── keymaps.lua            → Custom keybindings (loaded on VeryLazy event)
└── autocmds.lua           → Custom autocommands (loaded on VeryLazy event)
lua/plugins/
├── claudecode.lua         → Claude Code integration plugin
└── example.lua            → Template showing plugin customization patterns
```

**Loading order**: LazyVim defaults → options.lua → lazy.nvim plugins → keymaps.lua/autocmds.lua

## Adding/Modifying Plugins

Create or edit files in `lua/plugins/`. Each file returns a table (or list of tables) with plugin specs:

```lua
return {
  "author/plugin-name",
  dependencies = { "dep/plugin" },
  opts = { ... },           -- passed to plugin's setup()
  config = true,            -- or function for custom setup
  keys = { ... },           -- lazy-load on these keymaps
}
```

To override a LazyVim plugin, use the same plugin name and merge opts:
```lua
{ "existing/plugin", opts = { new_option = true } }
```

To disable a LazyVim plugin:
```lua
{ "plugin/name", enabled = false }
```

## Key Custom Bindings

- `<leader>ac` - Toggle Claude Code panel
- `<leader>af` - Focus Claude Code panel

## Formatting

Lua files use stylua with 2-space indentation (see `stylua.toml`). Format with `:LazyFormat` or on save.

## Enabled LazyVim Extras

- `lazyvim.plugins.extras.lang.typescript` - TypeScript/JavaScript language support
