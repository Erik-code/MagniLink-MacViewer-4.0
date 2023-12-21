//
//  OCRViewController.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-10-30.
//

import Foundation

class OCRViewController : NSViewController, SpeechDelegate, MetalImageScrollDelegate, PageScrollDelegate
{
    private var mSpeech = Speech()
    var mMainViewController : MainViewController?

//    private var mOCRDocument = OCRDocument()

//    private var mProgressView = MyProgressView()
//    private var mDocumentPickerController : UIDocumentPickerViewController?
//    private var mImageSideBar = ImageSidebarController()
    var mScrollViewController = ScrollContainerController()
//    private var mSplitView = MySplitViewController()
    private let mAnimationTime = 0.15
//    private var mFileFormat = FileFormatPopup()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.view.backgroundColor = .black

        
//        addChild(mSplitView)
//        self.view.addSubview(mSplitView.view)
        
//        mSplitView.addLeft(view: mImageSideBar.view)
//        mImageSideBar.delegate = self
                        
        let scrollFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        
        view.addSubview(mScrollViewController.view)
//        mSplitView.addRight(view: mScrollViewController.view)
        addChild(mScrollViewController)
        
//        mSplitView.view.frame = scrollFrame
                
        mScrollViewController.mImageScroll.metalDelegate = self
        mScrollViewController.mPageScroll.delegate = self
        mScrollViewController.mSpeech = mSpeech
        mSpeech.delegate = self
        
//        mSplitView.hideLeft(hide: UIDevice.isIPhone)
        
        let options = NSKeyValueObservingOptions(rawValue: NSKeyValueObservingOptions.old.rawValue | NSKeyValueObservingOptions.new.rawValue)
        Preferences.shared.addObserver(self, forKeyPath: "font", options: options, context: nil)
    }
        
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if "font" == keyPath
        {
            setScrollMode()
        }
    }
    
    func performAction(action: Actions) {
        switch action
        {
        case .nextArtificial:
            nextArtificial()
        case .previousArtificial:
            previousArtificial()
        case .nextNatural:
            nextNatural()
        case .increaseFontSize:
            changeFontSize(direction: 1)
        case .decreaseFontSize:
            changeFontSize(direction: -1)
        case .playpause:
            mSpeech.playpause()
        case .readPrevious:
            mSpeech.previous()
        case .readNext:
            mSpeech.next()
        case .changeReadmode:
            changeReadMode()
        case .previousPage:
            previousPage()
        case .nextPage:
            nextPage()
        case .changeScrollmode:
            changeScrollMode()
        case .startDecreaseContrast:
            mScrollViewController.contrast(direction: .decrease)
        case .startIncreaseContrast:
            mScrollViewController.contrast(direction: .increase)
        case .stopContrast:
            mScrollViewController.contrast(direction: .stop)
        case .delete:
            deletePage()
        case .saveDocument:
            saveDocument()
        case .openDocument:
            openDocument()
//        case .takeInkPicture:
//            takeInkPicture()
//        case .hideSideMenu:
//            mSplitView.hideLeft(hide: mSplitView.isLeftHidden() == false)
        default:
            break
        }
    }
                
    func wordTouched(position: Int) {
        mSpeech.readFrom(position: position)
    }
    
    func pageWordTouched(position: Int) {
//        if let pos = mOCRDocument.getCurrent()?.getWordPosition(pos: position) ERIKMARK
//        {
//            mSpeech.readFrom(position: pos)
//        }
    }
    
//    func handleTap(_ sender: UITapGestureRecognizer? = nil) ERIKMARK
//    {
//        mScrollViewController.handleTap(sender)
//    }
    
//MARK: Document
    
