#import "ViewController.h"

#import <UIKit/UIKit.h>

#import "ApiAI.h"
#import "AIDefaultConfiguration.h"
#import "AIResponse.h"
#import "AIRequestEntity.h"

@interface ViewController ()
@property(nonatomic, strong) ApiAI *apiai;
@end

@implementation ViewController
@synthesize textLabel;
NSString *result2 = @"";
NSInteger newTime = 30;

- (void)viewDidAppear:(BOOL)animated{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    bool log = [defaults boolForKey:@"loggedIn"];
    if(!log)
    {
        [self performSegueWithIdentifier:@"loginView" sender:self];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Allocate and initialize the SFSpeechRecognizer.
    recognizer = [[SFSpeechRecognizer alloc] initWithLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    recognizer.delegate = self;
 
    // Request access for the SFSpeechRecognizer, user must give access for the speech recognizer to work
    // once they give access they do not have to do it again
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        switch (status) {
            
            // Authorized Speech Recognizer
            case SFSpeechRecognizerAuthorizationStatusAuthorized:
                NSLog(@"Authorized");
                break;
            
            // Denied Speech Recognizer
            case SFSpeechRecognizerAuthorizationStatusDenied:
                NSLog(@"Denied");
                break;
            
            // Speech Recognizer Not Determined
            case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                NSLog(@"Not Determined");
                break;
            
            // Speech Recognizer Restricted
            case SFSpeechRecognizerAuthorizationStatusRestricted:
                NSLog(@"Restricted");
                break;
            
            default:
                break;
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)listen{
    
    // Initialize connection with Dialogflow
    ApiAI *apiai = [ApiAI sharedApiAI];
    AIDefaultConfiguration *configuration = [[AIDefaultConfiguration alloc] init];
    configuration.clientAccessToken = @"459d0c7aeb8943d89af0757cdef42bf6";
    [apiai setConfiguration:configuration];
    apiai.lang = @"en";
    self.apiai = apiai;
    
                // AVAudioEngine for speech to text
    /* * * * * * * * * * * * * * * * * * * * * * * * * * * */
    // Create AVAudioEngine, SFSpeechAudioBufferRecognitionRequest,
    avAudio = [[AVAudioEngine alloc] init];
    bufferRecognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    
    // Check if the SFSpeechRecognitionTask is running or not, if it is
    // then stop it and set it to null
    if (recognitionTask){
        
        [recognitionTask cancel];
        recognitionTask = nil;
    }
    
    NSError *error;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryRecord error:&error];
    [session setActive:YES error:&error];
    
    AVAudioInputNode *input = avAudio.inputNode;
    bufferRecognitionRequest.shouldReportPartialResults = YES;
    
    recognitionTask = [recognizer recognitionTaskWithRequest:bufferRecognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        BOOL isFinal = NO;
        
        // Store what the user says in result.
        if (result) {
            
                    // Send in the result to API.AI
            /* * * * * * * * * * * * * * * * * * * * * * * * * * * */
            AITextRequest *request = [_apiai textRequest];
            request.query = @[result];
            [request setCompletionBlockSuccess:^(AIRequest *request, id response) {
                // Handle success ...
            } failure:^(AIRequest *request, NSError *error) {
                // Handle error ...
            }];

            [_apiAI enqueue:request];
            /* * * * * * * * * * * * * * * * * * * * * * * * * * * */
            
            // Update the text label on the screen
            textLabel.text = result.bestTranscription.formattedString;
            
            result2 = @"";
            result2 = result.bestTranscription.formattedString;
            
            // Print out the result from speech to text
            isFinal = !result.isFinal;
        }
        
        // If there is an error, stop the AVAudioEngine and reset recognition tasks
        if (error) {
        
            [avAudio stop];
            [input removeTapOnBus:0];
            bufferRecognitionRequest = nil;
            recognitionTask = nil;
        }
    }];
    
    // Create AVAudioFormat
    AVAudioFormat *recordingFormat = [input outputFormatForBus:0];
    [input installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [bufferRecognitionRequest appendAudioPCMBuffer:buffer];
    }];
    
    // Starts the audio engine, i.e. it starts listening.
    [avAudio prepare];
    [avAudio startAndReturnError:&error];
    /* * * * * * * * * * * * * * * * * * * * * * * * * * * */
}


// Give the microphone button and IBAction
- (IBAction)microphone:(id)sender{
    
    // If the AVAudioEngine is running, stop it and end the recognition request
    if (avAudio.isRunning){
        [avAudio stop];
        [bufferRecognitionRequest endAudio];
        
        // If the user requests an order, create an opportunity for the user to cancel their order
        if ([result2 containsString:@"order"] || [result2 containsString:@"Order"]){
            
            // Make a timer
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown:)
                                           userInfo:nil repeats:YES];
            
            // Create the pop up window
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Cancel" message:@"Would you like to proceed with your order?" preferredStyle:UIAlertControllerStyleAlert];
            
            // Add two actions, cancel and proceed
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {[self cancelOrder];}];
            
            UIAlertAction* proceedAction = [UIAlertAction actionWithTitle:@"Proceed" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {[self proceedOrder];}];
            
            [alert addAction:cancelAction];
            [alert addAction:proceedAction];
            
            [self presentViewController:(alert) animated:true completion:nil];
        }else{
            // If an order is not placed, process what the user requested
        }
    }
    
    // If the AVAudioEngine is not running then call listen to set up new buffer to record to
    else{
        [self listen];
    }
}


// Create countdown for closing pop up window and placing an order
-(void)countDown:(NSTimer *)timer {
    // If the timer is 0, stop the timer, place the order and close the pop up
    if (--newTime == 0) {
        [timer invalidate];
        [self proceedOrder];
        [self dismissViewControllerAnimated:YES completion:nil];
        newTime = 30;
    }
}


// Proceed with order if user hits proceed button or waits 30 seconds
- (void)proceedOrder{
    textLabel.text = @"Order Placed!";
}


// Cancel order if user hits cancel button
- (void)cancelOrder{
    textLabel.text = @"Order Canceled!";
}


@end
