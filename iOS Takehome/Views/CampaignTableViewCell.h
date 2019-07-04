//
//  CampaignTableViewCell.h
//  iOS Takehome
//
//  Created by Yugene on 7/3/19.
//  Copyright © 2019 Real Labs Technology, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CampaignTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCampaign;
@property (weak, nonatomic) IBOutlet UILabel *labelCampaignTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelPaysCount;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewMedia;

@end

NS_ASSUME_NONNULL_END
