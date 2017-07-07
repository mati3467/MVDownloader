//
//  MVWebserviceDownloader.h
//  MVDownloader
//
//  Created by Mati ur Rab on 7/5/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVWebserviceDownloader : NSObject

#pragma mark - class methods
+ (nonnull instancetype)sharedDownloader;

#pragma mark - instance methods
-(void) downloadDataForUrl:(nullable NSURL*) url withCompletionHandler:(void(^ _Nullable)(NSData * _Nullable data, NSURL * _Nullable url, NSError * _Nullable error, NSURLResponse * _Nullable response))completionHandelr;
-(void) cancelRequestForUrl:(nullable NSURL*) url;

@end
