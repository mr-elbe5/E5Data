/*
 E5Data
 Base classes and extension for IOS and MacOS
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import ImageIO
import UniformTypeIdentifiers

open class ImageMetaData: NSObject, Codable {
    
    public static var exifDateFormatter : DateFormatter{
        get{
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = .none
            dateFormatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
            return dateFormatter
        }
    }
    
    public enum CodingKeys: String, CodingKey {
        case width
        case height
        case orientation
        case aperture
        case brightness
        case dateTime
        case offsetTime
        case cameraModel
        case altitude
        case latitude
        case longitude
    }
    
    public var width: Int = 0
    public var height: Int = 0
    public var orientation: Int = 0
    public var aperture: String?
    public var brightness: String?
    public var dateTime: Date?
    public var offsetTime: String?
    public var cameraModel: String?
    public var altitude: Double?
    public var latitude: Double?
    public var longitude: Double?
    
    public init(url: URL) {
        super.init()
        if let data = NSData(contentsOf: url) {
            self.readData(data: data)
        }
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        width = try values.decodeIfPresent(Int.self, forKey: .width) ?? 0
        height = try values.decodeIfPresent(Int.self, forKey: .height) ?? 0
        orientation = try values.decodeIfPresent(Int.self, forKey: .orientation) ?? 0
        aperture = try values.decodeIfPresent(String.self, forKey: .aperture)
        brightness = try values.decodeIfPresent(String.self, forKey: .brightness)
        dateTime = try values.decodeIfPresent(Date.self, forKey: .dateTime)
        offsetTime = try values.decodeIfPresent(String.self, forKey: .offsetTime)
        cameraModel = try values.decodeIfPresent(String.self, forKey: .cameraModel)
        altitude = try values.decodeIfPresent(Double.self, forKey: .altitude)
        latitude = try values.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try values.decodeIfPresent(Double.self, forKey: .longitude)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(orientation, forKey: .orientation)
        try container.encode(aperture, forKey: .aperture)
        try container.encode(brightness, forKey: .brightness)
        try container.encode(dateTime, forKey: .dateTime)
        try container.encode(offsetTime, forKey: .offsetTime)
        try container.encode(cameraModel, forKey: .cameraModel)
        try container.encode(altitude, forKey: .altitude)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
   
    private var dictionary: [String: Any] {
        return [
            "width": width,
            "height": height,
            "orientation": orientation,
            "aperture": aperture as Any,
            "brightness": brightness as Any,
            "dateTime": dateTime as Any,
            "offsetTime": offsetTime as Any,
            "cameraModel": cameraModel as Any,
            "altitude": altitude as Any,
            "latitude": latitude as Any,
            "longitude": longitude as Any,
        ]
    }
    
    public var toDictionary: NSDictionary {
        return dictionary as NSDictionary
    }
    
    private func readData(data: CFData) {
        let options = [kCGImageSourceShouldCache as String: kCFBooleanFalse]
        
        if let imgSrc = CGImageSourceCreateWithData(data, options as CFDictionary) {
            if let metadata: NSDictionary = CGImageSourceCopyPropertiesAtIndex(imgSrc, 0, options as CFDictionary){
                self.width = Int(metadata[kCGImagePropertyPixelWidth] as? Double ?? 0)
                self.height = Int(metadata[kCGImagePropertyPixelHeight] as? Double ?? 0)
                if let tiffData = metadata[kCGImagePropertyTIFFDictionary] as? NSDictionary {
                    self.cameraModel = tiffData[kCGImagePropertyTIFFModel] as? String
                }
                if let exifData = metadata[kCGImagePropertyExifDictionary] as? NSDictionary {
                    self.aperture = exifData[kCGImagePropertyExifApertureValue] as? String
                    self.brightness = exifData[kCGImagePropertyExifBrightnessValue] as? String
                    self.dateTime = ImageMetaData.exifDateFormatter.date(from: exifData[kCGImagePropertyExifDateTimeOriginal] as? String ?? "")
                    self.offsetTime = exifData[kCGImagePropertyExifOffsetTime] as? String
                }
                
                if let gpsData = metadata[kCGImagePropertyGPSDictionary] as? NSDictionary {
                    self.altitude = gpsData[kCGImagePropertyGPSAltitude] as? Double
                    self.latitude = gpsData[kCGImagePropertyGPSLatitude] as? Double
                    self.longitude = gpsData[kCGImagePropertyGPSLongitude] as? Double
                }
            }
        }
    }
}
