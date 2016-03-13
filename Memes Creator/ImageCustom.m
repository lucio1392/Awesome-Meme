//
//  ImageCustom.m
//  Memes Creator
//
//  Created by Vinh The on 3/9/16.
//  Copyright © 2016 Vinh The. All rights reserved.
//

#import "ImageCustom.h"
#import "CustomCell.h"
#import "ImageFromCustom.h"
#import "EditMeme.h"
#import "UIButton+Bootstrap.h"
#import "PageViewController.h"
@interface ImageCustom ()
@property(nonatomic, strong)EditMeme *editMeme;
@end

@implementation ImageCustom

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"manuallyData.plist"];
    
    self.arrayRoot = [[NSMutableArray alloc]initWithContentsOfFile:plistPath];
    
    [self.tableView reloadData];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayRoot count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ImageCustom";
    
    CustomCell *cell = (CustomCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = (CustomCell*)[cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    UIButton *deleteButton = (UIButton*)[cell viewWithTag:106];
    UIImageView *memeImage = (UIImageView *)[cell viewWithTag:104];
    UILabel *memeName = (UILabel *)[cell viewWithTag:105];
    
    memeImage.layer.cornerRadius = 4.0;
    memeImage.layer.borderWidth = 2.0;
    memeImage.layer.borderColor = [[UIColor blackColor]CGColor];
    
    UIImage *inputImage = [[ImageFromCustom shareStore]imageForKey:[self.arrayRoot objectAtIndex:indexPath.row]];
    
    //Resize image become thumb Image
    UIImage *thumbImage = [self resizeImage:inputImage withView:memeImage];
    memeImage.image = thumbImage;
    //
    memeName.text = [self.arrayRoot objectAtIndex:indexPath.row];
    memeName.font = [UIFont fontWithName:@"ArialRoundedMTBold" size:17];
    
    
    [deleteButton defaultStyle];
    return cell;
}

-(UIImage*)resizeImage:(UIImage *)image withView:(UIView *)view{
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.editMeme = [self.storyboard instantiateViewControllerWithIdentifier:@"EditMemeStoryboard"];
    
    self.editMeme.imageFromLibAndCamera = [[ImageFromCustom shareStore]imageForKey:[self.arrayRoot objectAtIndex:indexPath.row]];
    
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
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

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (IBAction)deleteSelectedRow:(id)sender {
    CGPoint buttonPostion = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPostion];
    
    [[ImageFromCustom shareStore]deleteImage:[self.arrayRoot objectAtIndex:indexPath.row]];
    [self.arrayRoot removeObjectAtIndex:indexPath.row];
    
    [self updatePlistAfterRemoveImage];
    
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    [self.tableView reloadData];
}
-(void)updatePlistAfterRemoveImage {
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"manuallyData.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: plistPath])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"manuallyData" ofType:@"plist"];
        
        [fileManager copyItemAtPath:bundle toPath:plistPath error:nil];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.arrayRoot writeToFile:plistPath atomically:YES];
    });
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
