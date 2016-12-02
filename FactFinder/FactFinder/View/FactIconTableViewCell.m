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
        // Set constraints
        [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self updateConstraints];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    // Setting constraints
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:10];
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    // Add constraints to content view
    [self.contentView addConstraints:@[left, top, right, bottom]];
}

@end
