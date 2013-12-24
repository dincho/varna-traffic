//
//  StationsViewController.m
//  Varna Traffic
//
//  Created by Dincho Todorov on 12/1/13.
//  Copyright (c) 2013 Dincho Todorov. All rights reserved.
//

#import "StationsViewController.h"
#import "StationsMapViewController.h"
#import "StationsListViewController.h"
#import "Station.h"


@interface StationsViewController ()

@property (nonatomic, weak) UIViewController* currentViewController;
@property (weak, nonatomic) IBOutlet UIView *contentView;


@end

@implementation StationsViewController

@synthesize stations;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
	// Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"viewdidload");
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)control
{
    NSLog(@"segmentedControlValueChanged: %d", control.selectedSegmentIndex);
}

- (void)displayContentController:(UIViewController*)content;
{
    [self addChildViewController:content];                 // 1
//    content.view.frame = self.contentView.frame;                  // 2
    [self.contentView addSubview:content.view];
    [content didMoveToParentViewController:self];          // 3
}

- (void)hideContentController:(UIViewController*)content
{
    [content willMoveToParentViewController:nil];  // 1
    [content.view removeFromSuperview];            // 2
    [content removeFromParentViewController];      // 3
}

- (void)switchToContentViewController:(UIViewController *)vc
{
    if (nil != self.currentViewController) {
	[self hideContentController:self.currentViewController];
    }

    [self displayContentController:vc];
}

- (void)loadStations:(void (^)(NSArray *stations))completionBlock
{
    NSURL *url = [NSURL URLWithString:@"http://varnatraffic.com/Ajax/GetStations"];

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
	 if (nil != error) {
	     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error: %d", [error code]]
							     message:[error localizedDescription]
							    delegate:nil
						   cancelButtonTitle:@"OK"
						   otherButtonTitles:nil];
	     [alert show];
	     return;
	 }

	 NSMutableArray *newStations = [NSMutableArray array];
	 NSArray *stationsArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
	 for (NSDictionary *stationDict in stationsArray) {
	     Station *station = [[Station alloc] initWithDictionary:stationDict];
	     [newStations insertObject:station atIndex:[newStations count]];
	 }

	 self.stations = [NSArray arrayWithArray:newStations];
	 completionBlock(self.stations);
     }];
}

- (NSArray *)stationDevicesWithID:(NSNumber *)stationID
{
    return [NSArray array];
}

- (NSArray *)lineWithID:(NSString *)lineID
{
    return [NSArray array];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"stationsMapVC"])
    {
	StationsMapViewController *vc = [segue destinationViewController];
	[vc setDataSource:self];
    }

    if ([[segue identifier] isEqualToString:@"stationsListVC"])
    {
	StationsListViewController *vc = [segue destinationViewController];
	[vc setDataSource:self];
    }
}


@end
