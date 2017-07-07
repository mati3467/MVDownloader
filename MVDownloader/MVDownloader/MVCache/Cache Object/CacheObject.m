//
//  CacheObject.m
//  MVDownloader
//
//  Created by Mati ur Rab on 7/7/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

#import "CacheObject.h"


@implementation CacheObject


- (instancetype) init {
    self = [super init];
    
    if (self) {
        _dataToStore = nil;
        _creationDate = [NSDate date];
    }
    return self;
}

-(void) setData:(NSData*) dataToStore withCreationDate:(NSDate*) creationDate{
    _dataToStore = dataToStore;
    _creationDate = creationDate;
}


@end
