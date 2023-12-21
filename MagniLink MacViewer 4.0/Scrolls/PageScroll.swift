//
//  PageScroll.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-10-30.
//

import Foundation

protocol PageScrollDelegate
{
    func pageWordTouched(position : Int)
}

class PageScroll: BaseScroll
{
    private var text: String = "";
    private var pos = 0;
    private var length = 0;
    private var mPageStorage : NSTextStorage?
    private var mPageLayout : NSLayoutManager?
    private var mPageContainer : NSTextContainer?
    private var mOffset : CGFloat = 0.0
    
    var delegate : PageScrollDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mBackColor = .red
//        setAttributes(fontSize: 75)
        
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
    
    func addBounds()
    {
        let margin : CGFloat = 10.0
        let frame = self.frame;
        
        let bounds = CGRect(x: frame.origin.x + margin, y: frame.origin.y + margin, width: frame.size.width - 2 * margin, height: frame.size.height - 2 * margin)
        self.frame = bounds
    }

    func setText(_ text : String)
    {
        if text != mStringToDraw {
            mStringToDraw = text.copy() as! String
        }
        if mPageStorage == nil
        {
            mPageStorage = NSTextStorage()
            mPageLayout = NSLayoutManager()
            mPageContainer = NSTextContainer()
            mPageLayout?.addTextContainer(mPageContainer!)
            mPageStorage?.addLayoutManager(mPageLayout!)
        }
                
        mPageStorage?.mutableString.setString(mStringToDraw)
        mPageStorage?.setAttributes(mAttributes, range: NSMakeRange(0, mPageStorage!.length))
        self.needsDisplay = true
    }
    
    func addText(_ text : String)
    {
        if mPageStorage == nil
        {
            mPageStorage = NSTextStorage()
            mPageLayout = NSLayoutManager()
            mPageContainer = NSTextContainer()
            mPageLayout?.addTextContainer(mPageContainer!)
            mPageStorage?.addLayoutManager(mPageLayout!)
        }
                
        mPageStorage?.mutableString.append(text)
        mPageStorage?.setAttributes(mAttributes, range: NSMakeRange(0, mPageStorage!.length))
        self.needsDisplay = true
    }
    
    func clearPage()
    {
        pos = 0
        length = 0
        self.setText("")
        self.needsDisplay = true
    }
    
    func setPage(/*_ text: OCRPage*/)
    {
//        pos = 0
//        length = 0
//        
//        self.setText("")
//        
//        for block in text.mBlocks {
//            self.addText(block.getText())
//        }
    }
    
    override func draw(_ rect: CGRect)
    {
        mBackColor.set()
        
        mPageContainer?.size = CGSize(width: rect.width - 20.0, height: CGFloat.greatestFiniteMagnitude)
        self.drawStringInRect(self.bounds)
    }

    private func drawStringInRect(_ rect : CGRect)
    {
        guard let length = mPageStorage?.length else { return }
        if mRangeToDraw.location + mRangeToDraw.length > length {
            return
        }
        
        mPageStorage?.setAttributes(mAttributes, range: NSMakeRange(0, mPageStorage!.length))
        mPageStorage?.setAttributes(mAttributesNeg, range: mRangeToDraw)
        
        let glyphLocation = mPageLayout?.location(forGlyphAt: 0)
        var origin = CGPoint(x: rect.origin.x - glyphLocation!.x, y: rect.origin.y)
        
        let nr : UInt = 0
        if let r = mPageLayout?.boundingRect(forGlyphRange: mRangeToDraw, in: mPageContainer!)
        {
            if r.minY + r.height + mOffset > rect.height
            {
                mOffset = -r.minY
            }
            else if r.minY + r.height + mOffset <= rect.origin.y
            {
                mOffset = -r.minY
            }
        }
        
        origin.x = 10.0
        origin.y = mOffset
        mPageLayout?.drawBackground(forGlyphRange: mRangeToDraw, at: origin)
        mPageLayout?.drawGlyphs(forGlyphRange: NSMakeRange(0, mPageStorage!.length), at: origin)
    }
        
    func getTextPosition(location : CGPoint) -> Int
    {
        var newPos = location
        newPos.y -= mOffset
        guard var position = mPageLayout?.characterIndex(for: newPos, in: mPageContainer!, fractionOfDistanceBetweenInsertionPoints: nil) else {
            return -1
        }
        
        
        delegate?.pageWordTouched(position: position)
        
        return position
    }
    
    func changeSelection(_ pos: Int, _ length: Int) {
        self.length = length;
        self.pos = pos;
        self.needsDisplay = true
    }

}
