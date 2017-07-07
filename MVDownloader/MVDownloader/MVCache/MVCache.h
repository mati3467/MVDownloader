//
//  MVCache.h
//  MVDownloader
//
//  Created by Mati ur Rab on 7/5/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MVCacheType) {
    MVCacheTypeNone,
    MVCacheTypeMemory
};

@interface MVCache : NSObject

@property (strong, nonatomic, nonnull) NSCache *memCache;
@property (nonatomic, assign) NSTimeInterval expiryTimeInterval;

#pragma mark - Singleton
+ (nonnull instancetype)sharedCache;

- (void)setMaxMemoryCost:(NSUInteger)maxMemoryCost;
- (void) getDataFromCacheForUrl:(nullable NSURL*)url completion:(void(^ _Nullable)( NSData * _Nullable data, BOOL objectFound))CompletionHandler;
- (void) saveDataToCache:(nullable NSData*) data forUrl:(nullable NSURL*)url;

@end
