local Button = {}

function Button.init (self, args)
    self.group.x = args.x
    self.group.y = args.y

    self.callback = args.callback
    self.background = display.newImage (self.group, args.image)
    self.background:addEventListener ("tap", self.callback)
    self.group.alpha = 0
end

function Button.destroy (self)
    self.background:removeEventListener ("tap", self.callback)
    display.remove (self.background)
    self.background = nil
end

function Button.show (self)
    self.group.isVisible = true
    transition.to (self.group, {time=Button.config.showAnimationDuration, alpha=1})
end

return Button