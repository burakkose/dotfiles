import sys
import os

home = os.getenv("HOME")
sys.path.append(home + "/.lib/pybase")

from rofi import Rofi
import csv
import os
import subprocess

csv_file = os.path.join(os.path.dirname(__file__), home + "/.config/rofi/bookmarks.csv")

with open(csv_file) as csvfile:
    reader = csv.reader(csvfile, delimiter=',')
    attr = list(reader)[1:]
    (options, values) = zip(*attr)
    r = Rofi()
    index = r.select('Select bookmark: ', options)[0]
    if index != -1:
        subprocess.call(['firefox', values[index]])
