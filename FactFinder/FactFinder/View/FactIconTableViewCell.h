//
//  FactIconTableViewCell.h
//  LazyTableView
//
//  Created by Arunkumar on 01/12/16.
//  Copyright © 2016 Infosys. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Constants.h"

@interface FactIconTableViewCell : UITableViewCell
{
    NSString *reuseID;
}
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIImageView *iconImage;

- (void)updateConstraints;

@end
