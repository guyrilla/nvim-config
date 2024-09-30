return {
	{
		"romgrk/barbar.nvim",
		dependencies = {
			"lewis6991/gitsigns.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		init = function()
			vim.g.barbar_auto_setup = false
		end,
		opts = {},
		version = "^1.0.0",
	},
	vim.keymap.set("n", "<A-.>", "<Cmd>BufferNext<CR>", {}),
	vim.keymap.set("n", "<A-,>", "<Cmd>BufferPrevious<CR>", {}),

	vim.keymap.set("n", "<A-C-.>", "<Cmd>BufferMoveNext<CR>", {}),
	vim.keymap.set("n", "<A-C-,>", "<Cmd>BufferMovePrevious<CR>", {}),

	vim.keymap.set("n", "<A-1>", "<Cmd>BufferGoto 1<CR>", {}),
	vim.keymap.set("n", "<A-2>", "<Cmd>BufferGoto 2<CR>", {}),
	vim.keymap.set("n", "<A-3>", "<Cmd>BufferGoto 3<CR>", {}),
	vim.keymap.set("n", "<A-4>", "<Cmd>BufferGoto 4<CR>", {}),
	vim.keymap.set("n", "<A-5>", "<Cmd>BufferGoto 5<CR>", {}),
	vim.keymap.set("n", "<A-6>", "<Cmd>BufferGoto 6<CR>", {}),
	vim.keymap.set("n", "<A-7>", "<Cmd>BufferGoto 7<CR>", {}),
	vim.keymap.set("n", "<A-8>", "<Cmd>BufferGoto 8<CR>", {}),
	vim.keymap.set("n", "<A-9>", "<Cmd>BufferGoto 9<CR>", {}),

	vim.keymap.set("n", "<A-p>", "<Cmd>BufferPin<CR>", {}),

	vim.keymap.set("n", "<A-c>", "<Cmd>BufferClose<CR>", {}),
}
