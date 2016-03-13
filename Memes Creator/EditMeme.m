//
//  EditMeme.m
//  Memes Creator
//
//  Created by Vinh The on 2/23/16.
//  Copyright © 2016 Vinh The. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import "EditMeme.h"
#import "CustomLabel.h"
#import "KLCPopup.h"
#import "SettingsView.h"
#import "UIButton+Bootstrap.h"

@interface EditMeme () <UIGestureRecognizerDelegate, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewForImageView;
@property (weak, nonatomic) IBOutlet UITextField *bottomTextField;
@property (weak, nonatomic) IBOutlet UITextField *topTextField;
@property (weak, nonatomic)IBOutlet SettingsView *settingsView;
@property (strong, nonatomic) IBOutlet UIView *fontView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentFontSize;
@property (weak, nonatomic) IBOutlet UITableView *tableViewFonts;
@property (weak, nonatomic) IBOutlet UIButton *pickingFontsButton;
@property (weak, nonatomic) IBOutlet UIView *viewForFont;
@property (weak, nonatomic) IBOutlet UILabel *fontLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *configureMemeTextButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIButton *shareViaEmail;
@property (weak, nonatomic) IBOutlet UIButton *shareViaTwitter;
@property (weak, nonatomic) IBOutlet UIButton *shareViaFacebook;
@property (weak, nonatomic) IBOutlet UIButton *resetTopButton;
@property (weak, nonatomic) IBOutlet UIButton *resetBottomButton;


@property(nonatomic, strong)CustomLabel *topLabel, *bottomLabel;
@property(nonatomic, strong)UIImageView *pickedImageView;
@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)KLCPopup *popupSettings, *popupFonts, *popupConfirmAlert, *popupShare;
@property(nonatomic)UIPanGestureRecognizer *panGestureRecognizerForTopLabel, *panGestureRecognizerForBottomLabel;
@property(nonatomic, strong)NSMutableArray *fontsName;
@property(nonatomic, strong)NSString *font;
@property(nonatomic, strong)UIImage *imageForShare;

@end


@implementation EditMeme
{
    CGFloat ratioOfImage;
    CGSize sizeOfImageResized;
    CGFloat fontSize;
    BOOL setFrame;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Edit Meme";
    self.backgroundImage.image = [UIImage imageNamed:@"bg.jpg"];
    //    self.backgroundImage.contentMode = UIViewContentModeScaleAspectFill;
    [self createdSubviews];
#pragma mark - hide keyboard when tapped View
    UITapGestureRecognizer *tapToHideKeyBoard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundTapped:)];
    [self.view addGestureRecognizer:tapToHideKeyBoard];
    
    self.font = @"ArialRoundedMTBold";
    [self settingsButtons];
}

-(void)settingsButtons{
    [self.submitButton defaultStyle];
    [self.submitButton addAwesomeIcon:FAIconPicture beforeTitle:YES];
    
    [self.configureMemeTextButton defaultStyle];
    [self.configureMemeTextButton addAwesomeIcon:FAIconEdit beforeTitle:YES];
    
    [self.shareButton defaultStyle];
    [self.shareButton addAwesomeIcon:FAIconShare beforeTitle:YES];
    
    [self.resetTopButton defaultStyle];
    [self.resetTopButton addAwesomeIcon:FAIconRefresh beforeTitle:YES];
    
    [self.resetBottomButton defaultStyle];
    [self.resetBottomButton addAwesomeIcon:FAIconRefresh beforeTitle:YES];
    
}
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self settingsSubviews];
    [self createPan];
}

