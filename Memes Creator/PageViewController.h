//
//  PageViewController.h
//  Memes Creator
//
//  Created by Vinh The on 3/9/16.
//  Copyright © 2016 Vinh The. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMobileAds;

@interface PageViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIPopoverPresentationControllerDelegate>
@property(nonatomic, strong)NSMutableArray *imageCustom;
@end
