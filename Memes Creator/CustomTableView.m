//
//  CustomTableView.m
//  Memes Creator
//
//  Created by Vinh The on 3/11/16.
//  Copyright © 2016 Vinh The. All rights reserved.
//

#import "CustomTableView.h"

@implementation CustomTableView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIImageView *background = [[UIImageView alloc]initWithFrame:self.bounds];
    
    UIImage *firstImage = [UIImage imageNamed:@"bg.jpg"];
    
    UIImage *bgImage = [self resizeImage:firstImage withView:background];
    
    background.image = bgImage;
    
    self.backgroundView = background;
    
}

-(UIImage *)resizeImage:(UIImage *)image withView:(UIView *)view{
    CGSize originalImageSize = image.size;
    
    CGRect newRect = CGRectMake(0,
                                0,
                                view.bounds.size.width,
                                view.bounds.size.height);
    
    float ratio = MAX(newRect.size.width / originalImageSize.width,
                      newRect.size.height / originalImageSize.height);
    
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect
                                                    cornerRadius:2.0];
    
    [path addClip];
    
    CGRect projectRect;
    
    projectRect.size.width = ratio * originalImageSize.width;
    projectRect.size.height = ratio * originalImageSize.height;
    
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    
    [image drawInRect:projectRect];
    
    UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return thumbImage;
}

@end
