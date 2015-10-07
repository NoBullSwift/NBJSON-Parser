# README

## What is NBJSON-Parser

This is a No Bullshit JSON-Parser.  I felt the typical Swift way of parsing JSON was about as Swift as taking a shit after consuming the whole dairy section at HEB (assuming you aren't lactose intolerant).  Converting from String to NSString to NSData just to parse JSON is bullshit...so I fixed that.  Still a WIP...but still a hell of a lot better than the default way of doing so.  Do keep in mind however that this will only work on regular ASCII strings (why the hell would you try to send non-ascii string as JSON blobs is beyond me).

## How to Use
    var json = JSON.Parser.parseJson(stringVariable)

HOLY CRAP!  LOOK AT ALL ONE LINE OF CODE!  Apple apparently didn't learn the concept of KISS.

## Version Details

### Version 0.4a

Added a stringify function to allow conversion of a map to a JSON String

### Version 0.3a

Added null objects

### Version 0.2a

Added ability to have int, float and boolean values in objects and lists.

### Version 0.1a

Doesn't have any form of validation.  This will be accomplished by running a preliminary scan across the JSON object and then examining the processing stack to ensure it's empty (i.e. that all opening braces and quotation marks have been closed) then finally throwing errors as it parses if it discovers an invalid data type (like an unquoted string other than "true", "false" or a number.

Currently supports JSON objects with String, Object and List values.  Next update will include integers, floats and booleans.
