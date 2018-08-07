import CloudKit

public protocol CloudDatabase {
    func add(_ operation: CKDatabaseOperation)
}

extension CKDatabase: CloudDatabase { }
