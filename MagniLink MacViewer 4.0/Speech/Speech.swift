//
//  Speech.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-10-30.
//

import Foundation
import AVFoundation

enum SpeechMode : CaseIterable
{
    case spell
    case word
    case sentence
    case block

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

protocol SpeechDelegate: AnyObject {
    func changeSelection(_ pos: Int,_ length : Int)
    func playPauseChanged(aIsPlaying : Bool)
}

class Speech: NSObject, AVSpeechSynthesizerDelegate
{
    private var synthesizer:AVSpeechSynthesizer = AVSpeechSynthesizer()
    weak var delegate: SpeechDelegate?
    private var mText : String = ""
    private var mOffset = 0
    var mPosition = 0
    private var mUseDelegate = false
    private var mSpeechMode : SpeechMode = .word
    //private var mPage : OCRPage?
    
    func create(/*_ ocrPage :OCRPage*/){
        
        //mPage = ocrPage
        mUseDelegate = true
        
        synthesizer.delegate = self
        synthesizer.stopSpeaking(at: .immediate)

        mPosition = 0
        mOffset = 0
        //mText = ocrPage.getText()
    }
    
    func clear()
    {
        synthesizer.stopSpeaking(at: .immediate)
        mPosition = 0
        mOffset = 0
        //mPage = nil
        mText = "";
    }
    
    func createSpeechUtterance(text: String) -> AVSpeechUtterance
    {
        let utterance:AVSpeechUtterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(identifier: Preferences.shared.voice)
        utterance.volume = Float(Preferences.shared.volume)
        utterance.rate = Float(Preferences.shared.speechrate)
                
        return utterance
    }
    
    func playpause()
    {
        if(synthesizer.isSpeaking == false){
            mOffset = mPosition
            if let substring = mText.substring(with: Range(NSMakeRange(mPosition, mText.count - mPosition))!)
            {
                speak(text: substring)
                delegate?.playPauseChanged(aIsPlaying: true)
            }
        }
        else {
            synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            delegate?.playPauseChanged(aIsPlaying: false)
        }
    }
    
    func play()
    {
        if(synthesizer.isSpeaking == false){
            mOffset = mPosition
            if let substring = mText.substring(with: Range(NSMakeRange(mPosition, mText.count - mPosition))!)
            {
                speak(text: substring)
                delegate?.playPauseChanged(aIsPlaying: true)
            }
        }
    }
    
    func pause()
    {
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        delegate?.playPauseChanged(aIsPlaying: false)
    }
    
    func speechInProgress() -> Bool
    {
        return synthesizer.isSpeaking
    }
    
    func readFrom(position : Int)
    {
        mPosition = position
        mOffset = position
        
        if let substring = mText.substring(with: Range(NSMakeRange(mPosition, mText.count - mPosition))!)
        {
            speak(text: substring)
            delegate?.playPauseChanged(aIsPlaying: true)
        }
    }
    
    func changeSpeechMode() -> SpeechMode
    {
        mSpeechMode.next()
        return mSpeechMode
    }
    
    func next()
    {
        switch mSpeechMode {
        case .block:
            nextBlock()
        case .sentence:
            nextSentence()
        case .word:
            nextWord()
        case .spell:
            nextCharacter()
        }
    }
    
    func previous()
    {
        switch mSpeechMode {
        case .block:
            previousBlock()
        case .sentence:
            previousSentence()
        case .word:
            previousWord()
        case .spell:
            previousCharacter()
        }
    }
    
    func nextCharacter()
    {
        mUseDelegate = false
        if mPosition < mText.count - 1
        {
            mPosition += 1
        }
        
        if let substring = mText.substring(with: Range(NSMakeRange(mPosition, 1))!)
        {
            synthesizer.stopSpeaking(at: .immediate)
            
            let utterance = createSpeechUtterance(text: substring)
            
            delegate?.changeSelection(mPosition, 1)
            
            synthesizer.speak(utterance)
        }
    }
    
    func previousCharacter()
    {
        mUseDelegate = false

        if mPosition > 0
        {
            mPosition -= 1
        }
        
        if let substring = mText.substring(with: Range(NSMakeRange(mPosition, 1))!)
        {
            synthesizer.stopSpeaking(at: .immediate)
            
            let utterance = createSpeechUtterance(text: substring)
            
            delegate?.changeSelection(mPosition, 1)
            synthesizer.speak(utterance)
        }
    }
    
    func nextWord()
    {
        mUseDelegate = true

        var temp = mPosition
        
        while temp < mText.count && mText[mText.index(from: temp)].isWhitespace == false
        {
            temp += 1
        }
        while temp < mText.count && mText[mText.index(from: temp)].isWhitespace == true
        {
            temp += 1
        }
        if temp == mText.count
        {
            temp = mPosition
            mOffset = temp
            
            if let substring = mText.substring(with: Range(NSMakeRange(mPosition, mText.count - mPosition))!)
            {
                synthesizer.stopSpeaking(at: .immediate)
                let utterance = createSpeechUtterance(text: substring)
                synthesizer.speak(utterance)
            }
        }
        else
        {
            mOffset = temp
            while temp < mText.count && mText[mText.index(from: temp)].isWhitespace == false {
                temp += 1
            }
            
            if let substring = mText.substring(with: Range(NSMakeRange(mOffset, temp - mOffset))!)
            {
                synthesizer.stopSpeaking(at: .immediate)
                
                let utterance = createSpeechUtterance(text: substring)
                
                synthesizer.speak(utterance)
                mPosition = mOffset
            }
        }
    }
    
