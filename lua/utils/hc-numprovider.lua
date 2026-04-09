local M = {}

local Provider = {}
Provider.__index = Provider

function Provider:lookup_number_using_ts(opts)
	local has_parser, parser =
		pcall(vim.treesitter.get_parser,opts.bufnr)
	if not has_parser or not parser then
		return
	end

	local row, col = opts.pos[1] - 1, opts.pos[2]

	local tree = parser:parse({ row, col, row, col})[1]
	if not tree then
		return
	end

	local node = vim.treesitter.get_node({
		bufnr = opts.bufnr,
		pos = { row, col }
	})
	if not node then
		return
	end

	if node:type() == "number_literal" then
		return vim.treesitter.get_node_text(node, opts.bufnr)
	end
end

function Provider:lookup_number_using_nvim(opts)
	local row, col = opts.pos[1] - 1, opts.pos[2]

	local line = vim.api.nvim_buf_get_lines(opts.bufnr, row, row + 1, false)[1]
	if not line or #line == 0 then return nil end

	local pattern = [[\k*\%]] .. (col + 1) .. [[c\k*]]
	local res = vim.fn.matchstr(line, pattern)

	return res ~= "" and res or nil
end

function Provider:is_enabled(opts)
	self.word = self:lookup_number_using_ts(opts)
	if not self.word then
		self.word = self:lookup_number_using_nvim(opts)
	end

	if not self.word then
		return
	end

	return not not tonumber(self.word)
end

local function number_to_bin(number)
	local t = {}
    repeat
        table.insert(t, 1, number % 2)
        number = math.floor(number / 2)
    until number == 0
    return "0b" .. table.concat(t)
end

function Provider:number_info(number_word)
	local number = tonumber(number_word)
	local dec = "**Dec**: " .. string.format("%d", number)
	local hex = "**Hex**: " .. string.format("0x%x", number)
	local bin = "**Bin**: " .. number_to_bin(number)
	local oct = "**Oct**: " .. string.format("0h%o", number)

	local col1_len = math.max(#dec, #hex)

	local gb = math.floor(number / (1024 * 1024 * 1024))
	local mb = math.floor((number - gb * 1024 * 1024 * 1024) / (1024 * 1024))
	local kb = math.floor((number - gb * 1024 * 1024 * 1024 - mb * 1024 * 1024) / 1024)
	local b  = number % 1024

	local size_str = (gb ~= 0 and string.format("%dGb ", gb) or '') ..
					 (mb ~= 0 and string.format("%dMb ", mb) or '') ..
					 (kb ~= 0 and string.format("%dKb ", kb) or '') ..
					 (b  ~= 0 and string.format("%db", b) or '')

	local lines = {
		dec .. string.rep(' ', col1_len - #dec + 3) .. bin,
		hex .. string.rep(' ', col1_len - #hex + 3) .. oct,
		' ',
		#size_str and '**Size:** ' .. size_str or ''
	}

	return lines
end

--- @option opts Hovercraft.Provider.ExecuteOptions
function Provider:execute(_, done)
	done({ lines = { self:number_info(self.word) }, filetype = 'markdown' })
end

function M.new()
  return setmetatable({}, Provider)
end

return M