#pragma mark - Create pan gestures and moving label method
-(void)createPan{
    //Moving label.
    self.panGestureRecognizerForTopLabel = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(moveViewWithGestureRecognizer:)];
    [self.topLabel addGestureRecognizer:self.panGestureRecognizerForTopLabel];
    
    self.panGestureRecognizerForBottomLabel = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                     action:@selector(moveViewWithGestureRecognizer:)];
    [self.bottomLabel addGestureRecognizer:self.panGestureRecognizerForBottomLabel];
}
-(void)moveViewWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer{
    
    CGPoint transaction = [panGestureRecognizer translationInView:self.pickedImageView];
    
    panGestureRecognizer.view.center = CGPointMake(transaction.x + panGestureRecognizer.view.center.x,
                                                   transaction.y + panGestureRecognizer.view.center.y);
    
    [panGestureRecognizer setTranslation:CGPointMake(0, 0)
                                  inView:self.pickedImageView];
}
#pragma mark - Create subviews
-(void)createdSubviews{
    
    self.viewForImageView.backgroundColor = [UIColor clearColor];
    self.pickedImageView = [[UIImageView alloc]init];
    self.topLabel = [[CustomLabel alloc]init];
    self.bottomLabel = [[CustomLabel alloc]init];
    self.topTextField.delegate = self;
    self.topTextField.clearButtonMode = YES;
    self.bottomTextField.delegate = self;
    self.bottomTextField.clearButtonMode = YES;
}

#pragma mark - TextField Delegate
//Setting textField update label's text in real time
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (self.topTextField == textField) {
        self.topLabel.text = [self.topTextField.text stringByReplacingCharactersInRange:range withString:string];
    }else if (self.bottomTextField == textField){
        self.bottomLabel.text = [self.bottomTextField.text stringByReplacingCharactersInRange:range withString:string];
    }
    return YES;
}
//TextField should return
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}
-(void)backgroundTapped:(id)sender{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if (self.topTextField == textField) {
        self.topLabel.text = @"";
    }else if (self.bottomTextField == textField){
        self.bottomLabel.text = @"";
    }
    return YES;
}

