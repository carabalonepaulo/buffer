require 'buffer'

function assertEquals(value, excpected, message)
  if value ~= excpected then
    print(message)
  end
end

local writer = BinaryWriter:new()
writer:writeByte(20)                -- 1
writer:writeInt(1267)               -- 4
writer:writeFloat(1.23)             -- 4
writer:writeDouble(1.18923764)      -- 8
writer:writeString('Paulo Soreto')  -- 4 + 12

assertEquals(writer:getSize(), 33, 'size :(')

local reader = BinaryReader:new(writer)
assertEquals(reader:readByte(), 20, 'byte :(')
assertEquals(reader:readInt(), 1267, 'int :(')

local f = reader:readFloat()
assertEquals((math.max(f, 1.23)), f, 'float :(')

local d = reader:readDouble()
assertEquals(math.max(d, 1.23), d, 'double :(')

assertEquals(reader:readString(), 'Paulo Soreto', 'string :(')
