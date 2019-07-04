//
//  MediaCollectionViewCell.h
//  iOS Takehome
//
//  Created by Yugene on 7/3/19.
//  Copyright © 2019 Real Labs Technology, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MediaCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewMedia;
@property (weak, nonatomic) IBOutlet UIView *viewPlay;
@property (weak, nonatomic) IBOutlet UIButton *buttonLink;
@property (weak, nonatomic) IBOutlet UIButton *buttonDownload;
@property (weak, nonatomic) IBOutlet UIView *viewButtons;
@property (weak, nonatomic) IBOutlet UIView *viewSeparate;

@end

NS_ASSUME_NONNULL_END
