//
//  EventCell.h
//  Kulturkalender
//
//  Created by Christian Rasmussen on 17.10.12.
//  Copyright (c) 2012 Under Dusken. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView *thumbnailImageView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *detailLabel;
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;

@end
