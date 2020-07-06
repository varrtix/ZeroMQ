//
//  ZeroMQ+Error.swift
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

public extension ZeroMQ {
  
  struct ZeroMQError: Error {
    
    public typealias Code = Int32
    
    let localizedDescription: String

    init(code: Code? = nil) {
      guard let errorCString = zmq_strerror(code ?? ZeroMQError.code) else {
        localizedDescription = ""
        return
      }
      localizedDescription = String(cString: errorCString)
    }
    
    static var code: Code { zmq_errno() }
    
    static var underlyError: ZeroMQError { ZeroMQError() }
    
    public enum ContextReason {
      case invalidContext
      case interrupted
    }
  }
}

public extension ZeroMQ.ZeroMQError.ContextReason {
  
  var code: ZeroMQ.ZeroMQError.Code {
    switch self {
      case .invalidContext: return EFAULT
      case .interrupted: return EINTR
    }
  }
  
  var underlyError: ZeroMQ.ZeroMQError {
    ZeroMQ.ZeroMQError(code: code)
  }
  
  var localizedDescription: String {
    switch self {
      case .invalidContext:
      return "The provided context was invalid."
      case .interrupted:
      return "Termination was interrupted by a signal. It can be restarted if needed."
    }
  }
}
