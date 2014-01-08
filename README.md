mod11
=====

[![travis-ci status](https://secure.travis-ci.org/Tieske/mod11.png)](http://travis-ci.org/#!/Tieske/mod11/builds)

Lua modulo11 number generator and verificator
Modulo 11 is a way to calculate checksums for digitbased codes. Common usage for modulo 11 is ISBN, credit card or bank account numbers. The verification offered is not intended for security, but to catch human errors (typo's). See [this wikipedia article](http://en.wikipedia.org/wiki/Check_digit).

[API documentation](http://tieske.github.io/mod11/) is available online at github as is the [source code](https://github.com/Tieske/mod11)

General usage
=============
Modulo 11 calculates a checksum based on a weight given to digits based upon their position. The verifycode must be supplied once, and checking numbers can be done against the same verifycode.
This implementation uses a verifycode 8 characters long, digits 2-9 (no duplicates). This means that for every 8 input digits 1 checksum digit is added. Different series of numbers can be used with different verifycodes.

For readability 'allowed' characters can be provided. When calculating or verifying checksums those characters are ignored. Common 'allowed' characters are "-/.".
With this set of allowed characters the following sequences will get the same checksums;

 - 2012.345.67/32
 - 2012-345/67.32
 - 20123456732

Examples
========
Using an invoicenumber containing a date and a sequential number that can be represented like this: "2013-12-15/015". The allowed characters must be "-/" in this case.
```lua
local invoice = "2013-12-15/015"
print(m:calc(invoice.."-"))
````
The above example will print the invoice number `2013-12-15/015-xx` where xx is the checksum depending on the verifynumber initially choosen for this sequence.

Searching
=========
The module contains an iterator function that can scan text for valid numbers. Sample use includes checking incoming emails for valid supportcase numbers, or scanning bank transaction details for valid invoice numbers or customerids.
For an example see the [sample.lua](https://github.com/Tieske/mod11/blob/master/samples/sample.lua) file. The sample contains 2 series with their own verifynumber sequence, where each iterator will only find its own numbers.


