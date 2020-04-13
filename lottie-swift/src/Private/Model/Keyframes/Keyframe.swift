//
//  Keyframe.swift
//  lottie-swift
//
//  Created by Brandon Withrow on 1/7/19.
//

import Foundation
import CoreGraphics

/**
 Keyframe represents a point in time and is the container for datatypes.
 Note: This is a parent class and should not be used directly.
 */
public struct Keyframe<T: Interpolatable> {
  
  /// The value of the keyframe
  public var value: T
  /// The time in frames of the keyframe.
  public var time: CGFloat
  /// A hold keyframe freezes interpolation until the next keyframe that is not a hold.
  public var isHold: Bool
  /// The in tangent for the time interpolation curve.
  public var inTangent: Vector2D?
  /// The out tangent for the time interpolation curve.
  public var outTangent: Vector2D?
  
  /// The spacial in tangent of the vector.
  public var spatialInTangent: Vector3D?
  /// The spacial out tangent of the vector.
  public var spatialOutTangent: Vector3D?
  
  /// Initialize a value-only keyframe with no time data.
  public init(_ value: T,
       spatialInTangent: Vector3D? = nil,
       spatialOutTangent: Vector3D? = nil) {
    self.value = value
    self.time = 0
    self.isHold = true
    self.inTangent = nil
    self.outTangent = nil
    self.spatialInTangent = spatialInTangent
    self.spatialOutTangent = spatialOutTangent
  }
  
  /// Initialize a keyframe
  public init(value: T,
       time: Double,
       isHold: Bool,
       inTangent: Vector2D?,
       outTangent: Vector2D?,
       spatialInTangent: Vector3D? = nil,
       spatialOutTangent: Vector3D? = nil) {
    self.value = value
    self.time = CGFloat(time)
    self.isHold = isHold
    self.outTangent = outTangent
    self.inTangent = inTangent
    self.spatialInTangent = spatialInTangent
    self.spatialOutTangent = spatialOutTangent
  }
  
}

/**
 A generic struct used to parse and remap keyframe json.
 
 Keyframe json has a couple of different variations and formats depending on the
 type of keyframea and also the version of the JSON. By parsing the raw data
 we can reconfigure it into a constant format.
 */
public struct KeyframeData<T: Codable>: Codable {
  
  /// The start value of the keyframe
  public var startValue: T?
  /// The End value of the keyframe. Note: Newer versions animation json do not have this field.
  public var endValue: T?
  /// The time in frames of the keyframe.
  public var time: Double?
  /// A hold keyframe freezes interpolation until the next keyframe that is not a hold.
  public var hold: Int?
  
  /// The in tangent for the time interpolation curve.
  public var inTangent: Vector2D?
  /// The out tangent for the time interpolation curve.
  public var outTangent: Vector2D?
  
  /// The spacial in tangent of the vector.
  public var spatialInTangent: Vector3D?
  /// The spacial out tangent of the vector.
  public var spatialOutTangent:Vector3D?
  
  init(startValue: T?,
       endValue: T?,
       time: Double?,
       hold: Int?,
       inTangent: Vector2D?,
       outTangent: Vector2D?,
       spatialInTangent: Vector3D?,
       spatialOutTangent: Vector3D?) {
    self.startValue = startValue
    self.endValue = endValue
    self.time = time
    self.hold = hold
    self.inTangent = inTangent
    self.outTangent = outTangent
    self.spatialInTangent = spatialInTangent
    self.spatialOutTangent = spatialOutTangent
  }
  
  enum CodingKeys : String, CodingKey {
    case startValue = "s"
    case endValue = "e"
    case time = "t"
    case hold = "h"
    case inTangent = "i"
    case outTangent = "o"
    case spatialInTangent = "ti"
    case spatialOutTangent = "to"
  }
  
  var isHold: Bool {
    if let hold = hold {
      return hold > 0
    }
    return false
  }
}
