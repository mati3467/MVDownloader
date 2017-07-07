//
//  MVJSONHandler.m
//  MVDownloader
//
//  Created by Mati ur Rab on 7/7/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

#import "MVJSONHandler.h"
#import "MVDownloadManager.h"
#import "PastebinDAO.h"

@implementation MVJSONHandler

+ (nonnull instancetype)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

-(void) downloadJSONForUrl:(NSString*) urlString completion:(void(^)(NSArray *responseArray))completionHandler{
    if (urlString) {
        
        [[MVDownloadManager sharedManager] loadJSONWithUrl:urlString shouldStoreToMemory:YES completed:^(NSArray * _Nullable responseArray, NSError * _Nullable error, NSURL * _Nullable JSONUrl) {
            if(!error){
                if (responseArray) {
                    //parse json here
                    NSArray *dataArray = [self parseJSONToDAO:responseArray];
                    completionHandler(dataArray);
                }else{
                    
                    [self showMessage:@"Invalid json was returned" withTitle:@"Error"];
                    completionHandler(nil);
                }
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(error.code != -999){ //Error code = -999 in case of cancel request
                        [self showMessage:error.localizedDescription withTitle:@"Error"];
                        completionHandler(nil);
                    }else{
                        completionHandler(nil);
                    }
                });
            }
        }];
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showMessage:@"Trying to load a nil url" withTitle:@"Error"];
            completionHandler(nil);
        });
    }
    
}

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

-(void) canclJSONDownload:(nullable NSString*) urlString{
    [[MVDownloadManager sharedManager] cancelDownloadForUrl:urlString completion:^(BOOL isCancelled,  NSURL* _Nullable  url){
        if(isCancelled){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadCancelled" object:nil];
            [self showMessage:@"Download was cancelled" withTitle:@"Alert"];
        }else{
            NSLog(@"No operation running against this url");
        }
    }];
}

#pragma mark - JSON parsing
-(NSArray*) parseJSONToDAO:(NSArray *)jsonDictionary{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *objectDictionary in jsonDictionary) {
        PastebinDAO *pasteBinObject = [[PastebinDAO alloc] init];
        pasteBinObject.recordID = [objectDictionary valueForKey:@"id"];
        
        pasteBinObject.recordID = [objectDictionary valueForKey:@"id"];
        pasteBinObject.created_at = [objectDictionary valueForKey:@"created_at"];
        pasteBinObject.width = [[objectDictionary valueForKey:@"width"] floatValue];
        pasteBinObject.height = [[objectDictionary valueForKey:@"height"] floatValue];
        pasteBinObject.color = [objectDictionary valueForKey:@"color"];
        pasteBinObject.likes = [[objectDictionary valueForKey:@"likes"] intValue];
        pasteBinObject.liked_by_user = [[objectDictionary valueForKey:@"liked_by_user"] boolValue];
        pasteBinObject.current_user_collections = [objectDictionary valueForKey:@"current_user_collections"];
        
        NSDictionary *user_dictionary = [objectDictionary valueForKey:@"user"];
        pasteBinObject.user.user_id = [user_dictionary valueForKey:@"id"];
        pasteBinObject.user.username = [user_dictionary valueForKey:@"username"];
        pasteBinObject.user.name = [user_dictionary valueForKey:@"name"];
        
        NSDictionary *user_profile_image_dictionary = [user_dictionary valueForKey:@"profile_image"];
        pasteBinObject.user.profile_image = [[NSDictionary alloc] initWithObjectsAndKeys:
                                             [user_profile_image_dictionary valueForKey:@"small"], @"small",
                                             [user_profile_image_dictionary valueForKey:@"medium"], @"medium",
                                             [user_profile_image_dictionary valueForKey:@"large"], @"large",
                                             nil];
        
        NSDictionary *urls_dictionary = [objectDictionary valueForKey:@"urls"];
        pasteBinObject.urls.raw = [urls_dictionary valueForKey:@"raw"];
        pasteBinObject.urls.full = [urls_dictionary valueForKey:@"full"];
        pasteBinObject.urls.regular = [urls_dictionary valueForKey:@"regular"];
        pasteBinObject.urls.small = [urls_dictionary valueForKey:@"small"];
        pasteBinObject.urls.thumb = [urls_dictionary valueForKey:@"thumb"];
        
        pasteBinObject.categories = [objectDictionary valueForKey:@"categories"];
        
        NSDictionary *links = [objectDictionary valueForKey:@"links"];
        pasteBinObject.links.self_link = [links valueForKey:@"self"];
        pasteBinObject.links.html = [links valueForKey:@"html"];
        pasteBinObject.links.download = [links valueForKey:@"download"];
       
        [dataArray addObject:pasteBinObject];
    }
    return [NSArray arrayWithArray:dataArray];
}
@end
