// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
import SwiftFoundation
#else
import Foundation
#endif

/*!
    @enum URLCredential.Persistence
    @abstract Constants defining how long a credential will be kept around
    @constant URLCredential.Persistence.none This credential won't be saved.
    @constant URLCredential.Persistence.forSession This credential will only be stored for this session.
    @constant URLCredential.Persistence.permanent This credential will be stored permanently. Note: Whereas in Mac OS X any application can access any credential provided the user gives permission, in iPhone OS an application can access only its own credentials.
    @constant URLCredential.Persistence.synchronizable This credential will be stored permanently. Additionally, this credential will be distributed to other devices based on the owning AppleID.
        Note: Whereas in Mac OS X any application can access any credential provided the user gives permission, on iOS an application can 
        access only its own credentials.
*/
extension URLCredential {
    public enum Persistence : UInt, Sendable {
        case none = 0
        case forSession = 1
        case permanent = 2
        
        @available(*, deprecated, message: "Synchronizable credential storage is not available in swift-corelibs-foundation. If you rely on synchronization for your functionality, please audit your code.")
        case synchronizable = 3
        
        // Wraps the check for synchronizable to avoid deprecation warning
        internal var isSynchronizable: Bool {
            self.rawValue == 3
        }
    }
}


/*!
    @class URLCredential
    @discussion This class is an immutable object representing an authentication credential.  The actual type of the credential is determined by the constructor called in the categories declared below.
*/
open class URLCredential : NSObject, NSSecureCoding, NSCopying, @unchecked Sendable {
    private let _user : String
    private let _password : String
    private let _persistence : Persistence
    
    /*!
        @method initWithUser:password:persistence:
        @abstract Initialize a URLCredential with a user and password
        @param user the username
        @param password the password
        @param persistence enum that says to store per session, permanently or not at all
        @result The initialized URLCredential
     */
    public init(user: String, password: String, persistence: Persistence) {
        _user = user
        _password = password
        _persistence = persistence
        super.init()
    }
    
    /*!
        @method credentialWithUser:password:persistence:
        @abstract Create a new URLCredential with a user and password
        @param user the username
        @param password the password
        @param persistence enum that says to store per session, permanently or not at all
        @result The new autoreleased URLCredential
     */
    
    public required init?(coder aDecoder: NSCoder) {
        guard aDecoder.allowsKeyedCoding else {
            preconditionFailure("Unkeyed coding is unsupported.")
        }
        
        func bridgeString(_ value: NSString) -> String? {
            return String._unconditionallyBridgeFromObjectiveC(value)
        }
        
        let encodedUser = aDecoder.decodeObject(forKey: "NS._user") as! NSString
        self._user = bridgeString(encodedUser)!
        
        let encodedPassword = aDecoder.decodeObject(forKey: "NS._password") as! NSString
        self._password = bridgeString(encodedPassword)!
        
        let encodedPersistence = aDecoder.decodeObject(forKey: "NS._persistence") as! NSNumber
        self._persistence = Persistence(rawValue: encodedPersistence.uintValue)!
    }
    
    open func encode(with aCoder: NSCoder) {
        guard aCoder.allowsKeyedCoding else {
            preconditionFailure("Unkeyed coding is unsupported.")
        }
        
        aCoder.encode(self._user._bridgeToObjectiveC(), forKey: "NS._user")
        aCoder.encode(self._password._bridgeToObjectiveC(), forKey: "NS._password")
        aCoder.encode(self._persistence.rawValue._bridgeToObjectiveC(), forKey: "NS._persistence")
    }
    
    static public var supportsSecureCoding: Bool {
        return true
    }
    
    open override func copy() -> Any {
        return copy(with: nil)
    }
    
    open func copy(with zone: NSZone? = nil) -> Any {
        return self 
    }
    
    open override func isEqual(_ object: Any?) -> Bool {
        guard let other = object as? URLCredential else { return false }
        return other === self
            || (other._user == self._user
                && other._password == self._password
                && other._persistence == self._persistence)
    }
    
    /*!
        @method persistence
        @abstract Determine whether this credential is or should be stored persistently
        @result A value indicating whether this credential is stored permanently, per session or not at all.
     */
    open var persistence: Persistence { return _persistence }
    
    /*!
        @method user
        @abstract Get the username
        @result The user string
     */
    open var user: String? { return _user }
    
    /*!
        @method password
        @abstract Get the password
        @result The password string
        @discussion This method might actually attempt to retrieve the
        password from an external store, possible resulting in prompting,
        so do not call it unless needed.
     */
    open var password: String? { return _password }

    /*!
        @method hasPassword
        @abstract Find out if this credential has a password, without trying to get it
        @result YES if this credential has a password, otherwise NO
        @discussion If this credential's password is actually kept in an
        external store, the password method may return nil even if this
        method returns YES, since getting the password may fail, or the
        user may refuse access.
     */
    open var hasPassword: Bool {
        // Currently no support for SecTrust/SecIdentity, always return true
        return true
    }
}
