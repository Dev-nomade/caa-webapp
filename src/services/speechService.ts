class SpeechService {
  private synth: SpeechSynthesis | null = null;
  private voices: SpeechSynthesisVoice[] = [];
  private voicesLoaded: boolean = false;

  constructor() {
    if (typeof window !== 'undefined' && 'speechSynthesis' in window) {
      this.synth = window.speechSynthesis;
      this.loadVoices();

      if (this.synth.onvoiceschanged !== undefined) {
        this.synth.onvoiceschanged = () => this.loadVoices();
      }
    }
  }

  private loadVoices(): void {
    if (!this.synth) return;
    this.voices = this.synth.getVoices();
    this.voicesLoaded = this.voices.length > 0;
  }

  private getPortugueseVoice(): SpeechSynthesisVoice | null {
    if (!this.voicesLoaded && this.synth) {
      this.voices = this.synth.getVoices();
    }

    return (
      this.voices.find(
        (v) => v.lang === 'pt-BR'
      ) ||
      this.voices.find(
        (v) => v.lang.startsWith('pt')
      ) ||
      null
    );
  }

  speak(text: string, lang: string = 'pt-BR'): void {
    if (!this.synth) {
      console.warn('Speech synthesis not supported');
      this.playConfirmSound();
      return;
    }

    this.synth.cancel();

    // Chrome bug workaround: resume if paused
    if (this.synth.paused) {
      this.synth.resume();
    }

    const utterance = new SpeechSynthesisUtterance(text);
    utterance.lang = lang;
    utterance.rate = 0.9;
    utterance.pitch = 1.0;
    utterance.volume = 1.0;

    const voice = this.getPortugueseVoice();
    if (voice) {
      utterance.voice = voice;
    }

    utterance.onerror = (event) => {
      console.warn('Speech error:', event.error);
      this.playConfirmSound();
    };

    // Chrome bug: long utterances can get stuck. Set a timeout to resume.
    utterance.onstart = () => {
      // Keep speech synthesis alive (Chrome pauses after ~15s)
      const keepAlive = setInterval(() => {
        if (this.synth && this.synth.speaking) {
          this.synth.resume();
        } else {
          clearInterval(keepAlive);
        }
      }, 5000);

      utterance.onend = () => clearInterval(keepAlive);
    };

    this.synth.speak(utterance);

    // Play a soft confirmation sound alongside
    this.playConfirmSound();
  }

  stop(): void {
    if (this.synth) {
      this.synth.cancel();
    }
  }

  playConfirmSound(): void {
    try {
      const audioContext = new (window.AudioContext || (window as any).webkitAudioContext)();

      // Soft chime - two pleasant notes
      const playNote = (freq: number, startTime: number, duration: number) => {
        const osc = audioContext.createOscillator();
        const gain = audioContext.createGain();
        osc.connect(gain);
        gain.connect(audioContext.destination);

        osc.type = 'sine';
        osc.frequency.setValueAtTime(freq, audioContext.currentTime + startTime);

        gain.gain.setValueAtTime(0, audioContext.currentTime + startTime);
        gain.gain.linearRampToValueAtTime(0.2, audioContext.currentTime + startTime + 0.05);
        gain.gain.exponentialRampToValueAtTime(
          0.01,
          audioContext.currentTime + startTime + duration
        );

        osc.start(audioContext.currentTime + startTime);
        osc.stop(audioContext.currentTime + startTime + duration);
      };

      // C5 + E5 chime (pleasant confirmation)
      playNote(523, 0, 0.15);
      playNote(659, 0.08, 0.2);
    } catch {
      // AudioContext not available
    }
  }

  playAlertSound(): void {
    try {
      const audioContext = new (window.AudioContext || (window as any).webkitAudioContext)();

      const playTone = (freq: number, startTime: number, duration: number, volume: number) => {
        const osc = audioContext.createOscillator();
        const gain = audioContext.createGain();
        osc.connect(gain);
        gain.connect(audioContext.destination);

        osc.type = 'sine';
        osc.frequency.setValueAtTime(freq, audioContext.currentTime + startTime);

        gain.gain.setValueAtTime(volume, audioContext.currentTime + startTime);
        gain.gain.exponentialRampToValueAtTime(
          0.01,
          audioContext.currentTime + startTime + duration
        );

        osc.start(audioContext.currentTime + startTime);
        osc.stop(audioContext.currentTime + startTime + duration);
      };

      // Gentle three-tone alert (not jarring)
      playTone(440, 0, 0.3, 0.25);
      playTone(520, 0.25, 0.3, 0.25);
      playTone(440, 0.5, 0.4, 0.2);
    } catch {
      // AudioContext not available
    }
  }
}

export const speechService = new SpeechService();
