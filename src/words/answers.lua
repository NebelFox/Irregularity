local utils = require "src.utils"
local Answers = {}

function Answers.init (self, args)
    self.total = args.total
    self.correct = args.correct
end

function Answers.add (self, isCorrect)
    self.total = self.total + 1
    self.correct = self.correct + (isCorrect and 1 or 0)
end

function Answers.ratio (self)
    return self.correct / self.total
end

return utils.class (Answers)