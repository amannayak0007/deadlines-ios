//
//  CompletedCustomCell.m
//  Deadlines
//
//  Created by Shiv Sakhuja on 1/9/15.
//  Copyright (c) 2015 Shiv Sakhuja. All rights reserved.
//

#import "CompletedCustomCell.h"

@implementation CompletedCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    //numberLabel.layer.cornerRadius = 15;
    //numberLabel.layer.masksToBounds = YES;
    
}

- (void)setFrame:(CGRect)frame {
    
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
