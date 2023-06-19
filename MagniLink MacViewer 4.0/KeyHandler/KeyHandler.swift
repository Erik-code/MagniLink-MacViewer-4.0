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

        let characters = key.charactersIgnoringModifiers?.lowercased() ?? ""
        
        return KeyCombo(ctrl: ctrl, option: option, cmd: cmd, shift: shift, characters: characters)
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
        
        createShortcut(array: &result, action: Actions.nextNatural, character: "UIKeyInputF1")
        createShortcut(array: &result, action: Actions.nextPositive, character: "UIKeyInputF2")
        createShortcut(array: &result, action: Actions.previousPositive, character: "UIKeyInputF2", shift: true)
        createShortcut(array: &result, action: Actions.nextNegative, character: "UIKeyInputF3")
        createShortcut(array: &result, action: Actions.previousNegative, character: "UIKeyInputF3", shift: true)

        createShortcut(array: &result, action: .zoomIn, character: "UIKeyInputUpArrow")
        createShortcut(array: &result, action: .zoomOut, character: "UIKeyInputDownArrow")

        createShortcut(array: &result, action: .startDecreaseContrast, character: "UIKeyInputLeftArrow")
        createShortcut(array: &result, action: .startIncreaseContrast, character: "UIKeyInputRightArrow")

        createShortcut(array: &result, action: .openSettings, character: ",", cmd: true)
        createShortcut(array: &result, action: .hideMenu, character: "h", alt: true)
        
        return result
    }
    
    private func setupCameraShortcuts() -> [Shortcut]
    {
        var result = [Shortcut]()
        
        createShortcut(array: &result, action: Actions.reflineLeft, character: "UIKeyInputLeftArrow", alt: true, scope: .camera)
        createShortcut(array: &result, action: Actions.reflineRight, character: "UIKeyInputRightArrow", alt: true, scope: .camera)

        createShortcut(array: &result, action: Actions.rotateClockwise, character: "r", alt: true , scope: .camera)
        createShortcut(array: &result, action: Actions.rotateCounterClockwise, character: "r", alt: true, shift: true, scope: .camera)

        createShortcut(array: &result, action: Actions.startRotateClockwise, character: "r", scope: .camera)
        createShortcut(array: &result, action: Actions.startRotateCounterClockwise, character: "r", shift: true, scope: .camera)

        createShortcut(array: &result, action: Actions.mirror, character: "i", alt: true, scope: .camera)
        
        return result
    }
    
    private func setupMultiViewShortcuts() -> [Shortcut]
    {
        var result = [Shortcut]()

        createShortcut(array: &result, action: Actions.switchView, character: "v")
        
        return result
    }
    
    private func setupPanTiltShortcuts() -> [Shortcut]
    {
        var result = [Shortcut]()

        createShortcut(array: &result, action: Actions.panLeft, character: "a")
        createShortcut(array: &result, action: Actions.panRight, character: "d")
        createShortcut(array: &result, action: Actions.panUp, character: "w")
        createShortcut(array: &result, action: Actions.panDown, character: "s")

        createShortcut(array: &result, action: Actions.setPresetOne , character: "1", ctrl: true, scope: .camera)
        createShortcut(array: &result, action: Actions.setPresetTwo , character: "2", ctrl: true, scope: .camera)
        createShortcut(array: &result, action: Actions.setPresetThree , character: "3", ctrl: true, scope: .camera)
        createShortcut(array: &result, action: Actions.setPresetFour , character: "4", ctrl: true, scope: .camera)
        createShortcut(array: &result, action: Actions.setPresetFive , character: "5", ctrl: true, scope: .camera)
        createShortcut(array: &result, action: Actions.setPresetSix , character: "6", ctrl: true, scope: .camera)

        createShortcut(array: &result, action: Actions.gotoPresetOne , character: "1", alt: true, scope: .camera)
        createShortcut(array: &result, action: Actions.gotoPresetTwo , character: "2", alt: true, scope: .camera)
        createShortcut(array: &result, action: Actions.gotoPresetThree , character: "3", alt: true, scope: .camera)
        createShortcut(array: &result, action: Actions.gotoPresetFour , character: "4", alt: true, scope: .camera)
        createShortcut(array: &result, action: Actions.gotoPresetFive , character: "5", alt: true, scope: .camera)
        createShortcut(array: &result, action: Actions.gotoPresetSix , character: "6", alt: true, scope: .camera)

        return result
    }
    
    private func setupMulticamShortcuts() -> [Shortcut]
    {
        var result = [Shortcut]()
        
        createShortcut(array: &result, action: Actions.switchCamera , character: "c", scope: .camera)
        createShortcut(array: &result, action: Actions.switchSources , character: "z", scope: .camera)
        createShortcut(array: &result, action: Actions.switchSplit , character: "x", scope: .camera)
        createShortcut(array: &result, action: Actions.splitLeft , character: "UIKeyInputLeftArrow", shift: true, scope: .camera)
        createShortcut(array: &result, action: Actions.splitRight , character: "UIKeyInputRightArrow", shift: true, scope: .camera)

        return result
    }

    private func setupRecordingShortcuts() -> [Shortcut]
    {
        var result = [Shortcut]()
        
        createShortcut(array: &result, action: Actions.takePicture , character: "UIKeyInputF5", scope: .camera)
        createShortcut(array: &result, action: Actions.record , character: "UIKeyInputF5", alt: true, scope: .camera)
        
        return result
    }
    
    private func setupLightShortcuts() -> [Shortcut]
    {
        var result = [Shortcut]()
        
        createShortcut(array: &result, action: Actions.light , character: "i", shift: true, scope: .camera)
        
        return result
    }
    
    private func setupNotepadShortcuts() -> [Shortcut]
    {
        var result = [Shortcut]()
        
        createShortcut(array: &result, action: Actions.takeInkPicture, character: "UIKeyInputF7")
        
        createShortcut(array: &result, action: Actions.new, character: "n", alt: true, scope: .ink)
        createShortcut(array: &result, action: Actions.load, character: "o", alt: true, scope: .ink)
        createShortcut(array: &result, action: Actions.save, character: "s", alt: true, scope: .ink)

        createShortcut(array: &result, action: Actions.undo, character: "z", cmd: true, scope: .ink)
        createShortcut(array: &result, action: Actions.redo, character: "z", cmd: true, shift: true, scope: .ink)

        createShortcut(array: &result, action: Actions.rotateClockwise, character: "r", alt: true, scope: .ink)
        createShortcut(array: &result, action: Actions.rotateCounterClockwise, character: "r", alt: true, shift: true, scope: .ink)
        
        createShortcut(array: &result, action: Actions.setPen, character: "p", alt: true, scope: .ink)
        createShortcut(array: &result, action: Actions.setMarker, character: "l", alt: true, scope: .ink)
        createShortcut(array: &result, action: Actions.setText, character: "t", alt: true, scope: .ink)
        createShortcut(array: &result, action: Actions.erase, character: "e", alt: true, scope: .ink)
        createShortcut(array: &result, action: Actions.zoom, character: "f", alt: true, scope: .ink)

        return result
    }
    
    private func setupOCRShortcuts() -> [Shortcut]
    {
        var result = [Shortcut]()

        createShortcut(array: &result, action: Actions.ocr, character: "UIKeyInputF4", scope: .camera)
        
        createShortcut(array: &result, action: Actions.increaseFontSize, character: "UIKeyInputUpArrow", alt: true, scope: .ocr)
        createShortcut(array: &result, action: Actions.decreaseFontSize, character: "UIKeyInputDownArrow", alt: true, scope: .ocr)

        createShortcut(array: &result, action: Actions.playpause, character: "1")
        createShortcut(array: &result, action: Actions.stopSpeech , character: "2")

        createShortcut(array: &result, action: Actions.readPrevious , character: "3", scope: .ocr)
        createShortcut(array: &result, action: Actions.readNext , character: "4", scope: .ocr)

        createShortcut(array: &result, action: Actions.changeReadmode , character: "5", scope: .ocr)
        createShortcut(array: &result, action: Actions.changeScrollmode , character: "b", scope: .ocr)

        return result
    }
    
    private func createShortcut(array : inout [Shortcut], action : Actions, character : String, ctrl : Bool = false, alt : Bool = false, cmd : Bool = false, shift : Bool = false , scope : ShortcutScope = .app)
    {
        let kc = KeyCombo(ctrl: ctrl, option: alt, cmd: cmd, shift: shift, characters: character)
        let sc = Shortcut(action: action, combo: kc, scope: scope)
        array.append(sc)
    }
    
//MARK: handle
    
    func handleKeyDown(key: NSEvent)
    {
        let kc = toKeyCombo(key: key)
        
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

