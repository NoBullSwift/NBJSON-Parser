# README

## What is NBJSON-Parser

No Bull JSON Parser.  Simple, easy to use, JSON parser written entirely in Swift.

## How to Use

### Deserialization
    
    var object = NBJSON.Parser.parseJson(string)

And you're done.  You are given an Any type object that can be either a Dictionary<String,Any> or an Array<Any>.

### Serialization

    var string = NBJSON.Parser.stringify(object)
    
And once again, poof...done!  You give it an Array or a Dictionary and you get a JSON string back.  We are working on adding object mapping abilities, but Swift's reflection support is mediocore at best right now.

### Accessing Elements By Path

Once you have an object back from JSON.Parser.parseJson, you can use a util function to access data at a certain "path" by doing the following:

    var dogName = NBJSON.Utils.search("/dogs[1]/name") as! String
    
Assuming you had the following data that was deserialized:

    {
        dogs: [
            {
                color: "Black",
                name: "Dixie"
            },
            {
                color: "Brown",
                name: "Sparky"
            }
        ]
    }
    
Dog name would now contain "Sparky".  In future versions we will make this feature stronger.  For now it just functions as a means of getting to deeply nested data more easily.

## Version Details

### Version 1.1

Added light, reduced feature set xpath like searching for complex dictionaries

### Version 1.0

Changed a few names around and added an adapter for use by NBRest's object mapping system

### Version 0.4a

Added a stringify function to allow conversion of a map to a JSON String

### Version 0.3a

Added null objects

### Version 0.2a

Added ability to have int, float and boolean values in objects and lists.

### Version 0.1a

Doesn't have any form of validation.  This will be accomplished by running a preliminary scan across the JSON object and then examining the processing stack to ensure it's empty (i.e. that all opening braces and quotation marks have been closed) then finally throwing errors as it parses if it discovers an invalid data type (like an unquoted string other than "true", "false" or a number.

Currently supports JSON objects with String, Object and List values.  Next update will include integers, floats and booleans.
