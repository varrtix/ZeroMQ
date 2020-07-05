//
//  ZeroMQ.swift
//  ZeroMQ.swift
//
//  Created by darcychiu on 2020/7/5.
//
//  Copyright (C) 2020 Wei Zhao <tiamo_nana@outlook.com>.
//
//  This file is part of the ZeroMQ.swift library. This library is free
//  software: you can redistribute it and/or modify it under the terms of
//  the GNU General Public License as published by the Free Software Foundation,
//  either version 3 of the License, or (at your option) any later version.
//
//  This library is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with the ZeroMQ.swift.  If not, see <https://www.gnu.org/licenses/>.

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
