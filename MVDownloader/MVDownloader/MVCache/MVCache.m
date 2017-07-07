//
//  MVCache.m
//  MVDownloader
//
//  Created by Mati ur Rab on 7/5/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

#import "MVCache.h"
#import "CacheObject.h"

@interface MVCache(){
    NSCache *memoryCache;
}
@end

@implementation MVCache

#pragma mark - Singleton
+ (nonnull instancetype)sharedCache {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
        [instance initSharedResources];
    });
    return instance;
}

-(void) initSharedResources{
    memoryCache = [[NSCache alloc] init];
}

#pragma mark - Caching Data

- (void) getDataFromCacheForUrl:(nullable NSURL*)url completion:(void(^ _Nullable)( NSData * _Nullable data, BOOL objectFound))CompletionHandler{
    
    if([memoryCache objectForKey:url.absoluteString])
    {
        CacheObject *cacheObject = [memoryCache objectForKey:url.absoluteString];
        
        NSTimeInterval timeSinceCache = fabs([cacheObject.creationDate timeIntervalSinceNow]);
        if (timeSinceCache > self.expiryTimeInterval) {
            [self.memCache removeObjectForKey:url.absoluteString];
            CompletionHandler(nil, NO);
        }else{
            NSData *data = cacheObject.dataToStore;
            CompletionHandler(data, YES);
        }
    }else{
        CompletionHandler(nil, NO);
    }
}

- (void) saveDataToCache:(nullable NSData*) data forUrl:(nullable NSURL*)url{
    if(![memoryCache objectForKey:url.absoluteString])
    {
        CacheObject *cacheObject = [[CacheObject alloc] init];
        [cacheObject setData:data withCreationDate:[NSDate date]];
        NSUInteger cost = [self cacheCostForData:data];
        [memoryCache setObject:cacheObject forKey:url.absoluteString cost:cost];
    }
}

-(NSUInteger) cacheCostForData:(NSData*) data{
    return [data length];
}

# pragma mark - Mem Cache settings

- (void)setMaxMemoryCost:(NSUInteger)maxMemoryCost {
    self.memCache.totalCostLimit = maxMemoryCost;
}

-(void) setExpiryTimeInterval:(NSTimeInterval)expiryTimeInterval{
    _expiryTimeInterval = expiryTimeInterval;
}
@end
