//
//  EventTableViewCell.h
//  mirrorless
//
//  Created by 六車卓土 on 2014/08/27.
//  Copyright (c) 2014年 innew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EventTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *HalfTime;
@property (weak, nonatomic) IBOutlet UILabel *HalfTimeSubLabel;
@property (weak, nonatomic) IBOutlet UILabel *HalfOthers;
@property (weak, nonatomic) IBOutlet UIButton *JustTime;
@property (weak, nonatomic) IBOutlet UILabel *JustTimeSubLabel;
@property (weak, nonatomic) IBOutlet UILabel *JustOthers;

@end