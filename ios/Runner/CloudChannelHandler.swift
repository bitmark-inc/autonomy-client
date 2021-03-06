//
//  SPDX-License-Identifier: BSD-2-Clause-Patent
//  Copyright © 2022 Bitmark. All rights reserved.
//  Use of this source code is governed by the BSD-2-Clause Plus Patent License
//  that can be found in the LICENSE file.
//

import Foundation
import Combine
import CloudKit

class CloudChannelHandler: NSObject {

    static let shared = CloudChannelHandler()
    private var cancelBag = Set<AnyCancellable>()
    private var cloudKitManger = CloudKitManager()

}

extension CloudChannelHandler: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.observeCloudAvailablity(events: events)
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        cancelBag.removeAll()
        return nil
    }

    func observeCloudAvailablity(events: @escaping FlutterEventSink) {
        cloudKitManger.observeAccountStatus()
            .map { $0 == CKAccountStatus.available }
            .sink { (isAvailable) in
                var params: [String: Any] = [:]
                params["isAvailable"] = isAvailable

                events([
                    "eventName": "observeCloudAvailablity",
                    "params": params
                ])
            }
            .store(in: &cancelBag)
    }
}
