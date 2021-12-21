import 'dart:typed_data';

import 'package:autonomy_flutter/service/persona_service.dart';
import 'package:web3dart/web3dart.dart';

abstract class EthereumService {
  Future<String> getETHAddress();
  Future<String> signPersonalMessage(Uint8List message);
  Future<BigInt> estimateFee(EthereumAddress to, EtherAmount amount);
  Future<String> sendTransaction(EthereumAddress to, BigInt value, BigInt? gas, String? data);
}

class EthereumServiceImpl extends EthereumService {

  PersonaService _personaService;
  Web3Client _web3Client;

  EthereumServiceImpl(this._personaService, this._web3Client);

  @override
  Future<BigInt> estimateFee(EthereumAddress to, EtherAmount amount) async {
    final persona = _personaService.getActivePersona();
    assert(persona != null);

    final gasPrice = await _web3Client.getGasPrice();
    final sender = EthereumAddress.fromHex(await persona!.getETHAddress()) ;

    try {
      BigInt gas = await _web3Client.estimateGas(
        sender: sender,
        to: to,
        value: amount,
        gasPrice: gasPrice,
      );
      return gas * gasPrice.getInWei;
    } catch (err) {
      //Cannot estimate return default value
      return BigInt.from(21000) * gasPrice.getInWei;
    }
  }

  @override
  Future<String> getETHAddress() async {
    return await _personaService.getActivePersona()?.getETHAddress() ?? "";
  }

  @override
  Future<String> signPersonalMessage(Uint8List message) async {
    return await _personaService.getActivePersona()?.signPersonalMessage(message) ?? "";
  }

  @override
  Future<String> sendTransaction(EthereumAddress to, BigInt value, BigInt? gas, String? data) async {
    final persona = _personaService.getActivePersona();
    assert(persona != null);

    final sender = EthereumAddress.fromHex(await persona!.getETHAddress()) ;
    final nonce = await _web3Client.getTransactionCount(sender);
    final gasPrice = await _web3Client.getGasPrice();
    final gasLimit = gas != null ? gas ~/ gasPrice.getInWei : BigInt.from(21000);

    final signedTransaction = await persona.signTransaction(
      nonce: nonce,
      gasPrice: gasPrice.getInWei,
      gasLimit: gasLimit,
      to: to.hexEip55,
      value: value,
      data: data ?? "",
      chainId: 4
    );

    return _web3Client.sendRawTransaction(signedTransaction);
  }
}