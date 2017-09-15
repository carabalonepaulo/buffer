require 'buffer'

function assertequals(value, excpected, message)
  if value ~= excpected then
    print(message)
  end
end

local writer = BinaryWriter:new()
writer:writebyte(20)                -- 1
writer:writeint(1267)               -- 4
writer:writefloat(1.23)             -- 4
writer:writedouble(1.18923764)      -- 8
writer:writestring('Paulo Soreto')  -- 4 + 12

assertEquals(writer:getSize(), 33, 'size :(')

local reader = BinaryReader:new(writer)
assertequals(reader:readbyte(), 20, 'byte :(')
assertequals(reader:readint(), 1267, 'int :(')

local f = reader:readfloat()
assertequals((math.max(f, 1.23)), f, 'float :(')

local d = reader:readdouble()
assertequals(math.max(d, 1.23), d, 'double :(')

assertequals(reader:readstring(), 'Paulo Soreto', 'string :(')
