--!native

local Curve = {}
Curve.__index = Curve

export type Curve = typeof(setmetatable({} :: {
	read _curve: {Vector2},
	read _parametric: boolean,
}, Curve))

local SAMPLE_SIZE = 256 -- defines the granularity of the cache values (how many values the array will store)

-- de Casteljau's algorithm
local function calc_bezier_point(t: number, ...: Vector2): Vector2
	local points = {...}
	for i = 1, #points do
		for j = 1, #points - i do
			points[j] = points[j]:Lerp(points[j+1], t)
		end
	end
	
	return points[1]
end

function Curve.new(...: Vector2): Curve
	if typeof(...) ~= "Vector2" then
		error("Bezier points must be Vector2s")
	end
	
	local curve = table.create(SAMPLE_SIZE)
	local increasing, decreasing = true, true

	for i = 1, SAMPLE_SIZE do
		local t = (i - 1) / (SAMPLE_SIZE - 1)
		curve[i] = calc_bezier_point(t, ...)

    if i < 2 then continue end
		if curve[i].x <= curve[i-1].x then
			increasing = false
		end
		if curve[i].x >= curve[i-1].x then
			decreasing = false
		end
	end
	local is_parametric = not (increasing or decreasing)
	
	return setmetatable({
		_curve = curve,
		_parametric = is_parametric,
	}, Curve)
end

function Curve.sample(self: Curve, x: number): number
	if self._parametric then
		error("Curve is parametric; use curve:sample_parametric(t) instead")
	end

	x = math.map(x, self._curve[1].x, self._curve[#self._curve].x, 0, 1)
	if math.isnan(x) then x = 1 end -- safeguard against division by zero math.map output
	return self:sample_parametric(x)
end

-- @t: value between [0, 1] representing a time in the curve. Calculate using point/max_point
function Curve.sample_parametric(self: Curve, t: number): number
	t = math.clamp(t, 0, 1)
	
	-- get the middle of two indices
	local i = t * (SAMPLE_SIZE - 1)
	local i0 = math.floor(i) + 1
	local i1 = math.min(i0 + 1, SAMPLE_SIZE)
	-- alpha of the lerp function is the decimal value between i0 and i1
	return self._curve[i0]:Lerp(self._curve[i1], i % 1).Y
end

function Curve.destroy(self: Curve): ()
	for k, v in pairs(self) do
		self[k] = nil
	end
end

return Curve
