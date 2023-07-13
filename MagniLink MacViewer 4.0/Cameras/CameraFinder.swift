//
//  File.swift
//  MagniLink MacViewer 4.0
//
//  Created by Erik Sandstrom on 2023-06-19.
//

import Foundation
import Cocoa
import AVFoundation

public class Camera: NSObject {
    public let ip: String
    public let model: String
    
    public init(ip: String, model: String) {
        self.ip = ip
        self.model = model
    }
}

public class PTZCamera: Camera {
    public let manufacturer: String
    
    public init(ip: String, model: String, manufacturer: String) {
        self.manufacturer = manufacturer
        
        super.init(ip: ip, model: model)
    }
}


public class EthernetCamera: PTZCamera {
    public init(model: String, manufacturer: String) {
        super.init(ip: "192.168.100.100", model: model, manufacturer: manufacturer)
    }
    
    public init(camera: Camera) {
        super.init(ip: "192.168.100.100", model: camera.model, manufacturer: camera.ip)
    }
}

public class ReadingCamera: PTZCamera {
    public init(model: String, manufacturer: String) {
        super.init(ip: "192.168.101.100", model: model, manufacturer: manufacturer)
    }
    
    public init(camera: PTZCamera) {
        super.init(ip: "192.168.101.100", model: camera.model, manufacturer: camera.manufacturer)
    }
}

public class DistanceCamera: PTZCamera {
    public init(model: String, manufacturer: String) {
        super.init(ip: "192.168.101.200", model: model, manufacturer: manufacturer)
    }
    
    public init(camera: PTZCamera) {
        super.init(ip: "192.168.101.200", model: camera.model, manufacturer: camera.manufacturer)
    }
}

struct Constants {
    
//    static let SSID = "LVI_WiFi_Camera"
//    static let SSID = "ML_AIR"
    static let SSID = "MagniWiFi"

    
    struct Cameras {
        static let VideoGrabber = "192.168.101.150"
        static let Reading = "192.168.101.100"
        static let Distance = "192.168.101.200"
        static let Ethernet = "192.168.100.100"
    }
}

protocol CameraFinderDelegate {
    
    func cameraFinder(_ cameraFinder: CameraFinder, didFindReadingCamera readingCamera: ReadingCamera)
    func cameraFinder(_ cameraFinder: CameraFinder, didFindDistanceCamera distanceCamera: DistanceCamera)
    func cameraFinder(_ cameraFinder: CameraFinder, didFindEthernetCamera ethernetCamera: EthernetCamera)
    func cameraFinderDidFindGrabber(_ cameraFinder: CameraFinder, ip : String)
    func cameraFinderDidFindLVICamera(_ cameraFinder: CameraFinder, delay : Double)
    func cameraFinderDidFindTwigaCamera(_ cameraFinder: CameraFinder, delay : Double)
}

class CameraFinder: NSObject {
    
    let getWiFiNrRetries = 2
    let getWiFiSleepTime = 10.0
    var delegate : CameraFinderDelegate?
    private let findQueue = DispatchQueue(label: "find queue") // Communicate with the session and other session objects on this queue.
    
    override init() {
        super.init()
    }
    
    func search()
    {
        searchForLVICamera()
        searchForAirCamera()
    }
    
    private func searchForLVICamera()
    {
        let session = AVCaptureDevice.DiscoverySession(deviceTypes: [.externalUnknown], mediaType: .video, position: .unspecified)
        
        for dev in session.devices {
            print("Device found \(dev.localizedName)")
            
            if ["USB3Neo 00000", "USB Camera3"].contains(dev.localizedName) {
                delegate?.cameraFinderDidFindTwigaCamera(self, delay: 1.0)
            }
        }
        
    }
    
    private func searchForAirCamera()
    {
        findDistanceCamera()
        findReadingCamera()
        findEthernetCamera()
        findGrabber();
    }
    
    private func findReadingCamera() {
        findOnvifCamera(ip: Constants.Cameras.Reading) { response in
            switch response {
            case .success(let camera):
                DispatchQueue.main.async {
                    self.delegate?.cameraFinder(self, didFindReadingCamera: ReadingCamera(camera: camera))
                }
            case .failure(let error):
                print("error = ",error.localizedDescription)
            }
        }
    }
    
    private func findDistanceCamera() {
        findOnvifCamera(ip: Constants.Cameras.Distance) { response in
            switch response {
            case .success(let camera):
                DispatchQueue.main.async {
                    self.delegate?.cameraFinder(self, didFindDistanceCamera: DistanceCamera(camera: camera))
                }
            case .failure(let error):
                print("error = ",error.localizedDescription)
            }
        }
    }
    
    private func findEthernetCamera() {
    }
    
    private func findOnvifCamera(ip: String, completionHandler: @escaping (Result<PTZCamera, Error>) -> Void) {
        
        Onvif.create(ip: ip, port: 56067) { response in
            switch response {
            case .success(let onvif):
                onvif.getDeviceInformation() { response in
                    switch response {
                    case .success(let deviceInformation):
                        completionHandler(.success(PTZCamera(ip: ip, model: deviceInformation.model, manufacturer: deviceInformation.manufacturer)))
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    private func findGrabber() {
    }
}
