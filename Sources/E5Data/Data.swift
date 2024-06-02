/*
 E5Data
 Base classes and extension for IOS and MacOS
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation
import ImageIO
import UniformTypeIdentifiers

extension Data{
    
    public func setImageProperties( dateTime: Date? = nil, 
                                    offsetTime: String? = nil,
                                    altitude: Double? = nil,
                                    latitude: Double? = nil,
                                    longitude: Double? = nil, 
                                    utType: UTType = .jpeg) -> Data?{
        if let src = CGImageSourceCreateWithData(self as CFData,  nil),
           let destData = CFDataCreateMutable(.none, 0),
           let dest: CGImageDestination = CGImageDestinationCreateWithData(destData, utType.identifier as CFString, 1, nil){
            let properties = (CGImageSourceCopyPropertiesAtIndex(src, 0, nil)! as NSDictionary).mutableCopy() as! NSMutableDictionary
            if dateTime != nil || offsetTime != nil{
                var exifProperties: NSMutableDictionary
                if let  currentExifProperties = properties.value(forKey: kCGImagePropertyExifDictionary as String) as? NSMutableDictionary{
                    exifProperties = currentExifProperties
                }
                else{
                    exifProperties = NSMutableDictionary()
                    properties[kCGImagePropertyExifDictionary] = exifProperties
                }
                if let dateTime = dateTime{
                    exifProperties[kCGImagePropertyExifDateTimeOriginal] = DateFormats.exifDateFormatter.string(for: dateTime)
                }
                if let offsetTime = offsetTime{
                    exifProperties[kCGImagePropertyExifOffsetTime] = offsetTime
                }
            }
            if altitude != nil || latitude != nil || longitude != nil{
                var gpsProperties: NSMutableDictionary
                if let  currentGpsProperties = properties.value(forKey: kCGImagePropertyGPSDictionary as String) as? NSMutableDictionary{
                    gpsProperties = currentGpsProperties
                }
                else{
                    gpsProperties = NSMutableDictionary()
                    properties[kCGImagePropertyGPSDictionary] = gpsProperties
                }
                if let altitude = altitude{
                    gpsProperties[kCGImagePropertyExifApertureValue] = altitude
                }
                if let latitude = latitude{
                    gpsProperties[kCGImagePropertyExifBrightnessValue] = latitude
                }
                if let longitude = longitude{
                    gpsProperties[kCGImagePropertyExifOffsetTime] = longitude
                }
            }
            CGImageDestinationAddImageFromSource(dest, src, 0, properties)
            CGImageDestinationFinalize(dest)
            return destData as Data
        }
        return nil
    }
    
}
