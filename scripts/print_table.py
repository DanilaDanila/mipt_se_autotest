#!/usr/bin/python3

import csv
import sys

def main():
    print("<table>")
    reports_path=sys.argv[1]

    with open(sys.argv[2]) as f:
        csv_reader = csv.DictReader(f, delimiter=',')

        print('<tr>')
        for key in csv_reader.fieldnames:
            print('<th>{}</th>'.format(key))
        print('</tr>')

        for row in csv_reader:
            print('<tr>')
            print('<td>{}</td>'.format(row['name']))
            print('<td><a href={}/build/{}.html>{}</a></td>'.format(reports_path, row['name'], row['build']))
            print('<td><a href={}/rational/{}.html>{}</a></td>'.format(reports_path, row['name'], row['rational']))
            print('<td><a href={}/m3i/{}.html>{}</a></td>'.format(reports_path, row['name'], row['m3i']))
            print('</tr>')

    print("</table>")

if __name__ == "__main__":
    main()