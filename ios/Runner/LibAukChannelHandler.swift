//
//  LibAukChannelHandler.swift
//  Runner
//
//  Created by Ho Hien on 08/02/2022.
//

import Foundation
import LibAuk
import BigInt
import Web3
import KukaiCoreSwift
import Combine

class LibAukChannelHandler {
    
    static let shared = LibAukChannelHandler()
    private var cancelBag = Set<AnyCancellable>()

    func createKey(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args: NSDictionary = call.arguments as! NSDictionary
        let uuid: String = args["uuid"] as! String
        let name: String = (args["name"] as? String) ?? ""
        
        LibAuk.shared.storage(for: UUID(uuidString: uuid)!).createKey(name: name)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in
                result([
                    "error": 0,
                    "msg": "createKey success",
                ])
            })
            .store(in: &cancelBag)
    }
    
    func importKey(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args: NSDictionary = call.arguments as! NSDictionary
        let uuid: String = args["uuid"] as! String
        let name: String = (args["name"] as? String) ?? ""
        let words: String = (args["words"] as? String) ?? ""
        let dateInMili: Double? = args["date"] as? Double
        
        let date = dateInMili != nil ? Date(timeIntervalSince1970: dateInMili!) : nil
        let wordsArray = words.components(separatedBy: " ")
        
        LibAuk.shared.storage(for: UUID(uuidString: uuid)!)
            .importKey(words: wordsArray, name: name, creationDate:date)
            .sink(receiveCompletion: { (completion) in
                if let error = completion.error {
                    result(
                        FlutterError(code: "Failed to import key", message: error.localizedDescription, details: nil)
                    )
                }

            }, receiveValue: { _ in
                result([
                    "error": 0,
                    "msg": "importKey success",
                ])
            })
            .store(in: &cancelBag)
    }
    
    func updateName(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args: NSDictionary = call.arguments as! NSDictionary
        let uuid: String = args["uuid"] as! String
        let name: String = (args["name"] as? String) ?? ""

        LibAuk.shared.storage(for: UUID(uuidString: uuid)!).updateName(name: name)
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in
                result([
                    "error": 0,
                    "msg": "updateName success",
                ])
            })
            .store(in: &cancelBag)
    }
    
    func isWalletCreated(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args: NSDictionary = call.arguments as! NSDictionary
        let uuid: String = args["uuid"] as! String
        
        LibAuk.shared.storage(for: UUID(uuidString: uuid)!).isWalletCreated()
            .sink(receiveCompletion: { _ in }, receiveValue: { isCreated in
                result([
                    "error": 0,
                    "msg": "isWalletCreated success",
                    "data": isCreated,
                ])
            })
            .store(in: &cancelBag)
    }
    
    func getName(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args: NSDictionary = call.arguments as! NSDictionary
        let uuid: String = args["uuid"] as! String
        
        let address = LibAuk.shared.storage(for: UUID(uuidString: uuid)!).getName() ?? ""
        
        result([
            "error": 0,
            "msg": "getName success",
            "data": address
        ])
    }
    
    func getETHAddress(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args: NSDictionary = call.arguments as! NSDictionary
        let uuid: String = args["uuid"] as! String
        
        let address = LibAuk.shared.storage(for: UUID(uuidString: uuid)!).getETHAddress() ?? ""
        
        result([
            "error": 0,
            "msg": "getETHAddress success",
            "data": address
        ])
    }
    
    func signPersonalMessage(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args: NSDictionary = call.arguments as! NSDictionary
        let uuid: String = args["uuid"] as! String
        let message = args["message"] as! FlutterStandardTypedData

        LibAuk.shared.storage(for: UUID(uuidString: uuid)!)
            .sign(message: [UInt8](message.data.personalSignedMessageData))
            .sink(receiveCompletion: { _ in }, receiveValue: { (v, r, s) in
                result([
                    "error": 0,
                    "msg": "exportMnemonicWords success",
                    "data": "0x" + r.toHexString() + s.toHexString() + String(v + 27, radix: 16),
                ])
            })
            .store(in: &cancelBag)
    }
    
    func signTransaction(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args: NSDictionary = call.arguments as! NSDictionary
        let uuid: String = args["uuid"] as! String
        let nonce: String = args["nonce"] as? String ?? ""
        let gasPrice: String = args["gasPrice"] as? String ?? ""
        let gasLimit: String = args["gasLimit"] as? String ?? ""
        let to: String = args["to"] as? String ?? ""
        let value: String = args["value"] as? String ?? ""
        let data: String = args["data"] as? String ?? ""
        let chainId: Int = args["chainId"] as? Int ?? 0
        
        let transaction = EthereumTransaction(
            nonce: EthereumQuantity(quantity: BigUInt(Double(nonce) ?? 0)),
            gasPrice: EthereumQuantity(quantity: BigUInt(Double(gasPrice) ?? 0)),
            gas: EthereumQuantity(quantity: BigUInt(Double(gasLimit) ?? 0)),
            from: nil,
            to: try! EthereumAddress.init(hex: to, eip55: false),
            value: EthereumQuantity(quantity: BigUInt(Double(value) ?? 0)),
            data: try! EthereumData.string(data))
        

        LibAuk.shared.storage(for: UUID(uuidString: uuid)!)
            .signTransaction(transaction: transaction, chainId: EthereumQuantity(quantity: BigUInt(chainId)))
            .sink(receiveCompletion: { _ in }, receiveValue: { signedTx in
                let bytes: [UInt8] = try! RLPEncoder().encode(signedTx.rlp())
                result([
                    "error": 0,
                    "msg": "exportMnemonicWords success",
                    "data": Data(bytes),
                ])
            })
            .store(in: &cancelBag)
    }
    
    func exportMnemonicWords(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args: NSDictionary = call.arguments as! NSDictionary
        let uuid: String = args["uuid"] as! String

        LibAuk.shared.storage(for: UUID(uuidString: uuid)!).exportMnemonicWords()
            .sink(receiveCompletion: { _ in }, receiveValue: { words in
                result([
                    "error": 0,
                    "msg": "exportMnemonicWords success",
                    "data": words.joined(separator: " "),
                ])
            })
            .store(in: &cancelBag)
    }
    
    func getTezosWallet(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args: NSDictionary = call.arguments as! NSDictionary
        let uuid: String = args["uuid"] as! String

        LibAuk.shared.storage(for: UUID(uuidString: uuid)!).getTezosWallet()
            .sink(receiveCompletion: { _ in }, receiveValue: { wallet in
                let hdWallet = wallet as! HDWallet
                result([
                    "error": 0,
                    "msg": "getTezosWallet success",
                    "address": wallet.address,
                    "secretKey": hdWallet.privateKey.data,
                    "publicKey": hdWallet.publicKey.data,
                ])
            })
            .store(in: &cancelBag)
    }

    func removeKeys(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let args: NSDictionary = call.arguments as! NSDictionary
        let uuid: String = args["uuid"] as! String

        LibAuk.shared.storage(for: UUID(uuidString: uuid)!).removeKeys()
            .sink(receiveCompletion: { (completion) in
                if let error = completion.error {
                    result(
                        FlutterError(code: "Failed to remove keys", message: error.localizedDescription, details: nil)
                    )
                }
            }, receiveValue: { _ in
                result([
                    "error": 0,
                    "msg": "removeKey success",
                ])
            })
            .store(in: &cancelBag)

    }
    
}

extension Data {
    var personalSignedMessageData: Data {
        let prefix = "\u{19}Ethereum Signed Message:\n"
        let prefixData = (prefix + String(self.count)).data(using: .ascii)!
        return prefixData + self
    }
}

extension Subscribers.Completion {
    var error: Failure? {
        switch self {
        case let .failure(error): return error
        default: return nil
        }
    }
}