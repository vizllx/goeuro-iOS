//
//  MainVC.h
//  goeuro_SM
//
//  Created by Sandeep-M on 12/09/16.
//  Copyright © 2016 Sandeep-Mukherjee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h" 




@interface MainVC : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *btnTrain;
@property (weak, nonatomic) IBOutlet UIButton *btnFlight;
@property (weak, nonatomic) IBOutlet UIButton *btnSort;
@property (weak, nonatomic) IBOutlet UIButton *btnBus;
- (IBAction)btnFlightSelected:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tblView;
- (IBAction)btnBusSelected:(id)sender;
- (IBAction)btnTrainSelected:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewHighlighter;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
- (IBAction)sortAction:(id)sender;

@end
