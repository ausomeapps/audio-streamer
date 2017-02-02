#pragma once

#include <audio_streamer.hpp>

namespace mobilecpp {
    
    class AudioStreamerImpl : public AudioStreamer {
    private:
        static std::shared_ptr<AudioStreamerImpl> mSharedInstance;
        std::shared_ptr<AudioStreamerProxy> mProxy;
        
    public:
        AudioStreamerImpl();
        ~AudioStreamerImpl();
        
        /**
         * A singleton instance of the audio streamer (in most applications you will
         * only be dealing with a single streamer reference since you don't want
         * multiple players playing at once)
         */
        static std::shared_ptr<AudioStreamer> sharedInstance();
        static std::shared_ptr<AudioStreamerImpl> internalSharedInstance();
        
        /**
         * Sets an instance of the proxy class that is used to implement the
         * platform specific proxy
         */
        virtual void setProxy(const std::shared_ptr<AudioStreamerProxy> & proxy) override;
        
        /** Provides the currently loaded URL song reference */
        virtual std::string url() override;
        
        /**
         * Sets the current URL song reference (will stop the player from playing
         * if it is currently playing)
         */
        virtual void setUrl(const std::string & url) override;
        
        /**
         * Returns a boolean indicating whether or not the player is currently
         * playing some audio
         */
        virtual bool isPlaying() override;
        
        /** Tells the player to start playing audio. */
        virtual void play() override;
        
        /** Tells the player to pause any audio it may be playing. */
        virtual void pause() override;
    };
    
}
