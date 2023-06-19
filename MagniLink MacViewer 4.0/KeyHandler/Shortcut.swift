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
    var characters = ""
    
    func toString() -> String
    {
        let ctrl = ctrl ? "1" : "0"
        let shift = shift ? "1" : "0"
        let alt = option ? "1" : "0"
        let cmd = cmd ? "1" : "0"
        return "\(ctrl)\(shift)\(alt)\(cmd)\(characters)"
    }
    
    init(ctrl: Bool, option: Bool, cmd: Bool, shift: Bool, characters: String = "") {
        self.ctrl = ctrl
        self.option = option
        self.cmd = cmd
        self.shift = shift
        self.characters = characters
    }
    
    init(string : String)
    {
        guard string.count >= 5 else { return }

        ctrl = string[0] == "1"
        shift = string[1] == "1"
        option = string[2] == "1"
        cmd = string[3] == "1"
//
        characters = string.substring(from: 4)
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
        case "UIKeyInputF1":
            return NSLocalizedString("F1", comment: "")
        case "UIKeyInputF2":
            return NSLocalizedString("F2", comment: "")
        case "UIKeyInputF3":
            return NSLocalizedString("F3", comment: "")
        case "UIKeyInputF4":
            return NSLocalizedString("F4", comment: "")
        case "UIKeyInputF5":
            return NSLocalizedString("F5", comment: "")
        case "UIKeyInputF6":
            return NSLocalizedString("F6", comment: "")
        case "UIKeyInputF7":
            return NSLocalizedString("F7", comment: "")
        case "UIKeyInputF8":
            return NSLocalizedString("F8", comment: "")
        case "UIKeyInputF9":
            return NSLocalizedString("F9", comment: "")
        case "UIKeyInputF10":
            return NSLocalizedString("F10", comment: "")
        case "UIKeyInputF11":
            return NSLocalizedString("F11", comment: "")
        case "UIKeyInputF12":
            return NSLocalizedString("F12", comment: "")
        case "UIKeyInputUpArrow":
            return NSLocalizedString("UpArrow", comment: "")
        case "UIKeyInputDownArrow":
            return NSLocalizedString("DownArrow", comment: "")
        case "UIKeyInputLeftArrow":
            return NSLocalizedString("LeftArrow", comment: "")
        case "UIKeyInputRightArrow":
            return NSLocalizedString("RightArrow", comment: "")

        default:
            return kc.characters.uppercased()
        }
    }
}
