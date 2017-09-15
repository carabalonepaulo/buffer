--[[
MIT License

Copyright (c) 2017 Paulo Carabalone

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]

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

function BinaryReader:new(d)
  local self = setmetatable({}, BinaryReader)
  if type(d) == 'table' then
    self:loadBuffer(d)
  elseif type(d) == 'string' then
    self.buffer = 
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
