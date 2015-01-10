//
//  CompletedCustomCell.h
//  Deadlines
//
//  Created by Shiv Sakhuja on 1/9/15.
//  Copyright (c) 2015 Shiv Sakhuja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface CompletedCustomCell : SWTableViewCell {
    
}

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *dateCompleted;

@end
