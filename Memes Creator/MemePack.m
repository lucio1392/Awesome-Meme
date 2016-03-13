//
//  MemePack.m
//  Memes Creator
//
//  Created by Vinh The on 2/23/16.
//  Copyright © 2016 Vinh The. All rights reserved.
//

#import "MemePack.h"
#import "CustomCell.h"
#import "EditMeme.h"
#import "UIButton+Bootstrap.h"
#import "ImageFromCustom.h"

@interface MemePack ()
@property(nonatomic, strong)EditMeme *editMeme;
@end

@implementation MemePack


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString* path = [[NSBundle mainBundle]pathForResource:@"ImageLibrary" ofType:@"plist"];
    
    NSDictionary *dict = [[NSDictionary alloc]initWithContentsOfFile:path];
    self.memeImages = [[[dict objectForKey:@"All Meme"]objectAtIndex:0]allValues];
    self.memeNames  = [[[dict objectForKey:@"All Meme"]objectAtIndex:0]allKeys];

}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.memeImages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"MemePack";
    
    CustomCell *cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = (CustomCell*)[cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //Settings ImageView
    UIImageView *memeImage = (UIImageView *)[cell viewWithTag:103];
    
    memeImage.layer.cornerRadius = 4.0;
    memeImage.layer.borderWidth = 2.0;
    memeImage.layer.borderColor = [[UIColor blackColor]CGColor];
    
    UIImage *inputImage = [UIImage imageNamed:[self.memeImages objectAtIndex:indexPath.row]];
    
    //Resize image become thumb Image
    UIImage *thumbImage = [self resizeImage:inputImage withView:memeImage];
    
    memeImage.image = thumbImage;
    
    //Setting label
    UILabel *memeName = (UILabel *)[cell viewWithTag:110];
    memeName.text = [self.memeNames objectAtIndex:indexPath.row];
    memeName.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:17];
    
    return cell;
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.editMeme = [self.storyboard instantiateViewControllerWithIdentifier:@"EditMemeStoryboard"];
    
    self.editMeme.imageName = [self.memeImages objectAtIndex:indexPath.row];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        [self.editMeme initDoneButtonForIPad:YES];
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self.editMeme];
        
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        
        [self presentViewController:nav animated:YES completion:nil];
        
    }else{
        [self.editMeme initDoneButtonForIPad:NO];
        
        [self.navigationController pushViewController:self.editMeme animated:YES];
        
    }
}

//Rounded corner first and last cell in tableview.
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(tintColor)]) {
        if (tableView == self.tableView) {
            CGFloat cornerRadius = 10.f;
            cell.backgroundColor = UIColor.clearColor;
            CAShapeLayer *layer = [[CAShapeLayer alloc] init];
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGRect bounds = CGRectInset(cell.bounds, 10, 0);
            BOOL addLine = NO;
            if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
            } else if (indexPath.row == 0) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                addLine = YES;
            } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
            } else {
                CGPathAddRect(pathRef, nil, bounds);
                addLine = YES;
            }
            layer.path = pathRef;
            CFRelease(pathRef);
            layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.4f].CGColor;
            
            if (addLine == YES) {
                CALayer *lineBottomLayer = [[CALayer alloc] init];
                CGFloat lineHeight = (4.f / [UIScreen mainScreen].scale);
                lineBottomLayer.frame = CGRectMake(CGRectGetMinX(bounds), bounds.size.height-lineHeight, bounds.size.width, lineHeight);
                lineBottomLayer.backgroundColor = [[UIColor whiteColor]CGColor];
                [layer addSublayer:lineBottomLayer];
            }
            
            UIView *testView = [[UIView alloc] initWithFrame:bounds];
            [testView.layer insertSublayer:layer atIndex:0];
            testView.backgroundColor = UIColor.clearColor;
            cell.backgroundView = testView;
        }
    }

}
@end
