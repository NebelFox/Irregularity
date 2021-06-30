-- class extension for publisher/subscriber functionality

local function subscribe (self, subscriber)
    -- adds a subscriber
    self.subscribers[#self.subscribers+1] = subscriber
end
local function notify (self, phase)
    -- invokes all the subscribers
    for _, subscriber in ipairs (self.subscribers) do
        subscriber (phase)
    end
end
local function unsubscribe (self, subscriber)
    -- removes the subscriber
    table.remove (self.subscribers, table.indexOf (subscriber))
end
local function unsubscribeAll (self)
    -- removes all the subscribers
    for index in ipairs (self.subscribers) do
        self.subscribers[index] = nil
    end
end

local function Publisher (class)
    -- extends the class functionality
    class.subscribe = subscribe
    class.notify = notify
    class.unsubscribe = unsubscribe
    class.unsubscribeAll = unsubscribeAll
    return class
end

return Publisher