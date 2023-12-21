//
//  KeyHandler.swift
//  MagniLink Viewer
//
//  Created by Erik Sandstrom on 2023-03-24.
//

import UniformTypeIdentifiers
import Foundation
import Cocoa

protocol KeyHandlerDelegate
{
    func performAction(action : Actions)
}

class KeyHandler
{
    private var mShortcutsStandard = [Shortcut]()
    private var mShortcutsCamera = [Shortcut]()
    private var mShortcutsPanTilt = [Shortcut]()
    private var mShortcutsMulticam = [Shortcut]()

    private var mShortcutsMultiView = [Shortcut]()
    
    private var mShortcutsRecording = [Shortcut]()
    private var mShortcutsOCR = [Shortcut]()
    private var mShortcutsLight = [Shortcut]()
    private var mShortcutsNotepad = [Shortcut]()

    var currentShortcutScope = ShortcutScope.camera
    var delegate : KeyHandlerDelegate?
    var cameraManager : CameraManager?
    
    init()
    {
        setDefault()
    }
    
    func setDefault()
    {
        mShortcutsStandard = setupStandardShortcuts()
        mShortcutsCamera = setupCameraShortcuts()
        mShortcutsPanTilt = setupPanTiltShortcuts()
        mShortcutsMulticam = setupMulticamShortcuts()
        
        mShortcutsMultiView = setupMultiViewShortcuts()
        
        mShortcutsRecording = setupRecordingShortcuts()
        mShortcutsLight = setupLightShortcuts()
        mShortcutsNotepad = setupNotepadShortcuts()
        mShortcutsOCR = setupOCRShortcuts()
    }
    
    func load()
    {
        let dict = Preferences.shared.shortcuts
        
        for sc in mShortcutsStandard
        {
            if dict.keys.contains(sc.action){
                sc.keyCombo = dict[sc.action]!
            }
        }
        for sc in mShortcutsCamera
        {
            if dict.keys.contains(sc.action){
                sc.keyCombo = dict[sc.action]!
            }
        }
        for sc in mShortcutsOCR
        {
            if dict.keys.contains(sc.action){
                sc.keyCombo = dict[sc.action]!
            }
        }
    }
    
    func save()
    {
        var dict = [Actions : KeyCombo]()
        for sc in mShortcutsStandard
        {
            dict[sc.action] = sc.keyCombo
        }
        for sc in mShortcutsCamera
        {
            dict[sc.action] = sc.keyCombo
        }
        for sc in mShortcutsOCR
        {
            dict[sc.action] = sc.keyCombo
        }
                
        Preferences.shared.shortcuts = dict
    }
    
    private func toKeyCombo(key : NSEvent) -> KeyCombo
    {
        let ctrl = key.modifierFlags.contains(.control)
        let option = key.modifierFlags.contains(.option)
        let shift = key.modifierFlags.contains(.shift)
        let cmd = key.modifierFlags.contains(.command)

        
        var characters = key.charactersIgnoringModifiers?.lowercased() ?? ""
        let keyCode = key.keyCode
        if keyCode == 126 {
            characters = "NSUpArrowFunctionKey"
        }
        else if keyCode == 125 {
            characters = "NSDownArrowFunctionKey"
        }
        else if keyCode == 99 {
            characters = "NSF3FunctionKey"
        }
        else if keyCode == 120 {
            characters = "NSF2FunctionKey"
        }
        else if keyCode == 122 {
            characters = "NSF1FunctionKey"
        }
        else if keyCode == 96 {
            characters = "NSF5FunctionKey"
        }
        else if keyCode == 118 {
            characters = "NSF4FunctionKey"
        }


        
        //let index = characters!.index(characters!.startIndex, offsetBy: 0)
        //let character = characters![index]
        
        return KeyCombo(ctrl: ctrl, option: option, cmd: cmd, shift: shift, characters: characters, keyCode: keyCode)
    }
    
    var GeneralShortcuts : [Shortcut]
    {
        guard let manager = cameraManager else { return [Shortcut]() }
        
        var result = mShortcutsStandard
//        if manager.availableFunctions.contains(.ocr) {
            result += mShortcutsMultiView
//        }
//        if VideoCaptureBase.hasLight() {
            result += mShortcutsLight
//        }
        
        return result
    }
    
