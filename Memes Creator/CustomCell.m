//
//  CustomCell.m
//  Memes Creator
//
//  Created by Vinh The on 2/23/16.
//  Copyright © 2016 Vinh The. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}
//-(void)setFrame:(CGRect)frame{
//    frame.origin.x += 20.0;
//    frame.size.width -= 2 * 20.0;
//    [super setFrame:frame];
//}

@end
