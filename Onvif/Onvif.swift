import Foundation
import os.log
import SWXMLHash

public class Onvif : NSObject, URLSessionTaskDelegate, XMLParserDelegate {
    private let logger: OSLog
    
    private var defaultSession: URLSession?
    private var dataTask: URLSessionDataTask?
    
    private let deviceUrl: String
    private var mediaUrl: String!
    private var ptzUrl: String!
    private var imagingUrl: String?
    
    // MARK: Initilization
    
    /*private override init() {
        logger = OSLog(category: String(describing: type(of: self)))
        
        super.init()
    
        defaultSession = URLSession.init(configuration: .default, delegate: self, delegateQueue: nil);
    }*/
    
    private init(ip: String, port: Int?) {
        self.deviceUrl = "http://\(port != nil ? "\(ip):\(port ?? 80)" : "\(ip)")/onvif/device_service"
        
        logger = OSLog(category: String(describing: type(of: self)))
        
        super.init()
    
        defaultSession = URLSession.init(configuration: .default, delegate: self, delegateQueue: nil);
    }
    
    // MARK: Class methods
    
    public class func create(ip: String, port: Int? = nil, completionHandler: @escaping (Result<Onvif, Error>) -> Void) {
        let onvif = Onvif(ip: ip, port: port)
        
        /*onvif.getDeviceInformation() { response in
            switch response {
            case .success(let deviceInformation):
                print("")
            case .failure(let error):
                print("")
            }
        }*/
        
