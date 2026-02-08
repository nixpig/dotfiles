local icons = {
  ui = require('icons').get 'ui',
  kind = require('icons').get 'kind',
  diagnostics = require('icons').get 'diagnostics',
  git = require('icons').get 'git',
  misc = require('icons').get 'misc',
  dap = require('icons').get 'dap',
  listchars = require('icons').get 'listchars',
}

local colors = require('colors').palette()

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.g.go_doc_keywordprg_enabled = false
vim.g.indent_blankline_buftype_exclude = { 'terminal', 'nofile' }

vim.scriptencoding = 'utf-8'

-- Editor behavior
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.confirm = true
vim.opt.timeout = true
vim.opt.timeoutlen = 500
vim.opt.updatetime = 250
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.backupskip = { '/tmp/*', '/private/tmp/*' }
vim.opt.clipboard = 'unnamedplus'
vim.opt.shell = 'bash'

-- Display
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.signcolumn = 'yes'
vim.opt.colorcolumn = '80'
vim.opt.title = true
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.termguicolors = true
vim.opt.background = 'dark'
vim.opt.winblend = 10
vim.opt.pumblend = 10

-- Search
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = 'split'

-- Indentation
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2

-- Wrapping and scrolling
vim.opt.wrap = false
vim.opt.scrolloff = 15
vim.opt.foldenable = false

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Encoding
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

-- Completion and wildcards
vim.opt.wildmenu = true
vim.opt.wildoptions = 'pum'
vim.opt.path:append { '**' }
vim.opt.wildignore:append { '*/node_modules/*', '^.git/' }

-- Editing
vim.opt.backspace = { 'start', 'eol', 'indent' }
vim.opt.formatoptions:append { 'r' }

