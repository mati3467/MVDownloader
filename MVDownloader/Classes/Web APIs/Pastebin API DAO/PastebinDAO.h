//
//  PastebinDAO.h
//  MVDownloader
//
//  Created by Mati ur Rab on 7/7/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserDictionary.h"
#import "URLsDictionary.h"
#import "LinksDictionary.h"

@interface PastebinDAO : NSObject

@property (nonatomic, retain) NSString * recordID;
@property (nonatomic, retain) NSString * created_at;
@property float width;
@property float height;

@property (nonatomic, retain) NSString * color;
@property int likes;
@property BOOL liked_by_user;
@property (nonatomic, retain) UserDictionary * user;
@property (nonatomic, retain) NSArray * current_user_collections;

@property (nonatomic, retain) URLsDictionary * urls;
@property (nonatomic, retain) NSArray * categories;

@property (nonatomic, retain) LinksDictionary *links;

- (instancetype) init;
@end
