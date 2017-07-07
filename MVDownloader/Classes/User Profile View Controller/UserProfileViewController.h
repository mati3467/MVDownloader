//
//  UserProfileViewController.h
//  MVDownloader
//
//  Created by mac new on 7/7/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PastebinDAO.h"

@interface UserProfileViewController : UIViewController

@property (nonatomic, strong) PastebinDAO *selectedPasteBinDAO;
@property (nonatomic, strong) NSArray *userCollections;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLikesLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLikedByUserLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *userPhotosCollectionView;
@end
