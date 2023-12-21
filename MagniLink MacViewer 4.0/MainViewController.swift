//
//  ViewController.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-06-19.
//

import Cocoa

class MainViewController: NSViewController, KeyHandlerDelegate, RibbonDelegate {
    
    var mCameraViewController : CamerasViewController?
    var mKeyhandler = KeyHandler()
    var mRibbon : MyRibbonView?
    //let mRibbonHeight : CGFloat = 154
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mKeyhandler.delegate = self
        mKeyhandler.load()
        
        mCameraViewController = CamerasViewController()
        mCameraViewController?.mMainViewController = self
    }
    
    override func viewDidAppear() {
        self.addChild(mCameraViewController!)
        self.view.addSubview(mCameraViewController!.view)
        //view.translatesAutoresizingMaskIntoConstraints = false
        
        //mCameraViewController?.view.frame = self.view.bounds
        
        var frame = self.view.bounds
        frame.origin.y = frame.size.height - 154
        frame.size.height = 154
        
        mRibbon = MyRibbonView(frame: frame)
        guard let ribbon = mRibbon else {
            return
        }
        
        ribbon.setup()
        view.addSubview(ribbon)
        ribbon.autoresizingMask = [.minXMargin, .maxXMargin, .minYMargin, .width]
        scaleRibbon(scale: 1.0)
        ribbon.setAllCameraGroups()
        ribbon.setAllOcrGroups()
        ribbon.delegate = self
        ribbon.translatesAutoresizingMaskIntoConstraints = false
     
        downloadFileFromFTP()
//        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
//            self.keyDown(with: $0)
//            return $0
//        }
//        NSEvent.addLocalMonitorForEvents(matching: .keyUp) {
//            self.keyUp(with: $0)
//            return $0
//        }
        postRequest()
        becomeFirstResponder()
    }
    
    func postRequest() {
        // Replace with your API endpoint URL
        let apiUrl = URL(string: "https://europe-west1-magnilink-chromeviewer-beta.cloudfunctions.net/getLicense2")!
        
        // Replace with your actual JSON payload
        let jsonPayload: [String: Any] = [
            "serialNumber": "210912",
            "productId": 10,
            "format": "xml"
        ]
        
        do {
            // Convert JSON data to Data
            let requestData = try JSONSerialization.data(withJSONObject: jsonPayload, options: [])
            
            print("requestData \(requestData.base64EncodedString())")
            
            // Create URLRequest
            var request = URLRequest(url: apiUrl)
            request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
//            request.httpBody = Data(
                
                
            let requestBodyString = "{\"serialNumber\":\"210912\",\"productId\":10,\"format\":\"xml\"}"

            request.httpBody = requestBodyString.data(using: .utf8)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                // Handle the response here
                if let error = error {
                    print("Error: \(error)")
                } else if let data = data {
                    // Handle the response data
                    let responseString = String(data: data, encoding: .utf8)
                    print("Response: \(responseString ?? "Empty response")")
                }
            }
            
            // Resume the task to initiate the request
            task.resume()
            
        } catch {
            print("Error converting JSON data to Data: \(error.localizedDescription)")
        }
    }
    
    func downloadFileFromFTP() {
        let ftpURL = URL(string: "ftp://lvi-sw-v8:po9gf3d@ftp.lvi.se/MLS_UNIT_Config.xml")!
        let applicationSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appendingPathComponent("MagniLink MacViewer 4.0").appendingPathComponent("MLS_UNIT_Config.xml")
        
        let request = URLRequest(url: ftpURL)
        let downloadTask = URLSession.shared.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                let fileManager = FileManager.default
                do {
                    // Create the app's Application Support folder if it doesn't exist
                    try fileManager.createDirectory(at: applicationSupportURL.deletingLastPathComponent(), withIntermediateDirectories: true, attributes: nil)
                    
                    // Replace the existing file if it exists
                    if fileManager.fileExists(atPath: applicationSupportURL.path) {
                        try fileManager.replaceItem(at: applicationSupportURL, withItemAt: tempLocalUrl, backupItemName: nil, options: .usingNewMetadataOnly, resultingItemURL: nil)
                    } else {
                        // Move the downloaded file to Application Support folder
                        try fileManager.moveItem(at: tempLocalUrl, to: applicationSupportURL)
                    }
                    
                    print("File downloaded successfully and saved at: \(applicationSupportURL)")
                } catch (let writeError) {
                    print("Error saving file to Application Support folder: \(writeError)")
                }
            } else {
                print("Error downloading file: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        downloadTask.resume()
    }

    
    
    override var acceptsFirstResponder: Bool
    {
        get{
            return true
        }
    }
    
    func scaleRibbon(scale : Float)
    {
        mRibbon?.setScale(scale)
        var rect = view.bounds
        rect.size.height -= (mRibbon?.bounds.height)!
        
        var ribbonRect = mRibbon?.frame
        
        print("ribbonRect \(ribbonRect!.height)")
        
        ribbonRect?.origin.y = view.bounds.size.height - (mRibbon?.bounds.size.height)!
        mRibbon?.frame = ribbonRect!
    }
    
    override func viewDidLayout() {
        
        var frame = self.view.bounds
        var ribbonRect = mRibbon?.frame
        frame.size.height = frame.size.height - (mRibbon?.bounds.size.height)!
        
        mRibbon?.frame = ribbonRect!
        
        mCameraViewController?.view.frame = frame
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    override func keyDown(with event: NSEvent) {
        
        
        guard event.isARepeat == false else {
            return
        }
        
        mKeyhandler.handleKeyDown(key: event)
//        super.keyDown(with: event)
        //mCameraViewController?.mCameraManager.currentCamera.mMetalView.updateUniformsRender()
    }
    
    override func keyUp(with event: NSEvent) {
//        super.keyDown(with: event)
        mKeyhandler.handleKeyUp(key: event)
    }
    
    func performAction(action: Actions) {
        mCameraViewController?.performAction(action: action)
    }
    
// MARK: Ribbon delegates
    
    func handleCameraButtonClicked(_ button: CameraButton, withModifier mod: UInt) {
        switch button {
        case kCamNatural:
            mCameraViewController?.performAction(action: .nextNatural)
        case kCamArtificial:
            mCameraViewController?.performAction(action: .nextArtificial)
        default:
            break
        }
    }
    
    func handleCameraButtonPress(_ button: CameraButton) {
        
    }
    
    func handleCameraButtonRelease(_ button: CameraButton) {
        
    }
        
    func handleVolumeChanged(_ value: Double) {
        
    }
    
    func handleSpeedChanged(_ value: Double) {
        
    }
    
    func handleSettings() {
        
    }
}

