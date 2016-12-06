//
//  FactIconTableViewCell.m
//  LazyTableView
//
//  Created by Arunkumar on 01/12/16.
//  Copyright © 2016 Infosys. All rights reserved.
//
#import "FactIconTableViewCell.h"

@implementation FactIconTableViewCell

// Init Tableviewcell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        reuseID = reuseIdentifier;
        // Create title label
        self.titleLabel = [[UILabel alloc] init];
        if (reuseID == PlaceholderCellIdentifier) {
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
        } else {
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
        }
        self.titleLabel.textColor = [UIColor colorWithRed:(43/255.f) green:(62/255.f) blue:(117/255.f) alpha:1.0];
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
        self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.titleLabel.numberOfLines = 0;
        [self.contentView addSubview:self.titleLabel];
        // Create description label
        self.descriptionLabel = [[UILabel alloc] init];
        self.descriptionLabel.textColor = [UIColor colorWithRed:(67/255.f) green:(67/255.f) blue:(67/255.f) alpha:1.0];
        [self.descriptionLabel setFont:[UIFont systemFontOfSize:16.0]];
        self.descriptionLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.descriptionLabel.numberOfLines = 0;
        [self.contentView addSubview:self.descriptionLabel];
        // Create icon image view
        self.iconImage =[[UIImageView alloc] init];
        [self.contentView addSubview:self.iconImage];
        // Update constraints
        [self setNeedsUpdateConstraints];
        [self layoutIfNeeded];
    }
    return self;
}

- (void)updateConstraints
{
    [super updateConstraints];
    // 1. Create a dictionary of views
    NSDictionary *viewsDictionary = @{@"titleLabel":self.titleLabel, @"descriptionLabel":self.descriptionLabel, @"iconImage":self.iconImage};
    // 2. Define the views Sizes
    NSArray *red_constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel(30)]"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDictionary];
    [self.titleLabel addConstraints:red_constraint_H];
    NSArray *yellow_constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[descriptionLabel(100)]"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:viewsDictionary];
    [self.descriptionLabel addConstraints:yellow_constraint_V];
    NSArray *blue_constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[iconImage(90)]"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:viewsDictionary];
    
    NSArray *blue_constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[iconImage(90)]"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:viewsDictionary];
    [self.iconImage addConstraints:blue_constraint_H];
    [self.iconImage addConstraints:blue_constraint_V];
    // 3. Define the views Positions using options
    NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[titleLabel]-0-[descriptionLabel]-0-|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDictionary];
    NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[titleLabel]-0-|"
                                                                        options:NSLayoutFormatAlignAllTop
                                                                        metrics:nil views:viewsDictionary];
    NSArray *constraint_POS_iconImage = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[descriptionLabel]-0-[iconImage]-0-|"
                                                                             options:NSLayoutFormatAlignAllTop
                                                                             metrics:nil views:viewsDictionary];
    [self.contentView addConstraints:constraint_POS_V];
    [self.contentView addConstraints:constraint_POS_H];
    [self.contentView addConstraints:constraint_POS_iconImage];
}

@end