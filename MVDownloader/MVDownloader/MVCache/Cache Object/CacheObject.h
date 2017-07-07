//
//  CacheObject.h
//  MVDownloader
//
//  Created by Mati ur Rab on 7/7/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CacheObject : NSObject

@property(nonatomic, strong) NSData *dataToStore;
@property(nonatomic, strong) NSDate *creationDate;

- (instancetype) init;
-(void) setData:(NSData*) dataToStore withCreationDate:(NSDate*) creationDate;

@end
