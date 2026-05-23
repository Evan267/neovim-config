# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration using [lazy.nvim](https://github.com/folke/lazy.nvim) as the plugin manager. The config is structured around project-type detection (Angular, Rust, Java/Spring) with automated code generation and context-aware keymaps.

## Structure

- `init.lua` — Entry point: sets up lazy.nvim, WezTerm integration, leader key (`<Space>`), and loads `lua/plugins/` + `lua/config/`
- `lua/config/` — Core settings: `options.lua` (vim opts), `keymaps.lua` (global keymaps), `commands.lua` (user commands), `project.lua` (project-type detection utilities), `utils.lua`
- `lua/plugins/` — One file per plugin, each returning a lazy.nvim plugin spec table
- `lua/core/generators/` — Code scaffolding logic for `angular.lua`, `rust.lua`, `java.lua`

## Key Architecture Patterns

### Project Detection (`lua/config/project.lua`)
`M.is_angular()`, `M.is_rust()`, `M.is_java_spring()` detect project type from root marker files (`angular.json`, `Cargo.toml`, `pom.xml`/`build.gradle`). Many keymaps and Oil behaviors branch on these.

### Module Scaffolding (`:CreateModule <name>`)
Defined in `lua/config/commands.lua`, delegates to `core/generators/angular.lua` or `core/generators/rust.lua` based on project type. Creates the full hexagonal architecture folder tree under `modules/`.

- **Angular**: creates `application/`, `presentation/`, `domain/`, `infrastructure/` subdirs
- **Rust**: same structure but also creates `.rs` stub files alongside each directory

### Oil.nvim Integration
Oil keymaps use `project.lua` helpers to jump directly to context-relevant directories:
- `<leader>of` → features path
- `<leader>or` → resources path
- `<leader>op` → project root

### Angular Component Navigation
`<leader>at/ah/ac` switch between `.ts`, `.html`, and style files (`.scss`/`.css`/`.less`) of the current Angular component via `project.switch_to_ext()`.

## LSP Setup

Mason auto-installs `angularls` and `vtsls`. Treesitter parsers: `java`, `xml`, `lua`, `vim`, `html`, `angular`, `css`, `scss`. `nvim-ts-autotag` handles XML/HTML tag auto-close.

## Adding a New Plugin

Create `lua/plugins/<name>.lua` returning a lazy.nvim spec table. It will be auto-loaded by `require("lazy").setup("plugins")` in `init.lua`.

## Adding a New Generator

Add `lua/core/generators/<type>.lua` with a `create_<type>_module(name)` function, then wire it into `lua/config/commands.lua` with a new `project.is_<type>()` branch.
