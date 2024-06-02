/*
 E5Data
 Base classes and extension for IOS and MacOS
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import ImageIO
import UniformTypeIdentifiers
import CoreLocation

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
    
    public var width: Double?
    public var height: Double?
    public var orientation: Int?
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
            self.readData(data: data as Data)
        }
    }
    
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        width = try values.decodeIfPresent(Double.self, forKey: .width)
        height = try values.decodeIfPresent(Double.self, forKey: .height)
        orientation = try values.decodeIfPresent(Int.self, forKey: .orientation)
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
   
    public var dictionary: NSDictionary {
        return [
            kCGImagePropertyPixelWidth: width as Any,
            kCGImagePropertyPixelHeight: height as Any,
            kCGImagePropertyOrientation: orientation as Any,
            kCGImagePropertyExifDictionary : [
                kCGImagePropertyExifApertureValue: aperture as Any,
                kCGImagePropertyExifBrightnessValue: brightness as Any,
                kCGImagePropertyExifApertureValue: dateTime as Any,
                kCGImagePropertyExifOffsetTime: offsetTime as Any
            ],
            kCGImagePropertyTIFFDictionary : [
                kCGImagePropertyTIFFModel: cameraModel
            ],
            kCGImagePropertyGPSDictionary : [
                kCGImagePropertyGPSAltitude: altitude as Any,
                kCGImagePropertyGPSLatitude: latitude as Any,
                kCGImagePropertyGPSLongitude: longitude as Any
            ]
        ]
    }
    
    public var coordinate: CLLocationCoordinate2D?{
        if let latitude = latitude, let longitude = longitude{
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        return nil
    }
    
    public func readData(data: Data) {
        let options = [kCGImageSourceShouldCache as String: kCFBooleanFalse]
        if let imgSrc = CGImageSourceCreateWithData(data as CFData, options as CFDictionary) {
            if let metadata: NSDictionary = CGImageSourceCopyPropertiesAtIndex(imgSrc, 0, options as CFDictionary){
                readDictionary(dict: metadata)
            }
        }
    }
    
    public func readDictionary(dict: NSDictionary) {
        self.width = dict[kCGImagePropertyPixelWidth] as? Double
        self.height = dict[kCGImagePropertyPixelHeight] as? Double
        self.orientation = dict[kCGImagePropertyOrientation] as? Int
        if let tiffData = dict[kCGImagePropertyTIFFDictionary] as? NSDictionary {
            self.cameraModel = tiffData[kCGImagePropertyTIFFModel] as? String
        }
        if let exifData = dict[kCGImagePropertyExifDictionary] as? NSDictionary {
            self.aperture = exifData[kCGImagePropertyExifApertureValue] as? String
            self.brightness = exifData[kCGImagePropertyExifBrightnessValue] as? String
            self.dateTime = ImageMetaData.exifDateFormatter.date(from: exifData[kCGImagePropertyExifDateTimeOriginal] as? String ?? "")
            self.offsetTime = exifData[kCGImagePropertyExifOffsetTime] as? String
        }
        if let gpsData = dict[kCGImagePropertyGPSDictionary] as? NSDictionary {
            self.altitude = gpsData[kCGImagePropertyGPSAltitude] as? Double
            self.latitude = gpsData[kCGImagePropertyGPSLatitude] as? Double
            self.longitude = gpsData[kCGImagePropertyGPSLongitude] as? Double
        }
    }
    
    public func writeDictionary(dict: NSMutableDictionary) {
        if let width = width{
            dict[kCGImagePropertyPixelWidth] = width
        }
        if let height = height{
            dict[kCGImagePropertyPixelHeight] = height
        }
        if cameraModel != nil{
            var tiffDict: NSMutableDictionary
            if let  currentTiffDict = dict.value(forKey: kCGImagePropertyTIFFDictionary as String) as? NSMutableDictionary{
                tiffDict = currentTiffDict
            }
            else{
                tiffDict = NSMutableDictionary()
                dict[kCGImagePropertyTIFFDictionary] = tiffDict
            }
            tiffDict[kCGImagePropertyTIFFModel] = cameraModel
        }
        if aperture != nil || brightness != nil || dateTime != nil || offsetTime != nil{
            var exifDict: NSMutableDictionary
            if let  currentExifDict = dict.value(forKey: kCGImagePropertyExifDictionary as String) as? NSMutableDictionary{
                exifDict = currentExifDict
            }
            else{
                exifDict = NSMutableDictionary()
                dict[kCGImagePropertyExifDictionary] = exifDict
            }
            if let aperture = aperture{
                exifDict[kCGImagePropertyExifApertureValue] = aperture
            }
            if let brightness = brightness{
                exifDict[kCGImagePropertyExifBrightnessValue] = brightness
            }
            if let dateTime = dateTime{
                exifDict[kCGImagePropertyExifDateTimeOriginal] = ImageMetaData.exifDateFormatter.string(for: dateTime)
            }
            if let offsetTime = offsetTime{
                exifDict[kCGImagePropertyExifOffsetTime] = offsetTime
            }
        }
        if altitude != nil || latitude != nil || longitude != nil{
            var gpsDict: NSMutableDictionary
            if let  currentGpsDict = dict.value(forKey: kCGImagePropertyGPSDictionary as String) as? NSMutableDictionary{
                gpsDict = currentGpsDict
            }
            else{
                gpsDict = NSMutableDictionary()
                dict[kCGImagePropertyGPSDictionary] = gpsDict
            }
            if let altitude = altitude{
                gpsDict[kCGImagePropertyExifApertureValue] = altitude
            }
            if let latitude = latitude{
                gpsDict[kCGImagePropertyExifBrightnessValue] = latitude
            }
            if let longitude = longitude{
                gpsDict[kCGImagePropertyExifOffsetTime] = longitude
            }
        }
    }
    
    public func getImageSource(data: Data) -> CGImageSource?{
        CGImageSourceCreateWithData(data as CFData,  nil)
    }
    
    public func readSourceProperties(source: CGImageSource) -> NSMutableDictionary{
        let srcProperties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil)! as NSDictionary
        readDictionary(dict: srcProperties)
        return srcProperties.mutableCopy() as! NSMutableDictionary
    }
    
    public func createImageDestination(src: CGImageSource, destProperties: NSMutableDictionary, utType: UTType) -> Data?{
        if let destData = CFDataCreateMutable(.none, 0), let dest: CGImageDestination = CGImageDestinationCreateWithData(destData, utType.identifier as CFString, 1, nil){
            CGImageDestinationAddImageFromSource(dest, src, 0, destProperties)
            CGImageDestinationFinalize(dest)
            return destData as Data
        }
        return nil
    }
    
    public func getDataWithCoordinate(from data: Data, coordinate: CLLocationCoordinate2D, utType: UTType) -> Data?{
        if let src = getImageSource(data: data){
            let properties = readSourceProperties(source: src)
            self.longitude = coordinate.longitude
            self.latitude = coordinate.latitude
            writeDictionary(dict: properties)
            return createImageDestination(src: src, destProperties: properties, utType: utType)
        }
        return nil
    }
    
    public func getDataWithLocation(from data: Data, location: CLLocation, utType: UTType) -> Data?{
        if let src = getImageSource(data: data){
            let properties = readSourceProperties(source: src)
            self.longitude = location.coordinate.longitude
            self.latitude = location.coordinate.latitude
            self.altitude = location.altitude
            writeDictionary(dict: properties)
            return createImageDestination(src: src, destProperties: properties, utType: utType)
        }
        return nil
    }
    
}
