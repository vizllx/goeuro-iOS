//
//  MainVC.m
//  goeuro_SM
//
//  Created by Sandeep-M on 12/09/16.
//  Copyright © 2016 Sandeep-Mukherjee. All rights reserved.
//

#import "MainVC.h"




@implementation MainVC
{
    NSMutableArray *arrAirlineList;
    NSMutableArray *arrBusList;
    NSMutableArray *arrTrainList;
    SplashVC * splashVC;
    UIImageOrientation scrollOrientation;
    CGPoint lastPos;
    UIAlertController *alertController;
    
    
}
-(void)viewDidLoad
{
    [self setNeedsStatusBarAppearanceUpdate];
    
    
    arrAirlineList=[[NSMutableArray alloc]init];
    arrTrainList=[[NSMutableArray alloc]init];
    arrBusList=[[NSMutableArray alloc]init];
    
    
    //Notification declaration
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeAnimatedSplash:)
                                                 name:@"RemoveSplash"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchDataOnActiveInternet:)
                                                 name:@"ActiveConnectionFound"
                                               object:nil];
    
    
    //Adding custom splash animation
    
    [self addAnimatedSplash];
    
    
    
    
    
    
    //load intial list of trains
    self.btnTrain.selected=YES;
    [self loadTrainListWebservice];
    
    
    
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}
#pragma mark - Notifiaction Action on Active Internet connection

-(void)fetchDataOnActiveInternet:(NSNotification *)notify
{
    
    if(self.btnTrain.selected)
    {
        if([arrTrainList count]==0)
        {
            [self loadTrainListWebservice];
        }
    }
    else if(self.btnBus.selected)
    {
        if([arrBusList count]==0)
        {
            [self loadBusListWebservice];
            
        }
        
    }
    else
    {
        if([arrAirlineList count]==0)
        {
            [self loadFlightListWebservice];
            
        }
        
    }
    
    
    
    
    
}
#pragma mark - Alert controller methods for Sorting List  call event


-(void)showSortAlert
{
    
    alertController = [UIAlertController alertControllerWithTitle:@"GoEuro" message:@"Select sort type" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Sort by arrival time" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self sortByArrivalTime];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Sort by duration" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self sortByDuration];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Sort by departure time" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self sortBydepartureTime];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self closeAlertview];
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^ {
        [self presentViewController:alertController animated:YES completion:nil];
    });
    
    
}

-(void)sortByArrivalTime
{
    NSDateFormatter *fmtTime = [[NSDateFormatter alloc] init];
    [fmtTime setDateFormat:@"HH:mm"];
    
    NSComparator compareTimes = ^(id string1, id string2)
    {
        NSDate *time1 = [fmtTime dateFromString:string1];
        NSDate *time2 = [fmtTime dateFromString:string2];
        
        return [time1 compare:time2];
    };
    
    NSSortDescriptor * sortDesc1 = [NSSortDescriptor sortDescriptorWithKey:@"arrival_time" ascending:YES comparator:compareTimes];
    
    if(self.btnTrain.selected)
    {
        [arrTrainList sortUsingDescriptors:@[sortDesc1]];
    }
    else if(self.btnBus.selected)
    {
        [arrBusList sortUsingDescriptors:@[sortDesc1]];
        
    }
    else
    {
        [arrAirlineList sortUsingDescriptors:@[sortDesc1]];
        
        
    }
    [self.tblView reloadData];
    
    
    
    
}
-(void)sortByDuration
{
    NSDateFormatter *fmtTime = [[NSDateFormatter alloc] init];
    [fmtTime setDateFormat:@"HH:mm"];
    
    NSComparator compareTimes = ^(id string1, id string2)
    {
        NSDate *time1 = [fmtTime dateFromString:string1];
        NSDate *time2 = [fmtTime dateFromString:string2];
        
        return [time1 compare:time2];
    };
    
    NSSortDescriptor * sortDesc1 = [NSSortDescriptor sortDescriptorWithKey:@"duration" ascending:YES comparator:compareTimes];
    
    if(self.btnTrain.selected)
    {
        [arrTrainList sortUsingDescriptors:@[sortDesc1]];
    }
    else if(self.btnBus.selected)
    {
        [arrBusList sortUsingDescriptors:@[sortDesc1]];
        
    }
    else
    {
        [arrAirlineList sortUsingDescriptors:@[sortDesc1]];
        
        
    }
    [self.tblView reloadData];
    
}
-(void)sortBydepartureTime
{
    NSDateFormatter *fmtTime = [[NSDateFormatter alloc] init];
    [fmtTime setDateFormat:@"HH:mm"];
    
    NSComparator compareTimes = ^(id string1, id string2)
    {
        NSDate *time1 = [fmtTime dateFromString:string1];
        NSDate *time2 = [fmtTime dateFromString:string2];
        
        return [time1 compare:time2];
    };
    
    NSSortDescriptor * sortDesc1 = [NSSortDescriptor sortDescriptorWithKey:@"departure_time" ascending:YES comparator:compareTimes];
    
    if(self.btnTrain.selected)
    {
        [arrTrainList sortUsingDescriptors:@[sortDesc1]];
    }
    else if(self.btnBus.selected)
    {
        [arrBusList sortUsingDescriptors:@[sortDesc1]];
        
    }
    else
    {
        [arrAirlineList sortUsingDescriptors:@[sortDesc1]];
        
        
    }
    [self.tblView reloadData];
}
-(void)closeAlertview
{
    [alertController dismissViewControllerAnimated:true completion:^{
    }];
    
    
}
#pragma mark - Webservice call event