-- List characters
vim.opt.list = true
vim.opt.listchars = {
  tab = icons.listchars.Tab,
  trail = icons.listchars.Trail,
  nbsp = icons.listchars.Nbsp,
  space = icons.listchars.Space,
  extends = icons.listchars.Extends,
  precedes = icons.listchars.Precedes,
  eol = icons.listchars.Eol,
}

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require('lazy').setup({
  -----------------------------------------------------------------------------
  -- Simple plugins (no config)
  -----------------------------------------------------------------------------
  -- Language support
  'maralla/gomod.vim',
  'jose-elias-alvarez/typescript.nvim',
  'rafamadriz/friendly-snippets',

  -- Editing
  'tpope/vim-repeat',
  'tpope/vim-unimpaired',
  'tpope/vim-surround',
  'tpope/vim-sleuth',
  'NMAC427/guess-indent.nvim',
  'unblevable/quick-scope',
  'christoomey/vim-tmux-navigator',

  -- Telescope extensions
  'nvim-telescope/telescope-fzf-native.nvim',
  'nvim-telescope/telescope-symbols.nvim',
  'nvim-telescope/telescope-ui-select.nvim',
  'nvim-telescope/telescope-file-browser.nvim',
  'debugloop/telescope-undo.nvim',
  'duane9/nvim-rg',

  -- Treesitter extensions
  'nvim-treesitter/nvim-treesitter-context',

  -- UI
  'norcalli/nvim-colorizer.lua',

  -----------------------------------------------------------------------------
  -- Language support
  -----------------------------------------------------------------------------
  {
    'fatih/vim-go',
    config = function()
      vim.g.go_fmt_command = 'gofumpt'
      vim.g.go_fmt_autosave = 0
      vim.g.go_gopls_enabled = 0
      vim.g.go_code_completion_enabled = 0
      vim.g.go_def_mapping_enabled = 0
    end,
  },

  {
    'towolf/vim-helm',
    lazy = false,
  },
  {
    'qvalentin/helm-ls.nvim',
    ft = 'helm',
    opts = {
      conceal_templates = {
        enabled = false, -- enable the replacement of templates with virtual text of their current values
      },
      indent_hints = {
        enabled = true, -- enable hints for indent and nindent functions
      },
    },
  },

  {
    'windwp/nvim-ts-autotag',
    opts = {},
  },

  {
    'rmagatti/alternate-toggler',
    keys = {
      {
        '<leader><space>',
        function()
          require('alternate-toggler').toggleAlternate()
        end,
        desc = 'Toggle boolean-like value',
      },
    },
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
      disable_filetype = { 'TelescopePrompt', 'vim' },
    },
  },

  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup {
        pre_hook = function(ctx)
          -- Only calculate commentstring for tsx filetypes
          if vim.bo.filetype == 'typescriptreact' then
            local U = require 'Comment.utils'

            -- Determine whether to use linewise or blockwise commentstring
            local type = ctx.ctype == U.ctype.linewise and '__default' or '__multiline'

            -- Determine the location where to calculate commentstring from
            local location = nil
            if ctx.ctype == U.ctype.blockwise then
              location = require('ts_context_commentstring.utils').get_cursor_location()
            elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
              location = require('ts_context_commentstring.utils').get_visual_start_location()
            end

            return require('ts_context_commentstring.internal').calculate_commentstring { key = type, location = location }
          end
        end,
      }
    end,
  },

  -----------------------------------------------------------------------------
  -- UI
  -----------------------------------------------------------------------------
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
      local highlight = {
        'RainbowRed',
        'RainbowYellow',
        'RainbowBlue',
        'RainbowOrange',
        'RainbowGreen',
        'RainbowViolet',
        'RainbowCyan',
      }

      local hooks = require 'ibl.hooks'
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        local hl = vim.api.nvim_set_hl
        hl(0, 'RainbowRed', { fg = colors.red })
        hl(0, 'RainbowYellow', { fg = colors.yellow })
        hl(0, 'RainbowBlue', { fg = colors.blue })
        hl(0, 'RainbowOrange', { fg = colors.peach })
        hl(0, 'RainbowGreen', { fg = colors.green })
        hl(0, 'RainbowViolet', { fg = colors.mauve })
        hl(0, 'RainbowCyan', { fg = colors.sky })
        hl(0, 'IblIndent', { fg = colors.surface1 })
      end)

      require('ibl').setup {
        indent = { highlight = 'IblIndent', char = '│', tab_char = '│' },
        whitespace = { highlight = { 'Whitespace' }, remove_blankline_trail = false },
        scope = { enabled = true, highlight = highlight },
      }
    end,
  },

  {
    'nvim-lualine/lualine.nvim',
    config = function()
      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'catppuccin',
          section_separators = { left = '', right = '' },
          component_separators = { left = icons.misc.Vbar, right = icons.misc.Vbar },
          disabled_filetypes = { 'packer', 'NvimTree', 'dbui' },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { { 'branch', icon = icons.git.Branch }, 'diff' },
          lualine_c = {
            {
              'filename',
              file_status = true, -- displays file status (readonly status, modified status)
              path = 1,           -- 0 = just filename, 1 = relative path, 2 = absolute path
            },
          },
          lualine_x = {
            {
              'diagnostics',
              sources = { 'nvim_diagnostic' },
              symbols = {
                error = icons.diagnostics.Error .. ' ',
                warn = icons.diagnostics.Warning .. ' ',
                info = icons.diagnostics.Information .. ' ',
                hint = icons.diagnostics.Hint .. ' ',
              },
            },
            'encoding',
            'filetype',
          },
          lualine_y = { 'progress' },
          lualine_z = { 'location' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            {
              'filename',
              file_status = true, -- displays file status (readonly status, modified status)
              path = 1,           -- 0 = just filename, 1 = relative path, 2 = absolute path
            },
          },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {
          -- lualine_a = { 'buffers' },
          -- lualine_z = { 'tabs' }
        },
        extensions = {},
      }
    end,
  },

  {
    'hiphish/rainbow-delimiters.nvim',
    config = function()
      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = require('rainbow-delimiters').strategy['global'],
          vim = require('rainbow-delimiters').strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
          tsx = 'rainbow-delimiters-react',
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
        blacklist = { 'php' },
      }
    end,
  },

  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 1000,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },
      spec = {
        { '<leader>s', group = '[S]earch' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      },
    },
  },

  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  -----------------------------------------------------------------------------
  -- Git
  -----------------------------------------------------------------------------
  {
    'dinhhuy258/git.nvim',
    opts = {
      blame = '<Leader>gb',
      browse = '<Leader>go',
    },
  },

  {
    'akinsho/git-conflict.nvim',
    opts = {
      -- default_mappings = false,
      highlights = {
        incoming = 'DiffAdd',
        current = 'DiffText',
      },
    },
    -- config = function()
    --   vim.keymap.set('n', 'co', '<Plug>(git-conflict-ours)', { desc = 'git-conflict choose ours' })
    --   vim.keymap.set('n', 'ct', '<Plug>(git-conflict-theirs)', { desc = 'git-conflict choose theirs' })
    --   vim.keymap.set('n', 'cb', '<Plug>(git-conflict-both)', { desc = 'git-conflict choose both' })
    --   vim.keymap.set('n', 'c0', '<Plug>(git-conflict-none)', { desc = 'git-conflict choose none' })
    --   vim.keymap.set('n', ']x', '<Plug>(git-conflict-next-conflict)', { desc = 'git-conflict next conflict' })
    --   vim.keymap.set('n', ']x', '<Plug>(git-conflict-prev-conflict)', { desc = 'git-conflict previous conflict' })
    -- end,
  },

  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = icons.git.Add },
        change = { text = icons.git.Mod_alt },
        delete = { text = icons.git.Remove },
        changedelete = { text = icons.git.ChangeDelete },
        untracked = { text = icons.git.Untracked },
        topdelete = { text = icons.git.TopDelete },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions
        -- visual mode
        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [s]tage hunk' })
        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'git [r]eset hunk' })
        -- normal mode
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', '<leader>hu', gitsigns.stage_hunk, { desc = 'git [u]ndo stage hunk' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>hD', function()
          gitsigns.diffthis '@'
        end, { desc = 'git [D]iff against last commit' })
      end,
    },
  },

  -----------------------------------------------------------------------------
  -- Telescope
  -----------------------------------------------------------------------------
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons',            enabled = vim.g.have_nerd_font },
    },
    config = function()
      local telescope = require 'telescope'

      local actions = require 'telescope.actions'
      local builtin = require 'telescope.builtin'
      local extensions = telescope.extensions
      local fb_actions = extensions.file_browser.actions

      telescope.load_extension 'file_browser'
      telescope.load_extension 'fzf'
      telescope.load_extension 'ui-select'
      telescope.load_extension 'undo'

      telescope.setup {
        defaults = {
          mappings = { n = { ['q'] = actions.close } },
          prompt_prefix = ' ' .. icons.ui.Search .. ' ',
          selection_caret = ' ',
          entry_prefix = ' ',
          initial_mode = 'insert',
          selection_strategy = 'reset',
          sorting_strategy = 'ascending',
          layout_strategy = 'horizontal',
          layout_config = {
            horizontal = {
              prompt_position = 'top',
              preview_width = 0.5,
              results_width = 0.5,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.85,
            preview_cutoff = 20,
          },
          set_env = { ['COLORTERM'] = 'truecolor' },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown {},
          },
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = 'smart_case',       -- or "ignore_case" or "respect_case" the default case_mode is "smart_case"
          },
          file_browser = {
            hijack_netrw = true,
            mappings = {
              ['i'] = {
                ['<C-w>'] = function()
                  vim.cmd 'normal vbd'
                end,
              },
              ['n'] = {
                -- your custom normal mode mappings
                ['N'] = fb_actions.create,
                ['h'] = fb_actions.goto_parent_dir,
                ['/'] = function()
                  vim.cmd 'startinsert'
                end,
              },
            },
          },
          undo = {},
        },
      }

      vim.keymap.set('n', '<leader>f', function()
        builtin.find_files {
          find_command = { 'rg', '--files', '--hidden', '-g', '!.git' },
          no_ignore = false,
          hidden = true,
        }
      end, { desc = 'Telescope: Find files' })

      vim.keymap.set('n', '<leader>r', function()
        builtin.live_grep()
      end, { desc = 'Telescope: Live grep' })

      vim.keymap.set('n', '<leader>\\', function()
        builtin.buffers {
          sort_lastused = true, --[[ ignore_current_buffer = true ]]
        }
      end, { desc = 'Telescope: Browse buffers' })

      vim.keymap.set('n', '<leader>t', function()
        builtin.help_tags()
      end, { desc = 'Telescope: Browse help tags' })

      vim.keymap.set('n', '<leader>;', function()
        builtin.resume()
      end, { desc = 'Telescope: Resume session' })

      vim.keymap.set('n', '<leader>e', function()
        builtin.diagnostics()
      end, { desc = 'Telescope: Browse file diagnostics' })

      vim.keymap.set('n', '<leader>b', function()
        extensions.file_browser.file_browser {
          respect_gitignore = false,
          hidden = true,
          grouped = true,
          previewer = false,
          initial_mode = 'insert',
        }
      end, { desc = 'Telescope: File browser' })

      vim.keymap.set('n', '<leader>m', function()
        builtin.marks()
      end, { desc = 'Telescope: Browse marks' })

      vim.keymap.set('n', '<leader>gc', function()
        builtin.git_bcommits()
      end, { desc = 'Telescope: Browse git commits' })

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find()
      end, { desc = 'Telescope: Fuzzy search current buffer' })

      vim.keymap.set('n', '<leader>u', '<cmd>Telescope undo<CR>', { desc = 'Telescope: Browse undo history' })

      vim.keymap.set('n', '<leader>k', '<cmd>Telescope keymaps<CR>', { desc = 'Telescope: Browse keymaps' })
    end,
  },

  -----------------------------------------------------------------------------
  -- LSP
  -----------------------------------------------------------------------------
  {
    'ray-x/lsp_signature.nvim',
    opts = {
      bind = true,
      hint_enable = false,
      doc_lines = 0,
      hi_parameter = 'LspSignatureActiveParameter',
      always_trigger = true,
      handler_opts = {
        border = 'rounded',
      },
    },
  },

  {
    'mrcjkb/rustaceanvim',
    version = '^5',
    lazy = false,
    ft = { 'rust' },
    config = function()
      vim.g.rustaceanvim = {
        tools = {
          hover_actions = {
            auto_focus = false,
          },
        },
        server = {
          on_attach = function(_, _)
            vim.api.nvim_create_autocmd('BufWritePre', {
              pattern = { '*.rs' },
              callback = function()
                vim.lsp.buf.format { timeout_ms = 100 }
              end,
              group = vim.api.nvim_create_augroup('MyAutocmdsRustFormatting', {}),
            })
          end,
          default_settings = {
            ['rust-analyzer'] = {
              check = {
                command = 'clippy',
              },
            },
          },
        },
      }
    end,
  },

  {
    'nvimdev/lspsaga.nvim',
    after = 'nvim-lspconfig',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      devicon = 'true',
      ui = {
        winblend = 10,
        border = 'rounded',
        code_action = '',
      },
      symbol_in_winbar = {
        enable = true,
        separator = ' ' .. icons.ui.ArrowClosed .. ' ',
        respect_root = true,
      },
      lightbulb = {
        enable = true,
      },
      diagnostic = {
        border_follow = true,
      },
      rename = {
        in_select = false,
      },
      hover = {
        open_browser = '!firefox',
      },
      finder = {
        max_height = 0.6,
      },
      definition = {
        width = 0.6,
        height = 0.5,
      },
      outline = {
        win_width = 50,
      },
    },
  },

  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'mason-org/mason.nvim', opts = {} },
      {
        'mason-org/mason-lspconfig.nvim',
        opts = {},
      },
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      {
        'j-hui/fidget.nvim',
        opts = {
          notification = {
            window = {
              winblend = 10,
              border = 'rounded',
              normal_hl = 'NormalFloat',
              border_hl = 'FloatBorder',
            },
          },
        },
      },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      vim.lsp.protocol.CompletionItemKind = {
        icons.kind.Text,
        icons.kind.Method,
        icons.kind.Function,
        icons.kind.Constructor,
        icons.kind.Field,
        icons.kind.Variable,
        icons.kind.Class,
        icons.kind.Interface,
        icons.kind.Module,
        icons.kind.Property,
        icons.kind.Unit,
        icons.kind.Value,
        icons.kind.Enum,
        icons.kind.Keyword,
        icons.kind.Snippet,
        icons.kind.Color,
        icons.kind.File,
        icons.kind.Reference,
        icons.kind.Folder,
        icons.kind.EnumMember,
        icons.kind.Constant,
        icons.kind.Struct,
        icons.kind.Event,
        icons.kind.Operator,
        icons.kind.TypeParameter,
      }

      local capabilities = vim.lsp.protocol.make_client_capabilities()

      vim.diagnostic.config {
        virtual_text = {
          spacing = 2,
          prefix = icons.ui.BigCircle,
        },
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
            [vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
            [vim.diagnostic.severity.INFO] = icons.diagnostics.Information,
            [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
          },
        },
        float = {
          source = 'if_many',
          border = 'rounded',
          format = function(d)
            return ('%s (%s) [%s]'):format(d.message, d.source, d.code or d.user_data.lsp.code)
          end,
        },
        jump = {
          on_jump = function(diagnostic)
            vim.diagnostic.open_float()
          end,
        },
      }

      local servers = {
        ts_ls = {
          root_dir = function(bufnr, on_dir)
            local root = vim.fs.root(bufnr, { 'tsconfig.json', 'jsconfig.json', 'package.json', '.git' })
            on_dir(root or vim.uv.cwd())
          end,
        },
        bashls = {
          filetypes = { 'sh', 'shell', 'bash', 'zsh', 'fish', 'fsh' },
        },
        cssls = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
              },

              workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file('', true),
                checkThirdParty = false,
              },
            },
          },
        },
        eslint = {
          root_dir = function(bufnr, on_dir)
            local eslint_configs =
            { 'eslint.config.js', 'eslint.config.mjs', 'eslint.config.cjs', '.eslintrc.js', '.eslintrc.json',
              '.eslintrc.yaml', '.eslintrc.yml', '.eslintrc' }
            local config_file = vim.fs.find(eslint_configs, { path = vim.api.nvim_buf_get_name(bufnr), upward = true })
                [1]
            if config_file then
              on_dir(vim.fs.dirname(config_file))
            end
            -- Don't call on_dir if no config found - this disables eslint for this buffer
          end,
        },
        ansiblels = {},
        cssmodules_ls = {},
        jsonls = {},
        docker_compose_language_service = {},
        html = {},
        dockerls = {},
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
            },
          },
        },
        buf_ls = {},
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                ['https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json'] = {
                  'docker-compose*.yml',
                  'docker-compose*.yaml',
                  '*compose.yml',
                  '*compose.yaml',
                },
                kubernetes = {
                  -- Full resource names
                  '**/*-deployment.yaml',
                  '**/*-deployment.yml',
                  '**/*-service.yaml',
                  '**/*-service.yml',
                  '**/*-configmap.yaml',
                  '**/*-configmap.yml',
                  '**/*-secret.yaml',
                  '**/*-secret.yml',
                  '**/*-ingress.yaml',
                  '**/*-ingress.yml',
                  '**/*-pod.yaml',
                  '**/*-pod.yml',
                  '**/*-statefulset.yaml',
                  '**/*-statefulset.yml',
                  '**/*-daemonset.yaml',
                  '**/*-daemonset.yml',
                  '**/*-job.yaml',
                  '**/*-job.yml',
                  '**/*-cronjob.yaml',
                  '**/*-cronjob.yml',
                  '**/*-namespace.yaml',
                  '**/*-namespace.yml',
                  '**/*-persistentvolume.yaml',
                  '**/*-persistentvolume.yml',
                  '**/*-persistentvolumeclaim.yaml',
                  '**/*-persistentvolumeclaim.yml',
                  '**/*-serviceaccount.yaml',
                  '**/*-serviceaccount.yml',
                  '**/*-role.yaml',
                  '**/*-role.yml',
                  '**/*-rolebinding.yaml',
                  '**/*-rolebinding.yml',
                  '**/*-clusterrole.yaml',
                  '**/*-clusterrole.yml',
                  '**/*-clusterrolebinding.yaml',
                  '**/*-clusterrolebinding.yml',
                  '**/*-networkpolicy.yaml',
                  '**/*-networkpolicy.yml',
                  '**/*-hpa.yaml',
                  '**/*-hpa.yml',
                  '**/*-replicaset.yaml',
                  '**/*-replicaset.yml',
                  -- Short resource names
                  '**/*-deploy.yaml',
                  '**/*-deploy.yml',
                  '**/*-svc.yaml',
                  '**/*-svc.yml',
                  '**/*-cm.yaml',
                  '**/*-cm.yml',
                  '**/*-ing.yaml',
                  '**/*-ing.yml',
                  '**/*-sts.yaml',
                  '**/*-sts.yml',
                  '**/*-ds.yaml',
                  '**/*-ds.yml',
                  '**/*-cj.yaml',
                  '**/*-cj.yml',
                  '**/*-ns.yaml',
                  '**/*-ns.yml',
                  '**/*-pv.yaml',
                  '**/*-pv.yml',
                  '**/*-pvc.yaml',
                  '**/*-pvc.yml',
                  '**/*-sa.yaml',
                  '**/*-sa.yml',
                  '**/*-rb.yaml',
                  '**/*-rb.yml',
                  '**/*-crb.yaml',
                  '**/*-crb.yml',
                  '**/*-netpol.yaml',
                  '**/*-netpol.yml',
                  '**/*-rs.yaml',
                  '**/*-rs.yml',
                },
              },
              validate = true,
              completion = true,
              hover = true,
            },
          },
        },
        jdtls = {
          on_attach = function()
            require('jdtls').start_or_attach {
              cmd = '~/.local/share/nvim/mason/bin/jdtls',
              root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
            }
          end,
        },
        gradle_ls = {},
        helm_ls = {
          settings = {
            ['helm-ls'] = {
              yamlls = {
                path = 'yaml-language-server',
              },
            },
          },
        },
        terraformls = {
          filetypes = { 'hcl', 'terraform' },
        },
        tflint = {
          filetypes = { 'hcl', 'terraform' },
        },
        templ = {},
        postgres_lsp = {},
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        -- 'stylua',
        'gofumpt',
        'golines',
      })

      require('mason-tool-installer').setup {
        ensure_installed = ensure_installed,
      }

      require('mason-lspconfig').setup {
        ensure_installed = {},
        automatic_enable = { exclude = { 'ts_ls', 'eslint' } },
      }

      -- Configure and enable servers with custom settings
      for server_name, server_config in pairs(servers) do
        server_config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_config.capabilities or {})
        vim.lsp.config(server_name, server_config)
        vim.lsp.enable(server_name)
      end
    end,
  },

  -----------------------------------------------------------------------------
  -- Formatting
  -----------------------------------------------------------------------------
  {
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    -- keys = {
    --   {
    --     '<leader>f',
    --     function()
    --       require('conform').format { async = true, lsp_format = 'fallback' }
    --     end,
    --     mode = '',
    --     desc = '[F]ormat buffer',
    --   },
    -- },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        if disable_filetypes[vim.bo[bufnr].filetype] then
          return nil
        else
          return {
            timeout_ms = 500,
            lsp_format = 'fallback',
          }
        end
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        json = { 'prettierd', 'prettier', stop_after_first = true },
        jsonc = { 'prettierd', 'prettier', stop_after_first = true },
        css = { 'prettierd', 'prettier', stop_after_first = true },
        scss = { 'prettierd', 'prettier', stop_after_first = true },
      },
      formatters = {},
    },
  },

  -----------------------------------------------------------------------------
  -- Completion
  -----------------------------------------------------------------------------
  {
    'saghen/blink.cmp',
    event = 'VimEnter',
    version = '1.*',
    dependencies = {
      {
        'L3MON4D3/LuaSnip',
        version = '2.*',
        dependencies = { 'rafamadriz/friendly-snippets' },
        config = function()
          local luasnip = require 'luasnip'
          require('luasnip.loaders.from_vscode').lazy_load()
          require('luasnip.loaders.from_vscode').lazy_load { paths = { vim.fn.stdpath 'config' .. '/snippets' } }

          luasnip.filetype_extend('helm', { 'yaml' })
        end,
        build = (function()
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'folke/lazydev.nvim',
    },
    --- @module 'blink.cmp'
    --- @type blink.cmp.Config
    opts = {
      keymap = {
        -- preset = 'default',
        ['<Esc>'] = { 'cancel', 'fallback' },
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'scroll_documentation_down', 'fallback' },
        ['<Up>'] = { 'scroll_documentation_up', 'fallback' },
        ['<Tab>'] = { 'accept', 'fallback' },
        ['<C-l>'] = { 'snippet_forward', 'fallback' },
        ['<C-h>'] = { 'snippet_backward', 'fallback' },
      },

      appearance = {
        nerd_font_variant = 'mono',
        kind_icons = {
          Text = icons.kind.Text,
          Method = icons.kind.Method,
          Function = icons.kind.Function,
          Constructor = icons.kind.Constructor,
          Field = icons.kind.Field,
          Variable = icons.kind.Variable,
          Class = icons.kind.Class,
          Interface = icons.kind.Interface,
          Module = icons.kind.Module,
          Property = icons.kind.Property,
          Unit = icons.kind.Unit,
          Value = icons.kind.Value,
          Enum = icons.kind.Enum,
          Keyword = icons.kind.Keyword,
          Snippet = icons.kind.Snippet,
          Color = icons.kind.Color,
          File = icons.kind.File,
          Reference = icons.kind.Reference,
          Folder = icons.kind.Folder,
          EnumMember = icons.kind.EnumMember,
          Constant = icons.kind.Constant,
          Struct = icons.kind.Struct,
          Event = icons.kind.Event,
          Operator = icons.kind.Operator,
          TypeParameter = icons.kind.TypeParameter,
          Copilot = icons.kind.Copilot,
        },
      },

      completion = {
        menu = {
          draw = {
            gap = 2,
            padding = 2,
            columns = {
              { 'kind_icon' },
              { 'label',    'label_description', gap = 1 },
              { 'kind' },
            },
            components = {},
          },
        },
        -- completeopt = 'menu,menuone,noinsert,preview',
        ghost_text = {
          enabled = false,
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 250,
          window = {
            winblend = 10,
            border = 'rounded',
            winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder',
            scrollbar = false,
          },
        },
      },

      --       -- sorting = {
      --       --     priority_weight = 2,
      --       --     comparators = {
      --       --         cmp.config.compare.offset,
      --       --         cmp.config.compare.scopes,
      --       --         cmp.config.compare.score,
      --       --         cmp.config.compare.recently_used,
      --       --         cmp.config.compare.locality,
      --       --         cmp.config.compare.kind,
      --       --         cmp.config.compare.sort_text,
      --       --         cmp.config.compare.length,
      --       --         cmp.config.compare.order,
      --       --         cmp.config.compare.exact,
      --       --     },
      --       -- },

      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          lsp = {
            score_offset = 10, -- Boost LSP above snippets
          },
          snippets = {
            score_offset = -5, -- Lower priority for snippets
          },
          lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
          dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
        },
        per_filetype = {
          sql = { 'dadbod', 'snippets', 'buffer' },
        },
      },

      snippets = { preset = 'luasnip' },

      fuzzy = {
        implementation = 'prefer_rust',
      },
    },
  },

  -----------------------------------------------------------------------------
  -- Database
  -----------------------------------------------------------------------------
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod',                     lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      local hl = vim.api.nvim_set_hl
      hl(0, 'NotificationInfo', { bg = 'NONE', fg = colors.green })
      hl(0, 'NotificationWarning', { bg = colors.peach, fg = colors.text })
      hl(0, 'NotificationError', { bg = colors.red, fg = colors.text })
    end,
  },

  -----------------------------------------------------------------------------
  -- Colorscheme
  -----------------------------------------------------------------------------
  {
    'catppuccin/nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      require('catppuccin').setup {
        comment_italics = true,
        integrations = {
          indent_blankline = { enabled = true, colored_indent_levels = false },
          mason = true,
          treesitter = true,
          native_lsp = {
            enabled = true,
            virtual_text = {
              errors = { 'italic' },
              hints = { 'italic' },
              warnings = { 'italic' },
              information = { 'italic' },
            },
            underlines = {
              errors = { 'underline' },
              hints = { 'underline' },
              warnings = { 'underline' },
              information = { 'underline' },
            },
          },
          cmp = true,
          dap = true,
          fidget = true,
          gitsigns = true,
          lsp_saga = true,
          neotest = true,
          notify = true,
          nvimtree = true,
          telescope = true,
          treesitter_context = true,
          which_key = true,
        },
      }

      vim.cmd.colorscheme 'catppuccin'

      vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE', ctermbg = 'NONE' })

      -- Fix floating window backgrounds to match theme
      vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = '*',
        callback = function()
          local palette = require('catppuccin.palettes').get_palette()
          vim.api.nvim_set_hl(0, 'NormalFloat', { bg = palette.mantle })
          vim.api.nvim_set_hl(0, 'FloatBorder', { bg = palette.mantle, fg = palette.blue })
          vim.api.nvim_set_hl(0, 'SagaNormal', { bg = palette.mantle })
          vim.api.nvim_set_hl(0, 'SagaBorder', { bg = palette.mantle, fg = palette.blue })
          vim.api.nvim_set_hl(0, 'FidgetNormal', { bg = palette.mantle })
          vim.api.nvim_set_hl(0, 'FidgetBorder', { bg = palette.mantle, fg = palette.blue })
          vim.api.nvim_set_hl(0, 'Whitespace', { fg = palette.surface0 })
          vim.api.nvim_set_hl(0, 'NonText', { fg = palette.surface0 })
        end,
      })

      -- Set highlights immediately as well
      local palette = require('catppuccin.palettes').get_palette()
      vim.api.nvim_set_hl(0, 'NormalFloat', { bg = palette.mantle })
      vim.api.nvim_set_hl(0, 'FloatBorder', { bg = palette.mantle, fg = palette.blue })
      -- Lspsaga specific highlights
      vim.api.nvim_set_hl(0, 'SagaNormal', { bg = palette.mantle })
      vim.api.nvim_set_hl(0, 'SagaBorder', { bg = palette.mantle, fg = palette.blue })

      -- Fidget notification window highlights
      vim.api.nvim_set_hl(0, 'FidgetNormal', { bg = palette.mantle })
      vim.api.nvim_set_hl(0, 'FidgetBorder', { bg = palette.mantle, fg = palette.blue })

      -- Make listchars (tabs, trailing spaces, etc.) subtle
      vim.api.nvim_set_hl(0, 'Whitespace', { fg = palette.surface0 })
      vim.api.nvim_set_hl(0, 'NonText', { fg = palette.surface0 })

      -- Bright cursor for insert mode
      vim.api.nvim_set_hl(0, 'iCursor', { fg = palette.base, bg = "#CDD6F4" })
      vim.opt.guicursor:append('i-ci-ve:ver25-iCursor')
    end,
  },

  -----------------------------------------------------------------------------
  -- Treesitter
  -----------------------------------------------------------------------------
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
      -- Add nvim-treesitter runtime queries to runtimepath
      local ts_path = vim.fn.stdpath('data') .. '/lazy/nvim-treesitter'
      vim.opt.runtimepath:prepend(ts_path .. '/runtime')

      require('nvim-treesitter').setup {}

      -- Install parsers
      local ensure_installed = {
        'markdown',
        'markdown_inline',
        'tsx',
        'typescript',
        'javascript',
        'java',
        'kotlin',
        'bash',
        'json',
        'json5',
        'go',
        'gomod',
        'yaml',
        'hcl',
        'terraform',
        'css',
        'html',
        'lua',
        'rust',
        'python',
        'diff',
        'dockerfile',
        'gitcommit',
        'gitattributes',
        'gitignore',
        'git_rebase',
        'http',
        'regex',
        'scss',
        'sql',
        'toml',
        'vim',
        'c',
        'cpp',
        'cmake',
        'vimdoc',
        'query',
        'templ',
        'vhs',
        'tmux',
      }

      -- Install missing parsers after startup
      vim.api.nvim_create_autocmd('VimEnter', {
        callback = function()
          local parser_dir = vim.fn.stdpath('data') .. '/site/parser/'
          local to_install = {}
          for _, lang in ipairs(ensure_installed) do
            local parser_file = parser_dir .. lang .. '.so'
            if vim.fn.filereadable(parser_file) == 0 then
              table.insert(to_install, lang)
            end
          end
          if #to_install > 0 then
            vim.cmd('TSInstall ' .. table.concat(to_install, ' '))
          end
        end,
      })

      -- Disable treesitter for helm files (use vim-helm syntax instead)
      -- Register to a non-existent parser so treesitter skips it entirely
      vim.treesitter.language.register('_noop', 'helm')

      -- Enable treesitter-based highlighting
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('TreesitterHighlight', { clear = true }),
        callback = function(args)
          -- Skip special buffers
          local buftype = vim.bo[args.buf].buftype
          if buftype ~= '' then
            return
          end

          -- Skip helm files - use vim syntax instead (handles YAML + Go templates)
          if args.match == 'helm' then
            return
          end

          -- Get the treesitter language for this filetype
          local lang = vim.treesitter.language.get_lang(args.match) or args.match

          -- Only start if parser is available
          if pcall(vim.treesitter.language.inspect, lang) then
            vim.treesitter.start(args.buf, lang)
          end
        end,
      })
    end,
  },

  -----------------------------------------------------------------------------
  -- Debugging (DAP)
  -----------------------------------------------------------------------------
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'mason-org/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'leoluz/nvim-dap-go',
    },
    keys = {
      {
        '<F5>',
        function()
          require('dap').continue()
        end,
        desc = 'Debug: Start/Continue',
      },
      {
        '<F1>',
        function()
          require('dap').step_into()
        end,
        desc = 'Debug: Step into',
      },
      {
        '<F2>',
        function()
          require('dap').step_over()
        end,
        desc = 'Debug: Step over',
      },
      {
        '<F3>',
        function()
          require('dap').step_out()
        end,
        desc = 'Debug: Step out',
      },
      {
        '<C-b>',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'Debug: Toggle breakpoint',
      },
      {
        '<C-c>',
        function()
          require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set conditional breakpoint',
      },
      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      {
        '<F7>',
        function()
          require('dapui').toggle()
        end,
        desc = 'Debug: See last session result',
      },
      {
        '<F9>',
        function()
          require('dap').close()
        end,
        desc = 'Debug: Stop debugging',
      },
      {
        '<C-Delete>',
        function()
          require('dap').clear_breakpoints()
        end,
        desc = 'Debug: Clear breakpoints',
      },
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      require('mason-nvim-dap').setup {
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_installation = true,

        ensure_installed = {
          'delve',
        },
      }

      dapui.setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = icons.dap.Pause,
            play = icons.dap.Play,
            step_into = icons.dap.StepInto,
            step_over = icons.dap.StepOver,
            step_out = icons.dap.StepOut,
            step_back = icons.dap.StepBack,
            run_last = icons.dap.RunLast,
            terminate = icons.dap.Terminate,
            disconnect = icons.dap.Disconnect,
          },
        },
      }

      vim.api.nvim_set_hl(0, 'DapBreak', { fg = colors.red })
      vim.api.nvim_set_hl(0, 'DapStop', { fg = colors.peach })
      local breakpoint_icons = vim.g.have_nerd_font
          and {
            Breakpoint = icons.dap.Breakpoint,
            BreakpointCondition = icons.dap.BreakpointCondition,
            BreakpointRejected = icons.dap.BreakpointRejected,
            LogPoint = icons.dap.LogPoint,
            Stopped = icons.dap.Stopped,
          }
          or {
            Breakpoint = icons.dap.Breakpoint,
            BreakpointCondition = icons.dap.BreakpointCondition,
            BreakpointRejected = icons.dap.BreakpointRejected,
            LogPoint = icons.dap.LogPoint,
            Stopped = icons.dap.Stopped,
          }
      for type, icon in pairs(breakpoint_icons) do
        local tp = 'Dap' .. type
        local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
        vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
      end

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      -- Install golang specific config
      require('dap-go').setup {
        delve = {
          -- On Windows delve must be run attached or it crashes.
          -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
          detached = vim.fn.has 'win32' == 0,
        },
      }
    end,
  },

  -----------------------------------------------------------------------------
  -- AI
  -----------------------------------------------------------------------------
  {
    'coder/claudecode.nvim',
    dependencies = { 'folke/snacks.nvim' },
    config = true,
    keys = {
      { '<leader>a',  nil,                              desc = 'AI/Claude Code' },
      { '<leader>ai', '<cmd>ClaudeCode<cr>',            desc = 'Toggle Claude' },
      { '<leader>af', '<cmd>ClaudeCodeFocus<cr>',       desc = 'Focus Claude' },
      { '<leader>ar', '<cmd>ClaudeCode --resume<cr>',   desc = 'Resume Claude' },
      { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
      { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' },
      { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>',       desc = 'Add current buffer' },
      { '<leader>as', '<cmd>ClaudeCodeSend<cr>',        mode = 'v',                  desc = 'Send to Claude' },
      { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>',  desc = 'Accept diff' },
      { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>',    desc = 'Deny diff' },
    },
    opts = {
      terminal = {
        split_side = 'right',
        split_width_percentage = 0.24,
        provider = 'auto',
        auto_close = true,
        snacks_win_opts = {}, -- Opts to pass to `Snacks.terminal.open()` - see Floating Window section below
      },
    },
  },
}, {
  rocks = {
    enabled = false,
  },
  ui = {
    icons = {},
  },
})

-- Enable Kubernetes schema for current YAML buffer
vim.keymap.set('n', '<leader>yk', function()
  local clients = vim.lsp.get_clients { bufnr = 0, name = 'yamlls' }

  if #clients == 0 then
    vim.notify('yamlls not attached', vim.log.levels.WARN)
    return
  end

  local client = clients[1]
  local uri = vim.uri_from_bufnr(0)
  local settings = client.config.settings or {}

  settings.yaml = settings.yaml or {}
  settings.yaml.schemas = settings.yaml.schemas or {}
  settings.yaml.schemas.kubernetes = settings.yaml.schemas.kubernetes or {}

  table.insert(settings.yaml.schemas.kubernetes, uri)
  client:notify('workspace/didChangeConfiguration', { settings = settings })
  vim.notify('Kubernetes schema enabled', vim.log.levels.INFO)
end, { desc = 'Enable Kubernetes schema for YAML buffer' })

-- Utility function to close any floating windows when you press escape
-- Source: https://gist.github.com/benfrain/97f2b91087121b2d4ba0dcc4202d252f#file-mappings-lua
local function close_floating()
  for _, win in pairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_config(win).relative == 'win' then
      vim.api.nvim_win_close(win, false)
    end
  end
end

-- Navigation
vim.keymap.set('n', '[[', '_i', { desc = 'Jump to first non-blank character on line' })
vim.keymap.set('n', ']]', '$a', { desc = 'Jump to end of line' })

-- Editing
vim.keymap.set('n', '+', '<C-a>', { desc = 'Increment number under cursor' })
vim.keymap.set('n', '-', '<C-x>', { desc = 'Decrement number under cursor' })
vim.keymap.set('n', 'U', '<C-r>', { desc = 'Redo' })
vim.keymap.set('v', 'y', 'ygv<Esc>', { desc = 'Yank and reposition cursor' })
vim.keymap.set({ 'n', 'x' }, '[p', '<Cmd>exe "put! " . v:register<CR>', { desc = 'Paste on line above' })
vim.keymap.set({ 'n', 'x' }, ']p', '<Cmd>exe "put "  . v:register<CR>', { desc = 'Paste on line below' })

-- Move lines/characters
vim.keymap.set('n', '<S-Up>', '<Cmd>m-2<CR>', { desc = 'Move current line up' })
vim.keymap.set('n', '<S-k>', '<Cmd>m-2<CR>', { desc = 'Move current line up' })
vim.keymap.set('n', '<S-Down>', '<Cmd>m+<CR>', { desc = 'Move current line down' })
vim.keymap.set('n', '<S-j>', '<Cmd>m+<CR>', { desc = 'Move current line down' })
vim.keymap.set('v', '<S-Down>', ":m '>+1<CR>gv=gv", { desc = 'Move selected region down' })
vim.keymap.set('v', '<S-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selected region down' })
vim.keymap.set('v', '<S-Up>', ":m '<-2<CR>gv=gv", { desc = 'Move selected region up' })
vim.keymap.set('v', '<S-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selected region up' })
vim.keymap.set('n', '<S-l>', 'xp', { desc = 'Move character under cursor right' })
vim.keymap.set('n', '<S-h>', 'xhhp', { desc = 'Move character under cursor left' })
vim.keymap.set('v', '<S-l>', 'dpgvlol', { desc = 'Move selected text right' })
vim.keymap.set('v', '<S-h>', 'dhhpgvhoh', { desc = 'Move selected text left' })

-- Selection
vim.keymap.set('n', '<C-a>', 'gg<S-v>G', { desc = 'Select all in current buffer' })

-- Buffers
vim.keymap.set('n', '<leader>d', '<Cmd>bd<CR>', { desc = 'Delete current buffer' })
vim.keymap.set('n', '<leader>D', '<Cmd>bd!<CR>', { desc = 'Force delete current buffer' })

-- Tabs
vim.keymap.set('n', 'te', '<Cmd>tabedit<CR>', { desc = 'Create new tab' })
vim.keymap.set('n', 'tc', '<Cmd>tabclose<CR>', { desc = 'Close tab' })

-- Splits
vim.keymap.set('n', 'sh', '<Cmd>split<CR><C-w>w', { desc = 'Split window horizontally' })
vim.keymap.set('n', 'sv', '<Cmd>vsplit<CR><C-w>w', { desc = 'Split window vertically' })
vim.keymap.set('n', 'sc', '<Cmd>only<CR>', { desc = 'Close all other splits' })
vim.keymap.set('n', '<leader><S-h>', '<C-w><', { desc = 'Resize window left' })
vim.keymap.set('n', '<leader><S-j>', '<C-w>-', { desc = 'Resize window down' })
vim.keymap.set('n', '<leader><S-k>', '<C-w>+', { desc = 'Resize window up' })
vim.keymap.set('n', '<leader><S-l>', '<C-w>>', { desc = 'Resize window right' })

-- Quickfix
vim.keymap.set('n', '<M-j>', '<Cmd>cnext<CR>', { desc = 'Next item in quickfix list' })
vim.keymap.set('n', '<M-k>', '<Cmd>cprev<CR>', { desc = 'Previous item in quickfix list' })

-- Utilities
vim.keymap.set('n', '<Esc>', function()
  close_floating()
  vim.cmd.noh()
end, { silent = true, desc = 'Clear search highlighting and dismiss popups' })
vim.keymap.set('n', '<leader>xc', '<Cmd>g/console.lo/d<CR>', { desc = 'Remove all console.log statements' })
vim.keymap.set('', '<leader>x', '<Cmd>!chmod +x %<CR>', { desc = 'Make current file executable' })

-- Tmux integration
vim.keymap.set('n', '<C-f>', '<Cmd>silent !tmux neww tmux-sessionizer<CR>', { desc = 'Trigger tmux-sessionizer' })
vim.keymap.set('n', '<C-_>', '<Cmd>silent ![[ "$TMUX" ]] && tmux split-window -h -p 30 tldr<CR>',
  { desc = 'Trigger tldr' })

-- Completion menu options
vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'preview' }
vim.api.nvim_set_hl(0, 'CmpItemKind', { link = 'CmpItemMenuDefault', default = true })

