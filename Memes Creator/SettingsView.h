//
//  SettingsView.h
//  Memes Creator
//
//  Created by Vinh The on 3/2/16.
//  Copyright © 2016 Vinh The. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsView : UIView
@property (weak, nonatomic) IBOutlet UISwitch *topSwitch;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UISwitch *bottomSwitch;

@end
