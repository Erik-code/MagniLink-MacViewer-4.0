//
//  WordScroll.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-10-30.
//

import Foundation

class WordScroll: BaseScroll {
    private var text: String = "";
    private var pos = 0;
    private var length = 0;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mBackColor = .red
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        mAttributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        mAttributesNeg[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        
//        let options = NSKeyValueObservingOptions(rawValue: NSKeyValueObservingOptions.old.rawValue | NSKeyValueObservingOptions.new.rawValue)
//        Preferences.shared.addObserver(self, forKeyPath: "font", options: options, context: nil)
    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if "font" == keyPath
//        {
//            setAttributes()
//        }
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect)
    {
        if text.count > 0
        {
            if pos >= 0 && pos + length <= text.count
            {
                let range = Range(NSMakeRange(pos, length))
                if let substring = text.substring(with: range!)
                {
                    let size : CGSize = substring.size(withAttributes: mAttributes)
                    let x = rect.origin.x + (rect.size.width - size.width) / 2;
                    let y = rect.origin.y + (rect.size.height - size.height) / 2;
                    let origin = CGPoint(x: x, y: y)
                    substring.draw(at: origin, withAttributes: mAttributes)
                }
            }
        }
    }
    
    func clearPage()
    {
        pos = 0
        length = 0
        self.text = ""
        self.needsDisplay = true
    }
    
    func setPage(/*_ page: OCRPage*/)
    {
//        pos = 0
//        length = 0
//        
//        var string = ""
//        
//        for block in page.mBlocks {
//            string.append(block.getText())
//        }
//        self.text = string
    }
    
    func changeSelection(_ pos: Int, _ length: Int) {
        self.length = length;
        self.pos = pos;
        self.needsDisplay = true
    }
}
