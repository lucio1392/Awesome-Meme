//
//  EditMeme.h
//  Memes Creator
//
//  Created by Vinh The on 2/23/16.
//  Copyright © 2016 Vinh The. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditMeme : UIViewController
@property(nonatomic, strong)NSString *imageName;
@property(nonatomic, strong)UIImage *imageFromLibAndCamera;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

-(void)initDoneButtonForIPad:(BOOL)isIpad;
@end
