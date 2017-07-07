//
//  PinboardCollectionViewCell.m
//  MVDownloader
//
//  Created by Mati Ur Rab on 7/7/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

#import "PinboardCollectionViewCell.h"

@implementation PinboardCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (IBAction)cancelDownload:(id)sender {
    if ([_delegate respondsToSelector:@selector(cancelDownload:)]) {
        [_delegate cancelDownload:self];
    }
}
@end
