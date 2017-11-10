#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

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
    
                    // API.AI
    /* * * * * * * * * * * * * * * * * * * * * * * * * * * */
    // Initialize API.AI (Now Dialogflow)
    self.apiAI = [[ApiAI alloc] init];
    
    // Define API.AI configuration here.
    id <AIConfiguration> configuration = [[AIDefaultConfiguration alloc] init];
    configuration.clientAccessToken = @"459d0c7aeb8943d89af0757cdef42bf6";
    self.apiAI.configuration = configuration;
    /* * * * * * * * * * * * * * * * * * * * * * * * * * * */
    
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
            AITextRequest *request = [ApiAI textRequest];
            request.query = @[result];
            [request setCompletionBlockSuccess:^(AIRequest *request, id response) {
                // Handle success ...
            } failure:^(AIRequest *request, NSError *error) {
                // Handle error ...
            }];
            
            [_apiAI enqueue:request];
            /* * * * * * * * * * * * * * * * * * * * * * * * * * * */
            
            // Print out the result from speech to text
            NSLog(@"RESULT:%@",result.bestTranscription.formattedString);
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


// Create new Delegate Method for the recognizer
#pragma mark - SFSpeechRecognizerDelegate Delegate Methods
- (void)recognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available {
    NSLog(@"Availability:%d",available);
}


// Give the microphone button and IBAction
- (IBAction)microphone:(id)sender{
    
    // If the AVAudioEngine is running, stop it and end the recognition request
    if (avAudio.isRunning){
        [avAudio stop];
        [bufferRecognitionRequest endAudio];
    }
    
    // If the AVAudioEngine is not running then call listen to set up new buffer to record to
    else{
        [self listen];
    }
}


@end
