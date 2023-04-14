import math
import struct
import wave

from flask import Flask, request

app = Flask(__name__)


def convert_bytes_to_audio(music):
    with wave.open('format.wav', mode='wb') as fo:
        fo.setnchannels(1)
        fo.setsampwidth(2)  # bytes
        fo.setframerate(44100)
        for i in music:
            fo.writeframes(i)
    audio = wave.open('format.wav', 'rb')
    return audio


def format_db(x, peak, pos=None):
    if pos == 0:
        return 0
    if x == 0:
        return 0

    db = 20 * math.log10(abs(x) / float(peak))
    return float(db)


@app.route('/music/', methods=["POST"])
def index():
    music = request.json.get("music")
    audio = list(map(lambda b: bytes([b]), eval(music)))
    audio_file = convert_bytes_to_audio(audio)
    (nchannels, sampwidth, framerate, nframes, comptype, compname) = audio_file.getparams()
    peak = 256 ** sampwidth / 2
    N_FRAMES = audio_file.getnframes()
    CHANNELS = audio_file.getnchannels()
    samples = audio_file.readframes(N_FRAMES)
    values = list(struct.unpack("<" + str(N_FRAMES * CHANNELS) + "h", samples))
    values_res = []
    for af in values:
        values_res.append(10 ** (format_db(af, peak) / 20))
    a_all = 0.0
    for i, a in enumerate(values_res):
        if i % 3 != 0:
            a_all += a
        if i % 3 == 0 and i != 0:
            values_res[i-2] = a_all/3
            values_res[i-1] = a_all/3
            values_res[i] = a_all/3
            a_all = 0.0

    return values_res, 200


if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8084, debug=True)
