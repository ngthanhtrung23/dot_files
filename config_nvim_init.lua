-- 1. GLOBAL CONFIGS {{{
vim.g.mapleader = ","
vim.g.python3_host_prog = vim.fn.expand('~/.neovim_venv/bin/python')
-- }}}

-- 2. PLUGIN MANAGER {{{
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- FZF
  {
    'junegunn/fzf.vim',
    dependencies = {
      { 'junegunn/fzf', build = './install --bin' }
    },
    init = function()
      if vim.fn.has('nvim') == 1 then
        vim.g.fzf_layout = { window = { width = 0.9, height = 0.6 } }
      end
    end,
    config = function()
      vim.cmd('cabbrev rg Rg')
      vim.keymap.set('n', '<C-p>', ':GFiles<CR>')
    end
  },

  -- Utils
  'tpope/vim-surround',
  'tpope/vim-repeat',
  {
    'tpope/vim-commentary',
    config = function()
      vim.keymap.set('v', '<leader>cc', 'gc', { remap = true, desc = 'Comment selection' })
      vim.keymap.set('n', '<leader>cc', 'gcc', { remap = true, desc = 'Comment out line' })
    end
  },
  'christoomey/vim-tmux-navigator',

  -- Git
  'tpope/vim-fugitive',
  {
    'airblade/vim-gitgutter',
    init = function()
      vim.g.gitgutter_realtime = 1
      vim.g.gitgutter_eager = 1

      -- Floating window settings
      vim.g.gitgutter_preview_win_floating = 1
      vim.g.gitgutter_floating_window_options = {
        relative = 'cursor',
        row = 1,
        col = 0,
        width = 42,
        height = 10,
        style = 'minimal',
        border = 'rounded',
      }
    end,
    config = function()
      vim.cmd('cabbrev git Git')
    end,
  },

  -- UI
  {
    'vim-airline/vim-airline',
    config = function()
      vim.g.airline_section_b = ""
      vim.g.airline_section_z = "%l/%L"
      vim.g.airline_extensions = [[]]
    end
  },
  {
    'catppuccin/nvim',
    name = "catppuccin",
    priority = 1000,
  },

  -- Languages
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ":TSUpdate",
    config = function()
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.opt.foldlevel = 99 -- Keeps folds open by default when you open a file
    end,
  },
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
    ft = {'markdown', 'latex'},
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'hrsh7th/nvim-cmp',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      -- Setup completion
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
        })
      })

      -- C++ LSP configuration
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      vim.lsp.config('clangd', {
        capabilities = capabilities,
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
        },
        filetypes = { "c", "cpp" },
        capabilities = capabilities,
      })
      -- Python LSP configuration using vim.lsp.config
      vim.lsp.config('pyright', {
        cmd = { 'pyright-langserver', '--stdio' },
        filetypes = { 'python' },
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            }
          }
        }
      })

      -- LSP keymaps
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local opts = { buffer = args.buf }
          vim.keymap.set('n', 'gd', function()
            vim.cmd('vsplit')
            vim.lsp.buf.definition()
          end, opts)
          vim.keymap.set('n', '<leader>gd', function()
            vim.cmd('tab split')
            vim.lsp.buf.definition()
          end, opts)

          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '[e', vim.diagnostic.goto_prev, opts)
          vim.keymap.set('n', ']e', vim.diagnostic.goto_next, opts)
          vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
        end,
      })
    end,
  },
})
-- }}}

-- 3. PLUGIN SETTINGS {{{
require("nvim-treesitter").setup({
  ensure_installed = { "cpp", "python", "lua" },
  sync_install = false,
  highlight = { enable = true },
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'cpp', 'cc', 'py', 'lua', 'tex' },
  callback = function()
    vim.treesitter.start()
    vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo[0][0].foldmethod = 'expr'
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

require("markview").setup({
  latex = {
  blocks = {
    enable = true, -- Enables rendering of LaTeX blocks
    -- other options like hl, pad_amount, etc.
  },
  commands = {
    enable = true, -- Enables rendering of inline LaTeX commands
    -- other command-specific options
  }
  },
  -- other markview options
})

require("catppuccin").setup({
  flavour = "mocha",
  color_overrides = {
    mocha = {
      base = "#000000",  -- Main background
      mantle = "#000000",  -- Slightly darker background (sidebars, etc.)
      crust = "#000000",  -- Even darker (status line background)
    },
  },
})
vim.cmd.colorscheme 'catppuccin-mocha'

-- Tmux
vim.api.nvim_create_autocmd('FocusGained', {
  callback = function()
    vim.cmd('highlight Normal guibg=#000000 ctermbg=NONE')
  end,
})
vim.api.nvim_create_autocmd('FocusLost', {
  callback = function()
    vim.cmd('highlight Normal guibg=#3d3d3d ctermbg=235')
  end
})

-- netrw
vim.g.netrw_bufsettings = 'noma nomod nu nobl nowrap ro'

-- LSP
-- Enable LSP for C/C++ files
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp' },
  callback = function()
    vim.lsp.enable('clangd')
  end,
})
-- Enable LSP for Python files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.lsp.enable('pyright')
  end,
})
-- LSP hover border
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or 'rounded'
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- }}}

-- 4. GENERAL SETTINGS {{{
local opt = vim.opt

opt.modeline = false
opt.number = true
opt.mouse = ""

-- Identation
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.autoindent = true
opt.expandtab = true
opt.backspace = {"start", "eol", "indent"}

-- System & Files
opt.autoread = true
opt.autowrite = true
opt.hidden = true
opt.history = 200
opt.updatetime = 200
opt.timeoutlen = 1200

-- UI
opt.cursorline = true

opt.background = "dark"
opt.ruler = true
opt.showcmd = true
opt.visualbell = true
opt.errorbells = false
opt.display:append("lastline")
opt.display:append("uhex")
opt.foldlevel = 20

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Search
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Clipboard
opt.clipboard = "unnamedplus"

opt.foldmethod = 'marker'

-- }}}

-- 5. KEY MAPPINGS {{{

-- Disable Ex mode
local map = vim.keymap.set

map('n', 'Q', '<Nop>')

-- Copy multiple times in visual mode
map('x', 'p', 'pgvy')

-- <leader>vs opens file in same dir
map('n', '<leader>vs', ':vs <C-R>=expand("%:p:h") . "/" <CR>')

-- netrw
map('n', '<C-N>', ':Ex<CR>')

-- folding
map('n', '<Tab>', 'zA')
-- }}}

-- 6. AUTOCMD (FILE TYPES, QUICKFIX) {{{
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'lua' },
  callback = function()
    opt.tabstop = 2
    opt.shiftwidth = 2
    opt.softtabstop = 2
  end,
})
-- }}}
