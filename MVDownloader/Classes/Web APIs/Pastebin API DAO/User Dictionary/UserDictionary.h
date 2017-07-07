//
//  UserDictionary.h
//  MVDownloader
//
//  Created by Mati ur Rab on 7/7/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDictionary : NSObject

@property (nonatomic, retain) NSString *user_id;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSDictionary *profile_image;
@property (nonatomic, retain) NSDictionary *links;

- (instancetype) init;
@end
