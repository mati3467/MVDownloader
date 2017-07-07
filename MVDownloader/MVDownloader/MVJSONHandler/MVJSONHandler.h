//
//  MVJSONHandler.h
//  MVDownloader
//
//  Created by Mati ur Rab on 7/7/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MVJSONHandler : NSObject

+ (nonnull instancetype)sharedManager;
-(void) downloadJSONForUrl:( NSString* _Nullable ) urlString completion:(void(^ _Nullable)(NSArray * _Nullable responseArray))completionHandler;

@end
