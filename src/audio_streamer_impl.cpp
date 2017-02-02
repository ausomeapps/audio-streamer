#include <audio_streamer_impl.hpp>
#include <audio_streamer_proxy.hpp>

namespace mobilecpp {
    
    std::shared_ptr<AudioStreamerImpl> AudioStreamerImpl::mSharedInstance = nullptr;
    
    AudioStreamerImpl::AudioStreamerImpl() {
        mProxy = nullptr;
    }
    
    AudioStreamerImpl::~AudioStreamerImpl() {
        // TBD
    }
    
    std::shared_ptr<AudioStreamer> AudioStreamer::sharedInstance() {
        return AudioStreamerImpl::internalSharedInstance();
    }
    
    std::shared_ptr<AudioStreamerImpl> AudioStreamerImpl::internalSharedInstance() {
        if (mSharedInstance == nullptr) {
            mSharedInstance = std::make_shared<AudioStreamerImpl>();
        }
        return mSharedInstance;
    }

    void AudioStreamerImpl::setProxy(const std::shared_ptr<AudioStreamerProxy> & proxy) {
        mProxy = proxy;
    }

    std::string AudioStreamerImpl::url() {
        if (mProxy == nullptr) {
            return nullptr;
        }
        return mProxy->url();
    }

    void AudioStreamerImpl::setUrl(const std::string & url) {
        if (mProxy != nullptr) {
            mProxy->setUrl(url);
        }
    }

    bool AudioStreamerImpl::isPlaying() {
        if (mProxy != nullptr) {
            return mProxy->isPlaying();
        }
        return false;
    }

    void AudioStreamerImpl::play() {
        if (mProxy != nullptr) {
            mProxy->play();
        }
    }

    void AudioStreamerImpl::pause() {
        if (mProxy != nullptr) {
            mProxy->pause();
        }
    }
    
}
