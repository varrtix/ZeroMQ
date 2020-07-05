//
//  ZeroMQ.swift
//  ZeroMQ
//
//  Created by Darcy Chiu on 2020/7/5.
//  Copyright © 2020 VARRTIX. All rights reserved.
//

import Foundation

/// The main abstraction for ZeroMQ to prevent name collisions with unrelated libraries.
public struct ZeroMQ {
  
  /// A private initialization to prevent instantion.
  private init() {}
  
  /// Version of the libzmq Low-level API.
  public static var zmqVersion: String { "4.3.2" }
  
  /// Version of this framework.
  public static var framewrokVersion: String {
    Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
  }
}
