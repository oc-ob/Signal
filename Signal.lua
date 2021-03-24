local Signal = {}
Signal.__index = Signal

function Signal:New()
	if name and name ~= '' then
		local new = {}
		new._args = {}
		new._argCount = nil
		new._event = Instance.new("BindableEvent")
		setmetatable(new,Signal)
		print(string.format('[SIGNALS](INFO) Successfully created "%s" signal.',name))
		return new
	else
		warn('[SIGNALS](ERR) Signal cannot have a nil or empty name.')
	end
end

function Signal:Fire(...)
	if self._event then
		self._args = {...}
		self._argCount = select('#', ...)
		self._event:Fire()
	else
		warn('[SIGNALS](ERR) Event not found or does not exist.')
	end
end

function Signal:Connect(handler)
	if (typeof(handler) == 'function') then
		return self._event.Event:Connect(function()
			handler(unpack(self._args,1,self._argCount))
		end)
	else
		warn(string.format('[SIGNALS](ERR) Cannot use "%s" as handler.',handler))
	end
end

function Signal:Destroy()
	if self._event then
		self._event:Destroy()
		self._event = nil
	end

	self._args = nil
	self._argCount = nil
end

return Signal
