// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See http://swift.org/LICENSE.txt for license information
// See http://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//

@available(*, unavailable)
extension MeasurementFormatter : @unchecked Sendable { }

@available(*, unavailable, message: "Not supported in swift-corelibs-foundation")
open class MeasurementFormatter : Formatter, NSSecureCoding {
    public struct UnitOptions : OptionSet, Sendable {
        public private(set) var rawValue: UInt
        public init(rawValue: UInt) { self.rawValue = rawValue }
        
        
        public static let providedUnit = UnitOptions(rawValue: 1 << 0)
        
        public static let naturalScale = UnitOptions(rawValue: 1 << 1)
        
        public static let temperatureWithoutUnit = UnitOptions(rawValue: 1 << 2)
    }
    
    /*
     This property can be set to ensure that the formatter behaves in a way the developer expects, even if it is not standard according to the preferences of the user's locale. If not specified, unitOptions defaults to localizing according to the preferences of the locale.
     
     Ex:
     
     By default, if unitOptions is set to the empty set, the formatter will do the following:
     - kilocalories may be formatted as "C" instead of "kcal" depending on the locale.
     - kilometersPerHour may be formatted as "miles per hour" for US and UK locales but "kilometers per hour" for other locales.
     
     However, if MeasurementFormatter.UnitOptions.providedUnit is set, the formatter will do the following:
     - kilocalories would be formatted as "kcal" in the language of the locale, even if the locale prefers "C".
     - kilometersPerHour would be formatted as "kilometers per hour" for US and UK locales even though the preference is for "miles per hour."
     
     Note that MeasurementFormatter will handle converting measurement objects to the preferred units in a particular locale.  For instance, if provided a measurement object in kilometers and the set locale is en_US, the formatter will implicitly convert the measurement object to miles and return the formatted string as the equivalent measurement in miles.
     
     */
    open var unitOptions: UnitOptions = []
    
    
    /*
     If not specified, unitStyle is set to NSFormattingUnitStyleMedium.
     */
    open var unitStyle: Formatter.UnitStyle
    
    
    /*
     If not specified, locale is set to the user's current locale.
     */
    /*@NSCopying*/ open var locale: Locale!
    
    
    /*
     If not specified, the number formatter is set up with NumberFormatter.Decimal.style.
     */
    open var numberFormatter: NumberFormatter!
    
    
    open func string(from measurement: Measurement<Unit>) -> String { NSUnsupported() }
    
    
    /*
     @param An NSUnit
     @return A formatted string representing the localized form of the unit without a value attached to it.  This method will return [unit symbol] if the provided unit cannot be localized.
     */
    open func string(from unit: Unit) -> String { NSUnsupported() }
    
    public override init() { NSUnsupported() }
    
    public required init?(coder aDecoder: NSCoder) { NSUnsupported() }
    open override func encode(with aCoder: NSCoder) { NSUnsupported() }
    public static var supportsSecureCoding: Bool { return true }
    
    public func string<UnitType>(from measurement: Measurement<UnitType>) -> String { NSUnsupported() }
}
