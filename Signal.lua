local Signal = {}
Signal.__index = Signal
Signal.ClassName = "Signal"

local ENABLE_DEBUG_TRACEBACK = true

-- Constructor
function Signal.new()
	local self = setmetatable({
		_event = Instance.new("BindableEvent");
		_args = {};
		_argCount = 0;
		_source = ENABLE_DEBUG_TRACEBACK and debug.traceback() or "";
	},Signal)
	
	return self
end

---- Functions

-- Fire
function Signal:Fire(...)
	assert(self._event ~= nil, string.format("No signal found. %s", self._source))
	self._args = {...}
	self._argCount = #self._args
	
	self._event:Fire()
end

function Signal:fire(...)
	self:Fire(...)
end

-- Connect
function Signal:Connect(handler)
	assert(type(handler) == "function", string.format("Handler must be a function. %s", self._source))
	return self._event.Event:Connect(function()
		handler(unpack(self._args))
	end)
end

function Signal:connect(handler)
	self:Connect(handler)
end

-- Wait
function Signal:Wait()
	self._event.Event:Wait()
	return unpack(self._args)
end

function Signal:wait()
	self:Wait()
end

-- Destroy
function Signal:Destroy()
	if self._event then
		self._event:Destroy()
		self._event = nil
	end
	setmetatable(self,nil)
end

function Signal:destroy()
	self:Destroy()
end

return Signal
