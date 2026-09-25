"""Original synthesized score and effects. No samples or third-party recordings."""
from pathlib import Path
import math
import wave
import numpy as np

ROOT = Path(__file__).resolve().parents[1]
RATE = 22050
RNG = np.random.default_rng(250926)


def voice(note, duration, kind="lyre"):
    t = np.arange(int(duration * RATE)) / RATE
    f = 440 * 2 ** ((note - 69) / 12)
    phase = 2 * np.pi * f * t
    if kind == "flute":
        wave_data = np.sin(phase + .012 * np.sin(2 * np.pi * 5 * t)) + .14 * np.sin(2 * phase)
        env = np.minimum(t / .035, 1) * np.minimum((duration - t) / .15, 1)
    elif kind == "pad":
        wave_data = np.sin(phase) + .3 * np.sin(phase * 1.003) + .15 * np.sin(phase * 2)
        env = np.minimum(t / .3, 1) * np.minimum((duration - t) / .5, 1)
    elif kind == "bell":
        wave_data = np.sin(phase) + .35 * np.sin(phase * 2.01) + .12 * np.sin(phase * 3.98)
        env = np.exp(-t * 3) * np.minimum(t / .005, 1)
    else:
        wave_data = np.sin(phase) + .4 * np.sin(2 * phase) + .18 * np.sin(3 * phase)
        env = np.exp(-t * 5 / max(.6, duration)) * np.minimum(t / .006, 1)
    return wave_data * np.clip(env, 0, 1)


def write(name, data, loop=False):
    data = np.asarray(data, dtype=np.float64)
    if data.ndim == 1:
        data = np.column_stack([data, data])
    if loop:
        # Tiny periodic boundary fade prevents clicks without a perceptible musical gap.
        fade = min(220, len(data) // 4)
        data[:fade] *= np.linspace(0, 1, fade)[:, None]
        data[-fade:] *= np.linspace(1, 0, fade)[:, None]
    data = np.tanh(data * .7)
    peak = np.max(np.abs(data))
    if peak > 0:
        data *= .72 / peak
    folder = ROOT / "sounds" / name
    folder.mkdir(parents=True, exist_ok=True)
    with wave.open(str(folder / (name + ".wav")), "wb") as out:
        out.setnchannels(2)
        out.setsampwidth(2)
        out.setframerate(RATE)
        out.writeframes((data * 32767).astype("<i2").tobytes())


def score(zone, root, bpm, scale, lead, rhythm):
    beat = 60 / bpm
    length = 16 * 4 * beat
    mix = np.zeros((round(length * RATE), 2))

    def add(sound, at, volume, pan=0):
        idx = (np.arange(len(sound)) + round(at * RATE)) % len(mix)
        mix[idx, 0] += sound * volume * math.sqrt((1 - pan) / 2)
        mix[idx, 1] += sound * volume * math.sqrt((1 + pan) / 2)

    motif = [0, 2, 4, 2, 1, 3, 5, 4, 2, 1, 0, 2, 4, 3, 1, 0]
    harmony = [0, 5, 3, 4]
    for bar in range(16):
        chord = harmony[(bar // 2) % 4]
        for degree in [0, 2, 4]:
            n = root - 12 + scale[(chord + degree) % 7]
            add(voice(n, beat * 4.5, "pad"), bar * beat * 4, .065, (degree - 2) * .25)
        for step in range(8):
            deg = (chord + [0, 2, 4, 6, 4, 2, 1, 2][step]) % 7
            add(voice(root + scale[deg], beat * 1.2), (bar * 4 + step * .5) * beat, .085, -.45)
        for step in range(4):
            if (bar + step) % 5 != 3:
                deg = motif[(bar * 3 + step) % len(motif)]
                sound = voice(root + 12 + scale[deg], beat * (1.4 if step == 3 else .8), lead)
                at = (bar * 4 + step) * beat
                add(sound, at, .13, .3)
                add(sound, at + beat * .75, .026, -.5)
            if rhythm:
                t = np.arange(int(.23 * RATE)) / RATE
                drum = np.sin(2 * np.pi * (70 * t - 45 * t * t)) * np.exp(-t * 19)
                add(drum, (bar * 4 + step) * beat, .1 if step % 2 == 0 else .045)
    write("snd_zone_" + zone, mix, True)


if __name__ == "__main__":
    major = [0, 2, 4, 5, 7, 9, 11]
    dorian = [0, 2, 3, 5, 7, 9, 10]
    minor = [0, 2, 3, 5, 7, 8, 10]
    for spec in [("sea", 50, 84, dorian, "bell", False),
                 ("coast", 55, 102, major, "flute", True),
                 ("mines", 45, 76, minor, "bell", True),
                 ("hades", 43, 68, minor, "pad", False),
                 ("greece", 60, 96, major, "lyre", True),
                 ("battlefield", 48, 112, dorian, "lyre", True),
                 ("olympus", 57, 80, major, "bell", False)]:
        score(*spec)
    effects = {"enemy_hit": (45, .19), "boss_hit": (33, .3), "enemy_death": (52, .55),
               "boss_death": (40, 1.4), "attack": (62, .18), "pickup": (81, .5),
               "reward": (76, 1.6), "potion": (86, .45), "button": (52, .2),
               "stone": (30, .45), "checkpoint": (74, 1), "door": (36, .9),
               "player_hurt": (58, .3), "wind": (35, 2), "water": (70, 1.7),
               "fire": (42, 1.1), "drip": (94, .7), "wisp": (80, 1.2)}
    for name, (note, duration) in effects.items():
        if name in ("pickup", "reward", "checkpoint", "potion"):
            data = np.zeros(int((duration + .35) * RATE))
            for i, interval in enumerate([0, 4, 7, 12]):
                tone = voice(note + interval, duration * .55, "bell") * .22
                start = int(i * .085 * RATE)
                count = min(len(tone), len(data) - start)
                data[start:start + count] += tone[:count]
        else:
            t = np.arange(int(duration * RATE)) / RATE
            noise = RNG.normal(0, 1, len(t))
            smooth = np.convolve(noise, np.ones(16) / 16, mode="same")
            tone = voice(note, duration, "lyre")
            env = np.minimum(t / .01, 1) * np.exp(-t * 5 / duration)
            data = (.45 * smooth + .28 * tone) * env
            if name in ("wind", "water", "fire"):
                data = smooth * np.sin(np.pi * t / duration) ** 2
        write("snd_fx_" + name, data)
    print("Generated seven original looping scores and 18 effects at 22050 Hz stereo.")
