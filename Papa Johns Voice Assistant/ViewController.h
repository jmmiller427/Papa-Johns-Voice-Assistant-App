#import <UIKit/UIKit.h>
#import <Speech/Speech.h>
#import <ApiAI/ApiAI.h>


@interface ViewController : UIViewController <SFSpeechRecognizerDelegate> {
    AVAudioEngine *avAudio;
    SFSpeechRecognizer *recognizer;
    SFSpeechAudioBufferRecognitionRequest *bufferRecognitionRequest;
    SFSpeechRecognitionTask *recognitionTask;
    NSString *res;
}

@property(nonatomic, strong) ApiAI *apiAI;
@property(nonatomic, retain) IBOutlet UILabel *textLabel;

@end