//    func takeInkPicture()
//    {
//        for page in mOCRDocument.mPages {
//            if let image = page.mImage {
//                self.mMainViewController?.ink(image: image, pixels: page.mPixels)
//            }
//        }
//    }
    
    func openDocument()
    {
//        let supportedTypes: [UTType] = [UTType.zip, UTType.pdf]
//        mDocumentPickerController = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes)
//        mDocumentPickerController!.delegate = self
//        present(mDocumentPickerController!, animated: true, completion: nil)
    }
    
    func numberOfPages(number: Int) {
//        DispatchQueue.main.async
//        {
//            self.mProgressView.maxProgress = number
//        }
    }
    
    func currentPage(number: Int) {
//        DispatchQueue.main.async
//        {
//            self.mProgressView.currentProgress = number
//        }
    }

    func extractPdf(filePath : URL)
    {
//        mProgressView.frame = self.view.frame
//        mProgressView.createStuff()
//        self.view.addSubview(mProgressView)
//        
//        DispatchQueue.global(qos: .background).async {
//            
//            let load = LoadPdf()
//            load.delegate = self
//            let result = load.load(filePath: filePath) { res in
//                switch res {
//                case .success(let document):
//                    DispatchQueue.main.async
//                    {
//                        self.mOCRDocument.clear()
//                        self.mImageSideBar.clear()
//                        
//                        var append = false
//                        for page in document.mPages
//                        {
//                            self.setPage(page: page, append: append)
//                            append = true
//                        }
//                        self.mProgressView.removeFromSuperview()
//                    }
//                case .failure(_):
//                    self.mProgressView.removeFromSuperview()
//                    break
//                }
//            }
////            if result.result
////            {
////                DispatchQueue.main.async
////                {
////                    self.mOCRDocument.clear()
////                    self.mImageSideBar.clear()
////
////                    var append = false
////                    for page in result.ocrDocument!.mPages
////                    {
////                        self.setPage(page: page, append: append)
////                        append = true
////                    }
////                    self.mProgressView.removeFromSuperview()
////                }
////            }
//        }
    }
    
    func extractZip(filePath : URL)
    {
//        let load = LoadZip()
//        let result = load.load(filePath: filePath)
//        if result.result {
//            
//            mOCRDocument.clear()
//            mImageSideBar.clear()
//            
//            for page in result.ocrDocument!.mPages
//            {
//                setPage(page: page, append: true)
//            }
//            
//            if let page = mOCRDocument.getCurrent()
//            {
//                mScrollViewController.setPage(page: page)
//                mSpeech.create(page)
//                mImageSideBar.select(index: mOCRDocument.mCurrentPage)
//                
//                if result.position > 0 {
//                    mSpeech.mPosition = result.position
//                }
//                if Preferences.shared.startSpeech {
//                    mSpeech.playpause()
//                }
//            }
//        }
//        else{
//            print("Failed to load file")
//        }
    }

    private func deletePage()
    {
//        let selected = mImageSideBar.mSelected
//        deletePage(pageNumber: selected)
    }
    
    func saveDocument()
    {
//        removePreviousFiles()
//        let fileFormat = FileFormatPopup()
//        fileFormat.delegate = self
//        fileFormat.view.frame = view.frame
//        addChild(fileFormat)
//        self.view.addSubview(fileFormat.view)
    }
        
// MARK: Scrolls
    func changeScrollMode()
    {
        var scrollMode = Preferences.shared.scrollMode
        scrollMode.next()
        Preferences.shared.scrollMode = scrollMode
        setScrollMode()
    }
    
    private func setScrollMode()
    {
        let imageModes = [ScrollMode.image, .imageLine, .imageWord]
        
        let imageModes2 = [ScrollMode.image]

        mScrollViewController.setScrollMode()
    }
    
    func updateSubViews(animate : Bool = false)
    {
        var frame = self.view.bounds
                
        self.mScrollViewController.view.frame = frame
     
        setScrollMode()
        setPageNumber()
    }
    
