local io = require("io")
local os = require("os")

--- custom table.each function
---@param t table the table to iterate over
---@param func function the function to apply on each key-value pair
function table.each(t, func)
	for k, v in pairs(t) do
		if type(v) == "table" then
			func(k, v)
		end
	end
end

local function print_table(t, indent)
	indent = indent or 0
	for k, v in pairs(t) do
		local formatting = string.rep("  ", indent) .. k .. ": "
		if type(v) == "table" then
			print(formatting)
			print_table(v, indent + 1)
		else
			print(formatting .. v)
		end
	end
end

--- parse the given args according to the arg_conf table
---@param args table the command line arguments
---@param tConf table the argument configuration table
---@return table parsed_args the parsed arguments
function _G.handle_args(args, tConf)
	local parsed_args = {}
	local argHelp = args[1]:gsub("^%s*(.-)%s*$", "%1"):lower()

	if #args == 0 or (argHelp == "help" or argHelp == "h") then
		return { help = true }
	end

	for name, conf in pairs(tConf) do
		-- if guard to  not go through the function in the table
		if type(conf) ~= "table" then
			goto continue
		end
		if conf.arg_index then
			local arg_value = args[conf.arg_index]
			if arg_value then
				if arg_value:match(conf.match) then
					parsed_args[name] = arg_value
				else
					print("Invalid value for argument '" .. name .. "': " .. arg_value)
					print(tConf:get_help_string())
					os.exit(1)
				end
			else
				if conf.required then
					print("Missing required argument: " .. name)
					print(tConf:get_help_string())
					os.exit(1)
				else
					parsed_args[name] = conf.default
				end
			end
		end
		::continue::
	end
	return parsed_args
end

-- Load argument configuration
local arg_conf = {
	help = {
		description = "Display this help message.",
		required = false,
		match = "^(help|h)$",
		arg_index = nil,
	},
	project_path = {
		description = "The absolute path to the LOVE2D project directory to package (trailing '\\' is mandatory).",
		required = true,
		match = ".-[/\\]$",
		arg_index = 1,
	},
	output_executable_name = {
		description = "The name of the output executable (without extension).",
		required = true,
		match = "[%w_%-]+",
		arg_index = 2,
	},
	remove_console = {
		description = "Flag to indicate whether to remove 't.console=true' from conf.lua (0/1 or y/n).",
		required = false,
		match = "^(0|1|y|n)$",
		default = "0",
		arg_index = 3,
	},
	--- get help string method
	---@param self table the argument configuration table
	---@return string help_string the formatted help string
	get_help_string = function(self)
		return "Love CLI Builder\n\n" ..
			"Usage:\n" ..
			"  lua main.lua <project_path> <output_executable_name> [remove_console]\n\n" ..
			"Arguments:\n" ..
			(function()
				local str = ""
				table.each(self, function(name, conf)
					str = str ..
						string.format("  %-25s : %s%s\n", name, conf.description, conf.required and " (required)" or "")
				end)
				return str
			end)()
	end
}

-- Process command line arguments
local args = _G.handle_args(arg, arg_conf)

if args.help then
	print(arg_conf:get_help_string())
	os.exit(0)
end
