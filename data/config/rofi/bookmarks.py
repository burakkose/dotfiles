from pybase import rofi
import csv
import subprocess

with open('bookmarks.csv') as csvfile:
    reader = csv.reader(csvfile, delimiter=',')
    attr = list(reader)[1:]
    (options, values) = zip(*attr)
    r = rofi.Rofi()
    index = r.select('Select bookmark: ', options)[0]
    subprocess.call(['firefox', values[index]])
