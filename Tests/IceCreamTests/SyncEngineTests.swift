//
//  IceCreamTests.swift
//  IceCreamTests
//
//  Created by David Collado on 8/8/18.
//

import XCTest
import IceCream
import CloudKit
import RealmSwift
@testable import IceCreamTests

class SyncEngineTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSetupsSyncObjectCloudPipe() {
        let syncObject = MockObject()
        let _ = SyncEngine.start(objects: [syncObject], remoteDataSource: CloudKitMock())
        XCTAssertNotNil(syncObject.pipeToEngine)
    }

    func testFetchsRemoteChanges() {
        let expectation = XCTestExpectation(description: "Wait cloudkit")
        let syncObject = MockObject()
        let dataSource = CloudKitMock()
        dataSource.fetchChangesCalled = {
            XCTAssert(true)
            expectation.fulfill()
        }
        let _ = SyncEngine.start(objects: [syncObject], remoteDataSource: dataSource)
        wait(for: [expectation], timeout: 0.1)
    }

    func testRegistersLocalDatabase() {
        let expectation = XCTestExpectation(description: "Wait cloudkit")
        let syncObject = MockObject()
        let dataSource = CloudKitMock()
        syncObject.registerLocalDatabaseCalled = {
            XCTAssert(true)
            expectation.fulfill()
        }
        let _ = SyncEngine.start(objects: [syncObject], remoteDataSource: dataSource)
        wait(for: [expectation], timeout: 0.1)
    }

    func testAddsToLocalDatabase() {
        let expectation = XCTestExpectation(description: "Wait cloudkit")
        let syncObject = MockObject()
        let dataSource = CloudKitMock()
        let mockRecord = mockCKRecord()
        dataSource.mockAddedRecords = [mockRecord]
        syncObject.addCalled = { record in
            XCTAssertEqual(record.recordID.recordName, mockRecord.recordID.recordName)
            expectation.fulfill()
        }
        let _ = SyncEngine.start(objects: [syncObject], remoteDataSource: dataSource)
        wait(for: [expectation], timeout: 0.1)
    }

    func testRemovesToLocalDatabase() {
        let expectation = XCTestExpectation(description: "Wait cloudkit")
        let syncObject = MockObject()
        let dataSource = CloudKitMock()
        let mockRecordId = mockCKRecordId()
        dataSource.mockRemovedRecordIds = [mockRecordId]
        syncObject.removeCalled = { recordId in
            XCTAssertEqual(recordId.recordName, mockRecordId.recordName)
            expectation.fulfill()
        }
        let _ = SyncEngine.start(objects: [syncObject], remoteDataSource: dataSource)
        wait(for: [expectation], timeout: 0.1)
    }
}