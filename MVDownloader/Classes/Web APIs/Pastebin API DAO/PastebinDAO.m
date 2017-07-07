//
//  PastebinDAO.m
//  MVDownloader
//
//  Created by Mati ur Rab on 7/7/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

#import "PastebinDAO.h"


@implementation PastebinDAO

- (instancetype) init {
    self = [super init];
    
    if (self) {
        _user = [[UserDictionary alloc] init];
        _links = [[LinksDictionary alloc] init];
        _urls = [[URLsDictionary alloc] init];
        
    }
    return self;
}

@end
