//
//  URLsDictionary.h
//  MVDownloader
//
//  Created by Mati ur Rab on 7/7/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLsDictionary : NSObject

@property (nonatomic, retain) NSString *raw;
@property (nonatomic, retain) NSString *full;
@property (nonatomic, retain) NSString *regular;
@property (nonatomic, retain) NSString *small;
@property (nonatomic, retain) NSString *thumb;

- (instancetype) init;
@end
