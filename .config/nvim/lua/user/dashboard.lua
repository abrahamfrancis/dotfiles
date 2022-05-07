local status_ok, alpha = pcall(require, "alpha")
if not status_ok then
  vim.notify "alpha not found!"
  return
end

alpha.setup(require("alpha.themes.dashboard").config)
