//
//  MVDownloadManager.m
//  MVDownloader
//
//  Created by Mati ur Rab on 7/5/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

#import "MVDownloadManager.h"
#import "MVDownloadTypeConstants.h"
#import "MVWebserviceDownloader.h"
#import "Reachability.h"

@interface MVDownloadManager(){
    NSMutableDictionary *runningWebserviceCalls;
}
@end

@implementation MVDownloadManager

+ (nonnull instancetype)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
        [instance initSharedResources];
    });
    return instance;
}

-(void) initSharedResources{
    runningWebserviceCalls = [[NSMutableDictionary alloc]init];
    [[MVCache sharedCache] setMaxMemoryCost:100000000];
    [[MVCache sharedCache] setExpiryTimeInterval:3600]; //1 Hour
}

-(void) loadImageWithUrl:(nullable NSString*) urlString shouldStoreToMemory:(BOOL) storeInMemory completed:(void (^ _Nullable)(UIImage * _Nullable image, NSError * _Nullable error, NSURL * _Nullable imageURL))completionHandler{
    
    if (!completionHandler) {
        NSLog(@"Invoking this method without a completion block is pointless");
        return;
    }
    
    NSString *formattedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:formattedString];
    
    if (![self checkIfUrlCanBeCalled:url]) {
        completionHandler(nil, [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:nil], url);
        return;
    }
    else{
        if ([url isKindOfClass:NSString.class]) {
            url = [NSURL URLWithString:(NSString *)url];
        }
        //check if cache hold object against URL, if yes the use that object otherwise go for download operation
        [[MVCache sharedCache] getDataFromCacheForUrl:url completion:^(NSData * _Nullable data, BOOL objectFound) {
            if (objectFound) {
                completionHandler([UIImage imageWithData:data], nil, url);
            }else{
                [self downloadDataFromUrl:url shouldStoreToMemory:YES completed:^(NSData *data, NSError *error, NSURL *url) {
                    if (!error) {
                        if (data) {
                            [self handleResponseForImageWithData:data completionHandler:^(UIImage *image) {
                                if (image) {
                                    if (storeInMemory) {
                                        [[MVCache sharedCache] saveDataToCache:data forUrl:url];
                                    }
                                    completionHandler(image, nil, url);
                                }else{
                                    completionHandler(nil, [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:nil], url);
                                }
                            }];
                        }else{
                            completionHandler(nil, error, url);
                        }
                    }else{
                        completionHandler(nil, error, url);
                    }
                }];
            }
        }];
    }
}

-(void) loadJSONWithUrl:(nullable NSString*) urlString shouldStoreToMemory:(BOOL) storeInMemory completed:(void (^ _Nullable)(NSArray * _Nullable responseArray, NSError * _Nullable error, NSURL * _Nullable JSONUrl))completionHandler{
    
    if (!completionHandler) {
        NSLog(@"Invoking this method without a completion block is pointless");
        return;
    }
    
    NSString *formattedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:formattedString];
    
    if (![self checkIfUrlCanBeCalled:url]) {
        completionHandler(nil, [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:nil], url);
        return;
    }
    else{
        if ([url isKindOfClass:NSString.class]) {
            url = [NSURL URLWithString:(NSString *)url];
        }
        //check if cache hold object against URL, if yes the use that object otherwise go for download operation
        [[MVCache sharedCache] getDataFromCacheForUrl:url completion:^(NSData * _Nullable data, BOOL objectFound) {
            if (objectFound) {
                completionHandler([self getJSONArrayFromData:data], nil, url);
            }else{
                [self downloadDataFromUrl:url shouldStoreToMemory:YES completed:^(NSData *data, NSError *error, NSURL *url) {
                    if (!error) {
                        if (data) {
                            [self handleResponseForJSONWithData:data completionHandler:^(NSArray *responseArray) {
                                if (responseArray) {
                                    if (storeInMemory) {
                                        [[MVCache sharedCache] saveDataToCache:data forUrl:url];
                                    }
                                    completionHandler(responseArray, nil, url);
                                }else{
                                    completionHandler(nil, [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:nil], url);
                                }
                            }];
                        }else{
                            completionHandler(nil, error, url);
                        }
                    }else{
                        completionHandler(nil, error, url);
                    }
                }];
            }
        }];
    }
}

