# README

## What is NBJSON-Parser

This is a No Bullshit JSON-Parser.  I felt the typical Swift way of parsing JSON was about as Swift as taking a shit after consuming the whole dairy section at HEB (assuming you aren't lactose intolerant).  Converting from String to NSString to NSData just to parse JSON is bullshit...so I fixed that.  Still a WIP...but still a hell of a lot better than the default way of doing so.

## How to Use
    var json = JSON.Parser.parseJson(stringVariable)

HOLY CRAP!  LOOK AT ALL ONE LINE OF CODE!  Apple apparently didn't learn the concept of KISS.

## Version Details

### Version 1

Doesn't have any form of validation.  This will be accomplished by running a preliminary scan across the JSON object and then examining the processing stack to ensure it's empty (i.e. that all opening braces and quotation marks have been closed) then finally throwing errors as it parses if it discovers an invalid data type (like an unquoted string other than "true", "false" or a number.

Currently supports JSON objects with String, Object and List values.  Next update will include integers, floats and booleans.
