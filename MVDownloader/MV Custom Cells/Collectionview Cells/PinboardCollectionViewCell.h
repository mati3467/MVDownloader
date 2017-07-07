//
//  PinboardCollectionViewCell.h
//  MVDownloader
//
//  Created by mac new on 7/7/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PinboardCollectionCellProtocols <NSObject>

@optional

-(void) cancelDownload:(id) collectionCell;

@end

@interface PinboardCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) id<PinboardCollectionCellProtocols> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *displayImage;
@property (weak, nonatomic) IBOutlet UIButton *cancelDownloadBtn;

- (IBAction)cancelDownload:(id)sender;


@end