-(void)loadTrainListWebservice
{
    
    
    [[DataAPI  new] makeGet:trainsAPI completionHandler:^(NSArray* jsonResponseArray, BOOL success){
        if(success)
        {
            
            for(int i=0;i<[jsonResponseArray count];i++)
            {
                TravelModel *travelModelObj=[[TravelModel alloc]initWithDictionary:[jsonResponseArray objectAtIndex:i] error:nil];
                
                travelModelObj.duration=[[HelperUtilityClass  sharedInstance] dateToStringTransformer:[[HelperUtilityClass  sharedInstance]getTimeDuration:[[HelperUtilityClass  sharedInstance] stringToDateTransformer:travelModelObj.arrival_time] departureTime:[[HelperUtilityClass  sharedInstance] stringToDateTransformer:travelModelObj.departure_time]]];
                
                
                [arrTrainList addObject:travelModelObj];
                
                
            }
            
            if(self.btnTrain.selected)
            {
                [self sortBydepartureTime];
                
            }
            if([arrTrainList count]>1)
            {
                self.tblView.alpha=1;
            }
            
            
            
        }
        else
        {
            if(![AFNetworkReachabilityManager sharedManager].reachable)
            {
                [self.view makeToastWithMessage:@"No active internet connection found."];
                
                
            }
            else
            {
                [self.view makeToastWithMessage:@"There is an internal server error,try again later."];
                
            }
            
        }
    }];
    
    
    
    
}

-(void)loadFlightListWebservice
{
    [[HelperUtilityClass new] showHUD:self.view];
    
    [[DataAPI  new] makeGet:flightsAPI completionHandler:^(NSArray* jsonResponseArray, BOOL success){
        if(success)
        {
            
            for(int i=0;i<[jsonResponseArray count];i++)
            {
                TravelModel *travelModelObj=[[TravelModel alloc]initWithDictionary:[jsonResponseArray objectAtIndex:i] error:nil];
                travelModelObj.duration=[[HelperUtilityClass  sharedInstance] dateToStringTransformer:[[HelperUtilityClass  sharedInstance]getTimeDuration:[[HelperUtilityClass  sharedInstance] stringToDateTransformer:travelModelObj.arrival_time] departureTime:[[HelperUtilityClass  sharedInstance] stringToDateTransformer:travelModelObj.departure_time]]];
                [arrAirlineList addObject:travelModelObj];
                
                
            }
            
            if(self.btnFlight.selected)
            {
                [self sortBydepartureTime];
                
            }
            if([arrAirlineList count]>1)
            {
                self.tblView.alpha=1;
            }
            
            
        }
        else
        {
            if(![AFNetworkReachabilityManager sharedManager].reachable)
            {
                [self.view makeToastWithMessage:@"No active internet connection found."];
                
                
            }
            else
            {
                [self.view makeToastWithMessage:@"There is an internal server error,try again later."];
                
            }
            
        }
        [[HelperUtilityClass new] removeHUD:self.view];
        
    }];
    
    
    
    
}