    var CameraShortcuts : [Shortcut]
    {
        guard let manager = cameraManager else { return [Shortcut]() }
        var result = mShortcutsCamera

        //if manager.availableFunctions.contains(.ocr) {
            result += mShortcutsRecording
        //}
        //if manager.count() > 1 {
            result += mShortcutsMulticam
        //}
        //if manager.availableFunctions.contains(.pan){
            result += mShortcutsPanTilt
        //}
        
        return result
    }
    
    var OCRShortcuts : [Shortcut]
    {
        guard let manager = cameraManager else { return [Shortcut]() }
        
        //if manager.availableFunctions.contains(.ocr){
            return mShortcutsOCR
        //}
        
        return [Shortcut]()
    }
    
    var NotepadShortcuts : [Shortcut]
    {
        guard let manager = cameraManager else { return [Shortcut]() }
        
        //if manager.availableFunctions.contains(.ocr){
            return mShortcutsNotepad
        //}
        
        return [Shortcut]()
    }
    
    private func setupStandardShortcuts() -> [Shortcut]
    {
        var result = [Shortcut]()
        
        createShortcut(array: &result, action: Actions.nextNatural, string: "NSF1FunctionKey")
        createShortcut(array: &result, action: Actions.nextPositive, string: "NSF2FunctionKey")
        createShortcut(array: &result, action: Actions.previousPositive, string: "NSF2FunctionKey", shift: true)
        createShortcut(array: &result, action: Actions.nextNegative, string: "NSF3FunctionKey")
        createShortcut(array: &result, action: Actions.previousNegative, string: "NSF3FunctionKey", shift: true)

        createShortcut(array: &result, action: .zoomIn, string: "NSUpArrowFunctionKey")
        createShortcut(array: &result, action: .zoomOut, string: "NSDownArrowFunctionKey")

        createShortcut(array: &result, action: .startDecreaseContrast, string: "NSLeftArrowFunctionKey")
        createShortcut(array: &result, action: .startIncreaseContrast, string: "NSRightArrowFunctionKey")

        //createShortcut(array: &result, action: .openSettings, string: ",", cmd: true)
        //createShortcut(array: &result, action: .hideMenu, string: "h", alt: true)
        
        return result
    }
    
    private func setupCameraShortcuts() -> [Shortcut]
    {
        var result = [Shortcut]()
        
        createShortcut(array: &result, action: Actions.reflineLeft, string: "NSLeftArrowFunctionKey", alt: true, scope: .camera)
        createShortcut(array: &result, action: Actions.reflineRight, string: "NSRightArrowFunctionKey", alt: true, scope: .camera)

        createShortcut(array: &result, action: Actions.rotateClockwise, string: "r", alt: true , scope: .camera)
        createShortcut(array: &result, action: Actions.rotateCounterClockwise, string: "r", alt: true, shift: true, scope: .camera)

        createShortcut(array: &result, action: Actions.startRotateClockwise, string: "r", scope: .camera)
        createShortcut(array: &result, action: Actions.startRotateCounterClockwise, string: "r", shift: true, scope: .camera)

        createShortcut(array: &result, action: Actions.mirror, string: "i", alt: true, scope: .camera)
        
        return result
    }
    
    private func setupMultiViewShortcuts() -> [Shortcut]
    {
        var result = [Shortcut]()

        createShortcut(array: &result, action: Actions.switchView, string: "v")
        
        return result
    }
    
