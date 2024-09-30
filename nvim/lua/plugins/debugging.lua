return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "leoluz/nvim-dap-go",
        "theHamsta/nvim-dap-virtual-text",
        "nvim-neotest/nvim-nio",
    },
    config = function()
        local dap = require("dap")
        require("nvim-dap-virtual-text").setup({
            display_callback = function(variable)
                local name = string.lower(variable.name)
                local value = string.lower(variable.value)
                if name:match("secret") or name:match("api") or value:match("secret") or value:match("api") then
                    return "*****"
                end
                if #variable.value > 15 then
                    return " " .. string.sub(variable.value, 1, 15) .. "... "
                end
                return " " .. variable.value
            end,
        })
        --c# dap configurations--
        local vstuc_path              = vim.env.HOME .. '/.vscode/extensions/visualstudiotoolsforunity.vstuc-1.0.4/bin/'
        dap.adapters.coreclr          = { type = "executable", command = "/usr/bin/netcoredbg", args = { "--interpreter=vscode" }, }
        dap.adapters.vstuc            = { type = 'executable', command = 'dotnet', args = { vstuc_path .. 'UnityDebugAdapter.dll' } }
        dap.configurations.cs         = { {
            type = "coreclr",
            name = "attach - netcoredbg",
            request = "attach",
            processId = function()
                return
                    vim.fn.input("Process Id ")
            end,
            program = function()
                return vim.fn.input("Path to dll",
                    vim.fn.getcwd() .. "/bin/Debug/net8.0/", "file")
            end,
            stopOnEntry = false,
        }, {
            type = 'vstuc', request = 'attach', name = 'Attach to Unity', logFile = vim.env.HOME .. "/vstuc.log", endPoint = function()
            local system_obj = vim.system({ 'dotnet', vstuc_path .. 'UnityAttachProbe.dll' })
            local probe_result = system_obj:wait(2000).stdout
            if probe_result == nil or #probe_result == 0 then
                print("No endpoint found (is unity running?)")
                return ""
            end
            local pattern = [["debuggerPort":(%d+)]]
            local port = string.match(probe_result, pattern)
            if port == nil or #port == 0 then
                print("Failed to parse debugger port")
                return ""
            end
            return "127.0.0.1:" .. port
        end
        }, }
        --c++--
        dap.adapters.codelldb         = {
            type = "server",
            port = "${port}",
            executable = {
                -- CHANGE THIS to your path!
                command = "/home/suknut/.local/share/nvim/mason/packages/codelldb/extension/adapter/codelldb",
                args = { "--port", "${port}" },

                -- On windows you may have to uncomment this:
                -- detached = false,
            },
        }
        dap.configurations.cpp        = {
            {
                name = "Launch file",
                type = "codelldb",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
            },
        }
        --python--
        dap.adapters.python           = function(cb, config)
            if config.request == "attach" then
                ---@diagnostic disable-next-line: undefined-field
                local port = (config.connect or config).port
                ---@diagnostic disable-next-line: undefined-field
                local host = (config.connect or config).host or "127.0.0.1"
                cb({
                    type = "server",
                    port = assert(port, "`connect.port` is required for a python `attach` configuration"),
                    host = host,
                    options = {
                        source_filetype = "python",
                    },
                })
            else
                cb({
                    type = "executable",
                    command = "path/to/virtualenvs/debugpy/bin/python",
                    args = { "-m", "debugpy.adapter" },
                    options = {
                        source_filetype = "python",
                    },
                })
            end
        end

        dap.configurations.python     = {
            {
                -- The first three options are required by nvim-dap
                type = "python", -- the type here established the link to the adapter definition: `dap.adapters.python`
                request = "launch",
                name = "Launch file",

                -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

                program = "${file}", -- This configuration will launch the current file if used.
                pythonPath = function()
                    -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
                    -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
                    -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
                    local cwd = vim.fn.getcwd()
                    if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
                        return cwd .. "/venv/bin/python"
                    elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
                        return cwd .. "/.venv/bin/python"
                    else
                        return "/usr/bin/python"
                    end
                end,
            },
        }
        --javascript--
        dap.adapters.firefox          = {
            type = "executable",
            command = "node",
            args = { os.getenv("HOME") .. "/path/to/vscode-firefox-debug/dist/adapter.bundle.js" },
        }

        dap.configurations.typescript = {
            {
                name = "Debug with Firefox",
                type = "firefox",
                request = "launch",
                reAttach = true,
                url = "http://localhost:3000",
                webRoot = "${workspaceFolder}",
                firefoxExecutable = "/usr/bin/firefox",
            },
        }

        --dapui--
        local dapui                   = require("dapui")

        dapui.setup({
            icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
            mappings = {
                expand = { "<CR>", "<2-LeftMouse>" },
                open = "o",
                remove = "d",
                edit = "e",
                repl = "r",
                toggle = "t",
            },
            element_mappings = {
                -- Example:
                -- stacks = {
                --   open = "<CR>",
                --   expand = "o",
                -- }
            },
            expand_lines = vim.fn.has("nvim-0.7") == 1,
            layouts = {
                {
                    elements = {
                        { id = "scopes", size = 0.25 },
                        "breakpoints",
                        "stacks",
                        "watches",
                    },
                    size = 40, -- 40 columns
                    position = "left",
                },
                {
                    elements = {
                        "repl",
                        "console",
                    },
                    size = 0.25,
                    position = "bottom",
                },
            },
            controls = {
                enabled = true,
                element = "repl",
                icons = {
                    pause = "",
                    play = "",
                    step_into = "",
                    step_over = "",
                    step_out = "",
                    step_back = "",
                    run_last = "↻",
                    terminate = "□",
                },
            },
            floating = {
                max_height = nil,
                max_width = nil,
                border = "single",
                mappings = {
                    close = { "q", "<Esc>" },
                },
            },
            windows = { indent = 1 },
            render = {
                max_type_length = nil,
                max_value_lines = 100,
            },
        })

        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end

        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end

        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end

        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end

        vim.keymap.set("n", "<F5>", dap.continue, {})
        vim.keymap.set("n", "<F10>", dap.step_over, {})
        vim.keymap.set("n", "<F11>", dap.step_into, {})
        vim.keymap.set("n", "<F12>", dap.step_out, {})
        vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, {})
        vim.keymap.set("n", "<leader>dt", dap.set_breakpoint, {})
        vim.keymap.set("n", "<leader>lp", dap.set_breakpoint, {})
        vim.keymap.set("n", "<leader>dr", dap.repl.open, {})
        vim.keymap.set("n", "<leader>dl", dap.run_last, {})
    end,
}
