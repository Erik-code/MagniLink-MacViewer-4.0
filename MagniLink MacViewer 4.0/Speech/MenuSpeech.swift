//
//  MenuSpeech.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-10-30.
//

import AVFoundation

class MenuSpeech: NSObject
{
    var synthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
    
    private var mBundle : Bundle?
    static let shared = MenuSpeech()
    private var mLastLanguage = ""
    
    private override init() {
        super.init()
        setLanguage(language: "sv")
    }
    
    func speak(text : String)
    {
        let utterance:AVSpeechUtterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(identifier: Preferences.shared.voice)
        
        synthesizer.speak(utterance)
    }
    
    private func setLanguage(language : String)
    {
        if let path = Bundle.main.path(forResource: language, ofType: "lproj")
        {
            mBundle = Bundle.init(path: path)
            mLastLanguage = language
        }
    }
    
    func getLocalizedStringForKey(key : String) -> String
    {
        let lang = AVSpeechSynthesisVoice(identifier: Preferences.shared.voice)?.language.substring(to: 2)
        if lang != mLastLanguage
        {
            setLanguage(language: lang!)
        }
        if let str = mBundle?.localizedString(forKey: key, value: nil, table: nil)
        {
            return str;
        }
        return "NOT LOCALIZED"
    }
}
