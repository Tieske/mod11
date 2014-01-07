
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
    assert.has.errors(function() m:calc(15) end)
    
    -- illegal chars
    assert.has.errors(function() m:calc("123x4y56") end)
    
    -- illegal length
    assert.has_errors(function() m:calc("") end)
  end)
  
  it("tests 'check'", function()
    m = mod11("23456789", "-/")
    -- validchecksum
    assert.is_true(m:check("197205278"..m:calc("197205278")))
    -- invalid checksum
    assert.is_false(m:check(m:calc("197205278").."-11"))
      
    -- errors
    -- not a string param
    assert.is_nil(m:check(15))
    -- illegal chars
    assert.is_nil(m:check("123x4y56"))
    -- invalid length
    assert.is_nil(m:check(""))
    assert.is_nil(m:check("1234567811"))
    assert.is_nil(m:check("1234567811234567811"))    
  end)

  it("tests 'foreach'", function()
    -- create two lists with different verify numbers, and mingle them
    m = mod11("23456789", "-/")
    n = mod11("92345678", "-/")
    local l1,l2,l3
    l1 = {
      [1] = "197205278"..m:calc("197205278"),
      [2] = "197205279"..m:calc("197205279"),
      [3] = "197205280"..m:calc("197205280"),
      [4] = "197205281"..m:calc("197205281"),
      [5] = "197205282"..m:calc("197205282"),
    }
    l2 = {
      [1] = "197205278"..n:calc("197205278"),
      [2] = "197205279"..n:calc("197205279"),
      [3] = "197205280"..n:calc("197205280"),
      [4] = "197205281"..n:calc("197205281"),
      [5] = "197205282"..n:calc("197205282"),
    }
    l3 = {}
    for i, v in ipairs(l1) do
      table.insert(l3,l1[i])
      table.insert(l3,l2[i])
    end
    
    -- creates a string from the values above, with a separator string
    -- returns the results of the iterators of m and n
    local c = function(sep, pre, post)
      local text = (pre or "")..table.concat(l3, sep)..(post or "")
      local r1 = {}
      local r2 = {}
      for v, s, e in m:foreach(text) do table.insert(r1,{v = v, s = s, e = e}) end
      for v, s, e in n:foreach(text) do table.insert(r2,{v = v, s = s, e = e}) end
      return r1, r2
    end
    
    -- regular text should find both lists
    local r1, r2 = c("just some text")
    for i,v in ipairs(l1) do
      assert.are_equal(v,(r1[i] or {}).v)
    end
    for i,v in ipairs(l2) do
      assert.are_equal(v,(r2[i] or {}).v)
    end
      
    -- no separator, so numbers stitched together, nothing should be found
    local r1, r2 = c("")
    assert.are_equal(0, #r1)
    assert.are_equal(0, #r2)
    
    -- spaces and allowed chars in between
    local r1, r2 = c("- /","/","-")
    assert.are_equal(5, #r1)
    assert.are_equal(5, #r2)
  end)

end)
