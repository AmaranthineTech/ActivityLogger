/**
 DataLogger<T> struct represents the behavior expected out of wrapped properties
 
 **Variables**
 
 `internalValue`
 
 This is the internally stored value.
 
 **Computed Property**
 
 `wrappedValue`
 
 This is the computed property that will perform the logging action.
 
 - Author: Arun Patwardhan
 - Version: 1.0
 - Date: 5th December 2019
 
 **Contact Details**
 
 [arun@amaranthine.co.in](mailto:arun@amaranthine.co.in)
 
 [www.amaranthine.in](https://www.amaranthine.in)
 */
@propertyWrapper public struct DataLogger<T:CustomStringConvertible> {
    private var internalValue       : T
    private var internalFileName    : String = ""
    private var fileHandle          : FileAccess?
    
    public var wrappedValue : T {
        get {
            self.fileHandle?.log(TheMessage: "Value: \(internalValue) fetched.")
            return internalValue
        }
        set (newValue) {
            internalValue = newValue
            self.fileHandle?.log(TheMessage: "Value: \(internalValue) written.")
        }
    }
    
    public init(newValue value : T, withLogFileName fileNamed : String)
    {
        self.internalValue      = value
        self.internalFileName   = fileNamed
        self.fileHandle         = FileAccess.getFileHandle(forFileNamed: self.internalFileName)
    }
}
