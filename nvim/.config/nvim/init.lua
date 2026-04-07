-- ┌─────────────────────────────────────────────────────────────┐
-- │  Stormdot · init.lua                                        │
-- │  Neovim como IDE: Python, bash, lua, markdown               │
-- │  Basado en kickstart.nvim — comentadísimo para aprender     │
-- │  Docs: https://github.com/nvim-lua/kickstart.nvim           │
-- └─────────────────────────────────────────────────────────────┘
--
-- Cómo funciona este archivo:
--   1. Settings nativos de nvim (opciones, keymaps, autocommands)
--   2. Bootstrap de lazy.nvim (gestor de plugins, se autoinstala)
--   3. Especificación de plugins (cada uno con su config)
--
-- Comandos clave:
--   :Lazy             → gestor de plugins (instalar/update/limpiar)
--   :Mason            → gestor de LSP/linters/formatters
--   :checkhealth      → diagnóstico de nvim
--   <Space>           → leader key (todos los keymaps custom empiezan así)


-- ══════════════════════════════════════════════════════════════
--   LEADER KEY (debe definirse ANTES de cargar plugins)
-- ══════════════════════════════════════════════════════════════

vim.g.mapleader      = ' '
vim.g.maplocalleader = ' '

-- Iconos Nerd Font (true porque ya tienes JetBrainsMono Nerd Font)
vim.g.have_nerd_font = true


-- ══════════════════════════════════════════════════════════════
--   OPCIONES NATIVAS
-- ══════════════════════════════════════════════════════════════

local opt = vim.opt

-- ── Línea y columna ──────────────────────────────────────────
opt.number         = true       -- Números de línea
opt.relativenumber = true       -- Números relativos (para j/k con count)
opt.cursorline     = true       -- Resaltar línea actual
opt.scrolloff      = 8          -- Margen de scroll vertical
opt.sidescrolloff  = 8          -- Margen horizontal
opt.signcolumn     = 'yes'      -- Columna de signos siempre visible (evita salto)
opt.colorcolumn    = '100'      -- Línea vertical en columna 100

-- ── Indentación ──────────────────────────────────────────────
opt.expandtab     = true        -- Tab inserta espacios
opt.tabstop       = 4           -- Tab = 4 espacios visuales
opt.shiftwidth    = 4           -- Auto-indent = 4 espacios
opt.softtabstop   = 4
opt.smartindent   = true
opt.breakindent   = true        -- Wrap respeta indentación

-- ── Búsqueda ────────────────────────────────────────────────
opt.hlsearch    = true          -- Resaltar matches
opt.incsearch   = true          -- Búsqueda incremental
opt.ignorecase  = true          -- Case insensitive...
opt.smartcase   = true          -- ...salvo si hay mayúsculas explícitas

-- ── Apariencia ──────────────────────────────────────────────
opt.termguicolors = true        -- Colores 24-bit (necesario para temas modernos)
opt.background    = 'dark'
opt.showmode      = false       -- No mostrar -- INSERT -- (lo hace lualine)
opt.cmdheight     = 1
opt.pumheight     = 10          -- Altura del menú de autocompletado
opt.conceallevel  = 0           -- Mostrar todo (markdown/json no oculta nada)

-- ── Comportamiento ──────────────────────────────────────────
opt.mouse         = 'a'         -- Ratón en todos los modos
opt.clipboard     = 'unnamedplus' -- Yanks al clipboard del sistema
opt.splitright    = true        -- Splits verticales abren a la derecha
opt.splitbelow    = true        -- Splits horizontales abren abajo
opt.wrap          = false       -- Sin wrap por defecto
opt.linebreak     = true        -- Si hay wrap, romper en palabras
opt.timeoutlen    = 300         -- ms antes de cancelar secuencia incompleta
opt.updatetime    = 250         -- ms para CursorHold (lsp diagnostics)
opt.confirm       = true        -- Preguntar al cerrar sin guardar

-- ── Archivos ────────────────────────────────────────────────
opt.swapfile  = false           -- Sin .swp (uso git)
opt.backup    = false
opt.undofile  = true            -- Undo persistente entre sesiones
opt.undodir   = vim.fn.stdpath('data') .. '/undo'

