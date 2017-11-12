#import <UIKit/UIKit.h>
#import <Speech/Speech.h>
#import <ApiAI/ApiAI.h>


@interface ViewController : UIViewController <SFSpeechRecognizerDelegate> {
    AVAudioEngine *avAudio;
    SFSpeechRecognizer *recognizer;
    SFSpeechAudioBufferRecognitionRequest *bufferRecognitionRequest;
    SFSpeechRecognitionTask *recognitionTask;
    NSString *res;
    
    IBOutlet UITextField *username;
    IBOutlet UITextField *password;
    NSDictionary *dict;
}

- (IBAction)loginButton:(id)sender;

@property(nonatomic, strong) ApiAI *apiAI;


@end

