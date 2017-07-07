//
//  UIImageView+MVIMageView.h
//  MVDownloader
//
//  Created by Mati ur Rab on 7/5/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MVImageViewProtocol <NSObject>

@optional
-(void) downloadCancelledForUrl:(nullable NSURL*) url;

@end

@interface UIImageView (MVIMageView)

@property(nonatomic, assign) _Nullable id<MVImageViewProtocol> delegate;
-(void) setImageForUrl:(nullable NSString *)urlString placeholderImage:(nullable UIImage *)image withFrame:(CGRect)frame;
-(void) cancelImageDownload:(nullable NSString*) urlString;

@end
