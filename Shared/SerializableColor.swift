//
//  SerializableColor.swift
//  TimeSince
//
//  Created by Ryan on 13/11/2023.
//

import Foundation
import struct CoreGraphics.CGFloat
import class CoreGraphics.CGColor
import class CoreGraphics.CGColorSpace

#if os(macOS)

import class AppKit.NSColor
import struct SwiftUI.Color

#else

import class UIKit.UIColor
import struct SwiftUI.Color

#endif



public class SerializableColor: NSObject, NSCoding, NSSecureCoding, Codable {
  public static var supportsSecureCoding: Bool = true
  
  public enum SerializableColorSpace: Int {
    case sRGB = 0
    case displayP3 = 1
  }
    
    required public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            colorSpace = SerializableColorSpace(rawValue: try container.decode(Int.self, forKey: .colorSpace)) ?? .sRGB
            r = try container.decode(Float.self, forKey: .red)
            g = try container.decode(Float.self, forKey: .green)
            b = try container.decode(Float.self, forKey: .blue)
            a = try container.decode(Float.self, forKey: .alpha)
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(colorSpace.rawValue, forKey: .colorSpace)
            try container.encode(r, forKey: .red)
            try container.encode(g, forKey: .green)
            try container.encode(b, forKey: .blue)
            try container.encode(a, forKey: .alpha)
        }

        private enum CodingKeys: String, CodingKey {
            case colorSpace = "colorSpace"
            case red = "red"
            case green = "green"
            case blue = "blue"
            case alpha = "alpha"
        }
  
  let colorSpace: SerializableColorSpace
  let r: Float
  let g: Float
  let b: Float
  let a: Float
    
    public override var description: String {
        return "\(colorSpace) \(String(format: "%.3f", r)) \(String(format: "%.3f", g)) \(String(format: "%.3f", b)) \(String(format: "%.3f", a))"
    }
  
  public func encode(with coder: NSCoder) {
    coder.encode(colorSpace.rawValue, forKey: "colorSpace")
    coder.encode(r, forKey: "red")
    coder.encode(g, forKey: "green")
    coder.encode(b, forKey: "blue")
    coder.encode(a, forKey: "alpha")
  }
  
  required public init?(coder: NSCoder) {
    colorSpace = SerializableColorSpace(rawValue: coder.decodeInteger(forKey: "colorSpace")) ?? .sRGB
    r = coder.decodeFloat(forKey: "red")
    g = coder.decodeFloat(forKey: "green")
    b = coder.decodeFloat(forKey: "blue")
    a = coder.decodeFloat(forKey: "alpha")
  }
  
  init(colorSpace: SerializableColorSpace, red: Float, green: Float, blue: Float, alpha: Float) {
    self.colorSpace = colorSpace
    self.r = red
    self.g = green
    self.b = blue
    self.a = alpha
  }
  
  convenience init(from cgColor: CGColor) {
    var colorSpace: SerializableColorSpace = .sRGB
    var components: [Float] = [0, 0, 0, 0]
    
    // Transform the color into sRGB space
    if cgColor.colorSpace?.name == CGColorSpace.displayP3 {
      if let p3components = cgColor.components?.map({ Float($0) }),
         cgColor.numberOfComponents == 4 {
        colorSpace = .displayP3
        components = p3components
      }
    } else {
      if let sRGB = CGColorSpace(name: CGColorSpace.sRGB),
         let sRGBColor = cgColor.converted(to: sRGB, intent: .defaultIntent, options: nil),
         let sRGBcomponents = sRGBColor.components?.map({ Float($0) }),
         sRGBColor.numberOfComponents == 4 {
        components = sRGBcomponents
      }
    }
    self.init(colorSpace: colorSpace, red: components[0], green: components[1], blue: components[2], alpha: components[3])
  }
    
  
    #if os(macOS)

    convenience init(from color: Color) {
      self.init(from: NSColor(color))
    }

    convenience init(from nsColor: NSColor) {
      self.init(from: nsColor.cgColor)
    }

    var cgColor: CGColor {
      return nsColor.cgColor
    }

    var color: Color {
        return Color(self.nsColor)
    }

    var nsColor: NSColor {
      if colorSpace == .displayP3 {
        return NSColor(displayP3Red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
      } else {
        return NSColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
      }
    }

    #else
    
    
      convenience init(from color: Color) {
        self.init(from: UIColor(color))
      }
      
      convenience init(from uiColor: UIColor) {
        self.init(from: uiColor.cgColor)
      }
      
      var cgColor: CGColor {
        return uiColor.cgColor
      }
      
      var color: Color {
        return Color(self.uiColor)
      }
      
      var uiColor: UIColor {
        if colorSpace == .displayP3 {
          return UIColor(displayP3Red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
        } else {
          return UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
        }
      }
    
    #endif
    

}

// MARK: Transformer Class
// For CoreData compatibility.


@objc(SerializableColorTransformer)
class SerializableColorTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass {
        return SerializableColor.self
    }

    override class func allowsReverseTransformation() -> Bool {
        return true
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let color = value as? SerializableColor else { return nil }
        do {
            return try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: true)
        } catch {
            print("Error: \(error)")
            return nil
        }
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else { return nil }
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: SerializableColor.self, from: data)
        } catch {
            print("Error: \(error)")
            return nil
        }
    }
}
