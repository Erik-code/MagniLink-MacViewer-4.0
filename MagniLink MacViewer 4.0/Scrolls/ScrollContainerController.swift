//
//  ScrollContainerController.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-10-30.
//

import Foundation

class ScrollContainerController: NSViewController {
 
    private var mRowScroll = RowScroll()
    private var mWordScroll = WordScroll()
    var mPageScroll = PageScroll()
    var mImageScroll = MetalImageScroll()
    
    var mSpeech : Speech?
    
    //private var mPageNumberLabel = PagesNumberLabel() //ERIKMARK
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //mPageNumberLabel.update()
        
        let bounds = self.view.bounds
        
        mRowScroll.frame = bounds
        mRowScroll.mBackColor = .black

        mWordScroll.frame = bounds
        mWordScroll.mBackColor = .black

        mPageScroll.frame = bounds
        mPageScroll.mBackColor = .black
        
        mImageScroll.frame = bounds
        
        self.view.addSubview(mImageScroll)
        self.view.addSubview(mPageScroll)
        self.view.addSubview(mWordScroll)
        self.view.addSubview(mRowScroll)
//        self.view.addSubview(mPageNumberLabel)
    }

//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        setScrollMode()
//    }
//    
//    override func viewDidLayoutSubviews() {
//        setScrollMode()
//    } ERIKMARK
    
    func setPage(/*page : OCRPage*/)
    {
//        mRowScroll.setPage(page)
//        mWordScroll.setPage(page)
//        mPageScroll.setPage(page)
//        mImageScroll.setPage(page: page)
    }
    
    func clearPage()
    {
        mRowScroll.clearPage()
        mWordScroll.clearPage()
        mPageScroll.clearPage()
        mImageScroll.clearPage()
    }
    
    func changeSelection(_ pos: Int, _ length: Int)
    {
        let range = NSMakeRange(pos, length)
        mRowScroll.changeSelection(pos, length)
        mWordScroll.changeSelection(pos, length)
        mPageScroll.changeSelection(pos, length)
        mPageScroll.setRange(range: range)
        
        mImageScroll.setRange(range: range)
    }
    
    func hideAll()
    {
        mPageScroll.isHidden = true
        mWordScroll.isHidden = true
        mRowScroll.isHidden = true
        mImageScroll.isHidden = true
    }
    
    func setScrollMode()
    {
        hideAll()
        
        var r = view.bounds
                        
        let scrollMode = Preferences.shared.scrollMode
        switch scrollMode {
        case .page:
            mPageScroll.isHidden = false
            mPageScroll.setFont(font: Preferences.shared.font, size: Preferences.shared.fontSizePage)
            mPageScroll.frame = r
        case .line:
            mRowScroll.isHidden = false
            mRowScroll.setFont(font: Preferences.shared.font, size: Preferences.shared.fontSizeLine)
            mRowScroll.frame = r
        case .word:
            mWordScroll.isHidden = false
            mWordScroll.setFont(font: Preferences.shared.font, size: Preferences.shared.fontSizeWord)
            mWordScroll.frame = r
        case .image:
            mImageScroll.isHidden = false
            mImageScroll.frame = r
        case .imageWord:
            mImageScroll.isHidden = false
            mWordScroll.isHidden = false
            
            let fn = Preferences.shared.fontSizeImageWord
            let wr = CGRect(x: 0, y: r.size.height - fn * 1.4, width: r.size.width, height: fn * 1.4)
            let ir = CGRect(x: 0, y: 0, width: r.size.width , height: r.size.height - wr.size.height)
            mWordScroll.frame = wr
            mWordScroll.setFont(font: Preferences.shared.font, size: Preferences.shared.fontSizeImageWord)
            mImageScroll.frame = ir
            
        case .imageLine:
            mImageScroll.isHidden = false
            mRowScroll.isHidden = false
            
            let fn = Preferences.shared.fontSizeImageLine
            let wr = CGRect(x: 0, y: r.size.height - fn * 1.4, width: r.size.width, height: fn * 1.4)
            let ir = CGRect(x: 0, y: 0, width: r.size.width , height: r.size.height - wr.size.height)
            mRowScroll.frame = wr
            mRowScroll.setFont(font: Preferences.shared.font, size: Preferences.shared.fontSizeImageLine)
            mImageScroll.frame = ir
        }
        
//        mPageNumberLabel.update()
        
        mImageScroll.updateUniforms()
        mImageScroll.needsDisplay = true
    }
    
    func setPageNumber(text : String)
    {
        //mPageNumberLabel.setText(text: text)
    }
    
    //MARK: Commands
    var beginContrast : CGFloat = 1.0
    func contrast(location: CGPoint, value : CGFloat, began: Bool)
    {
        if mImageScroll.isHidden == false
        {
            mImageScroll.contrast(location: location, value : value, began: began)
        }
    }
    
    func contrast(direction : PNDirection)
    {
        if mImageScroll.isHidden == false
        {
            mImageScroll.pn(direction: direction)
        }
    }
    
    var beginZoom : CGFloat = 1.0
    var beginFontSize : CGFloat = 1.0
    func zoom(location: CGPoint, value : CGFloat, began: Bool)
    {
        if mImageScroll.isHidden == false && mImageScroll.frame.contains(location)
        {
            if(began){
                beginZoom = CGFloat(mImageScroll.mZoom) / value
            }
            var zoom = Float(beginZoom) * Float(value)
            
            zoom = zoom > 5.0 ? 5.0 : zoom
            zoom = zoom < 1.0 ? 1.0 : zoom
            
            zoomHelp(aZoom: zoom)
        }
        else{
            if(began){
                beginFontSize = getFontSize()
            }
            
            let size = beginFontSize * value
            
            setFontSize(size: size)
            
            setScrollMode()
        }
    }
    
    private func getFontSize() -> CGFloat
    {
        let preferences = Preferences.shared
        let scrollMode = preferences.scrollMode
        switch scrollMode {
        case .page:
            return preferences.fontSizePage
        case .line:
            return preferences.fontSizeLine
        case .word:
            return preferences.fontSizeWord
        case .imageWord:
            return preferences.fontSizeImageWord
        case .imageLine:
            return preferences.fontSizeImageLine
        case .image:
            return 1.0
        }
    }
    
    private func setFontSize(size : CGFloat)
    {
        let preferences = Preferences.shared
        let scrollMode = preferences.scrollMode
        switch scrollMode {
        case .page:
            preferences.fontSizePage = size
        case .line:
            preferences.fontSizeLine = size
        case .word:
            preferences.fontSizeWord = size
        case .imageWord:
            preferences.fontSizeImageWord = size
        case .imageLine:
            preferences.fontSizeImageLine = size
        case .image:
            break
        }
    }
    
    private func zoomHelp(aZoom : Float)
    {
        mImageScroll.setZoom(aZoom : aZoom)
        mImageScroll.updateUniforms()
        mImageScroll.needsDisplay = true
        let percent = String(format: "%.0f", aZoom * 100.0 / (1))
        let string = "Zoom \(percent)%"
        //mMainViewController?.valueChanged(text: string)
    }
    
    var beginPan = CGPoint(x: 0, y: 0)
    func pan(location: CGPoint, value : CGPoint, began: Bool)
    {
        if(began){
            beginPan = mImageScroll.mPan
        }

        let pan = CGPoint(x: beginPan.x + value.x, y: beginPan.y - value.y)
                
        mImageScroll.setPan(aPan: pan)
        mImageScroll.updateUniforms()
        mImageScroll.needsDisplay = true
    }
    
    func setNaturalColors(grayscale: Bool)
    {
        mImageScroll.setNaturalColors(grayscale: grayscale)
    }

    func set(foreColor: NSColor, backColor: NSColor)
    {
        mImageScroll.set(foreColor: foreColor, backColor: backColor)
        mWordScroll.set(textColor: foreColor, backgroundColor: backColor)
        mRowScroll.set(textColor: foreColor, backgroundColor: backColor)
        mPageScroll.set(textColor: foreColor, backgroundColor: backColor)
    }
    
//    func handleTap(_ sender: UITapGestureRecognizer? = nil) ERIKMARK
//    {
//        guard let speech = mSpeech else { return }
//        
//        if mPageScroll.isHidden == false {
//            if let position = sender?.location(in: mPageScroll)
//            {
//                if speech.speechInProgress(){
//                    speech.pause()
//                }
//                else{
//                    if mPageScroll.getTextPosition(location: position) == -1
//                    {
//                        speech.playpause()
//                    }
//                }
//                print("position \(position)")
//            }
//        }
//        else {
//            speech.playpause()
//        }
//    }
}
