return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },

    config = function()
        require("neo-tree").setup({
            event_handlers = {
                {
                    event = "file_open_requested",
                    handler = function()
                        require("neo-tree.command").execute({ action = "close" })
                    end,
                },
            },
            window = {
                mappings = {
                    ["<leader>p"] = { "toggle_preview", config = { use_float = false, use_image_nvim = true } },
                },
            },
        })

        vim.keymap.set("n", "<C-n>", "<Cmd>:Neotree action=show position=left toggle=true<CR>", {})
        vim.keymap.set("n", "n", "<Cmd>:Neotree source=filesystem focus<CR>", {})
    end,
}
