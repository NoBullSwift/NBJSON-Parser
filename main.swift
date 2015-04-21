//
//  json_test.swift
//  JSON Parser
//
//  Created by Michael Main on 4/21/15.
//  Copyright (c) 2015 Michael Main. All rights reserved.
//

import Foundation

var jsonString : String = "{\"name\": \"Michael\", \"age\": 32, \"pi\": 3.14, \"isRegistered\": true, \"dogs\": [{\"name\": \"Dixie\", \"color\": \"black\"}, {\"name\": \"Sparky\", \"color\": \"black\"}], \"colors\": [\"pink\", \"blue\", \"black\"], \"object\": {\"type\": \"string\", \"value\": \"This is a string\"}, \"list\": [\"string\", 12, 3.14, false], \"lastItem\": 1234}"

var json = JSON.Parser.parseJson(jsonString)!
JSON.Utils.printJson(json)