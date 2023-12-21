//
//  Enums.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-06-19.
//

import Foundation

enum Split: CaseIterable
{
    case left
    case top
    case right
    case bottom
    case full
    
    init(value : Int)
    {
        let allCases = type(of: self).allCases
        self = allCases[value]
    }
    
    func intValue() -> Int
    {
        let allCases = type(of: self).allCases
        return allCases.firstIndex(of: self)!
    }
    
    mutating func next() {
        let allCases = type(of: self).allCases
        self = allCases[(allCases.firstIndex(of: self)! + 1) % allCases.count]
    }
}

struct SplitTwo
{
    var percent : CGFloat = 0.5
    var split : Split = .left
    var previousActive = 0
    var active : Int = 0
    var videos : [Int] = []
    var fullCount : Int = 0
    
    mutating func next(nrSources : Int)
    {
        if videos.count == nrSources {
            videos = [0, 1]
        }
        else if videos[1] < nrSources - 1 {
            videos = [videos[0], videos[1] + 1 ]
        }
        else if videos[0] < nrSources - 2 {
            videos = [videos[0] + 1, videos[0] + 2]
        }
        else {
            videos = Array(0..<nrSources)
        }
        
        if videos.contains(active) {
            return
        }
        active = videos[0]
    }
    
    func print()
    {
        Swift.print("Split************************")
        Swift.print("Split.Active \(active)")
        Swift.print("Split.videos \(videos)")
        Swift.print("Split.split \(split)")
        Swift.print("Split************************")
    }
}

struct Preset
{
    var rotation : Float = 0
    var mirror : Bool = false
    var refline : ReflineCurtainInfo
    var color : ColorManager
    var brightness : Float = 0
    
    init() {
        color = ColorManager.init(aValue: 0)
        refline = ReflineCurtainInfo()
    }
}

enum ReflineCommand
{
    case stop
    case left
    case right
}

enum CameraControlZoomDirection
{
    case inn
    case out
    case stop
}

enum DrawMode : CaseIterable
{
    case pen
    case marker
    case text
    case eraser
    case zoom
    
    init(value : Int)
    {
        let allCases = type(of: self).allCases
        self = allCases[value]
    }
    
    func intValue() -> Int
    {
        let allCases = type(of: self).allCases
        return allCases.firstIndex(of: self)!
    }
}

enum CameraType : CaseIterable
{
    case airReading
    case airDistance
    case airEthernet
    case airGrabber
    case MagniLink
    case Twiga
    
    func intValue() -> Int
    {
        let allCases = type(of: self).allCases
        return allCases.firstIndex(of: self)!
    }
    
    func stringValue() -> String
    {
        return "\(intValue())"
    }
}

enum ShortcutScope{
    case app
    case camera
    case ocr
    case ink
}

enum ScrollMode : CaseIterable
{
    case page
    case line
    case word
    case image
    case imageLine
    case imageWord

    init(value : Int)
    {
        let allCases = type(of: self).allCases
        self = allCases[value]
    }
    
    func intValue() -> Int
    {
        let allCases = type(of: self).allCases
        return allCases.firstIndex(of: self)!
    }
    
    mutating func next() {
        let allCases = type(of: self).allCases
        self = allCases[(allCases.firstIndex(of: self)! + 1) % allCases.count]
    }
    
    mutating func previous() {
        let allCases = type(of: self).allCases
        self = allCases[(allCases.firstIndex(of: self)! + allCases.count - 1) % allCases.count]
    }
}

enum Actions : CaseIterable
{
    init(value : Int)
    {
        let allCases = type(of: self).allCases
        self = allCases[value]
    }
    
    func intValue() -> Int
    {
        let allCases = type(of: self).allCases
        return allCases.firstIndex(of: self)!
    }
    
    case switchToCameraView
    case switchToOCRView
    case switchToInkView
    case switchView
    case switchCamera
    case switchSplit
    case switchSources
    case switchBackAndFront

    case splitLeft
    case splitRight
    case ocr
    case ocrApppend
    case takePicture
    case record
    case takeInkPicture
    case playpause
    case stopSpeech
    
    case light
    case zoomIn
    case zoomOut
    case zoomStop
    
    case panLeft
    case panRight
    case panStop

    case tiltUp
    case tiltDown
    case tiltStop

    case startIncreaseContrast
    case startDecreaseContrast
    case stopContrast
    
    case nextNatural
    case nextPositive
    case previousPositive
    case nextNegative
    case previousNegative

    case nextArtificial
    case previousArtificial

    case rotateClockwise
    case rotateCounterClockwise

    case startRotateClockwise
    case startRotateCounterClockwise
    case stopRotate
    
    case redraw // for testing
    
    case reflineLeft
    case reflineRight
    case reflineStop

    case whole
    case mirror
    case decreaseFontSize
    case increaseFontSize
    case readNext
    case readPrevious
    case previousPage
    case nextPage
    case changeReadmode
    case changeScrollmode
    
    case openSettings
    
    case saveDocument
    case openDocument
    case hideSideMenu
    case hideMenu
    
    case setPresetOne
    case setPresetTwo
    case setPresetThree
    case setPresetFour
    case setPresetFive
    case setPresetSix

    case gotoPresetOne
    case gotoPresetTwo
    case gotoPresetThree
    case gotoPresetFour
    case gotoPresetFive
    case gotoPresetSix

    case setPen
    case setMarker
    case setText
    case erase
    case zoom
    case undo
    case redo
    case new
    case save
    case load
    case delete
    case panUp
    case panDown
    
