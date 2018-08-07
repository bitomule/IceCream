import CloudKit

public protocol CloudContainer {
    var privateCloudDatabase: CKDatabase { get }
    func accountStatus(completionHandler: @escaping (CKAccountStatus, Error?) -> Void)
    func fetchAllLongLivedOperationIDs(completionHandler: @escaping ([String]?, Error?) -> Void)
    func fetchLongLivedOperation(withID operationID: String, completionHandler: @escaping (CKOperation?, Error?) -> Void)
    func add(_ operation: CKOperation)
}


extension CKContainer: CloudContainer { }
