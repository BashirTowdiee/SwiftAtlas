import Foundation

open class OpenFormatterExample {
    public init() {}
    open func describe() -> String { "Open types permit subclassing outside the module." }
}

public struct PublicFormatterExample {
    public init() {}
    public func describe() -> String { "Public types are visible outside the module without allowing override." }
}

fileprivate struct FilePrivateSample {
    let value = "Visible only inside this file."
}

private struct PrivateSample {
    let value = "Visible only inside this declaration scope."
}

struct AccessControlGuide {
    func examples(
        function: String = #function,
        fileID: String = #fileID,
        line: Int = #line,
        column: Int = #column
    ) -> [String] {
        [
            OpenFormatterExample().describe(),
            PublicFormatterExample().describe(),
            "fileprivate sample: \(FilePrivateSample().value)",
            "private sample: \(PrivateSample().value)",
            "Special identifiers => \(function) @ \(fileID):\(line):\(column)"
        ]
    }
}
