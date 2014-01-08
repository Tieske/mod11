local cmod = require("mod11"):new("23456789")  
local customerid = "234568"
local fcustomerid = cmod:calc(customerid)

local imod = require("mod11"):new("98765432", "-/")  -- verify sequence different from customer!
local invoice1 = "20131215-12"   -- invoice; date with sequence nr appended
local invoice2 = "20121221-07"   -- invoice; date with sequence nr appended
local finvoice1 = imod:calc(invoice1.."/")
local finvoice2 = imod:calc(invoice2.."/")

local message = [[
l.s.,

I noticed that the invoice send last December (]]..finvoice1..[[) has a substantial
difference from the one in 2012 (]]..finvoice2..[[). Can you please explain the difference?

Kind regards,

Acme Corp.
(our customer id is ]]..fcustomerid..[[)
]]

print("Now checking message:")
print(message, "\n\n\n")
print("This message contains:")
for c, s, e in cmod:foreach(message) do
  print("    Customerid: ", c, "(position "..s.." to ".. e..")")
end
for i, s, e in imod:foreach(message) do
  print("    Invoice: ", i, "(position "..s.." to ".. e..")")
end

