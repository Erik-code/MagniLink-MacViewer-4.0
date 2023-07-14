//
//  Shortcut.swift
//  MagniLink Viewer
//
//  Created by Erik Sandstrom on 2023-03-24.
//

import Foundation
import UniformTypeIdentifiers
import Cocoa

struct KeyCombo : Equatable
{
    var ctrl : Bool = false
    var option : Bool = false
    var cmd : Bool = false
    var shift : Bool = false
    var characters : String = ""
    var keyCode : UInt16 = 0
    
    func toString() -> String
    {
        let ctrl = ctrl ? "1" : "0"
        let shift = shift ? "1" : "0"
        let alt = option ? "1" : "0"
        let cmd = cmd ? "1" : "0"
        return "\(ctrl)\(shift)\(alt)\(cmd)\(characters) \(keyCode)"
    }
    
    init(ctrl: Bool, option: Bool, cmd: Bool, shift: Bool, characters: String = "", keyCode: UInt16) {
        self.ctrl = ctrl
        self.option = option
        self.cmd = cmd
        self.shift = shift
        self.characters = characters
        self.keyCode = keyCode
    }
    
    init(string : String)
    {
        guard string.count >= 5 else { return }

        ctrl = string[0] == "1"
        shift = string[1] == "1"
        option = string[2] == "1"
        cmd = string[3] == "1"
//
        characters = string.substring(from: 4) ?? ""
    }
}

func ==(lhs: KeyCombo, rhs: KeyCombo) -> Bool
{
    return lhs.ctrl == rhs.ctrl && lhs.option == rhs.option && lhs.cmd == rhs.cmd && lhs.shift == rhs.shift && lhs.characters == rhs.characters
}

func !=(lhs: KeyCombo, rhs: KeyCombo) -> Bool
{
    return !(lhs == rhs)
}

class Shortcut
{
    var action : Actions
    var keyCombo : KeyCombo?
    
    var scope : ShortcutScope
    
    init(action : Actions, combo : KeyCombo, scope : ShortcutScope = .app){
        self.action = action
        self.scope = scope
        keyCombo = combo
    }
    
    func toInt() -> Int
    {
        return 0
    }
    
    func fromInt(val : Int)
    {
        
    }
    
    func toString() -> String
    {
        guard let kc = keyCombo else {return ""}

        let ctrl = kc.ctrl ? "Ctrl+" : ""
        let shift = kc.shift ? "Shift+" : ""
        let alt = kc.option ? "Option+" : ""
        let cmd = kc.cmd ? "Cmd+" : ""
        return "\(ctrl)\(shift)\(alt)\(cmd)\(character())"
    }
    
    func character() -> String
    {
        guard let kc = keyCombo else {return ""}
        
        switch kc.characters {
        case "NSF1FunctionKey":
            return NSLocalizedString("F1", comment: "")
        case "NSF2FunctionKey":
            return NSLocalizedString("F2", comment: "")
        case "NSF3FunctionKey":
            return NSLocalizedString("F3", comment: "")
        case "NSF4FunctionKey":
            return NSLocalizedString("F4", comment: "")
        case "NSF5FunctionKey":
            return NSLocalizedString("F5", comment: "")
        case "NSF6FunctionKey":
            return NSLocalizedString("F6", comment: "")
        case "NSF7FunctionKey":
            return NSLocalizedString("F7", comment: "")
        case "NSF8FunctionKey":
            return NSLocalizedString("F8", comment: "")
        case "NSF9FunctionKey":
            return NSLocalizedString("F9", comment: "")
        case "NSF10FunctionKey":
            return NSLocalizedString("F10", comment: "")
        case "NSF11FunctionKey":
            return NSLocalizedString("F11", comment: "")
        case "NSF12FunctionKey":
            return NSLocalizedString("F12", comment: "")
        case "NSUpArrowFunctionKey":
            return NSLocalizedString("UpArrow", comment: "")
        case "NSDownArrowFunctionKey":
            return NSLocalizedString("DownArrow", comment: "")
        case "NSLeftArrowFunctionKey":
            return NSLocalizedString("LeftArrow", comment: "")
        case "NSRightArrowFunctionKey":
            return NSLocalizedString("RightArrow", comment: "")

        default:
            return kc.characters
        }
    }
}
