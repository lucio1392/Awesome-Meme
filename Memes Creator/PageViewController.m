//
//  PageViewController.m
//  Memes Creator
//
//  Created by Vinh The on 3/9/16.
//  Copyright © 2016 Vinh The. All rights reserved.
//

#import "PageViewController.h"
#import "VTPageViewController.h"
#import "MemePack.h"
#import "EditMeme.h"
#import "ImageCustom.h"
#import "ImageFromCustom.h"
#import "UIButton+Bootstrap.h"

@interface PageViewController ()<GADBannerViewDelegate>
@property(nonatomic, strong)UIBarButtonItem *camera, *library;
@property(nonatomic, strong)UIImagePickerController *imagePicker;
@property(nonatomic, strong)UIPopoverPresentationController *imagePickerPopover;
@property(nonatomic, strong)EditMeme *editMeme;
@property(nonatomic, strong)NSString *nameImage;
@property(nonatomic, strong)MemePack *memePack;
@property(nonatomic, strong)ImageCustom *imageCustomVC;
@property(nonatomic, strong)VTPageViewController *pageVC;
@property(strong, nonatomic)GADBannerView *gadBannerView;
@end

@implementation PageViewController{
    BOOL isBannerVisible;
}

-(void)loadView{
    [super loadView];
    
    [self settingPageViewController];
    
    [self settingsRightBarButton];
    
    self.navigationItem.title = @"Meme Pack";
    
    [self.navigationController.navigationBar setBackgroundColor:[UIColor colorWithRed:0.941 green:0.522 blue:0.184 alpha:1.00]];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
-(void)settingsRightBarButton{
    
    self.camera = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"compact_camera"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(takePictureFromCamera)];
    
    self.library = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"library"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(takePictureFromLibrary)];
    
    self.navigationItem.rightBarButtonItems = @[self.camera, self.library];
}
-(void)takePictureFromLibrary{
    self.imagePicker = [[UIImagePickerController alloc]init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    self.imagePicker.delegate = self;
    
    self.imagePicker.allowsEditing = YES;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.imagePicker.modalPresentationStyle = UIModalPresentationPopover;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
        
        self.imagePickerPopover = [self.imagePicker popoverPresentationController];
        self.imagePickerPopover.delegate = self;
        self.imagePickerPopover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        self.imagePickerPopover.barButtonItem = self.library;
        
    }else{
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
}

-(void)takePictureFromCamera{
    
    self.imagePicker = [[UIImagePickerController alloc]init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    self.imagePicker.delegate = self;
    
    self.imagePicker.allowsEditing = YES;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.imagePicker.modalPresentationStyle = UIModalPresentationPopover;
        [self presentViewController:self.imagePicker animated:YES completion:nil];
        
        self.imagePickerPopover = [self.imagePicker popoverPresentationController];
        self.imagePickerPopover.delegate = self;
        self.imagePickerPopover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        self.imagePickerPopover.barButtonItem = self.camera;
    }else{
        [self presentViewController:self.imagePicker animated:YES completion:nil];
    }
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController{
    self.imagePickerPopover = nil;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    self.editMeme = [self.storyboard instantiateViewControllerWithIdentifier:@"EditMemeStoryboard"];
    
    self.editMeme.imageFromLibAndCamera = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (!self.imageCustom) {
        self.imageCustom = [[NSMutableArray alloc]init];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"manuallyData.plist"];
    
    self.imageCustom = [[NSMutableArray alloc]initWithContentsOfFile:plistPath];
    
    NSString *idName = [self createIDName];
    
    //save name
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: plistPath])
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"manuallyData" ofType:@"plist"];
        
        [fileManager copyItemAtPath:bundle toPath:plistPath error:nil];
    }
    
    [self.imageCustom addObject:idName];
    
    //save image
    
    [self.imageCustom writeToFile:plistPath atomically:YES];
    
    NSString *pathImage = [self archiveImage:idName];
    
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    [data writeToFile:pathImage atomically:YES];
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        
        [self.editMeme initDoneButtonForIPad:YES];
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:self.editMeme];
        
        nav.modalPresentationStyle = UIModalPresentationFormSheet;
        
        [self presentViewController:nav animated:YES completion:^{
            
            _imageCustomVC.arrayRoot = [[NSMutableArray alloc]initWithContentsOfFile:plistPath];
            [_imageCustomVC.tableView reloadData];
            
        }];
        
    }else{
        [self.editMeme initDoneButtonForIPad:NO];
        
        [self.navigationController pushViewController:self.editMeme animated:YES];
    }
}

-(NSString*)createIDName{
    NSUUID *nameImage = [[NSUUID alloc]init];
    
    NSString *nameID = [nameImage UUIDString];
    
    return nameID;
}

-(NSString*)archiveImage:(NSString *)name{
    
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories firstObject];
    
    //    NSLog(@"dicrectory :%@", documentDirectory);
    
    return  [documentDirectory stringByAppendingPathComponent:name];
    
}

-(void)settingPageViewController{
    self.memePack = [self.storyboard instantiateViewControllerWithIdentifier:@"MemePacksStoryboard"];
    
    self.imageCustomVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ImageCustomStoryboard"];
    
    _pageVC = [[VTPageViewController alloc]initWithControllers:@[_memePack, _imageCustomVC] titleEachController:@[@"Meme Pack",@"Custom Image"]];
    
    _pageVC.colorBackgroundSegment = [UIColor colorWithRed:0.204 green:0.208 blue:0.180 alpha:1.00];
    _pageVC.colorBackgroundContainerIndicator = [UIColor colorWithRed:0.204 green:0.208 blue:0.180 alpha:1.00];
    _pageVC.colorBackgroundIndicator = [UIColor blackColor];
    _pageVC.colorTitleDefault = [UIColor whiteColor];
    _pageVC.colorTitleSegmentSelexted = [UIColor whiteColor];
    _pageVC.heightSegment  = 30;
    _pageVC.heightIndicator = 5;
    _pageVC.fontTitle = [UIFont fontWithName:@"Futura-CondensedMedium" size:15];
    _pageVC.fontSizeTitle = 17;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        _pageVC.view.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 154);
    }else{
        _pageVC.view.frame = CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 114);
    }
    
    [self addChildViewController:_pageVC];
    
    [self.view addSubview:_pageVC.view];
    
    [_pageVC didMoveToParentViewController:self];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    CGPoint bannerViewCenter = CGPointMake(0, self.view.bounds.size.height);
    self.gadBannerView = [[GADBannerView alloc]initWithAdSize:kGADAdSizeSmartBannerPortrait origin:bannerViewCenter];
    self.gadBannerView.delegate = self;
    self.gadBannerView.adUnitID = @"ca-app-pub-6773018240487175/9372298041";
    self.gadBannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
//    request.testDevices = @[kGADSimulatorID];
    [self.gadBannerView loadRequest:request];
}

// Called when an ad request loaded an ad.
- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    if (!isBannerVisible) {
        if (self.gadBannerView.superview == nil) {
            [self.view addSubview:self.gadBannerView];
        }
        
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        
        bannerView.frame = CGRectOffset(bannerView.frame, 0, -bannerView.frame.size.height);
        
        [UIView commitAnimations];
        
        isBannerVisible = YES;
    }
}
////
////// Called when an ad request failed.
- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    if (isBannerVisible) {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        
        bannerView.frame = CGRectOffset(bannerView.frame, 0, bannerView.frame.size.height);
        
        [UIView commitAnimations];
        
        isBannerVisible = NO;
    }
}
@end
