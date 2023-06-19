//
//  Preferences.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-06-19.
//

import Foundation
import AVFoundation

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
        
        UserDefaults.standard.register(defaults: defaults)
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
}