-(void)loadBusListWebservice
{
    [[HelperUtilityClass new] showHUD:self.view];
    
    [[DataAPI  new] makeGet:busesAPI completionHandler:^(NSArray* jsonResponseArray, BOOL success){
        if(success)
        {
            
            for(int i=0;i<[jsonResponseArray count];i++)
            {
                TravelModel *travelModelObj=[[TravelModel alloc]initWithDictionary:[jsonResponseArray objectAtIndex:i] error:nil];
                
                travelModelObj.duration=[[HelperUtilityClass  sharedInstance] dateToStringTransformer:[[HelperUtilityClass  sharedInstance]getTimeDuration:[[HelperUtilityClass  sharedInstance] stringToDateTransformer:travelModelObj.arrival_time] departureTime:[[HelperUtilityClass  sharedInstance] stringToDateTransformer:travelModelObj.departure_time]]];
                [arrBusList addObject:travelModelObj];
                
                
            }
            if(self.btnBus.selected)
            {
                [self sortBydepartureTime];
                
            }
            if([arrBusList count]>1)
            {
                self.tblView.alpha=1;
            }
            
            
            
        }
        else
        {
            if(![AFNetworkReachabilityManager sharedManager].reachable)
            {
                [self.view makeToastWithMessage:@"No active internet connection found."];
                
                
            }
            else
            {
                [self.view makeToastWithMessage:@"There is an internal server error,try again later."];
                
            }
            
        }
        [[HelperUtilityClass new] removeHUD:self.view];
        
        
    }];
    
    
}

#pragma mark - Utility Methods


-(void)addAnimatedSplash
{
    splashVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SplashVC"];
    [self addChildViewController:splashVC];                 // 1
    splashVC.view.bounds = self.view.bounds;                 //2
    [self.view addSubview:splashVC.view];
    [splashVC didMoveToParentViewController:self];          // 3
    
    
}
-(void)removeAnimatedSplash:(NSNotification *)notification
{
    [splashVC willMoveToParentViewController:nil];
    [splashVC.view removeFromSuperview];
    [splashVC removeFromParentViewController];
    [self.tblView reloadData];
    //show network status
    if(![AFNetworkReachabilityManager sharedManager].reachable)
    {
        [self.view makeToastWithMessage:@"No active internet connection found."];
        
        
    }
    
    
    
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.btnTrain.selected)
    {
        return  [arrTrainList count];
        
    }
    else if(self.btnBus.selected)
    {
        return  [arrBusList count];
        
    }
    else
    {
        return  [arrAirlineList count];
    }
    
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:@"TravelCell"];
    if (Cell == nil) {
        Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TravelCell"];
    }
    TravelModel *travelModelObj;
    // Configure Cell
    if(self.btnTrain.selected)
    {
        
        if(indexPath.row<=[arrTrainList count])
        {
            travelModelObj=(TravelModel *)[arrTrainList objectAtIndex:indexPath.row];
        }
        else
        {
            return Cell;
        }
    }
    else if(self.btnBus.selected)
    {
        
        
        if(indexPath.row<=[arrBusList count])
        {
            
            travelModelObj=(TravelModel *)[arrBusList objectAtIndex:indexPath.row];
        }
        else
        {
            return Cell;
        }
        
        
    }
    else
    {
        
        
        if(indexPath.row<=[arrAirlineList count])
        {
            travelModelObj=(TravelModel *)[arrAirlineList objectAtIndex:indexPath.row];
        }
        else
        {
            return Cell;
        }
        
        
    }
    UIImageView *imgLogo=(UIImageView *)[Cell.contentView viewWithTag:1];
    UILabel *lblPrice=(UILabel *)[Cell.contentView viewWithTag:2];
    UILabel *lblTime=(UILabel *)[Cell.contentView viewWithTag:3];
    UILabel *lblDuration=(UILabel *)[Cell.contentView viewWithTag:4];
    
    lblTime.text = [NSString stringWithFormat:@"%@ - %@",[[HelperUtilityClass  sharedInstance]  dateToStringTransformer:[[HelperUtilityClass  sharedInstance] stringToDateTransformer:travelModelObj.departure_time]],[[HelperUtilityClass  sharedInstance]  dateToStringTransformer:[[HelperUtilityClass  sharedInstance] stringToDateTransformer:travelModelObj.arrival_time]]];
    
    
    
    lblDuration.text = [NSString stringWithFormat:@"Duration : %@h",travelModelObj.duration];
    
    lblPrice.text = [NSString stringWithFormat:@"€%.2f", [travelModelObj.price_in_euros floatValue]];
    
    NSString *urlTextEscaped =
    [[[HelperUtilityClass  sharedInstance]getImgURLwithSize:travelModelObj.provider_logo size:63]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    UIImage *appIcon = [UIImage
                        imageNamed:[[[[[[NSBundle mainBundle] infoDictionary]
                                       objectForKey:@"CFBundleIcons"]
                                      objectForKey:@"CFBundlePrimaryIcon"]
                                     objectForKey:@"CFBundleIconFiles"] objectAtIndex:0]];
    __weak UIImageView *weakSelf = imgLogo;
    
    
    [imgLogo
     setImageWithURLRequest:
     [NSURLRequest requestWithURL:[NSURL URLWithString:urlTextEscaped]]
     placeholderImage:appIcon
     success:^(NSURLRequest *request, NSHTTPURLResponse *response,
               UIImage *image) {
         
         weakSelf.image = image;
         
     }
     failure:^(NSURLRequest *request, NSHTTPURLResponse *response,
               NSError *error){
     }];
    
    
    return Cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"Offer details are not yet implemented!"
                                                   delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



#pragma mark - Animate View Methods


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    scrollOrientation = scrollView.contentOffset.y > lastPos.y?UIImageOrientationDown:UIImageOrientationUp;
    lastPos = scrollView.contentOffset;
    
}


- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.isDragging) {
        UIView *myView = cell.contentView;
        CALayer *layer = myView.layer;
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -1000;
        if (scrollOrientation == UIImageOrientationDown) {
            rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, M_PI*0.5, 1.0f, 0.0f, 0.0f);
        } else {
            rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, -M_PI*0.5, 1.0f, 0.0f, 0.0f);
        }
        layer.transform = rotationAndPerspectiveTransform;
        [UIView animateWithDuration:.5 animations:^{
            layer.transform = CATransform3DIdentity;
        }];
    }
}



-(void)animateSlider:(UIButton*)btn
{
    
    
    CGRect frame=self.viewHighlighter.frame;
    frame.origin.x=(btn.center.x-30);
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.viewHighlighter.frame=frame;
        self.viewHighlighter.transform=CGAffineTransformMakeScale(2.5, 1.0);
        
        
        
    }completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.3f initialSpringVelocity:0.2f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.viewHighlighter.transform=CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
        }];
        
    }];
}

#pragma mark - Button Action

- (IBAction)btnBusSelected:(id)sender {
    if(!self.btnBus.selected)
    {
        self.btnTrain.selected=self.btnFlight.selected=NO;
        self.btnBus.selected=YES;
        [self animateSlider:self.btnBus];
        if([arrBusList count]==0)
        {
            self.tblView.alpha=0;
            
            [self loadBusListWebservice];
        }
        else
        {
            self.tblView.alpha=1;
            [self.tblView reloadData];
        }
        
    }
    
    
    
}

- (IBAction)btnTrainSelected:(id)sender {
    if(!self.btnTrain.selected)
    {
        self.btnBus.selected=self.btnFlight.selected=NO;
        self.btnTrain.selected=YES;
        
        [self animateSlider:self.btnTrain];
        if([arrTrainList count]==0)
        {
            self.tblView.alpha=0;
            
            [self loadTrainListWebservice];
        }
        else
        {
            self.tblView.alpha=1;
            
            [self.tblView reloadData];
        }
        
    }
    
    
}
- (IBAction)btnFlightSelected:(id)sender {
    if(!self.btnFlight.selected)
    {
        self.btnTrain.selected=self.btnBus.selected=NO;
        self.btnFlight.selected=YES;
        
        [self animateSlider:self.btnFlight];
        if([arrAirlineList count]==0)
        {
            self.tblView.alpha=0;
            
            [self loadFlightListWebservice];
        }
        else
        {
            self.tblView.alpha=1;
            
            [self.tblView reloadData];
        }
    }
    
    
}
- (IBAction)sortAction:(id)sender {
    
    if(self.btnTrain.selected)
    {
        if([arrTrainList count]==0)
        {
            [self.view makeToastWithMessage:@"The list is empty,sort is not possible."];
            
        }
        else
        {
            [self showSortAlert];
            
        }
    }
    else if(self.btnBus.selected)
    {
        if([arrBusList count]==0)
        {
            [self.view makeToastWithMessage:@"The list is empty,sort is not possible."];
            
        }
        else
        {
            [self showSortAlert];
            
        }
        
    }
    else
    {
        if([arrAirlineList count]==0)
        {
            [self.view makeToastWithMessage:@"The list is empty,sort is not possible."];
            
        }
        else
        {
            [self showSortAlert];
            
        }
        
    }
    
}
@end
