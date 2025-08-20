local function logkind(kind, ...)
	local msg = table.concat({ ... }, " ")
	vim.notify("[" .. kind .. "] " .. msg .. "\n")
end

local function log(...)
    logkind("LOG", ...)
end

local function loge(...)
    logkind("ERROR", ...)
end

local pathsep
if vim.fn.has("win32") == 1 then
	vim.opt.shell = "C:\\Windows\\System32\\cmd.exe"
	pathsep = "\\"
else
	vim.opt.shell = "/usr/bin/bash"
	pathsep = "/"
end

local function joinpath(...) 
    return table.concat({ ... }, pathsep)
end

local treesitter_dir = joinpath(vim.uv.cwd(), "nvim-treesitter")
log("adding", treesitter_dir, "to 'runtimepath'")
vim.opt.runtimepath:append(treesitter_dir)

local ok_treesitter, treesitter = pcall(require, "nvim-treesitter.configs")
if not ok_treesitter then
    loge("treesitter not found")
    os.exit(1)
end

local install_dir = joinpath(vim.uv.cwd(), "out")
log("cwd:", vim.uv.cwd())
log("parser_install_dir:", install_dir)

---@diagnostic disable-next-line
treesitter.setup({
	parser_install_dir = install_dir,
	ensure_installed = "all",
	sync_install = true,
})

os.exit(0)