// MARK: Read
    
    func changeReadMode()
    {
        let mode = mSpeech.changeSpeechMode()
        switch mode
        {
        case .block:
            MenuSpeech.shared.speak(text: MenuSpeech.shared.getLocalizedStringForKey(key: "Block"))
        case .sentence:
            MenuSpeech.shared.speak(text: MenuSpeech.shared.getLocalizedStringForKey(key: "Sentence"))
        case .word:
            MenuSpeech.shared.speak(text: MenuSpeech.shared.getLocalizedStringForKey(key: "WordByWord"))
        case .spell:
            MenuSpeech.shared.speak(text: MenuSpeech.shared.getLocalizedStringForKey(key: "Character"))
        }
    }
        
    func changeFontSize(direction : Int)
    {
        let preferences = Preferences.shared
        let scrollMode = preferences.scrollMode
        switch scrollMode {
        case .page:
            preferences.fontSizePage *= direction > 0 ? 1.05 : 1.0 / 1.05
            fontSizeHelp(value: preferences.fontSizePage)
        case .line:
            preferences.fontSizeLine *= direction > 0 ? 1.05 : 1.0 / 1.05
            fontSizeHelp(value: preferences.fontSizeLine)
        case .word:
            preferences.fontSizeWord *= direction > 0 ? 1.05 : 1.0 / 1.05
            fontSizeHelp(value: preferences.fontSizeWord)
        case .imageWord:
            preferences.fontSizeImageWord *= direction > 0 ? 1.05 : 1.0 / 1.05
            fontSizeHelp(value: preferences.fontSizeImageWord)
        case .imageLine:
            preferences.fontSizeImageLine *= direction > 0 ? 1.05 : 1.0 / 1.05
            fontSizeHelp(value: preferences.fontSizeImageLine)
        case .image:
            break
        }
        setScrollMode()
    }
    
    private func fontSizeHelp(value : CGFloat)
    {
        let val = String(format: "%.0f", value)
        let string = "Font size \(val)"
//        mMainViewController?.valueChanged(text: string)
    }
    
    func setPage(/*page : OCRPage,*/ append : Bool)
    {
//        mOCRDocument.append(page : page)
//        if append == false || mOCRDocument.mPages.count == 1
//        {
//            _ = mOCRDocument.gotoLast();
//            mScrollViewController.setPage(page: page)
//            mSpeech.create(page)
//            
//            if(Preferences.shared.startSpeech && append == false){
//                mSpeech.playpause()
//            }
//            else {
//                let range = page.getFirstWord()
//                mScrollViewController.changeSelection(range.location, range.length)
//            }
//        }
        setPageNumber()
        //mImageSideBar.addImage(image: page.mImage!)
        //mImageSideBar.select(index: mOCRDocument.mCurrentPage)
    }
    
    private func setPageNumber()
    {
//        let count = mOCRDocument.mPages.count
//        if count > 0 {
//            let number = mOCRDocument.mCurrentPage + 1
//            mScrollViewController.setPageNumber(text: "\(number)/\(count)")
//        }
//        else {
//            mScrollViewController.setPageNumber(text: "")
//        }
    }
    
    func previousPage()
    {
//        if let page = mOCRDocument.previous()
//        {
//            setPage(page: page)
//        }
    }
    
    func nextPage()
    {
//        if let page = mOCRDocument.next()
//        {
//            setPage(page: page)
//        }
    }
    
    func changePage(pageNumber: Int) {
//        if let page = mOCRDocument.goto(number: pageNumber)
//        {
//            setPage(page: page)
//        }
    }
    
    func deletePage(pageNumber: Int) {
//        if let page = mOCRDocument.delete(number: pageNumber)
//        {
//            //mImageSideBar.remove(index : pageNumber);
//            setPage(page: page)
//        }
//        else{
//            //mImageSideBar.remove(index : pageNumber);
//            clearPage()
//        }
    }
    
    func setPage(/*page : OCRPage*/)
    {
        mSpeech.pause()
//        mImageSideBar.select(index: mOCRDocument.mCurrentPage)
//        mScrollViewController.setPage(page: page)
//        mSpeech.create(page)
        
//        if let range = mOCRDocument.getCurrent()?.getFirstWord()
//        {
//            changeSelection(range.location, range.length)
//        }
        
        setPageNumber()
    }
    
    func clearPage()
    {
        mSpeech.clear()
        mScrollViewController.clearPage()
        setPageNumber()
    }
    
    func changeSelection(_ pos: Int, _ length: Int) {
        mScrollViewController.changeSelection(pos, length)
    }
    
//    func playPauseChanged(aIsPlaying: Bool) { ERIKMARK
//        mOCRButtonsViewController?.mPlayPauseButton?.mAlternate = aIsPlaying
//    }
    
//MARK: Colors
    func nextNatural()
    {
        guard let camera = EUCModel.shared.cameras.first(where:{ $0.name == "OCR" }) else {
            return
        }
        let grayscale = camera.nextNatural()
        mScrollViewController.setNaturalColors(grayscale: grayscale)
    }
    
    func nextArtificial()
    {
        guard let camera = EUCModel.shared.cameras.first(where:{ $0.name == "OCR" }) else {
            return
        }
        guard let color = camera.nextArtificial() else {
            return
        }
//        mSplitView.view.backgroundColor = UIColor(color.foreColor)
//       mImageSideBar.view.backgroundColor = UIColor(color.backColor)
        
        mScrollViewController.set(foreColor: NSColor(color.foreColor), backColor: NSColor(color.backColor))
    }
    
    func previousArtificial()
    {
        guard let camera = EUCModel.shared.cameras.first(where:{ $0.name == "OCR" }) else {
            return
        }
        guard let color = camera.previousArtificial() else {
            return
        }
//        mSplitView.view.backgroundColor = UIColor(color.foreColor)
//        mImageSideBar.view.backgroundColor = UIColor(color.backColor)

        mScrollViewController.set(foreColor: NSColor(color.foreColor), backColor: NSColor(color.backColor))
    }
    
    func setColor()
    {
        guard let camera = EUCModel.shared.cameras.first(where:{ $0.name == "OCR" }) else {
            return
        }

        let natural = camera.colorManager.colorType == .natural
       
        guard let color = camera.artificialColor else {
            return
        }
        
//        mSplitView.view.backgroundColor = UIColor(color.foreColor)
//        mImageSideBar.view.backgroundColor = UIColor(color.backColor)
        mScrollViewController.set(foreColor: NSColor(color.foreColor), backColor: NSColor(color.backColor))
        
        if natural
        {
            mScrollViewController.setNaturalColors(grayscale: camera.colorManager.grayscale)
        }
    }

    func save()
    {
        guard let model = EUCModel.shared.cameras.first(where:{ $0.name == "OCR" }) else {
            return
        }
        
        var colors = Preferences.shared.colorManagers
        colors["OCR"] = model.colorManager.intValue
        Preferences.shared.colorManagers = colors
    }
    
    func playPauseChanged(aIsPlaying: Bool) {
    }
    
    func valueChanged(text: String) {
    }
}