        onvif.getCapabilities(category: .all) { response in
            switch response {
            case .success(let capabilities):
                guard capabilities.device != nil,
                      capabilities.media != nil, let mediaUrl = capabilities.media?.xAddr,
                      capabilities.ptz != nil, let ptzUrl = capabilities.ptz?.xAddr else {
                    completionHandler(.failure(DeviceError.missingCapabilities))
                    return
                }
                
                onvif.mediaUrl = mediaUrl
                onvif.ptzUrl = ptzUrl
                onvif.imagingUrl = capabilities.imaging?.xAddr
            
                completionHandler(.success(onvif))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    // MARK: Public methods
    
    // MARK: Device methods
    
    public func getSystemDateAndTime() {
        // post(body: "<tds:GetSystemDateAndTime/>")
    }
    
    public func getCapabilities(category: CapabilitiesCategory, completionHandler: @escaping (Result<Capabilities, Error>) -> Void) {
        post(body: "<tds:GetCapabilities>\(category.rawValue)</tds:GetCapabilities>", uri: deviceUrl) { response in
            switch response {
            case .success(let xml):
                let deserializedCapabilities: Capabilities? = try? xml["Envelope"]["Body"]["GetCapabilitiesResponse"]["Capabilities"].value()
                
                guard let unwrappedCapabilities = deserializedCapabilities else {
                    completionHandler(.failure(OnvifError.parseError))
                    
                    return;
                }
            
                completionHandler(.success(unwrappedCapabilities))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func getDeviceInformation(completionHandler: @escaping (Result<BasicInformation, Error>) -> Void) {
        post(body: "<tds:GetDeviceInformation />", uri: deviceUrl) { response in
            switch response {
            case .success(let xml):
                let deserializedBasicInformation: BasicInformation? = try? xml["Envelope"]["Body"]["GetDeviceInformationResponse"].value()
                
                guard let unwrappedBasicInformation = deserializedBasicInformation else {
                    completionHandler(.failure(OnvifError.parseError))
                    
                    return;
                }
            
                completionHandler(.success(unwrappedBasicInformation))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    // MARK: Media methods
    
    public func getMediaProfiles(completionHandler: @escaping (Result<[MediaProfile], Error>) -> Void) {       
        post(body: "<trt:GetProfiles />", uri: mediaUrl) { response in
            switch response {
            case .success(let xml):
                let deserializedProfiles: [MediaProfile]? = try? xml["Envelope"]["Body"]["GetProfilesResponse"]["Profiles"].value()
                
                guard let unwrappedProfiles = deserializedProfiles else {
                    completionHandler(.failure(OnvifError.parseError))
                    
                    return;
                }
            
                completionHandler(.success(unwrappedProfiles))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }

    }
    
    public func getMediaProfile(profileToken: String, completionHandler: @escaping (Result<MediaProfile, Error>) -> Void) {
        post(body: "<trt:GetProfile><trt:ProfileToken>\(profileToken)</trt:ProfileToken></trt:GetProfile>", uri: mediaUrl) { response in
            switch response {
            case .success(let xml):
                let deserializedProfile: MediaProfile? = try? xml["Envelope"]["Body"]["GetProfileResponse"]["Profile"].value()
                
                guard let unwrappedProfile = deserializedProfile else {
                    completionHandler(.failure(OnvifError.parseError))
                    
                    return;
                }
            
                completionHandler(.success(unwrappedProfile))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func getVideoEncoderConfigurationOptions(profileToken: String?, configurationToken: String?, completionHandler: @escaping (Result<VideoEncoderConfigurationOptions, Error>) -> Void) {
        var profileTokenBody = ""
        var configurationTokenBody = ""
        
        if let profileToken = profileToken {
            profileTokenBody = "<trt:ProfileToken>\(profileToken)</trt:ProfileToken>"
        }
        
        if let configurationToken = configurationToken {
            configurationTokenBody = "<trt:ConfigurationToken>\(configurationToken)</trt:ConfigurationToken>"
        }
        
        post(body: "<trt:GetVideoEncoderConfigurationOptions>\(profileTokenBody)\(configurationTokenBody)</trt:GetVideoEncoderConfigurationOptions>", uri: mediaUrl) { response in
            switch response {
            case .success(let xml):
                let deserializedVideoEncoderConfigurationOptions: VideoEncoderConfigurationOptions? = try? xml["Envelope"]["Body"]["GetVideoEncoderConfigurationOptionsResponse"]["Options"].value()
                
                guard let unwrappedVideoEncoderConfigurationOptions = deserializedVideoEncoderConfigurationOptions else {
                    completionHandler(.failure(OnvifError.parseError))
                    
                    return;
                }
            
                completionHandler(.success(unwrappedVideoEncoderConfigurationOptions))
            break
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func getVideoEncoderConfiguration(configurationToken: String, completionHandler: @escaping (Result<VideoEncoderConfiguration, Error>) -> Void) {
        post(body: "<trt:GetVideoEncoderConfiguration><trt:ConfigurationToken>\(configurationToken)</trt:ConfigurationToken></trt:GetVideoEncoderConfiguration>", uri: mediaUrl) { response in
            switch response {
            case .success(let xml):
                let deserializedVideoEncoderConfiguration: VideoEncoderConfiguration? = try? xml["Envelope"]["Body"]["GetVideoEncoderConfigurationResponse"]["Configuration"].value()
                
                guard let unwrappedVideoEncoderConfiguration = deserializedVideoEncoderConfiguration else {
                    completionHandler(.failure(OnvifError.parseError))
                    
                    return;
                }
            
                completionHandler(.success(unwrappedVideoEncoderConfiguration))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    /*
     string ? aH264Profile = null,
     int? aGovLength = null,
     int? aQuality = null,
     int? aFrameRateLimit = null,
     int? aBitRateLimit = null,
     VideoResolution? aVideoResolution = null)

     */
    
    public func setVideoEncoderConfiguration(configurationToken: String,
                                             quality: Float? = nil,
                                             govLength: Int? = nil,
                                             frameRateLimit: Int? = nil,
                                             bitrateLimit: Int? = nil,
                                             h264Profile: String? = nil,
                                             width: Int? = nil,
                                             height: Int? = nil,
                                             completionHandler: @escaping (Result<Void, Error>) -> Void) {
        getVideoEncoderConfiguration(configurationToken: configurationToken) { response in
            switch response {
            case .success(let videoEncoderConfiguration):
                /*
                 <tt:RateControl>
                     <tt:FrameRateLimit>\(frameRateLimit ?? videoEncoderConfiguration.rateControl?.frameRateLimit)</tt:FrameRateLimit>
                     <tt:EncodingInterval>{videoEncoderConfiguration.RateControl.EncodingInterval}</tt:EncodingInterval>
                     <tt:BitrateLimit>{aBitRateLimit ?? videoEncoderConfiguration.RateControl.BitrateLimit}</tt:BitrateLimit>
                 </tt:RateControl>
                 */
                
                let newWidth = width != nil && height != nil ? width : videoEncoderConfiguration.resolution.width
                let newHeight = width != nil && height != nil ? height : videoEncoderConfiguration.resolution.height
                
                self.post(body: """
                        <trt:SetVideoEncoderConfiguration>
                        <trt:Configuration token="\(configurationToken)">
                            <tt:Name>\(videoEncoderConfiguration.name)</tt:Name>
                            <tt:UseCount>\(videoEncoderConfiguration.useCount)</tt:UseCount>
                            <tt:GuaranteedFrameRate>false</tt:GuaranteedFrameRate>
                            <tt:Encoding>H264</tt:Encoding>
                            <tt:Resolution>
                                <tt:Width>\(newWidth!)</tt:Width>
                                <tt:Height>\(newHeight!)</tt:Height>
                            </tt:Resolution>
                            <tt:Quality>\(quality ?? videoEncoderConfiguration.quality)</tt:Quality>
                            \(videoEncoderConfiguration.rateControl != nil ? """
                                 <tt:RateControl>
                                     <tt:FrameRateLimit>\(frameRateLimit ?? videoEncoderConfiguration.rateControl!.frameRateLimit)</tt:FrameRateLimit>
                                     <tt:EncodingInterval>\(videoEncoderConfiguration.rateControl!.encodingInterval)</tt:EncodingInterval>
                                     <tt:BitrateLimit>\(bitrateLimit ?? videoEncoderConfiguration.rateControl!.bitrateLimit)</tt:BitrateLimit>
                                 </tt:RateControl>
                            """ : "")
                            \(videoEncoderConfiguration.h264 != nil ? """
                                <tt:H264>
                                    <tt:GovLength>\(govLength ?? videoEncoderConfiguration.h264!.govLength)</tt:GovLength>
                                    <tt:H264Profile>\(h264Profile ?? videoEncoderConfiguration.h264!.h264Profile.rawValue)</tt:H264Profile>
                                </tt:H264>
                            """ : "")
                            <tt:Multicast>
                                <tt:Address>
                                    <tt:Type>\(videoEncoderConfiguration.multicast.address.type)</tt:Type>
                                    <tt:IPv4Address>\(videoEncoderConfiguration.multicast.address.ipV4Address!)</tt:IPv4Address>
                                </tt:Address>
                                <tt:Port>\(videoEncoderConfiguration.multicast.port)</tt:Port>
                                <tt:TTL>\(videoEncoderConfiguration.multicast.ttl)</tt:TTL>
                                <tt:AutoStart>\(videoEncoderConfiguration.multicast.autoStart.description.lowercased())</tt:AutoStart>
                            </tt:Multicast>
                            <tt:SessionTimeout>\(videoEncoderConfiguration.sessionTimeout)</tt:SessionTimeout>
                        </trt:Configuration>
                        <trt:ForcePersistence>true</trt:ForcePersistence>
                    </trt:SetVideoEncoderConfiguration>
                """, uri: self.mediaUrl) { response in
                    switch response {
                    case .success(let xml):
                        completionHandler(.success())
                        /*let deserializedVideoEncoderConfiguration: VideoEncoderConfiguration? = try? xml["Envelope"]["Body"]["GetVideoEncoderConfigurationResponse"]["Configuration"].value()
                        
                        guard let unwrappedVideoEncoderConfiguration = deserializedVideoEncoderConfiguration else {
                            completionHandler(.failure(OnvifError.parseError))
                            
                            return;
                        }
                    
                        completionHandler(.success(unwrappedVideoEncoderConfiguration))*/
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func getStreamUri(profileToken: String, completionHandler: @escaping (Result<MediaUri, Error>) -> Void) {
        post(body: """
            <trt:GetStreamUri>
                <trt:StreamSetup>
                    <tt:Stream>RTP-Unicast</tt:Stream>
                    <tt:Transport>
                        <tt:Protocol>RTSP</tt:Protocol>
                    </tt:Transport>
                </trt:StreamSetup>
                <trt:ProfileToken>\(profileToken)</trt:ProfileToken>
            </trt:GetStreamUri>

            """, uri: mediaUrl) { response in
            switch response {
            case .success(let xml):
                let deserializedMediaUri: MediaUri? = try? xml["Envelope"]["Body"]["GetStreamUriResponse"]["MediaUri"].value()
                
                guard let unwrappedMediaUri = deserializedMediaUri else {
                    completionHandler(.failure(OnvifError.parseError))
                    
                    return;
                }
            
                completionHandler(.success(unwrappedMediaUri))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func getSnapshotUri(profileToken: String, completionHandler: @escaping (Result<MediaUri, Error>) -> Void) {
        post(body: """
            <trt:GetSnapshotUri>
                <trt:ProfileToken>\(profileToken)</trt:ProfileToken>
            </trt:GetSnapshotUri>

            """, uri: mediaUrl) { response in
            switch response {
            case .success(let xml):
                let deserializedMediaUri: MediaUri? = try? xml["Envelope"]["Body"]["GetSnapshotUriResponse"]["MediaUri"].value()
                
                guard let unwrappedMediaUri = deserializedMediaUri else {
                    completionHandler(.failure(OnvifError.parseError))
                    
                    return;
                }
            
                completionHandler(.success(unwrappedMediaUri))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    // MARK: PTZ methods
    
    public func getPtzConfiguration(ptzConfigurationToken: String, completionHandler: @escaping (Result<PTZConfiguration, Error>) -> Void) {
        post(body: "<tptz:GetConfiguration><tptz:PTZConfigurationToken>\(ptzConfigurationToken)</tptz:PTZConfigurationToken></tptz:GetConfiguration>", uri: ptzUrl) { response in
            switch response {
            case .success(let xml):
                let deserializedPTZConfiguration: PTZConfiguration? = try? xml["Envelope"]["Body"]["GetConfigurationResponse"]["PTZConfiguration"].value()
                
                guard let unwrappedPTZConfiguration = deserializedPTZConfiguration else {
                    completionHandler(.failure(OnvifError.parseError))
                    
                    return;
                }
            
                completionHandler(.success(unwrappedPTZConfiguration))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
//    public func getPtzPresets(profileToken: String, completionHandler: @escaping (Result<PTZPresets, Error>) -> Void) {
//        post(body: "<tptz:GetPresets><tptz:ProfileToken>\(profileToken)</tptz:ProfileToken></tptz:GetPresets>", uri: ptzUrl) { response in
//            switch response {
//            case .success(let xml):
//                let deserializedPTZConfiguration: PTZConfiguration? = try? xml["Envelope"]["Body"]["GetConfigurationResponse"]["PTZConfiguration"].value()
//
//                guard let unwrappedPTZConfiguration = deserializedPTZConfiguration else {
//                    completionHandler(.failure(OnvifError.parseError))
//
//                    return;
//                }
//
//                completionHandler(.success(unwrappedPTZConfiguration))
//            case .failure(let error):
//                completionHandler(.failure(error))
//            }
//        }
//    }
    
    public func getPtzPreset(profileToken: String, completionHandler: @escaping (Result<[PTZPreset], Error>) -> Void) {
        post(body: "<tptz:GetPresets><tptz:ProfileToken>\(profileToken)</tptz:ProfileToken></tptz:GetPresets>", uri: ptzUrl) { response in
            switch response {
            case .success(let xml):
                let deserializedPresets: [PTZPreset]? = try? xml["Envelope"]["Body"]["GetPresetsResponse"]["Preset"].value()
                
                guard let unwrappedPTZPresets = deserializedPresets else {
                    completionHandler(.failure(OnvifError.parseError))
                    return;
                }
            
                completionHandler(.success(unwrappedPTZPresets))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func setPtzPreset(profileToken: String, presetName: String, presetToken: String, completionHandler: @escaping (Result<String, Error>) -> Void) {
        
        let message = """
            <tptz:SetPreset>
                <tptz:ProfileToken>\(profileToken)</tptz:ProfileToken>
                \(presetName == "" ? "" : "<tptz:PresetName>\(presetName)</tptz:PresetName>")
                \(presetToken == "" ? "" : "<tptz:PresetToken>\(presetToken)</tptz:PresetToken>")
            </tptz:SetPreset>
        """
        
        post(body: message, uri: ptzUrl) { response in
            switch response {
            case .success(let xml):
                let deserializedPTZToken: String? = try? xml["Envelope"]["Body"]["SetPresetResponse"]["PresetToken"].value()
                
                guard let unwrappedPTZToken = deserializedPTZToken else {
                    completionHandler(.failure(OnvifError.parseError))
                    return;
                }
                
                completionHandler(.success(unwrappedPTZToken))
                                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func gotoPtzPreset(profileToken: String, presetToken: String, completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        
        let message = """
            <tptz:GotoPreset>
                <tptz:ProfileToken>\(profileToken)</tptz:ProfileToken>
                <tptz:PresetToken>\(presetToken)</tptz:PresetToken>
            </tptz:GotoPreset>"
        """
        post(body: message, uri: ptzUrl) { response in
            switch response {
            case .success(let xml):
                
                if xml.description.contains("<GotoPresetResponse>") {
                    completionHandler(.success(true));
                } else {
                    completionHandler(.failure(NetworkError.unknownResponse));
                }
            
                completionHandler(.success(true))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func removePtzPreset(profileToken: String, presetToken: String, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        post(body: "<tptz:RemovePreset><tptz:ProfileToken>\(profileToken)</tptz:ProfileToken><tptz:PresetToken>\(presetToken)</tptz:PresetToken></tptz:RemovePreset>", uri: ptzUrl) { response in
            switch response {
            case .success(let xml):
                // <Envelope><Body><ContinuousMoveResponse></ContinuousMoveResponse></Body></Envelope>
                if xml.description.contains("<RemovePresetResponse>") {
                    completionHandler(.success());
                } else {
                    completionHandler(.failure(NetworkError.unknownResponse));
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func getPtzNode(nodeToken: String, completionHandler: @escaping (Result<PTZNode, Error>) -> Void) {
        post(body: "<tptz:GetNode><tptz:NodeToken>\(nodeToken)</tptz:NodeToken></tptz:GetNode>", uri: ptzUrl) { response in
            switch response {
            case .success(let xml):
                let deserializedPTZNode: PTZNode? = try? xml["Envelope"]["Body"]["GetNodeResponse"]["PTZNode"].value()
                
                guard let unwrappedPTZNode = deserializedPTZNode else {
                    completionHandler(.failure(OnvifError.parseError))
                    return;
                }
            
                completionHandler(.success(unwrappedPTZNode))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func getPtzStatus(profileToken: String, completionHandler: @escaping (Result<PTZStatus, Error>) -> Void) {
        post(body: "<tptz:GetStatus><tptz:ProfileToken>\(profileToken)</tptz:ProfileToken></tptz:GetStatus>", uri: ptzUrl) { response in
            switch response {
            case .success(let xml):
                let deserializedPTZStatus: PTZStatus? = try? xml["Envelope"]["Body"]["GetStatusResponse"]["PTZStatus"].value()
                
                guard let unwrappedPTZStatus = deserializedPTZStatus else {
                    completionHandler(.failure(OnvifError.parseError))
                    
                    return;
                }
            
                completionHandler(.success(unwrappedPTZStatus))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func continousMove(profileToken: String, pan: Float?, tilt: Float?, zoom: Float?, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        let panTiltBody = pan != nil && tilt != nil ?
            """
                <tt:PanTilt x="\(pan!)" y="\(tilt!)" />
            """ :
            ""
        
        let zoomBody = zoom != nil ?
            """
                <tt:Zoom x="\(zoom!)" />
            """ :
            ""
        
        let body = """
            <tptz:ContinuousMove>
                <tptz:ProfileToken>\(profileToken)</tptz:ProfileToken>
                <tptz:Velocity>
                    \(panTiltBody)
                    \(zoomBody)
                </tptz:Velocity>
            </tptz:ContinuousMove>
            """
        
        post(body: body, uri: ptzUrl) { response in
            switch response {
            case .success(let xml):
                // <Envelope><Body><ContinuousMoveResponse></ContinuousMoveResponse></Body></Envelope>
                if xml.description.contains("<ContinuousMoveResponse>") {
                    completionHandler(.success());
                } else {
                    completionHandler(.failure(NetworkError.unknownResponse));
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func absoluteMove(profileToken: String, ptzConfigurationToken: String, x: Float?, y: Float?, zoom: Float?, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        getPtzConfiguration(ptzConfigurationToken: ptzConfigurationToken) { response in
            switch response {
            case .success(let ptzConfiguration):
                var panTiltBody = ""
                var zoomBody = ""
                
                if var panTiltX = x, var panTiltY = y {
                    if let min = ptzConfiguration.panTiltLimits?.xRange.min, let max = ptzConfiguration.panTiltLimits?.xRange.max {
                        panTiltX = panTiltX.clamp(min, max)
                    }
                    
                    if let min = ptzConfiguration.panTiltLimits?.yRange.min, let max = ptzConfiguration.panTiltLimits?.yRange.max {
                        panTiltY = panTiltY.clamp(min, max)
                    }
                    
                    panTiltBody =
                        """
                            <tt:PanTilt x="\(panTiltX)" y="\(panTiltY)" />
                        """
                }
                
                if var zoomX = zoom {
                    if let min = ptzConfiguration.zoomLimits?.xRange.min, let max = ptzConfiguration.zoomLimits?.xRange.max {
                        zoomX = zoomX.clamp(min, max)
                    }
                    
                    zoomBody =
                        """
                            <tt:Zoom x="\(zoomX)" />
                        """
                }
                
                let body = """
                    <tptz:AbsoluteMove>
                        <tptz:ProfileToken>\(profileToken)</tptz:ProfileToken>
                        <tptz:Position>
                            \(panTiltBody)
                            \(zoomBody)
                        </tptz:Position>
                    </tptz:AbsoluteMove>
                    """
                
                self.post(body: body, uri: self.ptzUrl) { response in
                    switch response {
                    case .success(let xml):
                        // <Envelope><Body><AbsoluteMoveResponse></AbsoluteMoveResponse></Body></Envelope>
                        if xml.description.contains("<AbsoluteMoveResponse>") {
                            completionHandler(.success());
                        } else {
                            completionHandler(.failure(NetworkError.unknownResponse));
                        }
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    // MARK: Imaging methods
    
    public func getImagingSettings(videoSourceToken: String, completionHandler: @escaping (Result<ImagingSettings, Error>) -> Void) {
        post(body: "<timg:GetImagingSettings><timg:VideoSourceToken>\(videoSourceToken)</timg:VideoSourceToken></timg:GetImagingSettings>", uri: imagingUrl) { response in
            switch response {
            case .success(let xml):
                let deserializedImagingSettings: ImagingSettings? = try? xml["Envelope"]["Body"]["GetImagingSettingsResponse"]["ImagingSettings"].value()
                
                guard let unwrappedImagingSettings = deserializedImagingSettings else {
                    completionHandler(.failure(OnvifError.parseError))
                    
                    return;
                }
            
                completionHandler(.success(unwrappedImagingSettings))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func getImagingOptions(videoSourceToken: String, completionHandler: @escaping (Result<ImagingOptions, Error>) -> Void) {
        post(body: "<timg:GetOptions><timg:VideoSourceToken>\(videoSourceToken)</timg:VideoSourceToken></timg:GetOptions>", uri: imagingUrl) { response in
            switch response {
            case .success(let xml):
                let deserializedImagingOptions: ImagingOptions? = try? xml["Envelope"]["Body"]["GetOptionsResponse"]["ImagingOptions"].value()
                
                guard let unwrappedImagingOptions = deserializedImagingOptions else {
                    completionHandler(.failure(OnvifError.parseError))
                    
                    return;
                }
            
                completionHandler(.success(unwrappedImagingOptions))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func getImagingMoveOptions(videoSourceToken: String, completionHandler: @escaping (Result<MoveOptions, Error>) -> Void) {
        post(body: "<timg:GetMoveOptions><timg:VideoSourceToken>\(videoSourceToken)</timg:VideoSourceToken></timg:GetMoveOptions>", uri: imagingUrl) { response in
            switch response {
            case .success(let xml):
                let deserializedMoveOptions: MoveOptions? = try? xml["Envelope"]["Body"]["GetMoveOptionsResponse"]["MoveOptions"].value()
                
                guard let unwrappedMoveOptions = deserializedMoveOptions else {
                    completionHandler(.failure(OnvifError.parseError))
                    
                    return;
                }
            
                completionHandler(.success(unwrappedMoveOptions))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func setImagingSettings(videoSourceToken: String, brightness: Float? = nil, saturation: Float? = nil, contrast: Float? = nil, sharpness: Float? = nil, focusMode: String? = nil, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        
        getImagingOptions(videoSourceToken: videoSourceToken) { response in
            switch response {
            case .success(let imagingOptions):
                self.post(body: """
                    <timg:SetImagingSettings>
                        <timg:VideoSourceToken>\(videoSourceToken)</timg:VideoSourceToken>
                        <timg:ImagingSettings>
                            \(brightness != nil && imagingOptions.brightness?.min != nil && imagingOptions.brightness?.max != nil ? "<tt:Brightness>\(brightness!.clamp(imagingOptions.brightness!.min, imagingOptions.brightness!.max))</tt:Brightness>" : "")
                            \(saturation != nil && imagingOptions.saturation?.min != nil && imagingOptions.saturation?.max != nil ? "<tt:ColorSaturation>\(saturation!.clamp(imagingOptions.saturation!.min, imagingOptions.saturation!.max))</tt:ColorSaturation>" : "")
                            \(contrast != nil && imagingOptions.contrast?.min != nil && imagingOptions.contrast?.max != nil ? "<tt:Contrast>\(contrast!.clamp(imagingOptions.contrast!.min, imagingOptions.contrast!.max))</tt:Contrast>" : "")
                            \(sharpness != nil && imagingOptions.sharpness?.min != nil && imagingOptions.sharpness?.max != nil ? "<tt:Sharpness>\(sharpness!.clamp(imagingOptions.sharpness!.min, imagingOptions.sharpness!.max))</tt:Sharpness>" : "")
                            \(focusMode != nil && imagingOptions.focus != nil && imagingOptions.focus!.focusModes.contains(focusMode!) ? "<tt:Focus><tt:AutoFocusMode>\(focusMode!)</tt:AutoFocusMode></tt:Focus>" : "")
                        </timg:ImagingSettings>
                    </timg:SetImagingSettings>
                """, uri: self.imagingUrl) { response in
                    switch response {
                    case .success(_):
                        completionHandler(.success())
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
                
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    public func ImagingContinuousMove(videoSourceToken: String, speed: Float, completionHandler: @escaping (Result<Void, Error>) -> Void) {
        post(body: """
            <timg:Move>
                <timg:VideoSourceToken>\(videoSourceToken)</timg:VideoSourceToken>
                <timg:Focus>
                    <tt:Continuous><tt:Speed>\(speed)</tt:Speed></tt:Continuous>
                </timg:Focus>
            </timg:Move>
        """, uri: imagingUrl) { response in
            switch response {
            case .success(_):
                completionHandler(.success())
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    // MARK: Private methods
    
    func post(body: String, uri: String? = nil, completionHandler: @escaping (Result<XMLIndexer, Error>) -> Void) {
        let url = URL(string: uri ?? deviceUrl)!
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.httpBody = (buildHeader() + body + buildFooter()).data(using: .utf8)
        
        dataTask?.cancel()
        
        dataTask = defaultSession?.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil else {
                self.logger.error("Error when posting SOAP request to %s with body %s: %s", url.absoluteString, body, error!.localizedDescription)
                completionHandler(.failure(NetworkError.errorResponse(error: error!)))
                return
            }

            guard data != nil else {
                self.logger.error("Empty response when posting to %s with body %s", url.absoluteString, body)
                completionHandler(.failure(NetworkError.emptyResponse))
                return;
            }
            
            let xml = SWXMLHash.config { config in
                config.shouldProcessNamespaces = true
            }.parse(data!)
            
            self.logger.debug("%s", xml.description)
            
            if xml["Envelope"]["Body"]["Fault"].all.count > 0 {
                let soapFault: SoapFault? = try? xml["Envelope"]["Body"]["Fault"].value()
                
                if (soapFault != nil) {
                    completionHandler(.failure(OnvifError.soapFault(soapFault: soapFault!)))
                } else {
                    completionHandler(.failure(OnvifError.parseError))
                }

                return;
            } else if xml["Envelope"]["Body"].all.count > 0 {
                
                completionHandler(.success(xml))
                
                return
            } else {
                completionHandler(.failure(NetworkError.unknownResponse))
                
                return
            }
        })
        
        dataTask?.resume()
    }
    
    func buildHeader() -> String {
        return """
            <?xml version=\"1.0\" encoding=\"UTF-8\"?>
            <SOAP-ENV:Envelope
                xmlns:SOAP-ENV="http://www.w3.org/2003/05/soap-envelope"
                xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:tds="http://www.onvif.org/ver10/device/wsdl"
                xmlns:trt="http://www.onvif.org/ver10/media/wsdl"
                xmlns:tptz="http://www.onvif.org/ver20/ptz/wsdl"
                xmlns:timg="http://www.onvif.org/ver20/imaging/wsdl"
                xmlns:tt="http://www.onvif.org/ver10/schema">
                <SOAP-ENV:Body>
        """;
    }
    
    func buildFooter() -> String {
        return "</SOAP-ENV:Body></SOAP-ENV:Envelope>";
    }
    
    // MARK: URLSessionTaskDelegate methods
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let authMethod = challenge.protectionSpace.authenticationMethod
        
        guard authMethod == NSURLAuthenticationMethodHTTPDigest else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        
        let credential = URLCredential(user: "api", password: "cyz2sheipq0rLwR4", persistence: .forSession)
        
        completionHandler(.useCredential, credential)
    }
}
