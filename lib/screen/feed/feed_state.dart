//
//  SPDX-License-Identifier: BSD-2-Clause-Patent
//  Copyright © 2022 Bitmark. All rights reserved.
//  Use of this source code is governed by the BSD-2-Clause Plus Patent License
//  that can be found in the LICENSE file.
//

part of 'feed_bloc.dart';

abstract class FeedBlocEvent {}

class GetFeedsEvent extends FeedBlocEvent {}

class RetryMissingTokenInFeedsEvent extends FeedBlocEvent {}

class MoveToNextFeedEvent extends FeedBlocEvent {}

class MoveToPreviousFeedEvent extends FeedBlocEvent {}

class FeedState {
  AppFeedData? appFeedData;
  FeedEvent? viewingFeedEvent;
  AssetToken? viewingToken;
  int? viewingIndex;

  FeedState({
    this.appFeedData,
    this.viewingFeedEvent,
    this.viewingToken,
    this.viewingIndex,
  });

  FeedState copyWith({
    AppFeedData? appFeedData,
    FeedEvent? viewingFeedEvent,
    AssetToken? viewingToken,
    int? viewingIndex,
  }) {
    return FeedState(
      appFeedData: appFeedData ?? this.appFeedData,
      viewingFeedEvent: viewingFeedEvent ?? this.viewingFeedEvent,
      viewingToken: viewingToken ?? this.viewingToken,
      viewingIndex: viewingIndex ?? this.viewingIndex,
    );
  }
}
