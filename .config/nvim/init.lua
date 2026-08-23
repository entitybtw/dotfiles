local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.mouse = ""
opt.clipboard = "unnamedplus"
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.showmode = false
opt.laststatus = 3
opt.splitright = true
opt.splitbelow = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.wrap = false
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.stdpath("data") .. "/undo"
opt.undofile = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.timeoutlen = 300
opt.completeopt = "menuone,noinsert,noselect"
opt.hidden = true

local keymap = vim.keymap.set

keymap('i', 'jk', '<Esc>')
keymap('i', 'kj', '<Esc>')
keymap('n', '<C-s>', ':w<CR>')
keymap('i', '<C-s>', '<Esc>:w<CR>a')
keymap('n', '<C-q>', ':qa<CR>')
keymap('n', '<C-z>', 'u')
keymap('n', '<C-y>', '<C-r>')

keymap('n', '<C-h>', '<C-w>h')
keymap('n', '<C-j>', '<C-w>j')
keymap('n', '<C-k>', '<C-w>k')
keymap('n', '<C-l>', '<C-w>l')

keymap('n', '<Tab>', ':bnext<CR>')
keymap('n', '<S-Tab>', ':bprevious<CR>')
keymap('n', '<leader>q', ':bd<CR>')
keymap('n', '<leader>h', ':noh<CR>')

keymap('n', '<F1>', ':NvimTreeToggle<CR>')
keymap('n', '<F2>', ':NvimTreeFocus<CR>')

keymap('n', '<F3>', '<cmd>Telescope find_files<CR>')
keymap('n', '<F4>', '<cmd>Telescope live_grep<CR>')

keymap('n', 'gd', vim.lsp.buf.definition)
keymap('n', 'K', vim.lsp.buf.hover)
keymap('n', 'gi', vim.lsp.buf.implementation)
keymap('n', 'gr', vim.lsp.buf.references)
keymap('n', '<leader>rn', vim.lsp.buf.rename)
keymap('n', '<leader>ca', vim.lsp.buf.code_action)
keymap('n', '[d', vim.diagnostic.goto_prev)
keymap('n', ']d', vim.diagnostic.goto_next)

keymap('n', '<leader>/', 'gcc')
keymap('v', '<leader>/', 'gc')

keymap('n', '<leader>v', ':e ~/.config/nvim/init.lua<CR>')
keymap('n', '<leader>r', ':source ~/.config/nvim/init.lua<CR>')

local last_search = ""

keymap('n', '<C-w>', function()
  vim.ui.input({ prompt = "Search: ", default = last_search }, function(input)
    if input and input ~= "" then
      last_search = input
      pcall(vim.cmd, "/" .. vim.pesc(input))
    end
  end)
end)

keymap('n', '<C-r>', function()
  vim.ui.input({ prompt = "Replace: ", default = last_search }, function(find)
    if find and find ~= "" then
      last_search = find
      vim.ui.input({ prompt = "With: ", default = "" }, function(replace)
        if replace ~= nil then
          pcall(vim.cmd, "%s/" .. vim.pesc(find) .. "/" .. (replace or "") .. "/gc")
        end
      end)
    end
  end)
end)