#pragma mark - Settings first time for subviews
-(void)settingsSubviews{
    
    if (setFrame) {
        
        return;
        
    }else{
        setFrame = YES;
        
        //setting pickedImageView
        self.pickedImageView.frame = CGRectMake(0,
                                                0,
                                                self.viewForImageView.bounds.size.width,
                                                self.viewForImageView.bounds.size.height);
        
        self.pickedImageView.contentMode = UIViewContentModeScaleAspectFit;
        self.pickedImageView.backgroundColor = [UIColor clearColor];
        self.pickedImageView.userInteractionEnabled = YES;
        [self.viewForImageView addSubview:self.pickedImageView];
        
        //set image for imageView
        
        if (self.imageFromLibAndCamera == nil) {
            
            self.pickedImageView.image = [UIImage imageNamed:self.imageName];
        }else{
            self.pickedImageView.image = self.imageFromLibAndCamera;
        }
        
        sizeOfImageResized = [self imageSizeAfterAspectFit:self.pickedImageView];
        
        //settings scrollView
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,
                                                                        0,
                                                                        self.pickedImageView.bounds.size.width ,
                                                                        self.pickedImageView.bounds.size.height)];
        self.scrollView.bounces = YES;
        self.scrollView.contentSize = self.pickedImageView.bounds.size;
        
        [self.pickedImageView addSubview:self.scrollView];
        
        //ratio between image and imageView
        ratioOfImage = self.pickedImageView.image.size.width / sizeOfImageResized.width;
        NSLog(@"Ratio : %f", ratioOfImage);
        //Top Label
        self.topLabel.frame = CGRectMake(0,
                                         0,
                                         sizeOfImageResized.width,
                                         sizeOfImageResized.width / 6.0 + 10);
        
        self.topLabel.center = CGPointMake(sizeOfImageResized.width / 2.0,
                                           sizeOfImageResized.height/10.0);
        
        fontSize = sizeOfImageResized.width / 6.0;
        self.topLabel.font = [UIFont fontWithName:self.font
                                             size:fontSize];
        
        [self.scrollView addSubview:self.topLabel];
        
        //bottom label
        self.bottomLabel.frame = CGRectMake(0,
                                            0,
                                            sizeOfImageResized.width,
                                            sizeOfImageResized.width / 6.0 + 10);
        
        self.bottomLabel.center = CGPointMake(sizeOfImageResized.width / 2.0,
                                              sizeOfImageResized.height - self.bottomLabel.bounds.size.height);
        
        self.bottomLabel.font = [UIFont fontWithName:self.font
                                                size:fontSize];
        
        [self.scrollView addSubview:self.bottomLabel];
        
    }
}
#pragma mark - Couting image's size after aspect fit.
-(CGSize)imageSizeAfterAspectFit:(UIImageView*)imgview{
    float newwidth;
    float newheight;
    UIImage *image=imgview.image;
    if (image.size.height>=image.size.width){
        newheight=imgview.frame.size.height;
        newwidth=(image.size.width/image.size.height)*newheight;
        
        if(newwidth>imgview.frame.size.width){
            float diff=imgview.frame.size.width-newwidth;
            newheight=newheight+diff/newheight*newheight;
            newwidth=imgview.frame.size.width;
        }
    }
    else{
        newwidth=imgview.frame.size.width;
        newheight=(image.size.height/image.size.width)*newwidth;
        
        if(newheight>imgview.frame.size.height){
            float diff=imgview.frame.size.height-newheight;
            newwidth=newwidth+diff/newwidth*newwidth;
            newheight=imgview.frame.size.height;
        }
    }
    //adapt UIImageView size to image size
    imgview.frame=CGRectMake(imgview.frame.origin.x+(imgview.frame.size.width-newwidth)/2,imgview.frame.origin.y+(imgview.frame.size.height-newheight)/2,newwidth,newheight);
    
    return CGSizeMake(newwidth, newheight);
    
}
- (IBAction)submitPressed:(id)sender{
    //    [self configureAndDrawImage];
    UIButton *stateAlertPicked = [UIButton buttonWithType:UIButtonTypeCustom];
    stateAlertPicked.frame = CGRectMake(0, 0, 100, 100);
    
    self.popupConfirmAlert = [KLCPopup popupWithContentView:stateAlertPicked
                                                   showType:KLCPopupShowTypeBounceIn
                                                dismissType:KLCPopupDismissTypeBounceOut
                                                   maskType:KLCPopupMaskTypeDimmed
                                   dismissOnBackgroundTouch:YES
                                      dismissOnContentTouch:NO];
    
    UIAlertController *confirmSave = [UIAlertController alertControllerWithTitle:@"Are you sure ?"
                                                                         message:@"Make sure if you want to save this image to your photos library"
                                                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self configureAndDrawImage];
        UIImageWriteToSavedPhotosAlbum(self.imageForShare, nil, nil, nil);
        //
        [stateAlertPicked setTitle:@"Ok" forState:UIControlStateNormal];
        [stateAlertPicked successStyle];
        [stateAlertPicked addAwesomeIcon:FAIconOk beforeTitle:YES];
        [self.popupConfirmAlert showWithDuration:0.5];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action){
        [stateAlertPicked setTitle:@"Cancel" forState:UIControlStateNormal];
        [stateAlertPicked warningStyle];
        [stateAlertPicked addAwesomeIcon:FAIconStop beforeTitle:YES];
        [self.popupConfirmAlert showWithDuration:0.5];
    }];
    
    [confirmSave addAction:okAction];
    [confirmSave addAction:cancelAction];
    
    [self presentViewController:confirmSave animated:YES completion:nil];
}

