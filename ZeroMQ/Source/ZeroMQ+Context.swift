//
//  ZeroMQ+Context.swift
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
  
  /// The ØMQ context keeps the list of sockets and manages the async I/O thread and internal queries.
  /// Before using any ØMQ library functions you must create a ØMQ context.
  /// When you exit your application you should destroy the context.
  /// and the deinit will try to destroy the context.
  final class Context {
    
    typealias OptionCode = Int32
    
    /// It is the newly created context if initialization is successful.
    private var context: UnsafeMutableRawPointer?
    
    /// create new ØMQ context.
    /// - Throws: It shall throws an `ZeroMQError`
    /// - A ØMQ context is thread safe and may be shared among as many application threads as necessary,
    /// without any additional locking required on the part of the caller.
    init() throws {
      context = zmq_ctx_new()
      
      guard context != nil else { throw ZeroMQError.underlyError }
      
    }
    
    deinit { try? destroy() }
    
    func destroy() throws {
      guard let context = context else {
        throw ZeroMQError.ContextReason.invalidContext.underlyError
      }
      
      guard zmq_ctx_destroy(context) == 0 else {
        throw ZeroMQError.underlyError
      }
      self.context = nil
    }
    
    /// Get context options. The function shall return the option specified by the `option` argument.
    /// - Parameter option: option names
    /// - Returns: The value is 0 or greater. it depends on the `option` argument.
    func get(_ option: inout ContextOption) throws {
      let value = Int(zmq_ctx_get(context, option.code))
      guard value > 0 else { throw ZeroMQError.underlyError }
      
      switch option {
        case .ioThreads(_): option = .ioThreads(value)
        case .maxSockets(_): option = .maxSockets(value)
        case .maxMessageSize(_): option = .maxMessageSize(value)
        case .socketLimit(_): option = .socketLimit(value)
        case .ipv6(_): option = .ipv6(value == 1 ? true : false)
        case .blocky(_): option = .blocky(value == 1 ? true : false)
        case .threadSchedPolicy(_): option = .threadSchedPolicy(value)
        case .threadNamePrefix(_): option = .threadNamePrefix(value)
        case .runtimeMessageSize(_): option = .runtimeMessageSize(value)
      }
    }
    
    func set(for option: ContextOption) throws {
      let code: Int32
      switch option {
        case .ioThreads(let num):
          code = zmq_ctx_set(context, option.code, Int32(num))
        case .maxSockets(let max):
          code = zmq_ctx_set(context, option.code, Int32(max))
        case .maxMessageSize(let size):
          code = zmq_ctx_set(context, option.code, Int32(size))
        case .socketLimit(let limit):
          code = zmq_ctx_set(context, option.code, Int32(limit))
        case .ipv6(let enabled):
          code = zmq_ctx_set(context, option.code, enabled == true ? 1 : 0)
        case .blocky(let enabled):
          code = zmq_ctx_set(context, option.code, enabled == true ? 1 : 0)
        case .threadSchedPolicy(let policy):
          code = zmq_ctx_set(context, option.code, Int32(policy))
        case .threadNamePrefix(let num):
          code = zmq_ctx_set(context, option.code, Int32(num))
        case .runtimeMessageSize(let size):
          code = zmq_ctx_set(context, option.code, Int32(size))
      }
      
      guard code == 0 else { throw ZeroMQError.underlyError }
    }
  }
}

public extension ZeroMQ.Context {
  
  /// The available options for the context using function `get()` or `set()`.
  enum ContextOption {
    // Get number of I/O threads
    case ioThreads(Int)
    // Get maximum number of sockets
    case maxSockets(Int)
    // Get maximum message size
    case maxMessageSize(Int)
    // Get message decoding strategy
    //    case messageDecodingStrategy
    // Get largest configurable number of sockets
    case socketLimit(Int)
    // Set IPv6 option
    case ipv6(Bool)
    // Get blocky setting
    case blocky(Bool)
    // Get scheduling policy for I/O threads
    case threadSchedPolicy(Int)
    // Get name prefix for I/O threads
    case threadNamePrefix(Int)
    // Get the zmq_msg_t size at runtime
    case runtimeMessageSize(Int)

    var code: OptionCode {
      switch self {
        // The ZMQ_IO_THREADS argument returns the size of the ØMQ thread pool
        // for this context.
        case .ioThreads: return ZMQ_IO_THREADS
        // The ZMQ_MAX_SOCKETS argument returns the maximum number of sockets
        // allowed for this context.
        case .maxSockets: return ZMQ_MAX_SOCKETS
        // The ZMQ_MAX_MSGSZ argument returns the maximum size of a message
        // allowed for this context. Default value is INT_MAX.
        case .maxMessageSize: return ZMQ_MAX_MSGSZ
        //        case .messageDecodingStrategy:
        // The ZMQ_SOCKET_LIMIT argument returns the largest number of sockets
        // that `set()` will accept.
        case .socketLimit: return ZMQ_SOCKET_LIMIT
        // The ZMQ_IPV6 argument returns the IPv6 option for the context.
        case .ipv6: return ZMQ_IPV6
        // The ZMQ_BLOCKY argument returns 1 if the context will block on terminate,
        // zero if the "block forever on context termination" gambit was disabled
        // by setting ZMQ_BLOCKY to false on all new contexts.
        case .blocky: return ZMQ_BLOCKY
        // The ZMQ_THREAD_SCHED_POLICY argument returns the scheduling policy
        // for internal context's thread pool.
        case .threadSchedPolicy: return ZMQ_THREAD_SCHED_POLICY
        // The ZMQ_THREAD_NAME_PREFIX argument gets the numeric prefix of
        // each thread created for the internal context's thread pool.
        case .threadNamePrefix: return ZMQ_THREAD_NAME_PREFIX
        // The ZMQ_MSG_T_SIZE argument returns the size of the zmq_msg_t structure
        // at runtime, as defined in the include/zmq.h public header.
        // This is useful for example for FFI bindings that can't simply do a sizeof().
        case .runtimeMessageSize: return ZMQ_MSG_T_SIZE
      }
    }
  }
}
