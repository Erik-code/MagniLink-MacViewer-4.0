//
//  Preferences.swift
//  MagniLink iOSViewer
//
//  Created by Erik Sandstrom on 2022-02-03.
//

import Foundation
import AVFoundation
import Cocoa

@objcMembers class Preferences: NSObject
{
    enum Key: String, CaseIterable {
        case name, avatarData
        func make(for userID: String) -> String {
            return self.rawValue + "_" + userID
        }
    }
    
    static let shared = Preferences()
    
    let userDefaults: UserDefaults
    // MARK: - Lifecycle
    private init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        super.init()
        self.initialize()
    }
    
    private let strSplitPrimarySecondaryVertical = "splitPrimarySecondaryVertical"
    private let strSplitPrimarySecondaryHorizontal = "splitPrimarySecondaryHorizontal"
    private let strSplitSecondaryPrimaryVertical = "splitSecondaryPrimaryVertical"
    private let strSplitSecondaryPrimaryHorizontal = "splitSecondaryPrimaryHorizontal"
    private let strFrontOrBack = "frontOrBack"
    private let strActiveCamera = "activeCamera"
    private let strActivecameras = "activeCameras"
    private let strSplitMode = "splitMode"
    private let strNetwork = "network"
    private let strColorIndices = "colorIndices"
    private let strPnLevels = "pnLevels"
    private let strBrightness = "brightness"
    private let strRotations = "rotations"
    private let strMirrors = "mirrors"
    private let strSplitModes = "splitModes"
    private let strVideos = "videos"
    private let strReflines = "reflines"
    private let strScrollMode = "scrollMode"
    private let strFontSizePage = "fontSizePage"
    private let strFontSizeLine = "fontSizeLine"
    private let strFontSizeWord = "fontSizeWord"
    private let strFontSizeImageLine = "fontSizeImageLine"
    private let strFontSizeImageWord = "fontSizeImageWord"
    private let strVoice = "voice"
    private let strVolume = "volume"
    private let strSpeechrate = "speechrate"
    private let strStartSpeech = "startspeech"
    private let strColumnMode = "columnmode"
    private let strFont = "font"
    private let strArtificialColors = "artificialColors"
    private let strColorManagers = "colormanagers"
    private let strFrontCamera = "frontcamera"
    private let strBackCamera = "backcamera"
    private let strAngleCorrection = "anglecorrection"
    private let strLimitRecording = "limitrecording"
    private let strRecordingLength = "recordinglength"
    private let strRecordAudio = "recordAudio"
    private let strCameraGestures = "cameragestures"
    private let strOcrGestures = "ocrgestures"
    private let strLight = "light"
    private let strTurnOffPi = "turnoffpi"
    private let strPremiumPurchased = "premiumpurchased"
    private let strSplitrate = "splitrate"
    private let strPiBitrate = "pibitrate"
    private let strWhole = "whole"
    private let strCameraMenuHidden = "cameraMenuHidden"
    private let strOcrMenuHidden = "ocrMenuHidden"
    private let strPresets = "presets"
    private let strShortcuts = "shortcuts"
    private let strPenColor = "penColor"
    private let strPenWidth = "penWidth"
    private let strMarkerColor = "markerColor"
    private let strMarkerWidth = "markerWidth"
    private let strFontColor = "fontColor"
    private let strFontSize = "fontSize"
    private let strInkTool = "inkTool"
    private let strWiFiPasswords = "wifipass"

    func initialize()
    {
        var defaults : [String : Any] = [:]
        defaults[strSplitPrimarySecondaryVertical] = 0.5
        defaults[strSplitPrimarySecondaryHorizontal] = 0.5
        defaults[strSplitSecondaryPrimaryVertical] = 0.5
        defaults[strSplitSecondaryPrimaryHorizontal] = 0.5

        defaults[strActiveCamera] = 0
        defaults[strSplitMode] = 0

        defaults[strScrollMode] = 0
        defaults[strFontSizePage] = 64.0
        defaults[strFontSizeLine] = 96.0
        defaults[strFontSizeWord] = 104.0
        defaults[strFontSizeImageLine] = 96.0
        defaults[strFontSizeImageWord] = 104.0
        
        defaults[strVoice] = getDefaultVoice()
        defaults[strVolume] = 0.8
        defaults[strSpeechrate] = 0.5
        defaults[strStartSpeech] = true
        defaults[strColumnMode] = true
        defaults[strFont] = "Avenir Roman"
        defaults[strLight] = 0
        defaults[strTurnOffPi] = false
        let bitrate : Int = 2800000
        defaults[strPiBitrate] = bitrate
        
        defaults[strSplitrate] = 0.20
        defaults[strFrontCamera] = true
        defaults[strBackCamera] = true
        defaults[strAngleCorrection] = true

        defaults[strLimitRecording] = false
        defaults[strRecordingLength] = 10
        defaults[strRecordAudio] = true

        defaults[strCameraGestures] = 0x1FFF
        defaults[strOcrGestures] = 0xFFFF

        defaults[strPremiumPurchased] = false
        defaults[strCameraMenuHidden] = false
        defaults[strOcrMenuHidden] = false
        
        defaults[strPenColor] = 4
        defaults[strPenWidth] = 10.0
        
        defaults[strMarkerColor] = 6
        defaults[strMarkerWidth] = 20.0
        
        defaults[strFontColor] = 0
        defaults[strFontSize] = 48.0
        defaults[strInkTool] = 1
        
        UserDefaults.standard.register(defaults: defaults)
    }
    
    let defaultVoices: [String: [String]] = ["en-US": ["com.apple.voice.enhanced.en-US.Samantha", "com.apple.voice.compact.en-US.Samantha"]]
    
    func getDefaultVoice() -> String
    {
        guard let prefered = Locale.preferredLanguages.first else {
            return SpeechModel.voices.first?.description ?? ""
        }
        
        var lang = prefered
        if prefered == "en-CA" {
            lang = "en-US"
        }
        
        if let voice = defaultVoices[lang]{
            
            let firstVoice = AVSpeechSynthesisVoice(identifier: voice.first!)
            let lastVoice = AVSpeechSynthesisVoice(identifier: voice.last!)

            if let fv = firstVoice, SpeechModel.voices.contains(fv){
                return voice.first!
            }
            else if let lv = lastVoice, SpeechModel.voices.contains(lv){
                return voice.last!
            }
        }
        
        if let first = SpeechModel.voices.first(where: { v in
            return v.language == prefered
        }) {
            return first.identifier
        }
        
        if let first = SpeechModel.voices.first(where: { v in
            return v.language.substring(to: 2) == prefered.substring(to: 2)
        }) {
            return first.identifier
        }
        
        return SpeechModel.voices.first?.description ?? ""
    }
         
    var splitPrimarySecondaryVertical : Double
    {
        get{
            let d = userDefaults.double(forKey: strSplitPrimarySecondaryVertical)
            return d;
        }
        set (newValue){
            userDefaults.set(newValue, forKey: strSplitPrimarySecondaryVertical)
        }
    }
    
    var splitPrimarySecondaryHorizontal : Double
    {
        get{
            let d = userDefaults.double(forKey: strSplitPrimarySecondaryHorizontal)
            return d;
        }
        set (newValue){
            userDefaults.set(newValue, forKey: strSplitPrimarySecondaryHorizontal)
        }
    }
    
    var splitSecondaryPrimaryVertical : Double
    {
        get{
            let d = userDefaults.double(forKey: strSplitSecondaryPrimaryVertical)
            return d;
        }
        set (newValue){
            userDefaults.set(newValue, forKey: strSplitSecondaryPrimaryVertical)
        }
    }
    
    var splitSecondaryPrimaryHorizontal : Double
    {
        get{
            let d = userDefaults.double(forKey: strSplitSecondaryPrimaryHorizontal)
            return d;
        }
        set (newValue){
            userDefaults.set(newValue, forKey: strSplitSecondaryPrimaryHorizontal)
        }
    }
    
    var frontOrBack : Bool {
        get{
            let d = userDefaults.bool(forKey: strFrontOrBack)
            return d;
        }
        set (newValue){
            userDefaults.set(newValue, forKey: strFrontOrBack)
        }
    }
        
    var activeCamera : Int {
        get{
            let d = userDefaults.integer(forKey: strActiveCamera)
            return d;
        }
        set (newValue){
            userDefaults.set(newValue, forKey: strActiveCamera)
        }
    }
    
    func idFromVideoControllers(videoControllers : [CameraBaseViewController]) -> String
    {
        var sid = ""
        for videoController in videoControllers {
            sid += videoController.Id.stringValue()
        }
        return sid
    }
    
    func setSplitMode(videoControllers : [CameraBaseViewController] , split : SplitTwo)
    {
        let sid = idFromVideoControllers(videoControllers: videoControllers)
        
        var sd = splitModes
        var ad = activeCameras
        var vd = videos
        sd[sid] = split.split.intValue()
        ad[sid] = split.active
        vd[sid] = split.videos
        splitModes = sd
        activeCameras = ad
        videos = vd
    }
    
    func getSplitMode(videoControllers : [CameraBaseViewController]) -> SplitTwo
    {
        let sid = idFromVideoControllers(videoControllers: videoControllers)

        let sd = splitModes
        let ad = activeCameras
        let vd = videos

        if sd[sid] != nil && ad[sid] != nil && vd[sid] != nil
        {
            var split = SplitTwo()
            split.active = ad[sid]!
            split.split = Split(value: sd[sid]!)
            split.videos = vd[sid]!
            if videoControllers.count <= 2 && split.videos.count != videoControllers.count {
                split.videos.removeAll()
                for i in 0..<videoControllers.count {
                    split.videos.append(i)
                }
            }
            else if videoControllers.count >= 3 && split.videos.count < 2 {
                split.videos.removeAll()
                for i in 0..<videoControllers.count {
                    split.videos.append(i)
                }
            }
            
            return split
        }
        else {
            var split = SplitTwo()
            split.split = .left
            for i in 0..<videoControllers.count {
                split.videos.append(i)
            }
            return split
        }
    }
    
    var activeCameras : Dictionary<String,Int> {
        get{
            guard let d = userDefaults.dictionary(forKey: strActivecameras) as? Dictionary<String,Int> else { return Dictionary<String,Int>() }
            return d;
        }
        set (newValue){
            userDefaults.set(newValue, forKey: strActivecameras)
        }
    }
    
    var splitModes : Dictionary<String, Int>
    {
        get{
            guard let d = userDefaults.dictionary(forKey: strSplitModes) as? Dictionary<String,Int> else { return Dictionary<String,Int>() }
            return d
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strSplitModes)
        }
    }
    
    var videos : Dictionary<String, Array<Int>>
    {
        get{
            guard let d = userDefaults.dictionary(forKey: strVideos) as? Dictionary<String,Array<Int>> else { return Dictionary<String,Array<Int>>() }
            return d
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strVideos)
        }
    }
    
    var splitMode : Split
    {
        get{
            let d = userDefaults.integer(forKey: strSplitMode)
            return Split(value: d)
        }
        set (newValue)
        {
            let d = newValue.intValue()
            userDefaults.set(d, forKey: strSplitMode)
        }
    }
    
    var network : String
    {
        get{
            let d = userDefaults.string(forKey: strNetwork)
            return d ?? "";
        }
        set (newValue){
            userDefaults.set(newValue, forKey: strNetwork)
        }
    }
    
    var colorIndices : Dictionary<String, Int>
    {
        get{
            guard let d = userDefaults.dictionary(forKey:strColorIndices) as? Dictionary<String,Int>  else { return Dictionary<String,Int>() }
            return d;
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strColorIndices)
        }
    }

    var pnLevels : Dictionary<String, Double>
    {
        get{
            guard let d = userDefaults.dictionary(forKey:strPnLevels) as? Dictionary<String,Double>  else { return Dictionary<String,Double>() }
            return d;
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strPnLevels)
        }
    }

    var brightness : Dictionary<String, Double>
    {
        get{
            guard let d = userDefaults.dictionary(forKey:strBrightness) as? Dictionary<String,Double>  else { return Dictionary<String,Double>() }
            return d;
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strBrightness)
        }
    }
    
    var rotations : Dictionary<String, Float>
    {
        get{
            guard let d = userDefaults.dictionary(forKey:strRotations) as? Dictionary<String,Float>  else { return Dictionary<String,Float>() }
            return d;
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strRotations)
        }
    }
    
    var mirrors : Dictionary<String, Bool>
    {
        get{
            guard let d = userDefaults.dictionary(forKey:strMirrors) as? Dictionary<String,Bool>  else { return Dictionary<String,Bool>() }
            return d;
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strMirrors)
        }
    }
    
    var whole : Dictionary<String, Bool>
    {
        get{
            guard let d = userDefaults.dictionary(forKey:strWhole) as? Dictionary<String,Bool>  else { return Dictionary<String,Bool>() }
            return d;
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strWhole)
        }
    }
    
    var refLines : Dictionary<String, Int>
    {
        get{
            guard let d = userDefaults.dictionary(forKey:strReflines) as? Dictionary<String,Int>  else { return Dictionary<String,Int>() }
            return d;
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strReflines)
        }
    }
    
    var scrollMode : ScrollMode
    {
        get
        {
            let d = userDefaults.integer(forKey:strScrollMode)
            return ScrollMode(value: d);
        }
        set (newValue)
        {
            let d : Int = newValue.intValue()
            userDefaults.set(d, forKey: strScrollMode)
        }
    }
    
    
    