#pragma mark - Configure subviews before draw
-(void)configureAndDrawImage{
    
    //Top Label
    CustomLabel *topLabel = [[CustomLabel alloc]initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         sizeOfImageResized.width * ratioOfImage,
                                                                         (sizeOfImageResized.height / 6.0) * ratioOfImage)];
    
    topLabel.center = CGPointMake(self.topLabel.center.x * ratioOfImage,
                                  self.topLabel.center.y * ratioOfImage);
    
    topLabel.text = self.topLabel.text;
    topLabel.font = [self.topLabel.font fontWithSize:fontSize * ratioOfImage];
    topLabel.textColor = self.topLabel.textColor;
    
    CGPoint topPoint;
    topPoint.x = topLabel.frame.origin.x;
    topPoint.y = topLabel.frame.origin.y;
    
    //Bottom Label
    CustomLabel *bottomLabel = [[CustomLabel alloc]initWithFrame:CGRectMake(0,
                                                                            0,
                                                                            sizeOfImageResized.width * ratioOfImage,
                                                                            (sizeOfImageResized.height / 6.0) * ratioOfImage)];
    
    bottomLabel.center = CGPointMake(self.bottomLabel.center.x * ratioOfImage,
                                     self.bottomLabel.center.y * ratioOfImage);
    
    bottomLabel.text = self.bottomLabel.text;
    bottomLabel.font = [self.bottomLabel.font fontWithSize:fontSize * ratioOfImage];
    bottomLabel.textColor = self.bottomLabel.textColor;
    
    CGPoint bottomPoint;
    bottomPoint.x = bottomLabel.frame.origin.x;
    bottomPoint.y = bottomLabel.frame.origin.y;
    
    self.imageForShare = [[UIImage alloc]init];
    
    self.imageForShare = [self drawImage:self.pickedImageView.image
                              atTopPoint:topPoint
                            withTopLabel:topLabel
                           atBottomPoint:bottomPoint
                         withBottomLabel:bottomLabel];
    
    //save image
}
#pragma mark - Draw and save picture to photos
-(UIImage*)drawImage:(UIImage*)image
          atTopPoint:(CGPoint)topPoint
        withTopLabel:(UILabel *)topLabel
       atBottomPoint:(CGPoint)bottomPoint
     withBottomLabel:(UILabel *)bottomLabel
{
    UIGraphicsBeginImageContext(image.size);
    //draw input image
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    //place top text at point
    CGRect topRect = CGRectMake(topPoint.x,
                                topPoint.y,
                                topLabel.bounds.size.width,
                                topLabel.bounds.size.height);
    //[[UIColor whiteColor]set];
    [topLabel drawTextInRect:topRect];
    //place bottom text at point
    CGRect bottomRect = CGRectMake(bottomPoint.x,
                                   bottomPoint.y,
                                   bottomLabel.bounds.size.width,
                                   bottomLabel.bounds.size.height);
    //    [[UIColor whiteColor]set];
    [bottomLabel drawTextInRect:bottomRect];
    //draw new image
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //end context
    UIGraphicsEndImageContext();
    return newImage;
}

- (IBAction)configureMeMe:(id)sender {
    
    [[NSBundle mainBundle] loadNibNamed:@"SettingsView" owner:self options:nil];
    self.popupSettings = [KLCPopup popupWithContentView:self.settingsView
                                               showType:KLCPopupShowTypeBounceIn
                                            dismissType:KLCPopupDismissTypeBounceOut
                                               maskType:KLCPopupMaskTypeDimmed
                               dismissOnBackgroundTouch:YES
                                  dismissOnContentTouch:NO];
    [self.popupSettings show];
    
    [self.settingsView.okButton successStyle];
    [self.settingsView.okButton addAwesomeIcon:FAIconOk beforeTitle:YES];
    
    [self.settingsView.cancelButton primaryStyle];
    [self.settingsView.cancelButton addAwesomeIcon:FAIconOff beforeTitle:YES];
    
    [self.pickingFontsButton defaultStyle];
    
    self.settingsView.frame = CGRectMake(0, 0, self.view.bounds.size.width - 30, self.view.bounds.size.height / 2.0);
    
    [self.segmentFontSize setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                  [UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0], NSFontAttributeName, nil]
                                        forState:UIControlStateNormal];
    
    [self.pickingFontsButton setTitle:self.font forState:UIControlStateNormal];
    [self sizeState];
}

