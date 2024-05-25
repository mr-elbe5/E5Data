/*
 Maps For OSM
 App for display and use of OSM maps without MapKit
 Copyright: Michael Rönnau mr@elbe5.de
 */

import Foundation

extension CGRect{
    
    public func scaleBy(_ scale: CGFloat) -> CGRect{
        CGRect(origin: CGPoint(x: origin.x*scale, y: origin.y*scale), size: CGSize(width: size.width*scale, height: size.height*scale))
    }
    
    public func scaleCenteredBy(_ scale: CGFloat) -> CGRect{
        CGRect(origin: CGPoint(x: origin.x + size.width/2 - size.width*scale/2, y: origin.y + size.height/2 - size.height*scale/2), size: CGSize(width: size.width*scale, height: size.height*scale))
    }
    
    public func expandBy(size: CGSize) -> CGRect{
        CGRect(origin: CGPoint(x: origin.x - size.width, y: origin.y - size.height), size: CGSize(width: size.width + 2*size.width, height: size.height + 2*size.height))
    }
    
}