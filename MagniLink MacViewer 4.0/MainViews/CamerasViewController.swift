//
//  CamerasViewController.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-06-19.
//

import Foundation
import Cocoa

class CamerasViewController: NSViewController, CameraFinderDelegate {
    
    private let mAnimationTime = 0.15
    var mCameraViewController : CamerasViewController?
    var mCameraFinder : CameraFinder?
    var mCameraManager = CameraManager()
    var mVideoCapture : VideoCapture?
    
    override func loadView() {
        self.view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GStreamerBackend.init_gstreamer()
        
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.blue.cgColor
    }
    
    override func viewDidAppear() {
        
        if mCameraFinder == nil {
            
            mCameraFinder = CameraFinder()
            mCameraFinder?.delegate = self
            mCameraFinder?.search()
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func performAction(action :Actions)
    {
        switch action {
        case .switchSplit:
            changeSplit(direction: true)
        default:
            break
        }
    }
    
    func changeSplit(direction : Bool)
    {
        if mCameraManager.mSplit.split == .full
        {
            mCameraManager.mSplit.fullCount = (mCameraManager.mSplit.fullCount + 1) % mCameraManager.mSplit.videos.count
            mCameraManager.mSplit.active = mCameraManager.mSplit.videos[mCameraManager.mSplit.fullCount]
            if mCameraManager.mSplit.fullCount == 0 {
                mCameraManager.mSplit.split.next()
                if mCameraManager.mSplit.videos.contains(mCameraManager.mSplit.previousActive) {
                    mCameraManager.mSplit.active = mCameraManager.mSplit.previousActive
                }
                else {
                    mCameraManager.mSplit.active = mCameraManager.mSplit.videos.first!
                }
            }
        }
        else {
            mCameraManager.mSplit.split.next()
            if mCameraManager.mSplit.split == .full {
                mCameraManager.mSplit.previousActive = mCameraManager.mSplit.active
                mCameraManager.mSplit.fullCount = 0
                mCameraManager.mSplit.active = mCameraManager.mSplit.videos[mCameraManager.mSplit.fullCount]
            }
        }
        
        updateViews()
    }
    
    func cameraFinder(_ cameraFinder: CameraFinder, didFindReadingCamera readingCamera: ReadingCamera) {
        let cameraController = CameraAirReadingViewController()

        cameraController.setup(videoCapture: mVideoCapture!, manufacturer: readingCamera.manufacturer)
//        cameraController.delegate = self
//        cameraController.loadSettings()
        
        addCameraView(cameraView: cameraController)
    }
    
    func cameraFinder(_ cameraFinder: CameraFinder, didFindDistanceCamera distanceCamera: DistanceCamera) {
        let cameraController = CameraAirDistanceViewController()
        
        cameraController.setup(videoCapture: mVideoCapture!, manufacturer: distanceCamera.manufacturer)
//        cameraController.delegate = self
        
        addCameraView(cameraView: cameraController)
    }
    
    func cameraFinder(_ cameraFinder: CameraFinder, didFindEthernetCamera ethernetCamera: EthernetCamera) {
    }
    
    func cameraFinderDidFindGrabber(_ cameraFinder: CameraFinder, ip: String) {
    }
    
    func cameraFinderDidFindLVICamera(_ cameraFinder: CameraFinder, delay: Double) {
    }
    
    func cameraFinderDidFindTwigaCamera(_ cameraFinder: CameraFinder, delay: Double)
    {
        let cameraController = TwigaCameraViewController()
        
        mVideoCapture = VideoCapture()
        cameraController.setup(videoCapture: mVideoCapture!);
        
        addCameraView(cameraView: cameraController)
        
        mVideoCapture?.setup(){ success in
            if success {
                self.mVideoCapture?.start()
            }
        }
        
//        cameraController.setup(videoCapture: mVideoCapture!, manufacturer: readingCamera.manufacturer)
//        cameraController.delegate = self
//        cameraController.loadSettings()
        
        
    }
    
    private func addCameraView(cameraView : CameraBaseViewController)
    {
        mCameraManager.addController(controller: cameraView)
        cameraView.view.frame = self.view.bounds
        mCameraManager.mSplit.videos.append(mCameraManager.mVideoControllers.count-1)
        
        self.addChild(cameraView)
        self.view.addSubview(cameraView.view)
        updateViews()
    }
    
    func updateViews(updateScale : Bool = true)
    {
        guard mCameraManager.mVideoControllers.count > 0 else {
            return
        }
        
        let preferences = Preferences.shared
        
        switch (mCameraManager.mSplit.split)
        {
        case .left:
            mCameraManager.mSplit.percent = preferences.splitPrimarySecondaryVertical
        case .top:
            mCameraManager.mSplit.percent = preferences.splitPrimarySecondaryHorizontal
        case .right:
            mCameraManager.mSplit.percent = preferences.splitSecondaryPrimaryVertical
        case .bottom:
            mCameraManager.mSplit.percent = preferences.splitSecondaryPrimaryHorizontal
            default:
                break;
        }
                
        for vc in mCameraManager.mVideoControllers {
            
            vc.view.isHidden = true;
        }
        if mCameraManager.mSplit.active >= mCameraManager.mVideoControllers.count {
            mCameraManager.mSplit.active = mCameraManager.mVideoControllers.count - 1
        }
//
//        if let metal = mCameraManager.currentCamera.view as? MetalView {
//            metal.mDrawFrame = true
//        }
        
        var r = self.view.bounds

        if mCameraManager.mVideoControllers.count == 1 {
            mCameraManager.currentCamera.view.isHidden = false;
            NSView.animate(withDuration: mAnimationTime) {
                self.mCameraManager.currentCamera.view.frame = r;
            }
        }
        else if mCameraManager.mVideoControllers.count >= 2 && mCameraManager.mSplit.videos.count == 2
        {
            switch mCameraManager.mSplit.split {
            case .full:
                mCameraManager.currentCamera.view.isHidden = false;
                NSView.animate(withDuration: mAnimationTime) {
                    self.mCameraManager.currentCamera.view.frame = r;
                }
            case .left:
                let video0 = mCameraManager.mSplit.videos[0]
                let video1 = mCameraManager.mSplit.videos[1]
                
                let width = r.size.width;
                
                r.size.width *= mCameraManager.mSplit.percent
                mCameraManager.mVideoControllers[video0].view.isHidden = false;
                mCameraManager.mVideoControllers[video1].view.isHidden = false;

                NSView.animate(withDuration: mAnimationTime) {
                    self.mCameraManager.mVideoControllers[video0].view.frame = r;
                }
                
                r.origin.x = r.size.width;
                r.size.width = width * (1.0 - mCameraManager.mSplit.percent);

                NSView.animate(withDuration: mAnimationTime) {
                    self.mCameraManager.mVideoControllers[video1].view.frame = r;
                }

            case .top:
                let video0 = mCameraManager.mSplit.videos[0]
                let video1 = mCameraManager.mSplit.videos[1]
                
                let height = r.size.height;
                r.size.height *= mCameraManager.mSplit.percent
                mCameraManager.mVideoControllers[video0].view.isHidden = false;
                mCameraManager.mVideoControllers[video1].view.isHidden = false;

                NSView.animate(withDuration: mAnimationTime) {
                    self.mCameraManager.mVideoControllers[video0].view.frame = r;
                }
                
                r.origin.y = r.size.height;
                r.size.height = height * (1.0 - mCameraManager.mSplit.percent);

                NSView.animate(withDuration: mAnimationTime) {
                    self.mCameraManager.mVideoControllers[video1].view.frame = r;
                }
            case .right:
                let video0 = mCameraManager.mSplit.videos[0]
                let video1 = mCameraManager.mSplit.videos[1]
                
                let width = r.size.width;
                mCameraManager.mVideoControllers[video0].view.isHidden = false;
                mCameraManager.mVideoControllers[video1].view.isHidden = false;

                r.size.width *= mCameraManager.mSplit.percent
                NSView.animate(withDuration: mAnimationTime) {
                    self.mCameraManager.mVideoControllers[video1].view.frame = r;
                }
                
                r.origin.x = r.size.width;
                r.size.width = width * (1.0 - mCameraManager.mSplit.percent);

                NSView.animate(withDuration: mAnimationTime) {
                    self.mCameraManager.mVideoControllers[video0].view.frame = r;
                }
                
            case .bottom:
                let video0 = mCameraManager.mSplit.videos[0]
                let video1 = mCameraManager.mSplit.videos[1]
                
                let height = r.size.height;
                mCameraManager.mVideoControllers[video0].view.isHidden = false;
                mCameraManager.mVideoControllers[video1].view.isHidden = false;

                r.size.height *= mCameraManager.mSplit.percent
                NSView.animate(withDuration: mAnimationTime) {
                    self.mCameraManager.mVideoControllers[video1].view.frame = r;
                }
                
                r.origin.y = r.size.height;
                r.size.height = height * (1.0 - mCameraManager.mSplit.percent);

                NSView.animate(withDuration: mAnimationTime) {
                    self.mCameraManager.mVideoControllers[video0].view.frame = r;
                }
            }
        }
        else if mCameraManager.mVideoControllers.count >= 3 && mCameraManager.mSplit.videos.count >= 3
        {
            switch mCameraManager.mSplit.split {
            case .full:
                hideAll(hide: true)
                mCameraManager.currentCamera.view.isHidden = false;
                NSView.animate(withDuration: mAnimationTime) {
                    self.mCameraManager.currentCamera.view.frame = r;
                }
            case .left:
                
                let width = r.size.width;
                
                r.size.width *= mCameraManager.mSplit.percent
                hideAll(hide: false)
                
                NSView.animate(withDuration: mAnimationTime) {
                    self.mCameraManager.currentCamera.view.frame = r;
                }
                
                r.origin.x = r.size.width;
                r.size.width = width * (1.0 - mCameraManager.mSplit.percent);
                r.size.height = r.height / CGFloat((mCameraManager.mVideoControllers.count - 1))

                var next = mCameraManager.mSplit.active
                next = (next + 1) % mCameraManager.mVideoControllers.count
                repeat
                {
                    NSView.animate(withDuration: mAnimationTime) {
                        self.mCameraManager.mVideoControllers[next].view.frame = r;
                    }
                    r.origin.y += r.height
                    next = (next + 1) % mCameraManager.mVideoControllers.count
                } while next != mCameraManager.mSplit.active

            case .top:
                
                let height = r.size.height;
                r.size.height *= mCameraManager.mSplit.percent
                hideAll(hide: false)

                NSView.animate(withDuration: mAnimationTime) {
                    self.mCameraManager.currentCamera.view.frame = r;
                }
                
                r.origin.y = r.size.height;
                r.size.height = height * (1.0 - mCameraManager.mSplit.percent);
                r.size.width = r.width / CGFloat((mCameraManager.mVideoControllers.count - 1))
                
                var next = mCameraManager.mSplit.active
                next = (next + 1) % mCameraManager.mVideoControllers.count
                repeat
                {
                    NSView.animate(withDuration: mAnimationTime) {
                        self.mCameraManager.mVideoControllers[next].view.frame = r;
                    }
                    r.origin.x += r.width
                    next = (next + 1) % mCameraManager.mVideoControllers.count

                } while next != mCameraManager.mSplit.active
                
            case .right:
                let width = r.size.width;
                
                r.size.width *= mCameraManager.mSplit.percent
                r.origin.x = width - r.width
                hideAll(hide: false)
                
                NSView.animate(withDuration: mAnimationTime) {
                    self.mCameraManager.currentCamera.view.frame = r;
                }
                
                r.origin.x = 0;
                r.size.width = width * (1.0 - mCameraManager.mSplit.percent);
                r.size.height = r.height / CGFloat((mCameraManager.mVideoControllers.count - 1))

                var next = mCameraManager.mSplit.active
                next = (next + 1) % mCameraManager.mVideoControllers.count
                repeat
                {
                    NSView.animate(withDuration: mAnimationTime) {
                        self.mCameraManager.mVideoControllers[next].view.frame = r;
                    }
                    r.origin.y += r.height
                    next = (next + 1) % mCameraManager.mVideoControllers.count
                } while next != mCameraManager.mSplit.active

            case .bottom:
                                
                let height = r.size.height;
                r.size.height *= mCameraManager.mSplit.percent
                r.origin.y = height - r.height
                hideAll(hide: false)

                NSView.animate(withDuration: mAnimationTime) {
                    self.mCameraManager.currentCamera.view.frame = r;
                }
                
                r.origin.y = 0;
                r.size.height = height * (1.0 - mCameraManager.mSplit.percent);
                r.size.width = r.width / CGFloat((mCameraManager.mVideoControllers.count - 1))
                
                var next = mCameraManager.mSplit.active
                next = (next + 1) % mCameraManager.mVideoControllers.count
                repeat
                {
                    NSView.animate(withDuration: mAnimationTime) {
                        self.mCameraManager.mVideoControllers[next].view.frame = r;
                    }
                    r.origin.x += r.width
                    next = (next + 1) % mCameraManager.mVideoControllers.count
                } while next != mCameraManager.mSplit.active
            }
        }

        DispatchQueue.main.async {
            for videoController in self.mCameraManager.mVideoControllers {
                //
                //                //videoController.startVideo(start: videoController.view.isHidden == false)
                //
                guard let metalView = videoController.view as? MetalView else { break }
                //                    if updateScale {
                //                        metalView.updateScale()
                //                    }
                metalView.updateUniforms()
                //            }
            }
        }
    }
    
    func hideAll(hide : Bool)
    {
        for videoController in mCameraManager.mVideoControllers {
            videoController.view.isHidden = hide;
        }
    }
}
