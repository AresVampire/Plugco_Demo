//
//  ViewController.m
//  iOS Takehome
//
//  Created by Timothy Lenardo on 6/24/19.
//  Copyright © 2019 Real Labs Technology, Inc. All rights reserved.
//

#import "ViewController.h"
#import "Views/MediaCollectionViewCell.h"
#import "Views/CampaignTableViewCell.h"
#import "Model/Campaign.h"

#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/SDWebImage.h>
#import "ProgressHUD.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource>
    
@end

@implementation ViewController

NSMutableArray<Campaign *> *campaigns;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    campaigns = [NSMutableArray array];
    [self fetchData];
}

- (void)fetchData {
    [ProgressHUD show];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *urlString = @"http://www.plugco.in/public/take_home_sample_feed";
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *responseArray = responseObject[@"campaigns"];
            for (int i = 0 ; i < responseArray.count ; i++) {
                NSDictionary *json = responseArray[i];
                
                Campaign *campaign = [[Campaign alloc] init];
                campaign.iconUrl = json[@"campaign_icon_url"];
                campaign.name = json[@"campaign_name"];
                campaign.payPerInstall = json[@"pay_per_install"];
                
                campaign.coverPhotoUrl = [NSMutableArray array];
                campaign.downloadUrl = [NSMutableArray array];
                campaign.mediaType = [NSMutableArray array];
                campaign.trackingLink = [NSMutableArray array];
                
                NSArray *mediaArray = json[@"medias"];
                for (int j = 0 ; j < mediaArray.count ; j++) {
                    NSDictionary *mediaJson = mediaArray[j];
                    [campaign.coverPhotoUrl addObject:mediaJson[@"cover_photo_url"]];
                    [campaign.downloadUrl addObject:mediaJson[@"download_url"]];
                    [campaign.mediaType addObject:mediaJson[@"media_type"]];
                    [campaign.trackingLink addObject:mediaJson[@"tracking_link"]];
                }
                
                [campaigns addObject:campaign];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        NSLog(@"%@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", [error localizedDescription]);
    }];
}

- (void) downloadData:(NSString *)url {
    [ProgressHUD show:@"Downloading..."];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        [ProgressHUD showSuccess:[@"File downloaded to: " stringByAppendingString:filePath.absoluteString]];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [ProgressHUD dismiss];
        });
    }];
    [downloadTask resume];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return campaigns.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CampaignTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CampaignTableViewCell"];
    
    cell.labelCampaignTitle.text = campaigns[indexPath.row].name;
    cell.labelPaysCount.text = [campaigns[indexPath.row].payPerInstall stringByAppendingString:@" per install"];
    
    cell.imageViewCampaign.layer.cornerRadius = 15;
    [cell.imageViewCampaign setClipsToBounds:YES];
    [cell.imageViewCampaign sd_setImageWithURL:[NSURL URLWithString:campaigns[indexPath.row].iconUrl]];
    
    cell.collectionViewMedia.tag = indexPath.row;
    cell.collectionViewMedia.dataSource = self;
    [cell.collectionViewMedia reloadData];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    int index = (int)collectionView.tag;
    return [campaigns[index].mediaType count];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MediaCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MediaCollectionViewCell" forIndexPath:indexPath];
    
    int index = (int)collectionView.tag;
    if ([campaigns[index].mediaType[indexPath.row] isEqualToString:@"video"]) {
        [cell.viewPlay setHidden:NO];
    } else {
        [cell.viewPlay setHidden:YES];
    }
    
    cell.imageViewMedia.layer.cornerRadius = 5;
    [cell.imageViewMedia setClipsToBounds:YES];
    [cell.imageViewMedia sd_setImageWithURL:[NSURL URLWithString:campaigns[index].coverPhotoUrl[indexPath.row]]];
    
    cell.viewButtons.layer.borderWidth = 1.0;
    cell.viewButtons.layer.borderColor = cell.viewSeparate.backgroundColor.CGColor;
    cell.viewButtons.layer.cornerRadius = 5;
    [cell.viewButtons setClipsToBounds:YES];
    
    cell.buttonLink.tag = 10000 * index + indexPath.row;
    [cell.buttonLink addTarget:self action:@selector(tapOnLinkButton:) forControlEvents:UIControlEventTouchUpInside];
    cell.buttonDownload.tag = 10000 * index + indexPath.row;
    [cell.buttonDownload addTarget:self action:@selector(tapOnDownloadButton:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (void) tapOnLinkButton:(UIButton *)sender {
    int row = (int)sender.tag / 10000, col = (int)sender.tag % 10000;
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    [pasteBoard setString:campaigns[row].trackingLink[col]];
}

- (void) tapOnDownloadButton:(UIButton *)sender {
    int row = (int)sender.tag / 10000, col = (int)sender.tag % 10000;
    [self downloadData:campaigns[row].downloadUrl[col]];
}


@end
