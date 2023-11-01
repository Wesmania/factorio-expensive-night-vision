local function unformat(power)
	local mult = {
		M = 1000000,
		k = 1000,
	}
	local len = string.len(power)
	local suffix = power:sub(len - 1, len - 1)
	return tonumber(power:sub(1, len - 2)) * mult[suffix]
end

local stdlib_util = require("__core__/lualib/util")

local secs_per_battery = settings.startup["expensive-night-vision-seconds-of-operation-per-mk1-battery"].value

local night_vision = data.raw["night-vision-equipment"]["night-vision-equipment"]
local battery = data.raw["battery-equipment"]["battery-equipment"]

local battery_capacity = unformat(battery.energy_source.buffer_capacity)

local nv_consumption = battery_capacity / secs_per_battery
local nv_capacity = nv_consumption / 2
local nv_flow = nv_consumption * 2

night_vision.energy_source.buffer_capacity = stdlib_util.format_number(nv_capacity, true) .. "J"
night_vision.energy_source.input_flow_limit = stdlib_util.format_number(nv_flow, true) .. "W"
night_vision.energy_input = stdlib_util.format_number(nv_consumption, true) .. "W"