    func name() -> String
    {
        switch(self)
        {
        case .zoomIn:
            return NSLocalizedString("ZoomIn", comment: "")
        case .zoomOut:
            return NSLocalizedString("ZoomOut", comment: "")
        case .nextNatural:
            return NSLocalizedString("NaturalColors", comment: "")
        case .nextPositive:
            return NSLocalizedString("NextPositive", comment: "")
        case .previousPositive:
            return NSLocalizedString("PreviousPositive", comment: "")
        case .nextNegative:
            return NSLocalizedString("NextNegative", comment: "")
        case .previousNegative:
            return NSLocalizedString("PreviousNegative", comment: "")
        case .startDecreaseContrast:
            return NSLocalizedString("ContrastDown", comment: "")
        case .startIncreaseContrast:
            return NSLocalizedString("ContrastUp", comment: "")
        case .switchView:
            return NSLocalizedString("SwitchView", comment: "")
        case .openSettings:
            return NSLocalizedString("EnterSettings", comment: "")
        case .hideMenu:
            return NSLocalizedString("HideMenu", comment: "")
        case .rotateClockwise:
            return NSLocalizedString("RotateClockwise", comment: "")
        case .rotateCounterClockwise:
            return NSLocalizedString("RotateCounterClockwise", comment: "")
        case .startRotateClockwise:
            return NSLocalizedString("RotateClockwiseContinous", comment: "")
        case .startRotateCounterClockwise:
            return NSLocalizedString("RotateCounterClockwiseContinous", comment: "")
        case .reflineLeft:
            return NSLocalizedString("ReferenceLineLeftUp", comment: "")
        case .reflineRight:
            return NSLocalizedString("ReferenceLineRightDown", comment: "")
        case .playpause:
            return NSLocalizedString("StartSpeech", comment: "")
        case .stopSpeech:
            return NSLocalizedString("StopSpeech", comment: "")
        case .changeScrollmode:
            return NSLocalizedString("ChangeScrollMode", comment: "")
        case .readPrevious:
            return NSLocalizedString("ReadPrevious", comment: "")
        case .readNext:
            return NSLocalizedString("ReadNext", comment: "")
        case .changeReadmode:
            return NSLocalizedString("ReadMode", comment: "")
        case .increaseFontSize:
            return NSLocalizedString("IncreaseFont", comment: "")
        case .decreaseFontSize:
            return NSLocalizedString("DecreaseFont", comment: "")
        case .mirror:
            return NSLocalizedString("Mirror", comment: "")
        case .switchCamera:
            return NSLocalizedString("SwitchCamera", comment: "")
        case .switchSources:
            return NSLocalizedString("SwitchSources", comment: "")
        case .switchSplit:
            return NSLocalizedString("SwitchSplit", comment: "")
        case .splitLeft:
            return NSLocalizedString("SplitLeft", comment: "")
        case .splitRight:
            return NSLocalizedString("SplitRight", comment: "")
        case .takePicture:
            return NSLocalizedString("TakePicture", comment: "")
        case .record:
            return NSLocalizedString("RecordVideo", comment: "")
        case .panLeft:
            return NSLocalizedString("PanLeft", comment: "")
        case .panRight:
            return NSLocalizedString("PanRight", comment: "")
        case .panUp:
            return NSLocalizedString("PanUp", comment: "")
        case .panDown:
            return NSLocalizedString("PanDown", comment: "")
        case .setPresetOne:
            return NSLocalizedString("SetPresetOne", comment: "")
        case .setPresetTwo:
            return NSLocalizedString("SetPresetTwo", comment: "")
        case .setPresetThree:
            return NSLocalizedString("SetPresetThree", comment: "")
        case .setPresetFour:
            return NSLocalizedString("SetPresetFour", comment: "")
        case .setPresetFive:
            return NSLocalizedString("SetPresetFive", comment: "")
        case .setPresetSix:
            return NSLocalizedString("SetPresetSix", comment: "")
        case .gotoPresetOne:
            return NSLocalizedString("GotoPresetOne", comment: "")
        case .gotoPresetTwo:
            return NSLocalizedString("GotoPresetTwo", comment: "")
        case .gotoPresetThree:
            return NSLocalizedString("GotoPresetThree", comment: "")
        case .gotoPresetFour:
            return NSLocalizedString("GotoPresetFour", comment: "")
        case .gotoPresetFive:
            return NSLocalizedString("GotoPresetFive", comment: "")
        case .gotoPresetSix:
            return NSLocalizedString("GotoPresetSix", comment: "")
        case .light:
            return NSLocalizedString("SetLight", comment: "")
        case .ocr:
            return NSLocalizedString("OCR", comment: "")
        case .takeInkPicture:
            return NSLocalizedString("TakeInkPicture", comment: "")
        case .setPen:
            return NSLocalizedString("SetPen", comment: "")
        case .setMarker:
            return NSLocalizedString("SetMarker", comment: "")
        case .setText:
            return NSLocalizedString("SetText", comment: "")
        case .erase:
            return NSLocalizedString("Eraser", comment: "")
        case .zoom:
            return NSLocalizedString("Zoom", comment: "")
        case .undo:
            return NSLocalizedString("Undo", comment: "")
        case .redo:
            return NSLocalizedString("Redo", comment: "")
        case .new:
            return NSLocalizedString("New", comment: "")
        case .save:
            return NSLocalizedString("Save", comment: "")
        case .load:
            return NSLocalizedString("Open", comment: "")
        case .delete:
            return NSLocalizedString("Delete", comment: "")

        default:
            return "DEFAULT"
        }
    }
}

enum PNDirection
{
    case increase
    case decrease
    case stop
}

enum ImageReason
{
    case none
    case ocr
    case ocrAppend
    case takePicture
    case takeInkPicture
}
