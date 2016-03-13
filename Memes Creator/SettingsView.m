//
//  SettingsView.m
//  Memes Creator
//
//  Created by Vinh The on 3/2/16.
//  Copyright © 2016 Vinh The. All rights reserved.
//

#import "SettingsView.h"

@implementation SettingsView
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.cornerRadius = 10.0;
    }
    return self;
}
@end
