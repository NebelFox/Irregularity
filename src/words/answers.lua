local utils = require "src.utils"

local Answers = utils.class ()

-- 0 - the ratio is absolutely ignored, and frequencies are uniform 
-- 1 - words with ratio==1 are completely hidden
Answers.ratioCoefficient = 0.8

function Answers.init (self, args)
    self.total = args.total
    self.correct = args.correct
end

function Answers.add (self, isCorrect)
    self.total = self.total + 1
    self.correct = self.correct + (isCorrect and 1 or 0)
end

function Answers.ratio (self)
    -- correctness of user answers
    return self.correct / self.total
end

function Answers.priority (self)
    -- the higher the ration - the lower the frequency
    return (1 - self:ratio () * Answers.ratioCoefficient)
end

return Answers