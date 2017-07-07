//
//  LinksDictionary.h
//  MVDownloader
//
//  Created by Mati ur Rab on 7/7/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LinksDictionary : NSObject

@property (nonatomic, retain) NSString *self_link;
@property (nonatomic, retain) NSString *html;
@property (nonatomic, retain) NSString *download;

- (instancetype) init;
@end