-- ── Caracteres invisibles ───────────────────────────────────
opt.list      = true
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- ── Splits ──────────────────────────────────────────────────
opt.fillchars = { eob = ' ' }   -- Sin ~ en líneas vacías al final


-- ══════════════════════════════════════════════════════════════
--   KEYMAPS BÁSICOS
-- ══════════════════════════════════════════════════════════════

local map = vim.keymap.set

-- Limpiar highlight de búsqueda con Esc
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Guardar / salir rápido
map('n', '<leader>w', '<cmd>w<CR>',  { desc = 'Guardar' })
map('n', '<leader>q', '<cmd>q<CR>',  { desc = 'Salir' })
map('n', '<leader>Q', '<cmd>qa!<CR>', { desc = 'Salir forzado todo' })

-- Mover entre splits con Ctrl+hjkl
map('n', '<C-h>', '<C-w>h', { desc = 'Split izquierda' })
map('n', '<C-j>', '<C-w>j', { desc = 'Split abajo' })
map('n', '<C-k>', '<C-w>k', { desc = 'Split arriba' })
map('n', '<C-l>', '<C-w>l', { desc = 'Split derecha' })

-- Resize splits con Ctrl+flechas
map('n', '<C-Up>',    '<cmd>resize +2<CR>')
map('n', '<C-Down>',  '<cmd>resize -2<CR>')
map('n', '<C-Left>',  '<cmd>vertical resize -2<CR>')
map('n', '<C-Right>', '<cmd>vertical resize +2<CR>')

-- Mover líneas en visual mode con J/K
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Bajar selección' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Subir selección' })

-- Mantener cursor centrado al hacer scroll
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')
map('n', 'n',     'nzzzv')
map('n', 'N',     'Nzzzv')

-- Yank/paste sin perder el buffer
map('x', '<leader>p', '"_dP', { desc = 'Pegar sin sobreescribir buffer' })
map('n', '<leader>y', '"+y',  { desc = 'Yank al clipboard' })
map('v', '<leader>y', '"+y',  { desc = 'Yank al clipboard' })

-- Diagnostics (LSP)
map('n', '[d',         vim.diagnostic.goto_prev,  { desc = 'Diagnóstico anterior' })
map('n', ']d',         vim.diagnostic.goto_next,  { desc = 'Diagnóstico siguiente' })
map('n', '<leader>e',  vim.diagnostic.open_float, { desc = 'Mostrar diagnóstico flotante' })
map('n', '<leader>dq', vim.diagnostic.setloclist, { desc = 'Lista de diagnósticos' })


-- ══════════════════════════════════════════════════════════════
--   AUTOCOMMANDS
-- ══════════════════════════════════════════════════════════════

-- Resaltar yank brevemente (feedback visual)
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Resaltar texto al hacer yank',
    group = vim.api.nvim_create_augroup('stormdot-highlight-yank', { clear = true }),
    callback = function() vim.highlight.on_yank() end,
})

-- Quitar trailing whitespace al guardar
vim.api.nvim_create_autocmd('BufWritePre', {
    desc = 'Quitar trailing whitespace al guardar',
    group = vim.api.nvim_create_augroup('stormdot-trim-whitespace', { clear = true }),
    callback = function()
        local save = vim.fn.winsaveview()
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.winrestview(save)
    end,
})


-- ══════════════════════════════════════════════════════════════
--   BOOTSTRAP DE LAZY.NVIM (gestor de plugins)
-- ══════════════════════════════════════════════════════════════

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local out = vim.fn.system({
        'git', 'clone', '--filter=blob:none', '--branch=stable',
        'https://github.com/folke/lazy.nvim.git', lazypath,
    })
    if vim.v.shell_error ~= 0 then
        error('Error clonando lazy.nvim:\n' .. out)
    end
end
vim.opt.rtp:prepend(lazypath)


-- ══════════════════════════════════════════════════════════════
--   PLUGINS
-- ══════════════════════════════════════════════════════════════

