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

-- Load argument configuration
local arg_conf = {
	help = {
		description = "Display this help message.",
		required = false,
		match = "^(help|h)$",
	},
	project_path = {
		description = "The absolute path to the LOVE2D project directory to package.",
		required = true,
		match = ".-[/\\]$",
	},
	output_executable_name = {
		description = "The name of the output executable (without extension).",
		required = true,
		match = "[%w_%-]+",
	},
	remove_console = {
		description = "Flag to indicate whether to remove 't.console=true' from conf.lua (0/1 or y/n).",
		required = false,
		match = "^(0|1|y|n)$",
		default = "0",
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

print(arg_conf:get_help_string())