#pragma mark - Settings Controlls
- (IBAction)okButton:(id)sender {
    [self changeFontSize];
    [self.popupSettings dismiss:YES];
    if (self.settingsView.topSwitch.on == YES) {
        self.topLabel.font = [UIFont fontWithName:self.font size:fontSize];
    }
    if (self.settingsView.bottomSwitch.on == YES) {
        self.bottomLabel.font = [UIFont fontWithName:self.font size:fontSize];
    }
}
- (IBAction)cancelButton:(id)sender {
    [self.popupSettings dismiss:YES];
}

-(void)changeFontSize{
    if (self.settingsView.topSwitch.on == YES) {
        switch (self.segmentFontSize.selectedSegmentIndex) {
            case 0:
                fontSize = (sizeOfImageResized.width / 10.0);
                self.topLabel.font = [self.topLabel.font fontWithSize:fontSize];
                self.topLabel.frame = CGRectMake(self.topLabel.frame.origin.x,self.topLabel.frame.origin.y,sizeOfImageResized.width, fontSize);
                break;
            case 1:
                fontSize = (sizeOfImageResized.width / 8.0);
                self.topLabel.font = [self.topLabel.font fontWithSize:fontSize];
                self.topLabel.frame = CGRectMake(self.topLabel.frame.origin.x,self.topLabel.frame.origin.y,sizeOfImageResized.width, fontSize);
                break;
            case 2:
                fontSize = (sizeOfImageResized.width / 6.0);
                self.topLabel.font = [self.topLabel.font fontWithSize:fontSize];
                self.topLabel.frame = CGRectMake(self.topLabel.frame.origin.x,self.topLabel.frame.origin.y,sizeOfImageResized.width, fontSize);
                break;
            case 3:
                fontSize = (sizeOfImageResized.width / 4.0);
                self.topLabel.font = [self.topLabel.font fontWithSize:fontSize];
                self.topLabel.frame = CGRectMake(self.topLabel.frame.origin.x,self.topLabel.frame.origin.y,sizeOfImageResized.width, fontSize);
                break;
            case 4:
                fontSize = (sizeOfImageResized.width / 2.0);
                self.topLabel.font = [self.topLabel.font fontWithSize:fontSize];
                self.topLabel.frame = CGRectMake(self.topLabel.frame.origin.x,self.topLabel.frame.origin.y,sizeOfImageResized.width, fontSize);
                break;
            default:
                break;
        }
    }
    if(self.settingsView.bottomSwitch.on == YES){
        switch (self.segmentFontSize.selectedSegmentIndex) {
            case 0:
                fontSize = (sizeOfImageResized.width / 10.0);
                self.bottomLabel.font = [self.bottomLabel.font fontWithSize:fontSize];
                self.bottomLabel.frame = CGRectMake(self.bottomLabel.frame.origin.x, self.bottomLabel.frame.origin.y,sizeOfImageResized.width, fontSize);
                break;
            case 1:
                fontSize = (sizeOfImageResized.width / 8.0);
                self.bottomLabel.font = [self.bottomLabel.font fontWithSize:fontSize];
                self.bottomLabel.frame = CGRectMake(self.bottomLabel.frame.origin.x, self.bottomLabel.frame.origin.y,sizeOfImageResized.width, fontSize);
                break;
            case 2:
                fontSize = (sizeOfImageResized.width / 6.0);
                self.bottomLabel.font = [self.topLabel.font fontWithSize:fontSize];
                self.bottomLabel.frame = CGRectMake(self.bottomLabel.frame.origin.x, self.bottomLabel.frame.origin.y,sizeOfImageResized.width, fontSize);
                break;
            case 3:
                fontSize = (sizeOfImageResized.width / 4.0);
                self.bottomLabel.font = [self.bottomLabel.font fontWithSize:fontSize];
                self.bottomLabel.frame = CGRectMake(self.bottomLabel.frame.origin.x, self.bottomLabel.frame.origin.y,sizeOfImageResized.width, fontSize);
                break;
            case 4:
                fontSize = (sizeOfImageResized.width / 2.0);
                self.bottomLabel.font = [self.bottomLabel.font fontWithSize:fontSize];
                self.bottomLabel.frame = CGRectMake(self.bottomLabel.frame.origin.x, self.bottomLabel.frame.origin.y,sizeOfImageResized.width, fontSize);
                break;
            default:
                break;
                
        }
    }
}

