package syedharisali.audiostreamerexample;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.mobilecpp.streamer.AudioStreamer;
import com.mobilecpp.streamer.AudioStreamerProxyImpl;

public class MainActivity extends AppCompatActivity {

    private final String STREAM_URL = "http://a935.phobos.apple.com/us/r30/Music/53/6f/d8/mzm.eslehvlz.aac.p.m4a";

    // Used to load the 'native-lib' library on application startup.
    static {
        System.loadLibrary("AudioStreamer");
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        //
        // Check to see if we're already initialized the player (we don't want to do this
        // everytime the user rotates the device!
        //
        final AudioStreamer sharedStreamer = AudioStreamer.sharedInstance();
        if (sharedStreamer.getProxy() == null) {
            AudioStreamerProxyImpl proxy = new AudioStreamerProxyImpl(getApplicationContext());
            sharedStreamer.setProxy(proxy);
            sharedStreamer.setUrl(STREAM_URL);

            //
            // Setup the button `onClick` listener to change the AudioStreamer state as
            // the user interacts with the play button
            //
            final Button playButton = (Button)findViewById(R.id.play_button);
            playButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    String buttonText;
                    if (sharedStreamer.isPlaying()) {
                        sharedStreamer.pause();
                        buttonText = getResources().getString(R.string.button_state_play);
                    }
                    else {
                        sharedStreamer.play();
                        buttonText = getResources().getString(R.string.button_state_pause);
                    }
                    playButton.setText(buttonText);
                }
            });
        }
    }
}
