//
//  NavigationBarWithSegmentedControl.m
//  Navinival
//
//  Created by 六車卓土 on 2015/07/12.
//
//

#import "NavigationBarWithSegmentedControl.h"

@implementation NavigationBarWithSegmentedControl

- (CGSize)sizeThatFits:(CGSize)size {
    
    CGSize amendedSize = [super sizeThatFits:size];
    amendedSize.height += 38.0f;
    
    return amendedSize;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize {
    
    [self setTitleVerticalPositionAdjustment:-38.0f forBarMetrics:UIBarMetricsDefault];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSArray *classNamesToReposition = @[@"UINavigationButton"];
    
    for (UIView *view in [self subviews]) {
        
        if ([classNamesToReposition containsObject:NSStringFromClass([view class])]) {
            
            CGRect frame = [view frame];
            frame.origin.y -= 38.0f;
            
            [view setFrame:frame];
        }
    }
}

@end