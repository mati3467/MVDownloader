//
//  UserProfileViewController.m
//  MVDownloader
//
//  Created by mac new on 7/7/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

#import "UserProfileViewController.h"
#import "UIImageView+MVIMageView.h"
#import "UserCollectionViewCell.h"

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad
#define MVUserCollectionCellIdentifier @"UserCollectionViewCell"

@interface UserProfileViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self populateData];
    [self registerCustomCell];
}

-(void) registerCustomCell{
    [_userPhotosCollectionView registerNib:[UINib nibWithNibName:@"UserCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:MVUserCollectionCellIdentifier];
    [_userPhotosCollectionView reloadData];
}

-(void) populateData{
    [_userProfileImageView setImageForUrl:[_selectedPasteBinDAO.user.profile_image valueForKey:@"medium"] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"] withFrame:_userProfileImageView.frame];
    _userProfileImageView.layer.cornerRadius = _userProfileImageView.frame.size.width/2;
    _userProfileImageView.layer.borderWidth = 0.5;
    _userProfileImageView.clipsToBounds = YES;
    
    _userNameLabel.text = _selectedPasteBinDAO.user.name;
    _userLikesLabel.text = [NSString stringWithFormat:@"Likes: %d",_selectedPasteBinDAO.likes];
    _userLikedByUserLabel.text = [NSString stringWithFormat:@"Liked by user: %@", _selectedPasteBinDAO.liked_by_user?@"YES":@"NO"];
    
}
- (IBAction)backBtnTpd:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UICollectionView Delegates
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:      (NSInteger)section
{
    return [_userCollections count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UserCollectionViewCell *cell = (UserCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:MVUserCollectionCellIdentifier forIndexPath:indexPath];
    
    PastebinDAO *pastebinDAO = [_userCollections objectAtIndex:indexPath.row];
    [cell.displayImage setImageForUrl:pastebinDAO.urls.regular placeholderImage:[UIImage imageNamed:@"placeholder.jpg"] withFrame:cell.frame];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float marginalDistance = 14.0;
    float numberOfColumns = 2.0; //Replace the divisor with the column count requirement. Make sure to have it in float.
    if (IDIOM == IPAD) {
        numberOfColumns = 4.0;
    }
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    if (numberOfColumns <= 0) {
        numberOfColumns = 2.0;
    }
    float cellWidth = (screenWidth / numberOfColumns) - marginalDistance;
    CGSize size = CGSizeMake(cellWidth, cellWidth);
    
    return size;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

@end