-- LSP (Lspsaga)
vim.keymap.set('n', ']w', '<Cmd>Lspsaga diagnostic_jump_next<CR>', { desc = 'Jump to next diagnostic' })
vim.keymap.set('n', '[w', '<Cmd>Lspsaga diagnostic_jump_prev<CR>', { desc = 'Jump to previous diagnostic' })
vim.keymap.set('n', 'gl', '<Cmd>Lspsaga show_line_diagnostics<CR>', { desc = 'Show line diagnostics' })
vim.keymap.set('n', 'gs', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', { desc = 'Show signature help' })
vim.keymap.set('n', 'gk', '<Cmd>Lspsaga hover_doc<CR>', { desc = 'Show hover documentation' })
vim.keymap.set('n', 'gh', '<Cmd>Lspsaga finder<CR>', { desc = 'Show definition and references' })
vim.keymap.set('n', 'gp', '<Cmd>Lspsaga peek_definition<CR>', { desc = 'Peek definition' })
vim.keymap.set('n', 'gr', '<Cmd>Lspsaga rename<CR>', { desc = 'Rename symbol' })
vim.keymap.set('n', 'gd', '<Cmd>Lspsaga goto_definition<CR>', { desc = 'Go to definition' })
vim.keymap.set('n', 'go', '<Cmd>Lspsaga outline<CR>', { desc = 'Show outline' })
vim.keymap.set({ 'n', 'v' }, 'ga', '<Cmd>Lspsaga code_action<CR>', { desc = 'Code action' })
vim.keymap.set('n', 'gt', '<Cmd>Lspsaga term_toggle<CR>', { desc = 'Toggle floating terminal' })

-- Autocommands
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Editing behavior
autocmd({ 'BufWritePost', 'BufEnter' }, {
  group = augroup('DisableFolding', { clear = true }),
  pattern = '*',
  callback = function()
    vim.opt_local.foldenable = false
    vim.opt_local.foldmethod = 'manual'
    vim.opt_local.foldlevelstart = 99
  end,
  desc = 'Disable folding',
})

autocmd('InsertLeave', {
  group = augroup('DisablePaste', { clear = true }),
  pattern = '*',
  callback = function()
    vim.opt_local.paste = false
  end,
  desc = 'Turn off paste mode when leaving insert',
})

autocmd('TextYankPost', {
  group = augroup('HighlightYank', { clear = true }),
  pattern = '*',
  callback = function()
    vim.hl.on_yank { higroup = 'Visual', timeout = 250 }
  end,
  desc = 'Highlight yanked text',
})

-- Config file auto-reload
autocmd('BufWritePost', {
  group = augroup('I3Reload', { clear = true }),
  pattern = '*/i3/config',
  command = 'silent !i3-msg restart',
  desc = 'Reload i3 on config save',
})

autocmd('BufWritePost', {
  group = augroup('TmuxReload', { clear = true }),
  pattern = '*/.tmux.conf',
  command = 'silent !tmux source ~/.tmux.conf',
  desc = 'Re-source tmux.conf on save',
})

-- Filetype detection
vim.filetype.add {
  extension = {
    pcss = 'css',
    podspec = 'ruby',
    templ = 'templ',
    tf = 'terraform',
    tfvars = 'terraform',
    tpl = 'helm',
  },
  filename = {
    Podfile = 'ruby',
  },
  pattern = {
    -- Helm chart templates
    ['.*/templates/.*%.yaml'] = 'helm',
    ['.*/templates/.*%.yml'] = 'helm',
    ['.*/templates/.*%.tpl'] = 'helm',
    ['helmfile.*%.yaml'] = 'helm',
    -- Dockerfiles (e.g. Dockerfile-arm, Dockerfile.dev)
    ['.*Dockerfile.*'] = 'dockerfile',
  },
}

-- Force Whitespace highlight after all plugins load
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    local palette = require('catppuccin.palettes').get_palette()
    vim.api.nvim_set_hl(0, 'Whitespace', { fg = palette.surface0 })
    vim.api.nvim_set_hl(0, 'NonText', { fg = palette.surface0 })
  end,
})
