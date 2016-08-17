//
//  IgnoreTouchView.m
//  test
//
//  Created by Brian Olencki on 2/13/16.
//  Copyright © 2016 bolencki13. All rights reserved.
//

#import "IgnoreTouchView.h"

@implementation IgnoreTouchView
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        return nil;
    }
    return hitView;
}
@end
