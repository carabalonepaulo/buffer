local struct = require 'struct'

BinaryWriter = {}
BinaryWriter.__index = BinaryWriter

function BinaryWriter:new()
	local self = setmetatable({}, BinaryWriter)
	self.buffer = {}
	self.format = { '<' }
	return self
end

function BinaryWriter:getFormatString()
	return table.concat(self.format)
end

function BinaryWriter:getBuffer()
	return struct.pack(self:getFormatString(), unpack(self.buffer))
end

function BinaryWriter:getSize()
	return struct.size(self:getFormatString())
end

function BinaryWriter:write(type, v)
	table.insert(self.format, type)
	table.insert(self.buffer, v)
end

function BinaryWriter:writeByte(v)
	self:write('b', v)
end

function BinaryWriter:writeInt(v)
	self:write('i', v)
end

function BinaryWriter:writeFloat(v)
	self:write('f', v)
end

function BinaryWriter:writeDouble(v)
	self:write('d', v)
end

function BinaryWriter:writeString(v)
	self:writeInt(v:len())
	for i = 1, v:len() do
		self:writeByte(v:byte(i))
	end
end

BinaryReader = {}
BinaryReader.__index = BinaryReader

function BinaryReader:new(writer)
	local self = setmetatable({}, BinaryReader)
	if type(writer) == 'table' then
		self:loadBuffer(writer)
	end
	self.position = 0
	return self
end

function BinaryReader:loadBuffer(writer)
	self.size = writer:getSize()
	self.buffer = writer:getBuffer()
end

function BinaryReader:slice(i, len)
	return self.buffer:sub(i, i + len)
end

function BinaryReader:jump(len)
	self.position = self.position + len
end

function BinaryReader:read(type, size)
	local buff = self:slice(self.position + 1, size)
	local value, len = struct.unpack(type, buff)
	self:jump(size)
	return value
end

function BinaryReader:readByte()
	return self:read('b', 1)
end

function BinaryReader:readInt()
	return self:read('i', 4)
end

function BinaryReader:readFloat()
	return self:read('f', 4)
end

function BinaryReader:readDouble()
	return self:read('d', 8)
end

function BinaryReader:readString()
	local len = self:readInt()
	local buff = {}
	for i = 0, len - 1 do table.insert(buff, string.char(self:readByte())) end
	local str = table.concat(buff, '')
	return str
end

--[[local writer = BinaryWriter:new()
writer:writeByte(20)
writer:writeInt(1267)
writer:writeFloat(1.23)
writer:writeDouble(1.18923764)
writer:writeString('Paulo Soreto')

local reader = BinaryReader:new(writer)
print(reader:readByte())
print(reader:readInt())
print(reader:readFloat())
print(reader:readDouble())
print(reader:readString())]]
