-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.

local home = os.getenv "HOME" .. "/"
local install_path = home .. ".local/share/nvim/lsp_servers/jdtls/"

local function get_workspace_dir()
  -- If you started neovim within `~/dev/xy/project-1` this would resolve to `project-1`
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  local workspace_dir = home .. ".local/share/eclipse/workspace/" .. project_name
  --                                               ^^
  --                                               string concattenation in Lua
  return workspace_dir
end

local function get_root_dir()
  local root_dir = require("jdtls.setup").find_root { ".git", "mvnw", "gradlew" }
  return root_dir
end

local jdtls_cap = require("jdtls").extendedClientCapabilities
jdtls_cap.resolveAdditionalTextEditsSupport = true

local jvm_arg = "--jvm-arg="
local jdtls_opts = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {
    install_path .. "/bin/jdtls",
    jvm_arg .. "-Dlog.protocol=true",
    jvm_arg .. "-Dlog.level=ALL",
    jvm_arg .. "-javaagent:" .. home .. "/.local/share/nvim/lsp_servers/jdtls/lombok.jar",
    jvm_arg .. "-Xbootclasspath/a:" .. home .. "/.local/share/nvim/lsp_servers/jdtls/lombok.jar",
    jvm_arg .. "'-data " .. get_workspace_dir() .. "'",
  },

  -- 💀
  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  root_dir = get_root_dir,

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      codeGeneration = {
        toString = {
          template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
        },
      },
      configuration = {
        runtimes = {
          {
            name = "JavaSE-11",
            path = "/usr/lib/jvm/java-11-openjdk/",
          },
          {
            name = "JavaSE-17",
            path = "/usr/lib/jvm/java-17-openjdk/",
          },
        },
      },
    },
  },

  flags = {
    server_side_fuzzy_completion = true,
  },

  -- Language server `initializationOptions`
  -- You need to extend the `bundles` with paths to jar files
  -- if you want to use additional eclipse.jdt.ls plugins.
  --
  -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
  init_options = {
    extendedClientCapabilities = jdtls_cap,
    bundles = {},
  },
}

return jdtls_opts
