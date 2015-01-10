//
//  CustomCell.h
//  Deadlines
//
//  Created by Shiv Sakhuja on 07/01/15.
//  Copyright (c) 2014 Shiv Sakhuja. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"


@interface CustomCell : SWTableViewCell {
    
}

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *deadline;

@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;


@end
