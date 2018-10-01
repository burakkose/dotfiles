from pybase import rofi
import csv
import os
import subprocess

csv_file = os.path.join(os.path.dirname(__file__), "bookmarks.csv")

with open(csv_file) as csvfile:
    reader = csv.reader(csvfile, delimiter=',')
    attr = list(reader)[1:]
    (options, values) = zip(*attr)
    r = rofi.Rofi()
    index = r.select('Select bookmark: ', options)[0]
    if index != -1:
        subprocess.call(['firefox', values[index]])
