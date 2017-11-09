#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    recognizer = [[SFSpeechRecognizer alloc] initWithLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    recognizer.delegate = self;
 
    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        switch (status) {
            
            case SFSpeechRecognizerAuthorizationStatusAuthorized:
                NSLog(@"Authorized");
                break;
            
            case SFSpeechRecognizerAuthorizationStatusDenied:
                NSLog(@"Denied");
                break;
            
            case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                NSLog(@"Not Determined");
                break;
            
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
    
    NSLog(@"Started Listen");
    // Create AVAudioEngine, SFSpeechAudioBufferRecognitionRequest,
    avAudio = [[AVAudioEngine alloc] init];
    bufferRecognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    
    NSLog(@"Checking recognition task");
    // Check if the SFSpeechRecognitionTask is running or not, if it is
    // then stop it and set it to null
    if (recognitionTask){
        
        NSLog(@"There was a recognition task, kill it");
        [recognitionTask cancel];
        recognitionTask = nil;
    }
    
    NSLog(@"Create audio session");
    NSError *error;
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryRecord error:&error];
    [session setActive:YES error:&error];
    
    NSLog(@"Create input type");
    AVAudioInputNode *input = avAudio.inputNode;
    bufferRecognitionRequest.shouldReportPartialResults = YES;
    
    NSLog(@"recognition task should create result");
    recognitionTask = [recognizer recognitionTaskWithRequest:bufferRecognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
        BOOL isFinal = NO;
        
        NSLog(@"Before if (result)");
        if (result) {
            // Whatever you say in the mic after pressing the button should be being logged
            // in the console.
            NSLog(@"Result should be printed");
            NSLog(@"RESULT:%@",result.bestTranscription.formattedString);
            isFinal = !result.isFinal;
        }
        //NSLog(@"If (error)");
        //if (error) {
         //   NSLog(@"There was an error");
           // [avAudio stop];
          //  [input removeTapOnBus:0];
          //  bufferRecognitionRequest = nil;
          //  recognitionTask = nil;
   //     }
    }];
    
    NSLog(@"Create recording format");
    AVAudioFormat *recordingFormat = [input outputFormatForBus:0];
    [input installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        [bufferRecognitionRequest appendAudioPCMBuffer:buffer];
    }];
    
    NSLog(@"Start the av audio engine");
    // Starts the audio engine, i.e. it starts listening.
    [avAudio prepare];
    [avAudio startAndReturnError:&error];
}


#pragma mark - SFSpeechRecognizerDelegate Delegate Methods

- (void)recognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available {
    NSLog(@"Availability:%d",available);
}


- (IBAction)microphone:(id)sender{
    
    if (avAudio.isRunning){
        [avAudio stop];
        [bufferRecognitionRequest endAudio];
    }
    else{
        [self listen];
    }
}


@end
