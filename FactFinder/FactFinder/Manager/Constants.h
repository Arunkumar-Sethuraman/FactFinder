//
//  Constants.h
//  LazyTableView
//
//  Created by Arunkumar on 01/12/16.
//  Copyright © 2016 Infosys. All rights reserved.
//
// URL used for fetching the json
static NSString *const jsonAppFeed = @"https://dl.dropboxusercontent.com/u/746330/facts.json";

// Appdelegate
#define kTitle @"title"
#define kDescription @"description"
#define kImageHref @"imageHref"
#define kRows @"rows"
#define kConnectivityIssue @"Network Unavailable"
#define kInternetConnection @"Please check the Internet Connection"

// Viewcontroller
#define kPlaceholder @"Placeholder.png"
#define kCustomRowCount 7
#define kCustomRowHeight 130
#define kBorderWidth 1.0
#define kCornerRadius 2.0
#define kIconWidth 90
#define kIconHeight 90
#define kDescriptionFontSize 16.0
#define kTimeFormat @"MMM d, h:mm a"
#define kDataLoading @"Loading..."
#define kSepSpacing 10

// Tableview Cell
static NSString *CellIdentifier = @"LazyTableCell";
static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";