    private func setupPanTiltShortcuts() -> [Shortcut]
    {
        var result = [Shortcut]()

        createShortcut(array: &result, action: Actions.panLeft, string: "a")
        createShortcut(array: &result, action: Actions.panRight, string: "d")
        createShortcut(array: &result, action: Actions.panUp, string: "w")
        createShortcut(array: &result, action: Actions.panDown, string: "s")

        createShortcut(array: &result, action: Actions.setPresetOne , string: "1", ctrl: true, scope: .camera)
        createShortcut(array: &result, action: Actions.setPresetTwo , string: "2", ctrl: true, scope: .camera)
        createShortcut(array: &result, action: Actions.setPresetThree , string: "3", ctrl: true, scope: .camera)
        createShortcut(array: &result, action: Actions.setPresetFour , string: "4", ctrl: true, scope: .camera)
        createShortcut(array: &result, action: Actions.setPresetFive , string: "5", ctrl: true, scope: .camera)
        createShortcut(array: &result, action: Actions.setPresetSix , string: "6", ctrl: true, scope: .camera)

        createShortcut(array: &result, action: Actions.gotoPresetOne , string: "1", alt: true, scope: .camera)
        createShortcut(array: &result, action: Actions.gotoPresetTwo , string: "2", alt: true, scope: .camera)
        createShortcut(array: &result, action: Actions.gotoPresetThree , string: "3", alt: true, scope: .camera)
        createShortcut(array: &result, action: Actions.gotoPresetFour , string: "4", alt: true, scope: .camera)
        createShortcut(array: &result, action: Actions.gotoPresetFive , string: "5", alt: true, scope: .camera)
        createShortcut(array: &result, action: Actions.gotoPresetSix , string: "6", alt: true, scope: .camera)

        return result
    }
    
    private func setupMulticamShortcuts() -> [Shortcut]
    {
        var result = [Shortcut]()
        
        createShortcut(array: &result, action: Actions.switchCamera , string: "c", scope: .camera)
        createShortcut(array: &result, action: Actions.switchSources , string: "z", scope: .camera)
        createShortcut(array: &result, action: Actions.switchSplit , string: "x", scope: .camera)
        createShortcut(array: &result, action: Actions.splitLeft , string: "NSLeftArrowFunctionKey", shift: true, scope: .camera)
        createShortcut(array: &result, action: Actions.splitRight , string: "NSRightArrowFunctionKey", shift: true, scope: .camera)

        return result
    }

    private func setupRecordingShortcuts() -> [Shortcut]
    {
        var result = [Shortcut]()
        
        createShortcut(array: &result, action: Actions.takePicture , string: "NSF5FunctionKey", scope: .camera)
        createShortcut(array: &result, action: Actions.record , string: "NSF5FunctionKey", alt: true, scope: .camera)
        
        return result
    }
    
    private func setupLightShortcuts() -> [Shortcut]
    {
        var result = [Shortcut]()
        
        createShortcut(array: &result, action: Actions.light , string: "i", shift: true, scope: .camera)
        
        return result
    }
    
    private func setupNotepadShortcuts() -> [Shortcut]
    {
        var result = [Shortcut]()
        
        createShortcut(array: &result, action: Actions.takeInkPicture, string: "NSF7FunctionKey")
        
        createShortcut(array: &result, action: Actions.new, string: "n", alt: true, scope: .ink)
        createShortcut(array: &result, action: Actions.load, string: "o", alt: true, scope: .ink)
        createShortcut(array: &result, action: Actions.save, string: "s", alt: true, scope: .ink)

        createShortcut(array: &result, action: Actions.undo, string: "z", cmd: true, scope: .ink)
        createShortcut(array: &result, action: Actions.redo, string: "z", cmd: true, shift: true, scope: .ink)

        createShortcut(array: &result, action: Actions.rotateClockwise, string: "r", alt: true, scope: .ink)
        createShortcut(array: &result, action: Actions.rotateCounterClockwise, string: "r", alt: true, shift: true, scope: .ink)
        
        createShortcut(array: &result, action: Actions.setPen, string: "p", alt: true, scope: .ink)
        createShortcut(array: &result, action: Actions.setMarker, string: "l", alt: true, scope: .ink)
        createShortcut(array: &result, action: Actions.setText, string: "t", alt: true, scope: .ink)
        createShortcut(array: &result, action: Actions.erase, string: "e", alt: true, scope: .ink)
        createShortcut(array: &result, action: Actions.zoom, string: "f", alt: true, scope: .ink)

        return result
    }
    
