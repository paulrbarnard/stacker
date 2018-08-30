//
//  AppDelegate.m
//  Stacker
//
//  Created by pbarnard on 30/08/2018.
//  Copyright © 2018 ToxicCelery.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application
	NSArray *userDefaults = [NSArray arrayWithObjects:@"10",@"2",@"1",@"0",@"1",@"0",@"1",nil];
	NSArray *keys = [NSArray arrayWithObjects:@"steps",@"period",@"focus",@"fine",@"medium",@"coarse",@"home",nil];
	defaultPrefs = [NSDictionary dictionaryWithObjects:userDefaults forKeys:keys];
	prefs = [NSUserDefaults standardUserDefaults];
	[prefs registerDefaults:defaultPrefs];
	
	steps = [[prefs valueForKey:@"steps"] intValue];
	period = [[prefs valueForKey:@"period"] floatValue];
	focus = [[prefs valueForKey:@"focus"] floatValue];
	stepsText.intValue = steps;
	periodText.floatValue = period;
	focusText.floatValue = focus;
	StatusText.stringValue = @"";
	stopButton.enabled = FALSE;
	fineRadio.state = [[prefs valueForKey:@"fine"] boolValue];
	coarseRadio.state = [[prefs valueForKey:@"medium"] boolValue];
	xCoarseRadio.state = [[prefs valueForKey:@"coarse"] boolValue];
	homeCheck.state = [[prefs valueForKey:@"home"] boolValue];
}

-(BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return YES;
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
	[prefs setObject:[NSString stringWithFormat:@"%d",steps] forKey:@"steps"];
	[prefs setObject:[NSString stringWithFormat:@"%f",period] forKey:@"period"];
	[prefs setObject:[NSString stringWithFormat:@"%f",focus] forKey:@"focus"];
	[prefs setObject:[NSString stringWithFormat:@"%ld",(long)fineRadio.state] forKey:@"fine"];
	[prefs setObject:[NSString stringWithFormat:@"%ld",(long)coarseRadio.state] forKey:@"medium"];
	[prefs setObject:[NSString stringWithFormat:@"%ld",(long)xCoarseRadio.state] forKey:@"coarse"];
	[prefs setObject:[NSString stringWithFormat:@"%ld",(long)homeCheck.state] forKey:@"home"];
}


- (IBAction)stopStack:(id)sender {
	[self stopFocusTimer];
	[self stopPeriodTimer];
	stopButton.enabled = FALSE;
	goButton.enabled = TRUE;
}

- (IBAction)ActionStack:(id)sender {
	dispatch_async(dispatch_get_main_queue(), ^{
		[self nearFocus];
		self->thisStep = 0;
		[self startFocusTimer:2];  // make initial start 2 seconds
	});
	goButton.enabled = FALSE;
	stopButton.enabled = TRUE;
}

-(void)activateRemote{
	NSAppleScript *command = [[NSAppleScript alloc] initWithSource:@"activate application \"Remote\""];
	[command executeAndReturnError:nil];
}

-(void)nearFocus{
	if(homeCheck.state == TRUE){
		[self activateRemote];
		NSAppleScript *command = [[NSAppleScript alloc] initWithSource:@"tell application \"System Events\" to keystroke \"qqqq\""];
		[command executeAndReturnError:nil];
		[self startFocusTimer:2];  // wait 2 seconds before first frame
	}
}

-(void)stepFocus{
	[self activateRemote];
	NSAppleScript *command;
	if(fineRadio.state == TRUE){
		command = [[NSAppleScript alloc] initWithSource:@"tell application \"System Events\" to keystroke \"rr\""];
	} else if(coarseRadio.state == TRUE){
		command = [[NSAppleScript alloc] initWithSource:@"tell application \"System Events\" to keystroke \"t\""];
	} else {
		command = [[NSAppleScript alloc] initWithSource:@"tell application \"System Events\" to keystroke \"ttttt\""];
	}
	[command executeAndReturnError:nil];
}

-(void)takeImage{
	[self activateRemote];
	NSAppleScript *command = [[NSAppleScript alloc] initWithSource:@"tell application \"System Events\" to keystroke \"1\""];
	[command executeAndReturnError:nil];
	StatusText.stringValue = [NSString stringWithFormat:@"Taken %i images of %i", thisStep, steps];
	if(thisStep < steps){ // deal with the case of just one image
		[self startPeriodTimer:period];
		thisStep ++;
	} else {
		goButton.enabled = TRUE;
		stopButton.enabled = FALSE;
		[self.window makeKeyAndOrderFront:self.window];
	}
}


- (IBAction)stepsChanged:(id)sender {
	steps = stepsText.intValue;
}

- (IBAction)periodChanged:(id)sender {
	period = periodText.floatValue;
}

- (IBAction)focusChanged:(id)sender {
	focus = focusText.floatValue;
}

- (IBAction)fineChanged:(id)sender {
	coarseRadio.state = !fineRadio.state;
	xCoarseRadio.state = !fineRadio.state;
}

- (IBAction)coarseChanged:(id)sender {
	fineRadio.state = !coarseRadio.state;
	xCoarseRadio.state = !coarseRadio.state;
}

- (IBAction)xCoarseChanged:(id)sender {
	fineRadio.state = !xCoarseRadio.state;
	coarseRadio.state = !xCoarseRadio.state;
}


-(void)startPeriodTimer:(double)duration{
	[self stopPeriodTimer];
	periodTimer = [NSTimer scheduledTimerWithTimeInterval:period target:self selector:@selector(periodTimerTriggered:) userInfo:nil repeats:NO];
}

-(void)stopPeriodTimer{
	if (periodTimer) {
		[periodTimer invalidate];
	}
}

-(void)periodTimerTriggered:(NSTimer *)timer{
	dispatch_async(dispatch_get_main_queue(), ^{
	[self stepFocus];
	});
	[self startFocusTimer:focus];
}


-(void)startFocusTimer:(double)duration{
	[self stopFocusTimer];
	periodTimer = [NSTimer scheduledTimerWithTimeInterval:period target:self selector:@selector(focusTimerTriggered:) userInfo:nil repeats:NO];
}

-(void)stopFocusTimer{
	if (focusTimer) {
		[focusTimer invalidate];
	}
}

-(void)focusTimerTriggered:(NSTimer *)timer{
	dispatch_async(dispatch_get_main_queue(), ^{
	[self takeImage];
	});
}



@end