require("lazy").setup({
  spec = {
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      config = function()
        require("tokyonight").setup({ style = "night" })
        vim.cmd.colorscheme("tokyonight")
      end,
    },
    {
      "nvimdev/dashboard-nvim",
      event = "VimEnter",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("dashboard").setup({
          theme = "hyper",
          config = {
            header = {
              "                                                     ",
              "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
              "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
              "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
              "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
              "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
              "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
            },
            center = {
              { icon = " ", desc = "Find files", shortcut = "F3", action = "Telescope find_files" },
              { icon = " ", desc = "Search text", shortcut = "F4", action = "Telescope live_grep" },
              { icon = " ", desc = "File explorer", shortcut = "F1", action = "NvimTreeToggle" },
            },
            footer = {
              "",
              "  🔍 Ctrl+W = Search  |  Ctrl+R = Replace  |  F1 = Explorer",
              "  💾 Ctrl+S = Save   |  Ctrl+Q = Quit      |  Space+v = Config",
              "",
            },
            disable_ui = { "recent_projects", "recent_files" },
          },
        })
      end,
    },
    {
      "nvim-tree/nvim-tree.lua",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      keys = {
        { "<F1>", ":NvimTreeToggle<CR>" },
        { "<F2>", ":NvimTreeFocus<CR>" },
      },
      config = function()
        require("nvim-tree").setup({
          sort_by = "case_sensitive",
          renderer = {
            group_empty = true,
            icons = { show = { file = true, folder = true, folder_arrow = true, git = true } },
          },
          filters = { dotfiles = false },
          git = { enable = true, ignore = true, timeout = 400 },
          actions = { open_file = { quit_on_open = false, resize_window = true } },
          view = { width = 30, side = "left" },
        })
      end,
    },
    {
      "nvim-telescope/telescope.nvim",
      branch = "0.1.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
      },
      keys = {
        { "<F3>", "<cmd>Telescope find_files<CR>" },
        { "<F4>", "<cmd>Telescope live_grep<CR>" },
      },
      config = function()
        local actions = require("telescope.actions")
        require("telescope").setup({
          defaults = {
            file_ignore_patterns = { "node_modules", ".git", "dist", "build", "__pycache__", "*.lock" },
            vimgrep_arguments = {
              "rg",
              "--color=never",
              "--no-heading",
              "--with-filename",
              "--line-number",
              "--column",
              "--smart-case",
            },
            mappings = {
              i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
              },
            },
          },
          preview = {
            treesitter = false,
          },
        })
      end,
    },
    {
      "nvim-treesitter/nvim-treesitter",
      lazy = false,
      priority = 1000,
      build = ":TSUpdate",
      init = function()
        vim.defer_fn(function()
          local ok, treesitter = pcall(require, "nvim-treesitter.configs")
          if ok then
            treesitter.setup({
              ensure_installed = { "lua", "vim", "javascript", "typescript", "python", "go", "rust", "cpp", "c", "json", "yaml", "bash", "markdown", "html", "css", "toml" },
              auto_install = true,
              highlight = { enable = true },
              indent = { enable = true },
            })
          end
        end, 200)
      end,
    },
    {
      "williamboman/mason.nvim",
      build = ":MasonUpdate",
      config = function()
        require("mason").setup()
      end,
    },
    {
      "williamboman/mason-lspconfig.nvim",
      dependencies = { "neovim/nvim-lspconfig" },
      config = function()
        require("mason-lspconfig").setup({
          ensure_installed = { "lua_ls", "pyright", "ts_ls", "rust_analyzer", "gopls" },
          automatic_installation = true,
        })

        local function on_attach(client, bufnr)
          local opts = { buffer = bufnr, remap = false }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
          vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
          vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
        end

        vim.lsp.config['lua_ls'] = {
          cmd = { 'lua-language-server' },
          filetypes = { 'lua' },
          root_markers = { '.luarc.json', '.luacheckrc', '.git' },
          settings = {
            Lua = {
              runtime = { version = 'LuaJIT' },
              diagnostics = { globals = { 'vim' } },
              workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        }

        vim.lsp.config['pyright'] = {
          cmd = { 'pyright-langserver', '--stdio' },
          filetypes = { 'python' },
          root_markers = { 'pyproject.toml', 'setup.py', 'requirements.txt', '.git' },
        }

        vim.lsp.config['ts_ls'] = {
          cmd = { 'typescript-language-server', '--stdio' },
          filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
          root_markers = { 'package.json', 'tsconfig.json', '.git' },
        }

        vim.lsp.config['rust_analyzer'] = {
          cmd = { 'rust-analyzer' },
          filetypes = { 'rust' },
          root_markers = { 'Cargo.toml' },
        }

        vim.lsp.config['gopls'] = {
          cmd = { 'gopls' },
          filetypes = { 'go', 'gomod' },
          root_markers = { 'go.mod', '.git' },
        }

        vim.lsp.enable('lua_ls', 'pyright', 'ts_ls', 'rust_analyzer', 'gopls')
        vim.api.nvim_create_autocmd('LspAttach', {
          group = vim.api.nvim_create_augroup('UserLspConfig', {}),
          callback = function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            if client then on_attach(client, ev.buf) end
          end,
        })
      end,
    },
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
      },
      config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        cmp.setup({
          snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
          mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
              else fallback() end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then luasnip.jump(-1)
              else fallback() end
            end, { "i", "s" }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "path" },
          }),
        })
      end,
    },
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("lualine").setup({
          options = { theme = "tokyonight", component_separators = "", section_separators = "" },
          sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff" },
            lualine_c = { "filename", "diagnostics" },
            lualine_x = { "encoding", "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
          },
        })
      end,
    },
    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      config = function()
        require("ibl").setup({
          indent = { char = "│", smart_indent_cap = true },
          scope = { enabled = true },
        })
      end,
    },
    {
      "wakatime/vim-wakatime",
      lazy = false,
    },
    {
      "lewis6991/gitsigns.nvim",
      lazy = false,
      config = function()
        require("gitsigns").setup({
          signs = {
            add = { text = "│" },
            change = { text = "│" },
            delete = { text = "_" },
            topdelete = { text = "‾" },
            changedelete = { text = "~" },
          },
        })
      end,
    },
    {
      "tpope/vim-fugitive",
      lazy = false,
    },
    {
      "nvim-tree/nvim-web-devicons",
      lazy = true,
    },
  },
  install = { colorscheme = { "tokyonight" } },
  checker = { enabled = true },
  change_detection = { notify = false },
})

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = true },
})

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      vim.cmd("Dashboard")
      vim.defer_fn(function()
        pcall(vim.cmd, "NvimTreeOpen")
      end, 500)
    end
  end,
})

keymap('n', '<leader>d', ':Dashboard<CR>')
