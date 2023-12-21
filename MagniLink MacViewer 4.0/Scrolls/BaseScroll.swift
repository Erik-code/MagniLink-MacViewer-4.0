//
//  BaseScroll.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-10-30.
//

import Foundation

class BaseScroll: NSView
{
    var mAttributes = [NSAttributedString.Key: Any]()
    var mAttributesNeg = [NSAttributedString.Key: Any]()
    
    var mStringToDraw : String = ""
    var mRangeToDraw = NSMakeRange(0, 0)
    var mBackColor = NSColor.white

//    func setAttributes(fontSize : CGFloat)
//    {
//        mAttributes[NSAttributedString.Key.font] = UIFont(name: Preferences.shared.font, size: fontSize)
//        mAttributes[NSAttributedString.Key.foregroundColor] = UIColor.green
//
//        mAttributesNeg[NSAttributedString.Key.font] = UIFont(name: Preferences.shared.font, size: fontSize)
//        mAttributesNeg[NSAttributedString.Key.foregroundColor] = UIColor.blue
//        self.setNeedsDisplay()
//    }
    
    func set(textColor : NSColor, backgroundColor :  NSColor)
    {
        mAttributes[NSAttributedString.Key.foregroundColor] = textColor
        mAttributes[NSAttributedString.Key.backgroundColor] = backgroundColor

        mAttributesNeg[NSAttributedString.Key.foregroundColor] = backgroundColor
        mAttributesNeg[NSAttributedString.Key.backgroundColor] = textColor
        
        mBackColor = backgroundColor
        //self.backgroundColor = mBackColor

        self.needsDisplay = true
    }
    
    func setFont(font: String, size : CGFloat)
    {
        var size = size
        if size < 14
        {
            size = 14
        }
        if size > 240 {
            size = 240
        }
        mAttributes[NSAttributedString.Key.font] = NSFont(name: font, size: size)
        mAttributesNeg[NSAttributedString.Key.font] = NSFont(name: font, size: size)
        self.needsDisplay = true
    }
    
    func getFontSize() -> CGFloat
    {
        if let font = mAttributes[NSAttributedString.Key.font] as? NSFont
        {
            let size = font.fontDescriptor.pointSize
            return size
        }
        return 40
    }
    
    func setRange(range : NSRange)
    {
        mRangeToDraw = range;
        self.needsDisplay = true
    }
}