-(void) downloadDataFromUrl:(NSURL*) url shouldStoreToMemory:(BOOL) storeInMemory completed:(void(^)(NSData * data, NSError *error, NSURL *url)) completionHandler{
    
    if ([runningWebserviceCalls objectForKey:url.absoluteString]) {
        int count = [[runningWebserviceCalls objectForKey:url.absoluteString] intValue];
        count++;
        [runningWebserviceCalls setObject:@(count) forKey:url.absoluteString];
    }else{
        [runningWebserviceCalls setObject:@(1) forKey:url.absoluteString];
        [runningWebserviceCalls setObject:MV_DOWNLOAD_TYPE_IMAGE forKey:[NSString stringWithFormat:@"%@_TYPE",url.absoluteString]];
    }
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [self showMessage:@"Internet not available, please check your internet connection"
                withTitle:@"Error"];
    } else{
        //Call web service manager
        [[MVWebserviceDownloader sharedDownloader] downloadDataForUrl:url withCompletionHandler:^(NSData * _Nullable data, NSURL * _Nullable url, NSError * _Nullable error, NSURLResponse * _Nullable response) {
            
            if (!error) {
                
                NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
                NSInteger statusCode = [urlResponse statusCode];
                
                if (statusCode == 200 && data)
                {
                    if ([runningWebserviceCalls objectForKey:url.absoluteString]) {
                        completionHandler(data, error, url);
                    }
                }
                else
                {
                    completionHandler(nil, error, url);
                }
                
                
            }else{
                completionHandler(nil, error, url);
            }
            
        }];
    }
}

-(BOOL) checkIfUrlCanBeCalled:(NSURL*) url{
    BOOL canBeCalled = YES;
    if ([url isKindOfClass:NSString.class]) {
        url = [NSURL URLWithString:(NSString *)url];
    }
    
    // Check if url is kind of NSURL class only, NSNULL will cause error so need to stop it here
    if (![url isKindOfClass:NSURL.class]) {
        url = nil;
    }
    
    if (url.absoluteString.length == 0) {
        canBeCalled = NO;
    }
    
    return canBeCalled;
}

- (void) cancelDownloadForUrl:(nullable NSString*)urlString completion:(void(^ _Nullable)(BOOL,  NSURL* _Nullable ))completionHandler{
    NSString *formattedString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:formattedString];
    [self checkIfUrlCanBeCalled:url];
    if ([url isKindOfClass:NSString.class]) {
        url = [NSURL URLWithString:(NSString *)url];
    }
    
    if ([runningWebserviceCalls objectForKey:url.absoluteString]) {
        int count = [[runningWebserviceCalls objectForKey:url.absoluteString] intValue];
        if (count==1) {
            //call webservicemanager to remove object against url
            [[MVWebserviceDownloader sharedDownloader] cancelRequestForUrl:url];
            [runningWebserviceCalls removeObjectForKey:url.absoluteString];
        }else if(count>1){
            count--;
            [runningWebserviceCalls setObject:@(count) forKey:url.absoluteString];
        }
        completionHandler(YES, url);
    }else{
        completionHandler(NO, url);
    }
}

#pragma mark - Response type handlers

-(void) handleResponseForImageWithData:(NSData*) data completionHandler:(void(^)(UIImage *image))completionHandler{
    if (data) {
        UIImage *image = [UIImage imageWithData:data];
        completionHandler(image);
    }else{
        completionHandler(nil);
    }
    
}

-(void) handleResponseForJSONWithData:(NSData*) data completionHandler:(void(^)(NSArray *responseArray))completionHandler{
    if (data) {
        NSError *jsonReadingError = nil;
        NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonReadingError];
        completionHandler(responseArray);
    }else{
        completionHandler(nil);
    }
}

-(NSArray*) getJSONArrayFromData:(NSData*) data{
    NSError *jsonReadingError = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonReadingError];
    return jsonArray;
}

#pragma mark - Alerts

-(void)showMessage:(NSString*)message withTitle:(NSString *)title
{
    UIAlertController * alert =   [UIAlertController
                                   alertControllerWithTitle:title
                                   message:message
                                   preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    }];
    [alert addAction:okAction];
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc presentViewController:alert animated:YES completion:nil];
}

@end
