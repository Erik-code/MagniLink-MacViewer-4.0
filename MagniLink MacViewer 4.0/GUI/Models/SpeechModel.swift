//
//  SpeechModel.swift
//  MagniLink Viewer
//
//  Created by Erik Sandstrom on 2022-09-27.
//

import Foundation
import Cocoa
import AVFoundation

func flag(country:String) -> String {
    let base : UInt32 = 127397
    var s = ""
    let start = country.index(country.endIndex, offsetBy: -2)

    var newStr = country[start...]
    if country == "ar-001" { //Special case for Modern Standard Arabic
        newStr = "SA"
    }
    
    for v in newStr.unicodeScalars {
        s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
    }
    return String(s)
}

func languageDescription(language : String) -> String
{
    return Locale.current.localizedString(forLanguageCode: language)!
}

class SpeechModel: ObservableObject
{
    static let voices : [AVSpeechSynthesisVoice] =
    {
        //let languages = NSTextChecker.availableLanguages
        let ignores = ["el_GR", "ru_RU"]
        
        let allVoices = AVSpeechSynthesisVoice.speechVoices()
        for voice in allVoices {
            print(voice.description)
        }
        
        let filteredVoices = allVoices.filter { voice in
            
            let language = voice.language.replacingOccurrences(of: "-", with: "_")
            
            let id = SpeechModel.voiceType(id: voice.identifier)
            
            let ok = ["C","S","H","P"].contains(id)
            
            return !ignores.contains(language) && ok
        }
        
        return filteredVoices
    }()
    
    @Published var volume : Double
    @Published var speechrate : Double
    @Published var startSpeech : Bool
    @Published var columnMode : Bool
    @Published var font : String
    //@Published var fonts = NSFont.familyNames.flatMap { NSFont.fontNames(forFamilyName:$0) }
    //@Published var voicesModel : ModalModel
    
//    static var voicesArray:[ModalItem]
//    {
//        voices.map { voice in
//            ModalItem(display: "\(flag(country: voice.language)) \(voice.name) \(languageDescription(language: voice.language))", id: voice.identifier)
//        }
//    }
    
    static func voiceType(id : String) -> String {
        
        var index = id.lastIndex(of: ".")
        var substr = String(id.substring(to: index!))
        index = substr.lastIndex(of: ".")
        substr = String(substr.substring(to: index!))
        
        if substr == "com.apple.voice.compact" {
            return "C"
        }
        else if substr == "com.apple.eloquence" {
            return "E"
        }
        else if substr == "com.apple" {
            return "S"
        }
        else if substr == "com.apple.speech.synthesis" {
            return "A"
        }
        else if substr == "com.apple.voice.enhanced" {
            return "H"
        }
        else if substr == "com.apple.voice.premium" {
            return "P"
        }

        return ""
    }
    
//    static func voiceFromId(id : String) -> ModalItem
//    {
//        var v = AVSpeechSynthesisVoice(identifier: id)
//        if v == nil {
//            let id2 = Preferences.shared.getDefaultVoice()
//            v = AVSpeechSynthesisVoice(identifier: id2)
//        }
//
//        if let voice = v {
//            return ModalItem(display: "\(flag(country: voice.language)) \(voice.name) \(languageDescription(language: voice.language))", id: id)
//        }
//        return ModalItem(display: "", id: "")
//
//    }
    
    init()
    {
        self.volume = Preferences.shared.volume
        self.speechrate = Preferences.shared.speechrate
        self.startSpeech = Preferences.shared.startSpeech
        self.columnMode = Preferences.shared.columnMode
        self.font = Preferences.shared.font
        
//        let languages = UITextChecker.availableLanguages
//        let ignores = ["el_GR", "ru_RU"]
//
//        let voices = AVSpeechSynthesisVoice.speechVoices()
//
//        var types = [String]()
//        var example = [String]()
        
//        for v in voices {
//
//            print("VO \(v.identifier)")
//
//            var index = v.identifier.lastIndex(of: ".")
//            var substr = String(v.identifier.substring(to: index!))
//            index = substr.lastIndex(of: ".")
//            substr = String(substr.substring(to: index!))
//
//            if types.contains(substr) == false {
//                types.append(String(substr))
//                example.append(v.identifier)
//            }
//        }
        
//        for t in types {
//            print("type \(t)")
//        }
//        for e in example {
//            print("example \(e)")
//        }
//
//        let voices2 = voices.filter { voice in
//
//            let language = voice.language.replacingOccurrences(of: "-", with: "_")
//
//            let id = SpeechModel.voiceId(id: voice.identifier)
//
//            let ok = ["C","S","P"].contains(id)
//
//            return languages.contains(language) && !ignores.contains(language) && ok
//        }
        
        //SpeechModel.voices = voices2
//        let array = SpeechModel.voicesArray
//        let voice = Preferences.shared.voice
//        let selected = SpeechModel.voiceFromId(id: voice)
//        self.voicesModel = ModalModel(items: array, selectedItem: selected)
    }
        
    func standard()
    {
        self.volume = 0.8
        self.speechrate = 0.5
        self.startSpeech = true
        self.columnMode = true
        self.font = Preferences.shared.defaultFont
        let id = Preferences.shared.getDefaultVoice()
        //self.voicesModel.selectedItem = SpeechModel.voiceFromId(id: id)
        
        Preferences.shared.volume = self.volume
        Preferences.shared.speechrate = self.speechrate
        Preferences.shared.startSpeech = self.startSpeech
        Preferences.shared.columnMode = self.startSpeech
        Preferences.shared.font = self.font
        Preferences.shared.voice = id
    }
}
