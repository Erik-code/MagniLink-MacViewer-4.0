import Foundation
import os.log

@objcMembers public class CameraController : NSObject {
    private let logger: OSLog
    
    private var onvif: Onvif!
    
    public var profileToken: String!
    public var panSpeed: Float = 0.5
    public var tiltSpeed: Float = 0.5
    
    public var zoomSpeed: Float = 0.5

    
    private var videoEncoderConfigurationToken: String!
    private var videoSourceConfigurationToken: String!
    private var videoSourceToken: String!
    private var ptzConfigurationToken: String!
    private var ptzNodeToken: String!

    
    private let presetNameLvi1 = "PresetNameLvi1"
    private let presetNameLvi2 = "PresetNameLvi2"
    private let presetNameLvi3 = "PresetNameLvi3"
    private let presetNameLvi4 = "PresetNameLvi4"
    private let presetNameLvi5 = "PresetNameLvi5"
    private let presetNameLvi6 = "PresetNameLvi6"

    private var presetTokenLvi1 : String!
    private var presetTokenLvi2 : String!
    private var presetTokenLvi3 : String!
    private var presetTokenLvi4 : String!
    private var presetTokenLvi5 : String!
    private var presetTokenLvi6 : String!

    var panTiltZoomDirections: PanTiltZoomDirections = []
    
    // MARK: Initialization
    
    private override init() {
        logger = OSLog(category: String(describing: type(of: self)))
        
        super.init()
        
        
    }
    
    private convenience init(serialNumber: String, productId: String) {
        self.init()
        
        self.profileToken = "LVI_\(serialNumber)_\(productId)"
    }
    
    // MARK: Class methods
    
