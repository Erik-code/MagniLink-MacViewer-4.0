//
//  RowScroll.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-10-30.
//

import Foundation

class RowScroll: BaseScroll {
    private var text: String = "";
    private var pos = 0;
    private var length = 0;
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mBackColor = .red
        //setAttributes(fontSize: 75)
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
    
    override func draw(_ rect: CGRect) {
        
        guard let font = mAttributes[NSAttributedString.Key.font] as? NSFont else {
            return
        }
        
        let height = CGFloat(font.pointSize.magnitude)
                        
        var origin = CGPoint(x:0, y:0);
        
        let index = text.index(text.startIndex, offsetBy: pos)
        let first = String(text[..<index])
        //let next = text[pos<..<pos+length]
        let start = text.index(text.startIndex, offsetBy: pos)
        let end = text.index(text.startIndex, offsetBy: pos+length)
        let range = start..<end
        let middle = String(text[range])
        
        let endstring = String(text.suffix(text.count - pos - length))
        
        let sizeFirst : CGSize = first.size(withAttributes: mAttributes)
        let sizeMiddle : CGSize = middle.size(withAttributes: mAttributes)
        
        if Preferences.shared.scrollMode == .line {
            origin.y = rect.origin.y + (rect.size.height - height)/2;
        }
        else{
            origin.y = rect.origin.y + (rect.size.height - height)/3;
        }
        
        origin.x = rect.origin.x + rect.size.width/2 - sizeFirst.width - sizeMiddle.width/2
        
        first.draw(at: origin, withAttributes: mAttributes)
        
        origin.x = rect.origin.x + rect.size.width/2 - sizeMiddle.width/2;
        middle.draw(at: origin, withAttributes: mAttributesNeg)
        
        origin.x = rect.origin.x + rect.size.width/2 + sizeMiddle.width/2;
        endstring.draw(at: origin, withAttributes: mAttributes)
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
//        var string = ""
//        for block in page.mBlocks {
//            string.append(block.getText())
//        }
//        self.text = string.replacingOccurrences(of: "\n", with: " ")
    }
    
    func changeSelection(_ pos: Int, _ length: Int) {
        self.length = length;
        self.pos = pos;
        self.needsDisplay = true
    }
}