    func previousWord()
    {
        mUseDelegate = true

        if mPosition == 0
        {
            mOffset = 0
            var length = 0
            while length < mText.count && mText[mText.index(from: length)].isWhitespace == false
            {
                length += 1
            }
            
            if let substring = mText.substring(with: Range(NSMakeRange(mOffset, length))!)
            {
                synthesizer.stopSpeaking(at: .immediate)
                
                let utterance = createSpeechUtterance(text: substring)
                
                synthesizer.speak(utterance)
            }
        }
        else
        {
            var temp = mPosition
            if temp != 0 {
                temp -= 1
            }
            
            while temp > 0 && mText[mText.index(from: temp)].isWhitespace == true
            {
                temp -= 1
            }
            let endPos = temp
            while temp > 0 && mText[mText.index(from: temp)].isWhitespace == false
            {
                temp -= 1
            }
            mOffset =  temp
            if temp != 0 {
                mOffset += 1
            }
            
            synthesizer.stopSpeaking(at: .immediate)
            if let substring = mText.substring(with: Range(NSMakeRange(mOffset, endPos - mOffset + 1))!)
            {
                let utterance = createSpeechUtterance(text: substring)
                synthesizer.speak(utterance)
            }
        }
    }
    
    func nextSentence()
    {
        mUseDelegate = true

        var temp = mPosition
        while temp < mText.count && mText[mText.index(from: temp)].isEndOfSentence == false {
            temp += 1
        }
        
        while temp < mText.count && mText[mText.index(from: temp)].isEndOfSentence == true {
            temp += 1
        }
        let tempos = temp
        
        while temp < mText.count && mText[mText.index(from: temp)].isEndOfSentence == false {
            temp += 1
        }
        
        if tempos < mText.count
        {
            mOffset = tempos
            mPosition = mOffset
            
            if let substring = mText.substring(with: Range(NSMakeRange(mOffset, temp - mOffset))!)
            {
                if substring.allSatisfy({ character in
                    character.isWhitespace }) == false
                {
                    speak(text: substring)
                }
            }
        }
        delegate?.playPauseChanged(aIsPlaying: true)
    }
    
    private func speak(text : String)
    {
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = createSpeechUtterance(text: text)
        synthesizer.speak(utterance)
    }
    
    func previousSentence()
    {
        mUseDelegate = true

        var endPos : Int
        var temp = mPosition
        
        while temp > 0 && mText[mText.index(from: temp)].isEndOfSentence == false {
            temp -= 1
        }
        if temp == 0
        {
            while temp > 0 && mText[mText.index(from: temp)].isEndOfSentence == false
            {
                temp += 1
            }
            mOffset = 0
            mPosition = 0
            if let substring = mText.substring(with: Range(NSMakeRange(0, temp))!)
            {
                speak(text: substring)
            }
        }
        else
        {
            endPos = temp
            while temp > 0 && mText[mText.index(from: temp)].isEndOfSentence == true
            {
                temp -= 1
            }
            while temp > 0 && mText[mText.index(from: temp)].isEndOfSentence == false
            {
                temp -= 1
            }
            if temp != 0 {
                temp += 1
            }
            mOffset = temp
            mPosition = mOffset
            if let substring = mText.substring(with: Range(NSMakeRange(mOffset, endPos - temp))!)
            {
                speak(text: substring)
            }
        }
        delegate?.playPauseChanged(aIsPlaying: true)
    }
    
    func nextBlock()
    {
//        guard let page = mPage else {return}
//        
//        mUseDelegate = true
//        
//        var nr = page.getBlockNumber(pos: mPosition)
//        nr += 1
//        if nr >= page.mBlocks.count {
//            nr -= 1
//        }
//        let pos = page.getBlockPosition(number: nr)
//        
//        let length = mPage?.getBlock(pos: pos)?.mOcrData.count
//        
//        mPosition = pos
//        mOffset = pos
//        
//        if let substring = mText.substring(with: Range(NSMakeRange(pos, length!))!)
//        {
//            speak(text: substring)
//        }
//        delegate?.playPauseChanged(aIsPlaying: true)
    }
    
    func previousBlock()
    {
//        guard let page = mPage else {return}
//        
//        mUseDelegate = true
//        
//        var nr = page.getBlockNumber(pos: mPosition)
//        nr -= 1
//        if nr < 0 {
//            nr = 0
//        }
//        let pos = page.getBlockPosition(number: nr)
//        let length = page.getBlock(pos: pos)?.mOcrData.count
//        
//        mPosition = pos
//        mOffset = pos
//        if let substring = mText.substring(with: Range(NSMakeRange(pos, length!))!)
//        {
//            speak(text: substring)
//        }
//        delegate?.playPauseChanged(aIsPlaying: true)
    }

// MARK: - delegate
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance)
    {
        if mUseDelegate {
            mPosition = mOffset + characterRange.location
            delegate?.changeSelection(mOffset + characterRange.location, characterRange.length)
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        delegate?.playPauseChanged(aIsPlaying: false)
    }
}
