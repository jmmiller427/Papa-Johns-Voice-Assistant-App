#import <UIKit/UIKit.h>
#import <Speech/Speech.h>
#import <ApiAI/ApiAI.h>


@interface ViewController : UIViewController <SFSpeechRecognizerDelegate> {
    AVAudioEngine *avAudio;
    SFSpeechRecognizer *recognizer;
    SFSpeechAudioBufferRecognitionRequest *bufferRecognitionRequest;
    SFSpeechRecognitionTask *recognitionTask;
}


@property(nonatomic, strong) ApiAI *apiAI;


@end