-(void)sizeState{
    if (fabs(fontSize - sizeOfImageResized.width / 10.0) < 0.00001) {
        self.segmentFontSize.selectedSegmentIndex = 0;
    }
    
    if (fabs(fontSize - sizeOfImageResized.width / 8.0) < 0.00001) {
        self.segmentFontSize.selectedSegmentIndex = 1;
    }
    
    if(fabs(fontSize - sizeOfImageResized.width / 6.0) < 0.00001) {
        self.segmentFontSize.selectedSegmentIndex = 2;
    }
    
    if (fabs(fontSize - sizeOfImageResized.width / 4.0) < 0.00001) {
        self.segmentFontSize.selectedSegmentIndex = 3;
    }
    
    if (fabs(fontSize - sizeOfImageResized.width / 2.0) < 0.00001) {
        self.segmentFontSize.selectedSegmentIndex = 4;
    }
}
- (IBAction)pickingFonts:(id)sender {
    [[NSBundle mainBundle]loadNibNamed:@"FontsView" owner:self options:nil];
    
    self.popupFonts = [KLCPopup popupWithContentView:self.fontView
                                            showType:KLCPopupShowTypeBounceIn
                                         dismissType:KLCPopupDismissTypeBounceOut
                                            maskType:KLCPopupMaskTypeClear
                            dismissOnBackgroundTouch:YES
                               dismissOnContentTouch:NO];
    
    self.fontView.frame = CGRectMake(0,
                                     0,
                                     self.viewForFont.bounds.size.width,
                                     self.viewForFont.frame.origin.y + self.fontLabel.bounds.size.height);
    //get all family fonts name
    [self getFontsName];
    
    [self.popupFonts showAtCenter:CGPointMake(self.pickingFontsButton.center.x,
                                              self.pickingFontsButton.center.y - self.pickingFontsButton.bounds.size.height - (self.fontView.bounds.size.height / 2.0))
                           inView:self.pickingFontsButton];
}
-(void)getFontsName{
    self.fontsName = [[NSMutableArray alloc]init];
    for (NSString *familyName in [UIFont familyNames]){
        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
            [self.fontsName addObject:fontName];
        }
    }
}
#pragma mark - settings table view font size
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.fontsName count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"FontCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.fontsName objectAtIndex:indexPath.row];
    cell.textLabel.minimumScaleFactor = 1.0 / cell.textLabel.font.pointSize;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.font = [self.fontsName objectAtIndex:indexPath.row];
    
    [self.popupFonts dismiss:YES];
    
    [self.pickingFontsButton setTitle:self.font forState:UIControlStateNormal];
}


- (IBAction)shareImage:(id)sender {
    [[NSBundle mainBundle]loadNibNamed:@"ShareView" owner:self options:nil];
    
    self.popupShare = [KLCPopup popupWithContentView:self.shareView
                                            showType:KLCPopupShowTypeBounceIn
                                         dismissType:KLCPopupDismissTypeBounceOut
                                            maskType:KLCPopupMaskTypeDimmed
                            dismissOnBackgroundTouch:YES
                               dismissOnContentTouch:NO];
    
    [self.popupShare show];
    
    self.shareView.frame = CGRectMake(0,
                                      0,
                                      self.view.bounds.size.width - 60,
                                      self.view.bounds.size.height / 2);
    self.shareView.layer.cornerRadius = 8.0;
    
    [self.shareViaEmail defaultStyle];
    [self.shareViaEmail addAwesomeIcon:FAIconCloud beforeTitle:YES];
    
    [self.shareViaFacebook primaryStyle];
    [self.shareViaFacebook addAwesomeIcon:FAIconFacebook beforeTitle:YES];
    
    [self.shareViaTwitter infoStyle];
    [self.shareViaTwitter addAwesomeIcon:FAIconTwitter beforeTitle:YES];
}

