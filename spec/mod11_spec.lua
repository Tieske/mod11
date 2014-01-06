
local mod11 = require("mod11")

describe("modulo 11 tests", function()
  
  it("tests 'new' and '__call'", function()
    local v, a = "23456789","/-"
    local m = mod11(v, a)     -- module call
    assert.are_equal(v, m:getverify())
    local m = mod11.new(v, a) -- . notation
    assert.are_equal(v, m:getverify())
    local m = mod11:new(v, a) -- : notation
    assert.are_equal(v, m:getverify())
    assert.has.errors(function() mod11("2345678") end) -- one short
    assert.has.errors(function() mod11("234567897") end) -- one long
    assert.has.errors(function() mod11("03456789") end) -- one illegal
    assert.has.errors(function() mod11("13456789") end) -- one illegal
    assert.has.errors(function() mod11("234aa789") end) -- some alpha
    assert.has.errors(function() mod11({}) end) -- non string
    assert.has.errors(function() mod11("23456789", {}) end) -- non string for allowed
  end)
  
  it("tests 'calc'", function()
    m = mod11("23456789", "-/")
    -- proper checksum for different lengths
    assert.are_equal("9", m:calc("1"))
    assert.are_equal("1", m:calc("1972052"))  -- 7 pos (1 check pos)
    assert.are_equal(m:calc("1972052"), m:calc("1972-05/2"))
    assert.are_equal("5", m:calc("19720527")) -- 8 pos (1 check pos)
    assert.are_equal(m:calc("19720527"), m:calc("1972-05/27"))
    assert.are_equal("91", m:calc("197205278")) -- 9 pos (2 check pos)
    assert.are_equal("55", m:calc("1972052719720527")) -- 16 pos (2 check pos)
    assert.are_equal("921", m:calc("19720527197205278")) -- 17 pos (3 check pos)
    
    -- errors
    -- not a string param
    -- illegal chars
  end)
  
  pending("tests 'check'", function()
    -- validchecksum
    -- errors
    -- not a string param
    -- illegal chars
    -- invalid length
    -- invalid checksum
  end)

  pending("tests 'foreach'", function()
  end)

end)
