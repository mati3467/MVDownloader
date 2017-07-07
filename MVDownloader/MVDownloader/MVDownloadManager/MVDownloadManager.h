//
//  MVDownloadManager.h
//  MVDownloader
//
//  Created by Mati ur Rab on 7/5/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MVCache.h"

@interface MVDownloadManager : NSObject

+ (nonnull instancetype)sharedManager;

- (void) cancelDownloadForUrl:(nullable NSString*)urlString completion:(void(^ _Nullable)(BOOL,  NSURL* _Nullable ))completionHandler;
-(void) loadImageWithUrl:(nullable NSString*) urlString shouldStoreToMemory:(BOOL) storeInMemory completed:(void (^ _Nullable)(UIImage * _Nullable image, NSError * _Nullable error, NSURL * _Nullable imageURL))completionHandler;
-(void) loadJSONWithUrl:(nullable NSString*) urlString shouldStoreToMemory:(BOOL) storeInMemory completed:(void (^ _Nullable)(NSArray * _Nullable responseArray, NSError * _Nullable error, NSURL * _Nullable JSONUrl))completionHandler;

@end
