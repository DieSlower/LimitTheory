-- script/App/ExtendDemo.lua : run with  bin\lt64.exe ExtendDemo
local Entity = require('Game.Entity')
local Action = require('Game.Action')
local Item = require('Game.Item')
local Production = require('Game.Production')
local LTheory = require('App.LTheory')

-- 1. New content: an item and a recipe (see Game/Content.lua)
Item.PlasmaGel = Item('Plasma Gel', 2, 3.0)
Production.GelSynth = Production('Gel Synthesizer')
  :addInput(Item.Isotopes, 1)
  :addOutput(Item.PlasmaGel, 2)
  :setDuration(2)

-- 2. New component: adds methods to Entity and registers an update handler
function Entity:addBeacon (label)
  assert(not self.beacon)
  self.beacon = { label = label, age = 0 }
  self:register(Event.Update, Entity.updateBeacon)
end
function Entity:hasBeacon () return self.beacon ~= nil end
function Entity:updateBeacon (state)
  self.beacon.age = self.beacon.age + state.dt
end

-- 3. New action: a stack-based behaviour
local Ping = subclass(Action, function (self, seconds)
  self.seconds = seconds
  self.t = 0
end)
function Ping:clone () return Ping(self.seconds) end
function Ping:getName () return 'Ping' end
function Ping:onStart (e) printf('[Ping] %s started', e:getName()) end
function Ping:onUpdateActive (e, dt)
  self.t = self.t + dt
  if self.t >= self.seconds then
    printf('[Ping] %s done after %.1fs, beacon age %.1f', e:getName(), self.t, e.beacon.age)
    e:popAction()
  end
end

-- 4. Hook into world generation
local baseGenerate = LTheory.generate
function LTheory:generate ()
  baseGenerate(self)
  local player = self.player:getControlling()
  for _, e in self.system:iterChildren() do
    if e ~= player and e:hasActions() and e.body then
      e:setName('Demo Escort')
      e:addBeacon('demo')
      e:pushAction(Ping(2))
      break
    end
  end
  printf('Productions registered: %d, Plasma Gel mass %.1f', #Production.All(), Item.PlasmaGel:getMass())
end

return LTheory
