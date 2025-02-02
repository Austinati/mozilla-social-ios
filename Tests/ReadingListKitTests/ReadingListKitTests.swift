// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

import XCTest
@testable import ReadingListKit
@testable import MoSoAnalytics
@testable import MoSoCore

final class ReadingListKitTests: XCTestCase {
    func testExample() {
        let mockSessionProvider: ReadingListSessionProvider = sessionProvider
        let model = ReadingListModel(sessionProvider: mockSessionProvider, consumerKey: "ConsumerKey", analyticsTracker: MoSoReadingListTracker(baseTracker: MockBaseTracker()))

        let mockAccessLayer = MocketAccessLayer()
        mockAccessLayer.fetchSavesAction = {
            XCTAssert(true) // Check that the code was indeed called as expected.
        }
        model.pocketAccessLayer = mockAccessLayer

        model.fetchMoreReadingList()
    }
}

class MocketAccessLayer: PocketAccessLayerProtocol {
    var delegate: ReadingListKit.ReadingListModelDelegate?

    var fetchSavesAction: () -> Void = { XCTAssert(false) } // Fail by default
    var getItemForURLAction: () -> ReadingListKit.PocketItem = {
        XCTAssert(false)
        return MockPocketItem(remoteID: "rID", givenUrl: "gURL")
    }
    var archiveAction: () -> Void = { XCTAssert(false) }

    func fetchSaves(after cursor: String?) {
        fetchSavesAction()
    }

    func getItemForURL(_ urlString: String) async throws -> ReadingListKit.PocketItem {
        getItemForURLAction()
    }

    func archive(item: String) {
        archiveAction()
    }
}

class MockBaseTracker: BaseTracker {
    var startAction: () -> Void = { XCTAssert(false) } // Fail by default
    var stopAction: () -> Void = { XCTAssert(false) }
    var trackAppDidBecomeActiveAction: () -> Void = { XCTAssert(false) }
    var trackAppWillBackgroundAction: () -> Void = { XCTAssert(false) }
    var trackImpressionAction: () -> Void = { XCTAssert(false) }
    var trackEngagementAction: () -> Void = { XCTAssert(false) }

    func start() {
        startAction()
    }

    func stop() {
        stopAction()
    }

    func trackAppDidBecomeActive() {
        trackAppDidBecomeActiveAction()
    }

    func trackAppWillBackground() {
        trackAppWillBackgroundAction()
    }

    func trackImpression(postID: String?, recommendationID: String?, additionalInfo: String?, uiIdentifier: String?, url: String?) {
        trackImpressionAction()
    }

    func trackEngagement(action: MoSoAnalytics.EngagementAction, associatedValue: String?, postID: String?, recommendationID: String?, additionalInfo: String?, uiIdentifier: String?, url: String?) {
        trackEngagementAction()
    }
}

struct MockPocketItem: PocketItem {
    var remoteID: String
    var title: String?
    var givenUrl: String
    var image: String?
    var subtitle: String?
}

extension MoSoSession: ReadingListSession {}

func sessionProvider() throws -> MoSoSession {
    MoSoSession(token: "Token", guid: "GUID")
}