- (IBAction)shareViaEmailButton:(id)sender {
    NSLog(@"email");
    [self.popupShare dismiss:NO];
    [self configureAndDrawImage];
    
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc]init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Share Meme"];
        [mail setMessageBody:@"Real Meme" isHTML:NO];
        [mail addAttachmentData:UIImageJPEGRepresentation(self.imageForShare, 1) mimeType:@"image/jpeg" fileName:@"my image"];
        if (mail) {
            [self presentViewController:mail animated:YES completion:nil];
        }
    }else{
        NSLog(@"your device not ready for sent mail");
        UIAlertController *settingEmailBox = [UIAlertController
                                             alertControllerWithTitle:@"Settings Mail Box"
                                             message:@"You need to sign in your email account in your Mail app."
                                             preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [settingEmailBox addAction:defaultAction];
        
        [self presentViewController:settingEmailBox animated:YES completion:nil];
    }
    
    
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0)
{
    switch (result) {
        case MFMailComposeResultFailed:
            NSLog(@"failed");
            break;
        case MFMailComposeResultSent:
            NSLog(@"sended");
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"cancel");
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        case MFMailComposeResultSaved:
            NSLog(@"saved");
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        default:
            break;
    }
}
- (IBAction)shareViaTwitterButton:(id)sender {
    NSLog(@"twitter");
    [self.popupShare dismiss:NO];
    if (self.imageForShare == nil) {
        [self configureAndDrawImage];
    }
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *twitter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [twitter setInitialText:@"My meme"];
        [twitter addImage:self.imageForShare];
        [self presentViewController:twitter animated:YES completion:^{
            self.imageForShare = nil;
        }];
    }else{
        UIAlertController *servicesTypeNA = [UIAlertController
                                             alertControllerWithTitle:@"Twitter Share"
                                             message:@"You need to sign in your Twitter account in Settings."
                                             preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [servicesTypeNA addAction:defaultAction];
        
        [self presentViewController:servicesTypeNA animated:YES completion:nil];
    }
}
- (IBAction)shareViaFacebookButton:(id)sender {
    NSLog(@"facebook");
    [self.popupShare dismiss:NO];
    
    if (self.imageForShare == nil) {
        [self configureAndDrawImage];
    }
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *facebook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebook setInitialText:@"My meme"];
        [facebook addImage:self.imageForShare];
        [self presentViewController:facebook animated:YES completion:^{
            self.imageForShare = nil;
        }];
    }else{
        UIAlertController *servicesTypeNA = [UIAlertController
                                             alertControllerWithTitle:@"Facebook Share"
                                             message:@"You need to sign in your facebook account in Settings."
                                             preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [servicesTypeNA addAction:defaultAction];
        
        [self presentViewController:servicesTypeNA animated:YES completion:nil];
    }
    
}

#pragma mark - reset button
-(IBAction)resetTopText:(id)sender{
    self.topLabel.center = CGPointMake(sizeOfImageResized.width / 2.0,
                                       sizeOfImageResized.height/10.0);
    
}
-(IBAction)resetBottomText:(id)sender{
    self.bottomLabel.center = CGPointMake(sizeOfImageResized.width / 2.0,
                                          sizeOfImageResized.height - self.bottomLabel.bounds.size.height);
}


-(void)initDoneButtonForIPad:(BOOL)isIpad{
    if (isIpad) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
        
        self.navigationItem.leftBarButtonItem = doneButton;
    }
}
-(void)done:(id)sender{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end

