//
//  UIImageView+MVIMageView.m
//  MVDownloader
//
//  Created by Mati ur Rab on 7/5/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

#import "UIImageView+MVIMageView.h"
#import "MVDownloadManager.h"

#define MVActivityIndicatorTag 100

@implementation UIImageView (MVIMageView)
@dynamic delegate;

-(void) setImageForUrl:(nullable NSString *)urlString placeholderImage:(nullable UIImage *)image withFrame:(CGRect)frame{
    
    if (urlString) {
        
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        activityIndicator.tag = MVActivityIndicatorTag;
        [self.superview addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        [self setImage:image];
        [self setNeedsDisplay];
        
        //Call MVDownloadManager to manage url download
        [[MVDownloadManager sharedManager] loadImageWithUrl:urlString shouldStoreToMemory:YES completed:^(UIImage * _Nullable imageReceived, NSError * _Nullable error, NSURL * _Nullable imageURL) {
            if(!error){
                if (imageReceived) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [self setImage:imageReceived];
                        [self setNeedsDisplay];
                        [activityIndicator stopAnimating];
                        [activityIndicator removeFromSuperview];
                        
                        self.alpha = 0.0;
                        
                        [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionTransitionNone  animations:^{
                            self.alpha = 1.0;
                        } completion:^(BOOL finished) {
                            //code for completion
                        }];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [activityIndicator stopAnimating];
                        [activityIndicator removeFromSuperview];
                        [self showMessage:@"No image available for the url"
                                withTitle:@"Error"];
                    });
                }
            }else{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [activityIndicator stopAnimating];
                    [activityIndicator removeFromSuperview];
                    if(error.code != -999){ //Error code = -999 in case of cancel request
                        [self showMessage:error.localizedDescription
                                withTitle:@"Error"];
                    }
                });
            }
        }];
        
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showMessage:@"Trying to load a nil url"
                    withTitle:@"Error"];
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

-(void) cancelImageDownload:(nullable NSString*) urlString{
    [[MVDownloadManager sharedManager] cancelDownloadForUrl:urlString completion:^(BOOL isCancelled,  NSURL* _Nullable  url){
        if(isCancelled){
            UIActivityIndicatorView *activityIndicator = (UIActivityIndicatorView*)[self viewWithTag:MVActivityIndicatorTag];
            [activityIndicator stopAnimating];
            [activityIndicator removeFromSuperview];
        }else{
            NSLog(@"No operation running against this url");
        }
    }];
}

@end