//    var turnOffPi : Bool
//    {
//        get
//        {
//            let d = userDefaults.bool(forKey:strTurnOffPi)
//            return d
//        }
//        set (newValue)
//        {
//            userDefaults.set(newValue, forKey: strTurnOffPi)
//        }
//    }
    
    var piBitrate : Int
    {
        get
        {
            let d = userDefaults.integer(forKey:strPiBitrate)
            return d
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strPiBitrate)
        }
    }
    
    var splitrate : Double
    {
        get
        {
            let d = userDefaults.double(forKey:strSplitrate)
            return d
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strSplitrate)
        }
    }
    
    let minFontSize : Double = 48
    let maxFontSize :Double = 280
    var fontSizePage : Double
    {
        get
        {
            let d = userDefaults.double(forKey: strFontSizePage)
            return d
        }
        set (newValue)
        {
            var val = newValue < minFontSize ? minFontSize : newValue
            val = val > maxFontSize ? maxFontSize : val
            userDefaults.set(val, forKey: strFontSizePage)
        }
    }
    
    var fontSizeLine : Double
    {
        get
        {
            let d = userDefaults.double(forKey: strFontSizeLine)
            return d
        }
        set (newValue)
        {
            var val = newValue < minFontSize ? minFontSize: newValue
            val = val > maxFontSize ? maxFontSize: val
            userDefaults.set(val, forKey: strFontSizeLine)
        }
    }
    
    var fontSizeWord : Double
    {
        get
        {
            let d = userDefaults.double(forKey: strFontSizeWord)
            return d
        }
        set (newValue)
        {
            var val = newValue < minFontSize ? minFontSize: newValue
            val = val > maxFontSize ? maxFontSize: val
            userDefaults.set(val, forKey: strFontSizeWord)
        }
    }
   
    var fontSizeImageLine : Double
    {
        get
        {
            let d = userDefaults.double(forKey: strFontSizeImageLine)
            return d
        }
        set (newValue)
        {
            var val = newValue < minFontSize ? minFontSize: newValue
            val = val > maxFontSize ? maxFontSize: val
            userDefaults.set(val, forKey: strFontSizeImageLine)
        }
    }
        
    var fontSizeImageWord : Double
    {
        get
        {
            let d = userDefaults.double(forKey: strFontSizeImageWord)
            return d
        }
        set (newValue)
        {
            var val = newValue < minFontSize ? minFontSize: newValue
            val = val > maxFontSize ? maxFontSize: val
            userDefaults.set(val, forKey: strFontSizeImageWord)
        }
    }
    
    var voice : String
    {
        get
        {
            let d = userDefaults.string(forKey: strVoice) ?? ""
            return d
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strVoice)
        }
    }
    
    var volume : Double
    {
        get
        {
            let d = userDefaults.double(forKey: strVolume)
            return d
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strVolume)
        }
    }
    
    var speechrate : Double
    {
        get
        {
            let d = userDefaults.double(forKey: strSpeechrate)
            return d
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strSpeechrate)
        }
    }
    
    var startSpeech : Bool
    {
        get
        {
            let d = userDefaults.bool(forKey: strStartSpeech)
            return d
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strStartSpeech)
        }
    }
    
    var columnMode : Bool
    {
        get
        {
            let d = userDefaults.bool(forKey: strColumnMode)
            return d
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strColumnMode)
        }
    }
    
    var defaultFont = "Avenir Roman"
    @objc dynamic var font : String
    {
        get
        {
            if let d = userDefaults.string(forKey: strFont) {
                return d
            }
            else {
                return "Avenir Roman"
            }
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strFont)
        }
    }
    
    var artificialColors : Dictionary<String, Array<Int>>
    {
        get
        {
            guard let d = userDefaults.dictionary(forKey: strArtificialColors) as? Dictionary<String,[Int]> else { return Dictionary<String,[Int]>() }
            return d;
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strArtificialColors)
        }
    }
    
    var colorManagers : Dictionary<String, Int>
    {
        get
        {
            guard let d = userDefaults.dictionary(forKey: strColorManagers) as? Dictionary<String,Int> else { return Dictionary<String,Int>() }
            return d;
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strColorManagers)
        }
    }
    
    var frontCamera : Bool
    {
        get
        {
            let d = userDefaults.bool(forKey: strFrontCamera)
            return d;
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strFrontCamera)
        }
    }
    
    var backCamera : Bool
    {
        get
        {
            let d = userDefaults.bool(forKey: strBackCamera)
            return d;
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strBackCamera)
        }
    }
    
    @objc dynamic var angleCorrection : Bool
    {
        get
        {
            let d = userDefaults.bool(forKey: strAngleCorrection)
            return d;
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strAngleCorrection)
        }
    }
        
    var limitRecording : Bool
    {
        get
        {
            let d = userDefaults.bool(forKey: strLimitRecording)
            return d;
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strLimitRecording)
        }
    }
    
    var recordingLength : Int
    {
        get
        {
            let d = userDefaults.integer(forKey: strRecordingLength)
            return d;
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strRecordingLength)
        }
    }
    
    var recordAudio : Bool
    {
        get
        {
            let d = userDefaults.bool(forKey: strRecordAudio)
            return d;
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strRecordAudio)
        }
    }
    
    @objc dynamic var cameraGestures : Int
    {
        get
        {
            let d = userDefaults.integer(forKey: strCameraGestures)
            return d;
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strCameraGestures)
        }
    }
    
    @objc dynamic var ocrGestures : Int
    {
        get
        {
            let d = userDefaults.integer(forKey: strOcrGestures)
            return d;
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strOcrGestures)
        }
    }
    
    var cameraMenuHidden : Bool
    {
        get
        {
            let d = userDefaults.bool(forKey: strCameraMenuHidden)
            return d;
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strCameraMenuHidden)
        }
    }
    
    var ocrMenuHidden : Bool
    {
        get
        {
            let d = userDefaults.bool(forKey: strOcrMenuHidden)
            return d;
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strOcrMenuHidden)
        }
    }
    
    var premiumPurchased : Bool
    {
        get
        {
            let d = userDefaults.bool(forKey: strPremiumPurchased)
            return d;
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strPremiumPurchased)
        }
    }
    
    var shortcuts : Dictionary<Actions, KeyCombo>
    {
        get
        {
            if let dict = userDefaults.dictionary(forKey: strShortcuts) as? [String : String]
            {
                var result = [Actions: KeyCombo]()
                for kvp in dict {
                    let action = (Actions(value: Int(kvp.key)!))
                    let combo = KeyCombo(string: kvp.value)
                    result[action] = combo
                }
                return result
            }
            else{
                return [Actions : KeyCombo]()
            }
        }
        set
        {
            var dict = [String : String]()
            for kvp in newValue {
                let i = "\(kvp.key.intValue())"
                let s = kvp.value.toString()
                dict[i] = s
            }
            
            userDefaults.set(dict, forKey: strShortcuts)
        }
    }
    
    var presets : Dictionary<String, [Preset]>
    {
        get
        {
            if let dict = userDefaults.dictionary(forKey: strPresets) {

                var result = Dictionary<String, [Preset]>()

                for kvp in dict {
                    let array = kvp.value as! [Any]
                    var pres = [Preset]()
                    
                    if array.count == 7,
                       let rotations = array[0] as? [Float],
                       let mirrors = array[1] as? [Bool],
                       let refPos = array[2] as? [Int],
                       let refTypes = array[3] as? [Int],
                       let refOnOf = array[4] as? [Bool],
                       let colors = array[5] as? [Int],
                       let brightness = array[6] as? [Float]
                    {
                        for i in 0..<rotations.count {
                            var pre = Preset()
                            pre.rotation = rotations[i]
                            pre.mirror = mirrors[i]
                            pre.refline.position = refPos[i]
                            pre.refline.onOrOff = refOnOf[i]
                            pre.refline.type = ReflineType(value: refTypes[i])
                            pre.color = ColorManager(aValue: colors[i])
                            pre.brightness = brightness[i]
                            pres.append(pre)
                        }
                        
                        result[kvp.key] = pres
                    }
                }
                
                return result
            }
            else {
                return Dictionary<String, [Preset]>()
            }
        }
        set (newValue)
        {
            var dict = Dictionary<String, [Any] >()
            
            for kvp in newValue {
            
                var result = [Any]()
                var rotations = [Float]()
                var mirrors = [Bool]()
                var refPos = [Int]()
                var refTypes = [Int]()
                var refOnOff = [Bool]()
                var colors = [Int]()
                var brightness = [Float]()

                for pre in kvp.value {
                    rotations.append(pre.rotation)
                    mirrors.append(pre.mirror)
                    refPos.append(pre.refline.position)
                    refTypes.append(pre.refline.type.intValue())
                    refOnOff.append(pre.refline.onOrOff)
                    
                    colors.append(pre.color.intValue)
                    brightness.append(pre.brightness)
                }
                result.append(rotations)
                result.append(mirrors)
                result.append(refPos)
                result.append(refTypes)
                result.append(refOnOff)
                result.append(colors)
                result.append(brightness)
                
                dict[kvp.key] = result
            }
            
            userDefaults.set(dict, forKey: strPresets)
        }
    }
    
    var penColor : Int
    {
        get
        {
            let d = userDefaults.integer(forKey: strPenColor)
            return d
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strPenColor)
        }
    }
    
    var penWidth : CGFloat
    {
        get
        {
            let d = userDefaults.float(forKey: strPenWidth)
            return CGFloat(d)
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strPenWidth)
        }
    }
    
    var markerColor : Int
    {
        get
        {
            let d = userDefaults.integer(forKey: strMarkerColor)
            return d
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strMarkerColor)
        }
    }
    
    var markerWidth : CGFloat
    {
        get
        {
            let d = userDefaults.float(forKey: strMarkerWidth)
            return CGFloat(d)
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strMarkerWidth)
        }
    }
    
    var fontColor : Int
    {
        get
        {
            let d = userDefaults.integer(forKey: strFontColor)
            return d
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strFontColor)
        }
    }
    
    var fontSize : CGFloat
    {
        get
        {
            let d = userDefaults.float(forKey: strFontSize)
            return CGFloat(d)
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strFontSize)
        }
    }
    
    var inkTool : DrawMode
    {
        get
        {
            let d = userDefaults.integer(forKey: strInkTool)
            return DrawMode(value: d)
        }
        set (newValue)
        {
            userDefaults.set(newValue.intValue(), forKey: strInkTool)
        }
    }
    
    var wifiPasswords : Dictionary<String, String>
    {
        get
        {
            if let d = userDefaults.dictionary(forKey: strWiFiPasswords) as? Dictionary<String,String> {
                return d
            }
            return Dictionary<String,String>()
        }
        set (newValue)
        {
            userDefaults.set(newValue, forKey: strWiFiPasswords)
        }
    }
    
    // MARK: - API
    func storeBool(forUserID userID: String, forValue value: Bool)
    {
        let i = true == value ? "1" : "0"
        
        let data = i.data(using: .utf8)
        
        storeInfo(forUserID: userID, name: i , avatarData: data!)
    }
    
    func getBool(forUserID userID: String) -> Bool
    {
        let ui = getUserInfo(forUserID: userID)
        if ui.avatarData != nil
        {
            let str = String(data: ui.avatarData!, encoding: .utf8)
            return str == "1"
        }
        return false;
    }
    
    func storeInfo(forUserID userID: String, name: String, avatarData: Data) {
        saveValue(forKey: .name, value: name, userID: userID)
        saveValue(forKey: .avatarData, value: avatarData, userID: userID)
    }
    
    func getUserInfo(forUserID userID: String) -> (name: String?, avatarData: Data?) {
        let name: String? = readValue(forKey: .name, userID: userID)
        let avatarData: Data? = readValue(forKey: .avatarData, userID: userID)
        return (name, avatarData)
    }
    
    func removeUserInfo(forUserID userID: String) {
        Key
            .allCases
            .map { $0.make(for: userID) }
            .forEach { key in
                userDefaults.removeObject(forKey: key)
        }
    }
    // MARK: - Private
    private func saveValue(forKey key: Key, value: Any, userID: String) {
        userDefaults.set(value, forKey: key.make(for: userID))
    }
    private func readValue<T>(forKey key: Key, userID: String) -> T? {
        return userDefaults.value(forKey: key.make(for: userID)) as? T
    }
}
