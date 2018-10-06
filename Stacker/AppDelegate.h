//
//  AppDelegate.h
//  Stacker
//
//  Created by pbarnard on 30/08/2018.
//  Copyright © 2018 ToxicCelery.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate> {
	NSAppleScript *key;
	int steps;
    int stepSize;
	int thisStep;
	float period;
	float focus;
	NSTimer *periodTimer;
	NSTimer *focusTimer;
	NSUserDefaults * prefs;
	NSDictionary *defaultPrefs;

	
	__weak IBOutlet NSTextField *stepsText;
	__weak IBOutlet NSTextField *periodText;
	__weak IBOutlet NSTextField *focusText;
	__weak IBOutlet NSButton *goButton;
	__weak IBOutlet NSTextField *StatusText;
	__weak IBOutlet NSButton *stopButton;
	__weak IBOutlet NSButton *fineRadio;
	__weak IBOutlet NSButton *coarseRadio;
	__weak IBOutlet NSButton *xCoarseRadio;
	__weak IBOutlet NSButton *homeCheck;
    __weak IBOutlet NSSlider *stepSizeSlider;
    __weak IBOutlet NSTextField *stepSizeText;
}


- (IBAction)stopStack:(id)sender;
- (IBAction)ActionStack:(id)sender;
- (IBAction)stepsChanged:(id)sender;
- (IBAction)periodChanged:(id)sender;
- (IBAction)focusChanged:(id)sender;
- (IBAction)fineChanged:(id)sender;
- (IBAction)coarseChanged:(id)sender;
- (IBAction)xCoarseChanged:(id)sender;
- (IBAction)stepSizeChaged:(id)sender;


@end