    private func setupOCRShortcuts() -> [Shortcut]
    {
        var result = [Shortcut]()

        createShortcut(array: &result, action: Actions.ocr, string: "NSF4FunctionKey", scope: .camera)
        
        createShortcut(array: &result, action: Actions.increaseFontSize, string: "NSUpArrowFunctionKey", alt: true, scope: .ocr)
        createShortcut(array: &result, action: Actions.decreaseFontSize, string: "NSDownArrowFunctionKey", alt: true, scope: .ocr)

        createShortcut(array: &result, action: Actions.playpause, string: "1")
        createShortcut(array: &result, action: Actions.stopSpeech , string: "2")

        createShortcut(array: &result, action: Actions.readPrevious , string: "3", scope: .ocr)
        createShortcut(array: &result, action: Actions.readNext , string: "4", scope: .ocr)

        createShortcut(array: &result, action: Actions.changeReadmode , string: "5", scope: .ocr)
        createShortcut(array: &result, action: Actions.changeScrollmode , string: "b", scope: .ocr)

        return result
    }
    
    private func createShortcut(array : inout [Shortcut], action : Actions, string : String, ctrl : Bool = false, alt : Bool = false, cmd : Bool = false, shift : Bool = false , scope : ShortcutScope = .app)
    {
        let kc = KeyCombo(ctrl: ctrl, option: alt, cmd: cmd, shift: shift, characters: string, keyCode: 0)
        let sc = Shortcut(action: action, combo: kc, scope: scope)
        array.append(sc)
    }
    
    
//MARK: handle
    
    func handleKeyDown(key: NSEvent)
    {
        let kc = toKeyCombo(key: key)
        
        print("KEY \(kc.toString())")
        
        if handleKeyDownHelper(shortcuts: mShortcutsStandard, combo: kc) {
            return
        }
        if handleKeyDownHelper(shortcuts: mShortcutsMultiView, combo: kc) {
            return
        }
        if handleKeyDownHelper(shortcuts: mShortcutsCamera, combo: kc) {
            return
        }
        if handleKeyDownHelper(shortcuts: mShortcutsRecording, combo: kc) {
            return
        }
        
        if handleKeyDownHelper(shortcuts: mShortcutsLight, combo: kc) {
            return
        }
        
        if handleKeyDownHelper(shortcuts: mShortcutsMulticam, combo: kc) {
            return
        }
        if handleKeyDownHelper(shortcuts: mShortcutsPanTilt, combo: kc) {
            return
        }

        if handleKeyDownHelper(shortcuts: mShortcutsOCR, combo: kc) {
            return
        }
        if handleKeyDownHelper(shortcuts: mShortcutsNotepad, combo: kc) {
            return
        }
    }
    
    func handleKeyUp(key : NSEvent)
    {
        let combo = toKeyCombo(key: key)
        
        handleKeyUpHelper(shortcuts: mShortcutsStandard, combo: combo)

        handleKeyUpHelper(shortcuts: mShortcutsCamera, combo: combo)
        
        handleKeyUpHelper(shortcuts: mShortcutsOCR, combo: combo)
    }
    
    private func handleKeyDownHelper(shortcuts : [Shortcut] , combo : KeyCombo) -> Bool
    {
        //Här behöver vi veta vilken tab
        for sc in shortcuts
        {
            if (sc.scope == .app || currentShortcutScope == sc.scope) && sc.keyCombo == combo {
                delegate?.performAction(action: sc.action)
                return true
            }
        }
        return false
    }
    
    private func handleKeyUpHelper(shortcuts : [Shortcut] , combo : KeyCombo)
    {
        for sc in shortcuts
        {
            if sc.keyCombo?.characters == combo.characters {
                performUpAction(action: sc.action)
            }
        }
    }
    
    private func performUpAction(action : Actions)
    {
        if [.zoomIn, .zoomOut].contains(action) {
            delegate?.performAction(action: .zoomStop)
        }
        else if [.startDecreaseContrast, .startIncreaseContrast].contains(action) {
            delegate?.performAction(action: .stopContrast)
        }
        else if [.reflineLeft, .reflineRight].contains(action) {
            delegate?.performAction(action: .reflineStop)
        }
        else if [.startRotateCounterClockwise, .startRotateClockwise].contains(action) {
            delegate?.performAction(action: .stopRotate)
        }
    }
}

