//
//  main.swift
//  JSON Parser
//
//  Created by Michael Main on 4/17/15.
//  Copyright (c) 2015 Michael Main. All rights reserved.
//
//  Change log
//  Michael Main | 04/21/2015 | Initial classes done- need to implement non string values

import Foundation

struct Stack<T> {
    var items = [T]()
    mutating func push(item: T) {
        items.append(item)
    }
    mutating func pop() -> T {
        var item : T = items.removeLast()
        return item
    }
    func peek() -> T {
        return items.last!
    }
    func isEmpty() -> Bool {
        return items.count == 0
    }
    
    func displayStack() -> String {
        var s = ""
        var seperator = ""
        for item in items {
            s = "\(s)\(seperator)\(item)"
            seperator = ","
        }
        
        return s
    }
}

class JSON {
    enum JsonType {
        case NONE
        case OBJECT
        case LIST
        case STRING
    }
    
    enum ParserState {
        case INIT
        case READING_KEY
        case SEARCHING_NEXT
        case SEARCHING_SEPERATOR
        case SEARCHING_VALUE
        case READING_STRING_VALUE
        case READING_INT_VALUE
        case READING_BOOL_VALUE
        case READING_OBJECT_VALUE
        case READING_LIST_VALUE
        case STORING
    }
    
    class Parser {
        class func parseJson(jsonString : String) -> Any? {
            var jsonStringArray : Array<Character> = Array(jsonString)
            var index : Int
            var expression : Array<Character>
            var type : JsonType
            
            (index, expression, type) = extractJsonExpression(jsonString: jsonStringArray)
            
            if (type == JsonType.OBJECT) {
                return parseJsonObject(expression)
            } else if (type == JsonType.LIST) {
                return parseJsonList(expression)
            }
            
            
            return nil
        }
        
        private class func parseJsonList(jsonString : Array<Character>) -> Array<Any> {
            var type : JsonType
            var list  : Array<Any> = Array()
            var state : ParserState = ParserState.INIT
            var value : String = ""
            var index : Int
            var expression : Array<Character>
            
            for var i = 0; i < jsonString.count; i++ {
                var c = jsonString[i]
                
                switch (state) {
                case .INIT:
                    if (c == "\"") {
                        state = ParserState.READING_STRING_VALUE
                    } else if (c == "{") {
                        (index, expression, type) = extractJsonExpression(jsonString: jsonString, startIndex: i)
                        i = index
                        list.append(parseJsonObject(expression))
                        value = ""
                        state = ParserState.SEARCHING_NEXT
                    } else if (c == "[") {
                        (index, expression, type) = extractJsonExpression(jsonString: jsonString, startIndex: i)
                        i = index
                        list.append(parseJsonList(expression))
                        value = ""
                        state = ParserState.SEARCHING_NEXT
                    }
                    break
                case .READING_STRING_VALUE:
                    if (c == "\"") {
                        list.append(value)
                        value = ""
                        state = ParserState.SEARCHING_NEXT
                        continue
                    }
                    value.append(c)
                    break
                case .READING_INT_VALUE:
                    break
                case .READING_BOOL_VALUE:
                    break
                case .SEARCHING_NEXT:
                    if (c == ",") {
                        state = ParserState.INIT
                    }
                    break
                case .STORING:
                    break
                default:
                    break
                }
            }
            
            return list
        }
        
        private class func parseJsonObject(jsonString : Array<Character>) -> Dictionary<String, Any> {
            var type : JsonType
            var object : Dictionary<String, Any> = Dictionary()
            var state : ParserState = ParserState.INIT
            var key : String = ""
            var value : String = ""
            var index : Int
            var expression : Array<Character>
            
