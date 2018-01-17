//
//  Coord.swift
//
//  Created by Ranjith on 1/17/18.
//  Copyright (c) . All rights reserved.
//

import Foundation
import SwiftyJSON

public struct Coord {

  // MARK: Declaration for string constants to be used to decode and also serialize.
  private struct SerializationKeys {
    static let lon = "lon"
    static let lat = "lat"
  }

  // MARK: Properties
  public var lon: Float?
  public var lat: Float?

  // MARK: SwiftyJSON Initializers
  /// Initiates the instance based on the object.
  ///
  /// - parameter object: The object of either Dictionary or Array kind that was passed.
  /// - returns: An initialized instance of the class.
  public init(object: Any) {
    self.init(json: JSON(object))
  }

  /// Initiates the instance based on the JSON that was passed.
  ///
  /// - parameter json: JSON object from SwiftyJSON.
  public init(json: JSON) {
    lon = json[SerializationKeys.lon].float
    lat = json[SerializationKeys.lat].float
  }

  /// Generates description of the object in the form of a NSDictionary.
  ///
  /// - returns: A Key value pair containing all valid values in the object.
  public func dictionaryRepresentation() -> [String: Any] {
    var dictionary: [String: Any] = [:]
    if let value = lon { dictionary[SerializationKeys.lon] = value }
    if let value = lat { dictionary[SerializationKeys.lat] = value }
    return dictionary
  }

}