require('lazy').setup({

    -- ── Tema Nord ─────────────────────────────────────────────
    {
        'shaunsingh/nord.nvim',
        priority = 1000,           -- Cargar antes que el resto
        init = function()
            vim.g.nord_contrast        = true
            vim.g.nord_borders         = true
            vim.g.nord_disable_background = false
            vim.g.nord_italic          = true
            vim.cmd.colorscheme('nord')
        end,
    },

    -- ── Detección de tipo de archivo y configuración ──────────
    'tpope/vim-sleuth',            -- Detecta tabstop/shiftwidth automáticamente

    -- ── Comentarios con gc/gcc ────────────────────────────────
    { 'numToStr/Comment.nvim', opts = {} },

    -- ── Git signs en la columna de signos ────────────────────
    {
        'lewis6991/gitsigns.nvim',
        opts = {
            signs = {
                add          = { text = '┃' },
                change       = { text = '┃' },
                delete       = { text = '_' },
                topdelete    = { text = '‾' },
                changedelete = { text = '~' },
            },
        },
    },

    -- ── Which-key: muestra los keymaps disponibles ───────────
    {
        'folke/which-key.nvim',
        event = 'VimEnter',
        opts = {
            preset = 'modern',
            spec = {
                { '<leader>c', group = '[C]ode' },
                { '<leader>d', group = '[D]iagnostics' },
                { '<leader>f', group = '[F]ind (telescope)' },
                { '<leader>g', group = '[G]it' },
                { '<leader>r', group = '[R]ename' },
                { '<leader>s', group = '[S]earch' },
                { '<leader>t', group = '[T]oggle' },
            },
        },
    },

    -- ── Telescope: fuzzy finder universal ─────────────────────
    {
        'nvim-telescope/telescope.nvim',
        event = 'VimEnter',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', cond = function() return vim.fn.executable('make') == 1 end },
            'nvim-telescope/telescope-ui-select.nvim',
            { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
        },
        config = function()
            require('telescope').setup({
                extensions = {
                    ['ui-select'] = { require('telescope.themes').get_dropdown() },
                },
            })
            pcall(require('telescope').load_extension, 'fzf')
            pcall(require('telescope').load_extension, 'ui-select')

            local builtin = require('telescope.builtin')
            map('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
            map('n', '<leader>fg', builtin.live_grep,  { desc = '[F]ind by [G]rep' })
            map('n', '<leader>fb', builtin.buffers,    { desc = '[F]ind [B]uffers' })
            map('n', '<leader>fh', builtin.help_tags,  { desc = '[F]ind [H]elp' })
            map('n', '<leader>fr', builtin.oldfiles,   { desc = '[F]ind [R]ecent' })
            map('n', '<leader>fk', builtin.keymaps,    { desc = '[F]ind [K]eymaps' })
            map('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
        end,
    },

    -- ── LSP: configuración + Mason (instalador) ───────────────
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'williamboman/mason.nvim', config = true },
            'williamboman/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',
            { 'j-hui/fidget.nvim', opts = {} },              -- Notificaciones LSP en la esquina
            'hrsh7th/cmp-nvim-lsp',
        },
        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('stormdot-lsp-attach', { clear = true }),
                callback = function(event)
                    local builtin = require('telescope.builtin')
                    local b = event.buf
                    local lmap = function(keys, func, desc)
                        map('n', keys, func, { buffer = b, desc = 'LSP: ' .. desc })
                    end

                    lmap('gd',         builtin.lsp_definitions,      '[G]oto [D]efinition')
                    lmap('gr',         builtin.lsp_references,       '[G]oto [R]eferences')
                    lmap('gI',         builtin.lsp_implementations,  '[G]oto [I]mplementation')
                    lmap('<leader>D',  builtin.lsp_type_definitions, 'Type [D]efinition')
                    lmap('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
                    lmap('<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
                    lmap('<leader>rn', vim.lsp.buf.rename,           '[R]e[n]ame')
                    lmap('<leader>ca', vim.lsp.buf.code_action,      '[C]ode [A]ction')
                    lmap('K',          vim.lsp.buf.hover,            'Hover (docs)')
                end,
            })

            -- Capabilities con cmp
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

            -- ── Servidores LSP a instalar ─────────────────────
            -- Para instalar más: :Mason
            local servers = {
                pyright   = {},                              -- Python
                bashls    = {},                              -- Bash
                lua_ls    = {                                -- Lua (con awareness de nvim)
                    settings = {
                        Lua = {
                            completion = { callSnippet = 'Replace' },
                            diagnostics = { globals = { 'vim' } },
                            workspace   = { checkThirdParty = false },
                            telemetry   = { enable = false },
                        },
                    },
                },
                marksman  = {},                              -- Markdown
            }

            -- Tools extra (formatters/linters) instalados via Mason
            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                'stylua',          -- Formatter Lua
                'black',           -- Formatter Python
                'isort',           -- Ordenar imports Python
                'shfmt',           -- Formatter Bash
                'shellcheck',      -- Linter Bash
            })

            require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

            require('mason-lspconfig').setup({
                ensure_installed = {},                       -- Lo hace mason-tool-installer
                automatic_installation = false,
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
                        require('lspconfig')[server_name].setup(server)
                    end,
                },
            })
        end,
    },

    -- ── Formatter (conform.nvim) ──────────────────────────────
    {
        'stevearc/conform.nvim',
        event = { 'BufWritePre' },
        cmd   = { 'ConformInfo' },
        keys  = {
            { '<leader>cf', function() require('conform').format({ async = true, lsp_fallback = true }) end, desc = '[C]ode [F]ormat' },
        },
        opts = {
            notify_on_error = false,
            format_on_save = function(bufnr)
                -- Desactivar para algunos filetypes
                local disable_filetypes = { c = true, cpp = true }
                return {
                    timeout_ms   = 500,
                    lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
                }
            end,
            formatters_by_ft = {
                lua    = { 'stylua' },
                python = { 'isort', 'black' },
                sh     = { 'shfmt' },
                bash   = { 'shfmt' },
            },
        },
    },

    -- ── Autocompletado (nvim-cmp) ─────────────────────────────
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            { 'L3MON4D3/LuaSnip', build = 'make install_jsregexp' },
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-buffer',
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            luasnip.config.setup({})

            cmp.setup({
                snippet = {
                    expand = function(args) luasnip.lsp_expand(args.body) end,
                },
                completion = { completeopt = 'menu,menuone,noinsert' },
                mapping = cmp.mapping.preset.insert({
                    ['<C-n>']     = cmp.mapping.select_next_item(),
                    ['<C-p>']     = cmp.mapping.select_prev_item(),
                    ['<C-b>']     = cmp.mapping.scroll_docs(-4),
                    ['<C-f>']     = cmp.mapping.scroll_docs(4),
                    ['<C-y>']     = cmp.mapping.confirm({ select = true }),
                    ['<C-Space>'] = cmp.mapping.complete({}),
                    ['<C-l>'] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump() end
                    end, { 'i', 's' }),
                    ['<C-h>'] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then luasnip.jump(-1) end
                    end, { 'i', 's' }),
                }),
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'path' },
                    { name = 'buffer' },
                },
            })
        end,
    },

    -- ── Treesitter: syntax highlighting moderno ───────────────
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        main  = 'nvim-treesitter.configs',
        opts  = {
            ensure_installed = {
                'bash', 'lua', 'python', 'markdown', 'markdown_inline',
                'json', 'yaml', 'toml', 'html', 'css', 'javascript',
                'vim', 'vimdoc', 'gitcommit', 'diff', 'dockerfile',
            },
            auto_install = true,
            highlight    = { enable = true, additional_vim_regex_highlighting = false },
            indent       = { enable = true },
        },
    },

    -- ── Statusline ────────────────────────────────────────────
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            options = {
                theme = 'nord',
                icons_enabled = true,
                component_separators = '|',
                section_separators = '',
            },
        },
    },

    -- ── Indentación visual ────────────────────────────────────
    {
        'lukas-reineke/indent-blankline.nvim',
        main = 'ibl',
        opts = {
            indent = { char = '│' },
            scope  = { enabled = false },
        },
    },

}, {
    ui = {
        icons = vim.g.have_nerd_font and {} or {
            cmd = '⌘', config = '🛠', event = '📅', ft = '📂', init = '⚙',
            keys = '🗝', plugin = '🔌', runtime = '💻', require = '🌙',
            source = '📄', start = '🚀', task = '📌', lazy = '💤 ',
        },
    },
})

-- vim: ts=4 sts=4 sw=4 et
