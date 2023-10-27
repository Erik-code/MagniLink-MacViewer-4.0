//
//  CameraAirViewController.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-06-19.
//

import Cocoa

class CameraAirViewController: CameraBaseViewController {

    var mGStreamer : GStreamerBackend?
    var mVideoCapture : VideoCapture?
    var mAirCameraController : AirCameraController?
    var mCameraController : CameraController?
    var mSerial : String = ""
    var mProductId : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    func parseToken(profileToken : String?)
    {
        if let token = profileToken
        {
            let arr = token.split(separator: "_")
            if arr.count >= 3 {
                mSerial = String(arr[1])
                mProductId = String(arr[2])
            }
        }
    }
    
    func setVideoStruct(aVideo : VideoStruct)
    {
        mMetalView.setVideoStruct(aVideo: aVideo)
    }
    
    @objc func gstreamerInitialized(_ aBackend: GStreamerBackend!) {
        DispatchQueue.main.async {
            aBackend.play()
            //self.isRunning = true
        }
    }
    
    @objc func gstreamerExitedMainLoop(_ aBackend: GStreamerBackend!)
    {
        DispatchQueue.main.async
        {
            print("gstreamerExitedMainLoop")
        }
    }
    
    @objc func gstreamerSetUIMessage(_ aMessage : String)
    {
        print("gstreamerSetUIMessage: \(aMessage)")
    }
    
    override func zoom(aDirection: CameraControlZoomDirection)
    {
        switch aDirection {
        case .inn:
            mCameraController?.panTiltZoom(panDirection: .ignore, tiltDirection: .ignore, zoomDirection: .In)
        case .out:
            mCameraController?.panTiltZoom(panDirection: .ignore, tiltDirection: .ignore, zoomDirection: .out)
        case .stop:
            mCameraController?.panTiltZoom(panDirection: .ignore, tiltDirection: .ignore, zoomDirection: .none)
        }
    }
    
    override func takePicture()
    {
        mCameraController?.getSnapshotUrl(completionHandler: { response in
            switch response {
            case .success(let url):

                var request = URLRequest(url: URL(string: url)!)

                request.httpMethod = "GET"
                request.url = URL(string: url)

                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config)

                let dataTask = session.dataTask(with: request as URLRequest) { data, urlresponse, error in

                    if let data = data
                    {
                        if let image = NSImage(data: data)
                        {
                            self.delegate?.imageTaken(aImage: image, pixels: nil)
                        }
                    }
                }

                dataTask.resume()

                break
            case .failure(_):
                break
            }
        })
    }
}
