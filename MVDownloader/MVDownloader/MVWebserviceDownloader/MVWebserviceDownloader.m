
//
//  MVWebserviceDownloader.m
//  MVDownloader
//
//  Created by Mati ur Rab on 7/5/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

#import "MVWebserviceDownloader.h"
#import "MVDownloadTypeConstants.h"

@interface MVWebserviceDownloader(){
    NSOperationQueue *requestQueue;
}
@property (assign, nonatomic) NSTimeInterval downloadTimeout;
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonnull) NSMutableDictionary *runningRequests;
@end



@implementation MVWebserviceDownloader

+ (nonnull instancetype)sharedDownloader {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
        
        [instance initSharedResources];
    });
    return instance;
}

-(void) initSharedResources{
    requestQueue = [[NSOperationQueue alloc] init];
    self.runningRequests = [[NSMutableDictionary alloc] init];
    _downloadTimeout = 20.0;
}

-(void) downloadDataForUrl:(nullable NSURL*) url withCompletionHandler:(void(^ _Nullable)(NSData * _Nullable data, NSURL * _Nullable url,NSError * _Nullable error, NSURLResponse * _Nullable response))completionHandelr{
    
    NSURLRequestCachePolicy cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:cachePolicy timeoutInterval:_downloadTimeout];
    request.HTTPShouldUsePipelining = YES;
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSURL *url = response.URL;
        if (url) {
            [_runningRequests removeObjectForKey:url];
        }
        if (completionHandelr) {
            completionHandelr(data, url, error, response);
        }
    }];
    [_runningRequests setObject:task forKey:url];
    [task resume];
}

-(void) cancelRequestForUrl:(nullable NSURL*) url{
    if ([_runningRequests objectForKey:url]) {
        NSURLSessionTask *task = [_runningRequests objectForKey:url];
        [task cancel];
    }
}

@end
