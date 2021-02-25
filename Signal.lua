local Signal = {}
Signal.__index = Signal

function Signal:New()
	local new = {}
	new._args = {}
	new._argCount = nil
	new._event = Instance.new("BindableEvent")
	setmetatable(new,Signal)
	return new
end

function Signal:Fire(...)
	if not self._event then
		warn('ERR: event not found or does not exist')
	end
	
	self._args = {...}
	self._argCount = select('#', ...)
	if self._event then self._event:Fire() else warn('ERR: cannot fire a event that does not exist') end
end

function Signal:Connect(handler)
	if not (typeof(handler) == 'function') then
		error(string.format('cannot use %s as a handler',handler))
	end
	
	return self._event.Event:Connect(function()
		handler(unpack(self._args,1,self._argCount))
	end)
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
