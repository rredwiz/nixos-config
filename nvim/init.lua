require("config.lazy")

-- personal shortcut keybinds
vim.keymap.set("i", "<C-BS>", "<C-w>", { noremap = true, silent = true, desc = "Delete word" })
vim.keymap.set("i", "<C-H>", "<C-w>", { noremap = true, silent = true, desc = "Delete word" })
vim.keymap.set("c", "<C-BS>", "<C-w>", { noremap = true, silent = true, desc = "Delete word" })
vim.keymap.set("c", "<C-H>", "<C-w>", { noremap = true, silent = true, desc = "Delete word" })

-- open diagnostics keybind
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

-- telescope keybinds
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "Telescope find files" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })

-- open file_browser with the path of the current buffer
vim.keymap.set("n", "<space>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")

-- always block cursor
vim.opt.guicursor = "a:block"

-- normal settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 4

vim.opt.autoindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4

vim.opt.showcmd = true
vim.opt.showmode = true
vim.opt.cursorline = true

vim.opt.swapfile = false
vim.opt.backup = false

-- override treesitter macro italics
vim.cmd("highlight rustMacro gui=NONE")
vim.cmd("highlight @lsp.type.macro gui=NONE")
vim.cmd("highlight Macro gui=NONE")

-- don't automatically create comments after newline on comment
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("no_auto_comment", {}),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- nvimtree cmd
vim.api.nvim_create_user_command("Nt", "NvimTreeToggle", { nargs = 0, desc = "Toggle NvimTree" })

-- automatically switches tab width in nix files to 2
vim.api.nvim_create_autocmd("FileType", {
	pattern = "nix",
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
		vim.opt_local.expandtab = true
	end,
})

-- make everything transparent at the END
vim.cmd("TransparentEnable")

-- setting my visual to a better highlight
vim.api.nvim_set_hl(0, "Visual", { bg = "#888888" }) -- A darker, blended hex
