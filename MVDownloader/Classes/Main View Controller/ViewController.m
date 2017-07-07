//
//  ViewController.m
//  MVDownloader
//
//  Created by Mati ur Rab on 7/5/17.
//  Copyright © 2017 Mati Ur Rab. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+MVIMageView.h"
#import "MVDownloadTypeConstants.h"
#import "APIConstants.h"
#import "MVJSONHandler.h"
#import "PinboardCollectionViewCell.h"
#import "PastebinDAO.h"
#import "UserProfileViewController.h"

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad
#define MVPinCollectionCellIdentifier @"PinboardCollectionViewCell"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, PinboardCollectionCellProtocols>
{
    NSArray *images;
    NSArray *dataArray;
    int counter;
    int refreshLimit;
    NSArray *mainDataArray;
    UIRefreshControl *refreshControl;
    UIActivityIndicatorView *activityIndicator;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerCustomCellsAndPullToRefresh];
    [self downloadDataFromApi:MV_API];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeActivityIndicator) name:@"downloadCancelled" object:nil];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) registerCustomCellsAndPullToRefresh{

    
    [_photosColletionView registerNib:[UINib nibWithNibName:@"PinboardCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:MVPinCollectionCellIdentifier];
    
    refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [_photosColletionView addSubview:refreshControl];
    _photosColletionView.alwaysBounceVertical = YES;

    counter = 10;
    refreshLimit = 10;
}

-(void) removeActivityIndicator{
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
}

#pragma mark - Pull To refresh function
-(void) refreshData{
    counter += refreshLimit;
    if (mainDataArray.count > counter) {
        dataArray = [mainDataArray subarrayWithRange:NSMakeRange(0, counter)];
    }else{
        dataArray = mainDataArray;
    }
    [_photosColletionView reloadData];
    [refreshControl endRefreshing];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:      (NSInteger)section
{
    return [dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PinboardCollectionViewCell *cell = (PinboardCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:MVPinCollectionCellIdentifier forIndexPath:indexPath];
    
    PastebinDAO *pastebinDAO = [dataArray objectAtIndex:indexPath.row];
    [cell.displayImage setImageForUrl:pastebinDAO.urls.regular placeholderImage:[UIImage imageNamed:@"placeholder.jpg"] withFrame:cell.frame];
    
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PastebinDAO *pastebinDAO = [dataArray objectAtIndex:indexPath.row];
    UserProfileViewController *userProfileController = [self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
    userProfileController.selectedPasteBinDAO = pastebinDAO;
    userProfileController.userCollections = mainDataArray;
    [self.navigationController pushViewController:userProfileController animated:YES];
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

#pragma mark - PinboardCollectionViewCell Delegates
-(void) cancelDownload:(id)collectionCell{
    PinboardCollectionViewCell *cell = (PinboardCollectionViewCell*) collectionCell;
    NSIndexPath *indexPath = [_photosColletionView indexPathForCell:cell];
    PastebinDAO *pastebinDAO = [dataArray objectAtIndex:indexPath.row];
    [cell.displayImage cancelImageDownload:pastebinDAO.urls.regular];
}

#pragma mark - API call to download data
-(void) downloadDataFromApi:(NSString*) urlString {
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = _photosColletionView.center;
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    [[MVJSONHandler sharedManager] downloadJSONForUrl:urlString completion:^(NSArray * _Nullable responseArray) {
        if (responseArray) {
            dispatch_async(dispatch_get_main_queue(), ^{
                mainDataArray = responseArray;
                if (mainDataArray.count > counter) {
                    dataArray = [mainDataArray subarrayWithRange:NSMakeRange(0, counter)];
                }else{
                    dataArray = mainDataArray;
                }
                [_photosColletionView reloadData];
                [activityIndicator stopAnimating];
                [activityIndicator removeFromSuperview];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                dataArray = nil;
                [activityIndicator stopAnimating];
                [activityIndicator removeFromSuperview];
            });
            
        }
    }];
}

@end