    @available(*, renamed: "create(ip:)")
    public class func create(ip: String, completionHandler: @escaping (Result<CameraController, Error>) -> Void) {
        getLicense(ip: ip) { response in
            switch response {
            case .success(let license):
                let cameraController = CameraController(serialNumber: license.serialNumber, productId: license.productId)
                
                Onvif.create(ip: ip, port: 56067) { response in
                    switch response {
                    case .success(let onvif):
                        cameraController.onvif = onvif
                        
                        onvif.getMediaProfile(profileToken: cameraController.profileToken) { response in
                            switch response {
                            case .success(let mediaProfile):
                                if mediaProfile.isConfiguredProperly() {
                                                                        
                                    cameraController.videoEncoderConfigurationToken = mediaProfile.videoEncoderConfiguration?.token
                                    cameraController.videoSourceConfigurationToken = mediaProfile.videoSourceConfiguration?.token
                                    cameraController.videoSourceToken = mediaProfile.videoSourceConfiguration?.sourceToken
                                    cameraController.ptzConfigurationToken = mediaProfile.ptzConfiguration?.token
                                    cameraController.ptzNodeToken = mediaProfile.ptzConfiguration?.nodeToken
                                    
                                    completionHandler(.success(cameraController))
                                } else {
                                    completionHandler(.failure(CameraControllerError.mediaProfileNotConfiguredProperly))
                                }
                            case .failure(let error):
                                completionHandler(.failure(error))
                            }
                        }
                        
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
                
                
            case .failure(let error):
                os_log(.error, "%s", error.localizedDescription)
            }
        }
    }
    
    
    
    
    public class func create(ip: String, completionHandler: @escaping (CameraController?, Error?) -> Void) {
        create(ip: ip) { response in
            switch response {
            case .success(let cameraController):
                completionHandler(cameraController, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    
    public class func getLicense(ip: String, completionHandler: @escaping (Result<License, Error>) -> Void) {
        Onvif.create(ip: ip, port: 56067) { response in
            switch response {
            case .success(let onvif):
                onvif.getMediaProfiles() { response in
                    switch response {
                    case .success(let mediaProfiles):
                        print(mediaProfiles)
                        
                        let license = mediaProfiles.lazy.first { profile in
                            profile.token.toLicense() != nil
                        } .map {
                            $0.token.toLicense()
                        }
                                       
                        guard let temp = license, let unwrappedLicense = temp else {
                            completionHandler(.failure(CameraControllerError.licenseNotFound))
                            
                            return
                        }
                                            
                        completionHandler(.success(unwrappedLicense))
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    // MARK: Public methods
    // public class func create(ip: String, completionHandler: @escaping (CameraController?, Error?) -> Void)
    public func configurePresets(completionHandler: @escaping (Result<Bool, Error>) -> Void)
    {
        self.onvif.getPtzNode(nodeToken: self.ptzNodeToken) { response in
            switch response {
            case .success(let profileNode):
                let maxPresets = profileNode.maximumNumberOfPresets
                
                self.onvif.getPtzPreset(profileToken: self.profileToken) { response in
                    switch response {
                        case .success(let profileTokens):
                        
                        let lviPresets = profileTokens.filter { preset in
                            preset.name == self.presetNameLvi1 || preset.name == self.presetNameLvi2 || preset.name == self.presetNameLvi3 || preset.name == self.presetNameLvi4 || preset.name == self.presetNameLvi5 || preset.name == self.presetNameLvi6
                        }
                        
                        let defaultPresets = profileTokens.filter { preset in
                            preset.name != self.presetNameLvi1 && preset.name != self.presetNameLvi2 && preset.name != self.presetNameLvi3 && preset.name != self.presetNameLvi4 && preset.name != self.presetNameLvi5 && preset.name != self.presetNameLvi6
                        }
                        
                        if defaultPresets.count > maxPresets - 6
                        {
                            self.removePresets(aPreset: 9, aPresets: defaultPresets)
                        }
                        
                        if(lviPresets.count == 0)
                        {
                            self.setLviPresets(aPreset: 0)
                        }
                        else
                        {
                            self.presetTokenLvi1 = lviPresets.count > 0 ? lviPresets[0].token : ""
                            self.presetTokenLvi2 = lviPresets.count > 1 ? lviPresets[1].token : ""
                            self.presetTokenLvi3 = lviPresets.count > 2 ? lviPresets[2].token : ""
                            self.presetTokenLvi4 = lviPresets.count > 3 ? lviPresets[3].token : ""
                            self.presetTokenLvi5 = lviPresets.count > 4 ? lviPresets[4].token : ""
                            self.presetTokenLvi6 = lviPresets.count > 5 ? lviPresets[5].token : ""
                        }
                        completionHandler(.success(true))
                            
                        case .failure(let error):
                            self.logger.error("Error: %s", error.localizedDescription)
                            completionHandler(.failure(error))
                    }
                }
                
            case .failure(let error):
                self.logger.error("Error: %s", error.localizedDescription)
            }
        }
        return;
    }
    
    public func configurePresets(completionHandler: @escaping (Bool, Error?) -> Void) {
        configurePresets() { response in
            switch response {
            case .success(let success):
                completionHandler(success, nil)
                break
            case .failure(let error):
                completionHandler(false, error)
            }
        }
    }
    
    private func removePresets(aPreset: Int, aPresets: [PTZPreset])
    {
        if(aPreset >= aPresets.count){
            return;
        }
        self.onvif.removePtzPreset(profileToken: self.profileToken, presetToken: aPresets[aPreset].token) { response in
            self.removePresets(aPreset: aPreset+1, aPresets: aPresets)
        }
    }
    
    private func setLviPresets(aPreset: Int)
    {
        var presetName = ""
        if aPreset == 0 {
            presetName = presetNameLvi1
        }
        else if aPreset == 1 {
            presetName = presetNameLvi2
        }
        else if aPreset == 2 {
            presetName = presetNameLvi3
        }
        else if aPreset == 3 {
            presetName = presetNameLvi4
        }
        else if aPreset == 4 {
            presetName = presetNameLvi5
        }
        else if aPreset == 5 {
            presetName = presetNameLvi6
        }
        else {
            return
        }

        self.onvif.setPtzPreset(profileToken: self.profileToken, presetName: presetName, presetToken: "") { response in
            switch response
            {
                case .success(let presetToken):
                
                    if aPreset == 0 {
                        self.presetTokenLvi1 = presetToken
                    }
                    else if aPreset == 1 {
                        self.presetTokenLvi2 = presetToken
                    }
                    else if aPreset == 2 {
                        self.presetTokenLvi3 = presetToken
                    }
                    else if aPreset == 3 {
                        self.presetTokenLvi4 = presetToken
                    }
                    else if aPreset == 4 {
                        self.presetTokenLvi5 = presetToken
                    }
                    else if aPreset == 5 {
                        self.presetTokenLvi6 = presetToken
                    }
                
                
                self.setLviPresets(aPreset: aPreset + 1)
                
                case .failure(let error):
                    self.logger.error("Error: %s", error.localizedDescription)
            }
        }
    }
    
    public func gotoPreset(aPreset: Int) {
    
        if(aPreset == 0)
        {
            self.onvif.gotoPtzPreset(profileToken: self.profileToken, presetToken: presetTokenLvi1) { response in
            }
        }
        else if(aPreset == 1)
        {
            self.onvif.gotoPtzPreset(profileToken: self.profileToken, presetToken: presetTokenLvi2) { response in
            }
        }
        else if(aPreset == 2)
        {
            self.onvif.gotoPtzPreset(profileToken: self.profileToken, presetToken: presetTokenLvi3) { response in
            }
        }
        else if(aPreset == 3)
        {
            self.onvif.gotoPtzPreset(profileToken: self.profileToken, presetToken: presetTokenLvi4) { response in
            }
        }
        else if(aPreset == 4)
        {
            self.onvif.gotoPtzPreset(profileToken: self.profileToken, presetToken: presetTokenLvi5) { response in
            }
        }
        else if(aPreset == 5)
        {
            self.onvif.gotoPtzPreset(profileToken: self.profileToken, presetToken: presetTokenLvi6) { response in
            }
        }
    }
    
    public func savePreset(aPreset: Int) {
    
        if(aPreset == 0)
        {
            self.onvif.setPtzPreset(profileToken: self.profileToken, presetName: self.presetNameLvi1, presetToken: self.presetTokenLvi1) { _ in
            }
        }
        else if(aPreset == 1)
        {
            self.onvif.setPtzPreset(profileToken: self.profileToken, presetName: self.presetNameLvi2, presetToken: self.presetTokenLvi2) { _ in
            }
        }
        else if(aPreset == 2)
        {
            self.onvif.setPtzPreset(profileToken: self.profileToken, presetName: self.presetNameLvi3, presetToken: self.presetTokenLvi3) { _ in
            }
        }
        else if(aPreset == 3)
        {
            self.onvif.setPtzPreset(profileToken: self.profileToken, presetName: self.presetNameLvi4, presetToken: self.presetTokenLvi4) { _ in
            }
        }
        else if(aPreset == 4)
        {
            self.onvif.setPtzPreset(profileToken: self.profileToken, presetName: self.presetNameLvi5, presetToken: self.presetTokenLvi5) { _ in
            }
        }
        else if(aPreset == 5)
        {
            self.onvif.setPtzPreset(profileToken: self.profileToken, presetName: self.presetNameLvi6, presetToken: self.presetTokenLvi6) { _ in
            }
        }
    }
    
    public func getRtspUrl(completionHandler: @escaping (Result<String, Error>) -> Void)
    {
        onvif.getStreamUri(profileToken: profileToken) { response in
            switch response {
            case .success(let streamUri):
                var url = streamUri.uri
                
                url.insert(contentsOf: "api:cyz2sheipq0rLwR4@", at: url.index(url.startIndex, offsetBy: 7));
                
                completionHandler(.success(url))
            case .failure(let error):
                self.logger.error("Error: %s", error.localizedDescription)
                
                completionHandler(.failure(error))
            }
        }
    }
    
    public func getRtspUrl(completionHandler: @escaping (String?, Error?) -> Void) {
        getRtspUrl() { response in
            switch response {
            case .success(let rtspUrl):
                completionHandler(rtspUrl, nil)
                break
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    public func getSnapshotUrl(completionHandler: @escaping (Result<String, Error>) -> Void) {
        onvif.getSnapshotUri(profileToken: profileToken) { response in
            switch response {
            case .success(let snapshotUri):
                completionHandler(.success(snapshotUri.uri))
            case .failure(let error):
                self.logger.error("Error: %s", error.localizedDescription)
                
                completionHandler(.failure(error))
            }
        }
    }
    
    public func getSnapshotUrl(completionHandler: @escaping (String?, Error?) -> Void) {
        getSnapshotUrl() { response in
            switch response {
            case .success(let snapshotUrl):
                completionHandler(snapshotUrl, nil)
                break
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    public func panTiltZoom(panDirection: PanDirection, tiltDirection: TiltDirection, zoomDirection: ZoomDirection) {
        if panDirection != .ignore {
            if panDirection == .left {
                panTiltZoomDirections.insert(.Left)
                panTiltZoomDirections.remove(.Right)
            } else if panDirection == .right {
                panTiltZoomDirections.remove(.Left)
                panTiltZoomDirections.insert(.Right)
            } else if panDirection == .none {
                panTiltZoomDirections.remove(.Left)
                panTiltZoomDirections.remove(.Right)
            }
        }
        
        if tiltDirection != .ignore {
            if tiltDirection == .up {
                panTiltZoomDirections.insert(.Up)
                panTiltZoomDirections.remove(.Down)
            } else if tiltDirection == .down {
                panTiltZoomDirections.remove(.Up)
                panTiltZoomDirections.insert(.Down)
            } else if tiltDirection == .none {
                panTiltZoomDirections.remove(.Up)
                panTiltZoomDirections.remove(.Down)
            }
        }
        
        if zoomDirection != .ignore {
            if zoomDirection == .In {
                panTiltZoomDirections.insert(.In)
                panTiltZoomDirections.remove(.Out)
            } else if zoomDirection == .out {
                panTiltZoomDirections.remove(.In)
                panTiltZoomDirections.insert(.Out)
            } else if zoomDirection == .none {
                panTiltZoomDirections.remove(.In)
                panTiltZoomDirections.remove(.Out)
            }
        }
        
        var pan: Float = panTiltZoomDirections.contains(.Left) ? -panSpeed : 0.0
        pan = panTiltZoomDirections.contains(.Right) ? panSpeed : pan
        
        var tilt: Float = panTiltZoomDirections.contains(.Up) ? tiltSpeed : 0.0
        tilt = panTiltZoomDirections.contains(.Down) ? -tiltSpeed : tilt
        
        var zoom: Float = panTiltZoomDirections.contains(.In) ? zoomSpeed : 0.0
        zoom = panTiltZoomDirections.contains(.Out) ? -zoomSpeed : zoom
        
        onvif.continousMove(profileToken: profileToken, pan: pan, tilt: tilt, zoom: zoom) { response in
            switch response {
            case .success(): break
            case .failure(let error):
                self.logger.error("Error: %s", error.localizedDescription)
            }
        }
    }
    
    public func absoluteMove(x: NSNumber?, y: NSNumber?, zoom: NSNumber?) {
        onvif.absoluteMove(profileToken: profileToken, ptzConfigurationToken: ptzConfigurationToken, x: x?.floatValue, y: y?.floatValue, zoom: zoom?.floatValue) { response in
            switch response {
            case .success(): break
            case .failure(let error):
                self.logger.error("Error: %s", error.localizedDescription)
            }
        }
    }
    
    public func getPtzStatus(completionHandler: @escaping (Result<PanTiltZoomStatus, Error>) -> Void) {
        onvif.getPtzStatus(profileToken: profileToken) { response in
            switch response {
            case .success(let ptzStatus):
                completionHandler(.success(ptzStatus.toPanTiltZoomStatus()))
            case .failure(let error):
                self.logger.error("Error: %s", error.localizedDescription)
                
                completionHandler(.failure(error))
            }
        }
    }
    
    public func getPtzStatus(completionHandler: @escaping (PanTiltZoomStatus?, Error?) -> Void) {
        onvif.getPtzStatus(profileToken: profileToken) { response in
            switch response {
            case .success(let ptzStatus):
                completionHandler(ptzStatus.toPanTiltZoomStatus(), nil)
                break
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    public func setFocusMode(autoFocus: Bool, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        onvif.setImagingSettings(videoSourceToken: videoSourceToken, focusMode: autoFocus ? "AUTO" : "MANUAL") { response in
            switch response {
            case .success():
                completionHandler(.success())
            case .failure(let error):
                self.logger.error("Error: %s", error.localizedDescription)
                
                completionHandler(.failure(error))
            }
        }
    }
    
    public func setFocusMode(autoFocus: Bool, completionHandler: @escaping (Error?) -> Void) {
        onvif.setImagingSettings(videoSourceToken: videoSourceToken, focusMode: autoFocus ? "AUTO" : "MANUAL") { response in
            switch response {
            case .success():
                completionHandler(nil)
            case .failure(let error):
                self.logger.error("Error: %s", error.localizedDescription)
                
                completionHandler(error)
            }
        }
    }
    
    public func focus(focusDirection: FocusDirection, speed: Float, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        onvif.getImagingOptions(videoSourceToken: videoSourceToken) { response in
            switch response {
            case .success(let imagingOptions):
            
                var speed = speed.clamp(imagingOptions.focus?.defaultSpeed?.min ?? speed, imagingOptions.focus?.defaultSpeed?.max ?? speed)
                
                if (focusDirection == FocusDirection.In && speed < 0.0) || (focusDirection == FocusDirection.out && speed > 0.0) {
                    speed *= -1.0
                }
                else if focusDirection == FocusDirection.none {
                    speed = 0.0
                }
                
                self.onvif.ImagingContinuousMove(videoSourceToken: self.videoSourceToken, speed: speed) { response in
                    switch response {
                    case .success():
                        break
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func focus(focusDirection: FocusDirection, speed: Float, completionHandler: @escaping (Bool, Error?) -> Void) {
        focus(focusDirection: focusDirection, speed: 1.0) { response in
            switch response {
            case .success():
                completionHandler(true, nil)
            case .failure(let error):
                completionHandler(false, error)
            }
        }
    }
    
    //public func getStreamSettingsAsync() async ->
    @available(*, renamed: "getStreamSettings()")
    public func getStreamSettings(completionHandler: @escaping (Result<StreamSettings, Error>) -> Void) {
        onvif.getVideoEncoderConfigurationOptions(profileToken: profileToken, configurationToken: videoEncoderConfigurationToken) { response in
            switch response {
            case .success(let videoEncoderConfigurationOptions):
                
                self.onvif.getVideoEncoderConfiguration(configurationToken: self.videoEncoderConfigurationToken) { response in
                    switch response {
                    case .success(let videoEncoderConfiguration):
                        completionHandler(.success(videoEncoderConfigurationOptions.toStreamSettings(videoEncoderConfiguration: videoEncoderConfiguration)))
                    case .failure(let error):
                        self.logger.error("Error: %s", error.localizedDescription)
                        
                        completionHandler(.failure(error))
                    }
                }
                
              
            case .failure(let error):
                self.logger.error("Error: %s", error.localizedDescription)
            }
        }
    }
    
    
    
    public func getStreamSettings(completionHandler: @escaping (StreamSettings?, Error?) -> Void) {
        getStreamSettings() { response in
            switch response {
            case .success(let streamSettings):
                completionHandler(streamSettings, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    public func getCameraSettings(completionHandler: @escaping (Result<CameraSettings, Error>) -> Void) {
        self.onvif.getImagingOptions(videoSourceToken: videoSourceToken) { response in
            switch response {
            case .success(let imagingOptions):
                self.onvif.getImagingSettings(videoSourceToken: self.videoSourceToken) { response in
                    switch response {
                    case .success(let imagingSettings):
                        self.onvif.getImagingMoveOptions(videoSourceToken: self.videoSourceToken) { response in
                            switch response {
                            case .success(let moveOptions):
                                completionHandler(.success(imagingOptions.toCameraSettings(imagingSettings: imagingSettings, moveOptions: moveOptions)))
                            case .failure(let error):
                                completionHandler(.failure(error))
                            }
                        }
                        break
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
            case .failure(let error):
                self.logger.error("Error: %s", error.localizedDescription)
                
                completionHandler(.failure(error))
            }
        }
    }
    
    public func getCameraSettings(completionHandler: @escaping (CameraSettings?, Error?) -> Void) {
        getCameraSettings() { response in
            switch response {
            case .success(let cameraSettings):
                completionHandler(cameraSettings, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
    
    /*public func setBrightness(brightness: Float, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        onvif.setImagingSettings(videoSourceToken: videoSourceToken, brightness: brightness) { response in
            switch response {
            case .success():
                completionHandler(.success())
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func setBrightness(brightness: Float, completionHandler: @escaping (Bool, Error?) -> Void) {
        setBrightness(brightness: brightness) { response in
            switch response {
            case .success():
                completionHandler(true, nil)
            case .failure(let error):
                completionHandler(false, error)
            }
        }
    }*/
    
    public func setQuality(quality: Float, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        print("Setting quality ...")
        onvif.setVideoEncoderConfiguration(configurationToken: videoEncoderConfigurationToken, quality: quality) { response in
            switch response {
            case .success():
                completionHandler(.success())
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func setQuality(quality: Float, completionHandler: @escaping (Bool, Error?) -> Void) {
        setQuality(quality: quality) { response in
            switch response {
            case .success():
                completionHandler(true, nil)
            case .failure(let error):
                completionHandler(false, error)
            }
        }
    }
    
    public func setFrameRate(frameRate: Int, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        onvif.setVideoEncoderConfiguration(configurationToken: videoEncoderConfigurationToken, frameRateLimit: frameRate) { response in
            switch response {
            case .success():
                completionHandler(.success())
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func setFrameRate(frameRate: Int, completionHandler: @escaping (Bool, Error?) -> Void) {
        setFrameRate(frameRate: frameRate) { response in
            switch response {
            case .success():
                completionHandler(true, nil)
            case .failure(let error):
                completionHandler(false, error)
            }
        }
    }
    
    public func setBitrate(bitrate: Int, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        onvif.setVideoEncoderConfiguration(configurationToken: videoEncoderConfigurationToken, bitrateLimit: bitrate) { response in
            switch response {
            case .success():
                completionHandler(.success())
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func setBitrate(bitrate: Int, completionHandler: @escaping (Bool, Error?) -> Void) {
        setBitrate(bitrate: bitrate) { response in
            switch response {
            case .success():
                completionHandler(true, nil)
            case .failure(let error):
                completionHandler(false, error)
            }
        }
    }
    
    public func setResolution(width: Int, height: Int, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        onvif.setVideoEncoderConfiguration(configurationToken: videoEncoderConfigurationToken, width: width, height: height) { response in
            switch response {
            case .success():
                completionHandler(.success())
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func setResolution(width: Int, height: Int, completionHandler: @escaping (Bool, Error?) -> Void) {
        setResolution(width: width, height: height) { response in
            switch response {
            case .success():
                completionHandler(true, nil)
            case .failure(let error):
                completionHandler(false, error)
            }
        }
    }
    
    
}