            for var i = 0; i < jsonString.count; i++ {
                var c = jsonString[i]
                
                switch (state) {
                case .INIT:
                    if (c == "\"") {
                        state = ParserState.READING_KEY
                    }
                    break
                case .READING_KEY:
                    if (c == "\"") {
                        state = ParserState.SEARCHING_SEPERATOR
                        continue
                    }
                    key.append(c)
                    break
                case .SEARCHING_SEPERATOR:
                    if (c == ":") {
                        state = ParserState.SEARCHING_VALUE
                    }
                    break
                case .SEARCHING_NEXT:
                    if (c == ",") {
                        state = ParserState.INIT
                    }
                    break
                case .SEARCHING_VALUE:
                    if (c == "\"") {
                        state = ParserState.READING_STRING_VALUE
                    } else if (c == "{") {
                        (index, expression, type) = extractJsonExpression(jsonString: jsonString, startIndex: i)
                        i = index
                        var obj = parseJsonObject(expression)
                        object[key] = obj
                        key = ""
                        value = ""
                        state = ParserState.SEARCHING_NEXT
                    } else if (c == "[") {
                        (index, expression, type) = extractJsonExpression(jsonString: jsonString, startIndex: i)
                        i = index
                        var list = parseJsonList(expression)
                        object[key] = list
                        key = ""
                        value = ""
                        state = ParserState.SEARCHING_NEXT
                    }
                    break
                case .READING_STRING_VALUE:
                    if (c == "\"") {
                        object[key] = value
                        key = ""
                        value = ""
                        state = ParserState.SEARCHING_NEXT
                        continue
                    }
                    value.append(c)
                    break
                case .READING_INT_VALUE:
                    break
                case .READING_BOOL_VALUE:
                    break
                case .STORING:
                    break
                default:
                    break;
                }
            }
            
            return object
        }
        
        private class func extractJsonExpression(#jsonString : Array<Character>, startIndex index : Int = 0) -> (Int, Array<Character>, JsonType) {
            var typeStack = Stack<String>()
            var jsonSubString = Array<Character>()
            var objectStarted = false
            var type : JsonType = JsonType.NONE;
            
            for var i = index; i < jsonString.count; i++ {
                var c = jsonString[i]
                
                if (objectStarted) {
                    jsonSubString.append(c)
                }
                //println(c)
                
                if (c == "{") {
                    if (!objectStarted) {
                        type = JsonType.OBJECT
                    }
                    typeStack.push("{")
                    objectStarted = true
                } else if (c == "}" && typeStack.peek() == "{") {
                    typeStack.pop()
                } else if (c == "[") {
                    if (!objectStarted) {
                        type = JsonType.LIST
                    }
                    typeStack.push("[")
                    objectStarted = true
                } else if (c == "]" && typeStack.peek() == "[") {
                    typeStack.pop()
                } else if (c == "\"") {
                    if (typeStack.peek() == "\"") {
                        typeStack.pop()
                    } else {
                        if (!objectStarted) {
                            type = JsonType.STRING
                        }
                        typeStack.push("\"")
                        objectStarted = true
                    }
                }
                
                if (objectStarted && typeStack.isEmpty()) {
                    //println("\tDONE")
                    jsonSubString.removeLast()
                    return (i, jsonSubString, type)
                }
            }
            
            return (-1, Array(), JsonType.NONE)
        }
    }
    
    class Utils {
        class func printJson(json: Any) {
            if (json is Dictionary<String, Any>) {
                printJsonObject(json: json as! Dictionary<String, Any>)
            } else if (json is Array<Any>) {
                printJsonList(json: json as! Array<Any>)
            }
        }
        
        private class func printJsonObject(#json: Dictionary<String, Any>, level: Int = 0) {
            for (key, value) in json {
                tabs(level)
                print("\(key) => ")
                if (value is String) {
                    println(value)
                } else if (value is Array<Any>) {
                    println()
                    printJsonList(json: value as! Array<Any>, level: level + 1)
                } else if (value is Dictionary<String, Any>) {
                    println()
                    printJsonObject(json: value as! Dictionary<String, Any>, level: level + 1)
                }
            }
        }
        
        private class func printJsonList(#json: Array<Any>, level: Int = 0) {
            for (index, value) in enumerate(json) {
                tabs(level)
                print("[\(index)] => ")
                if (value is String) {
                    println(value)
                } else if (value is Array<Any>) {
                    println()
                    printJsonList(json: value as! Array<Any>, level: level + 1)
                } else if (value is Dictionary<String, Any>) {
                    println()
                    printJsonObject(json: value as! Dictionary<String, Any>, level: level + 1)
                }
            }
        }
        
        private class func tabs(amount: Int) {
            for var i = 0; i < amount; i++ {
                print("\t")
            }
        }
    }
}

