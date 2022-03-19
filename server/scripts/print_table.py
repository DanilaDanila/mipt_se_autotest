#!/usr/bin/python3

import csv

def main():
    print("<table>")

    with open('../table.csv') as f:
        csv_reader = csv.DictReader(f, delimiter=',')

        print('<tr>')
        for key in csv_reader.fieldnames:
            print('<th>{}</th>'.format(key))
        print('</tr>')

        for row in csv_reader:
            print('<tr>')
            print('<td>{}</td>'.format(row['name']))
            print('<td><a href=reports/{}.log>{}</a></td>'.format(row['name'], row['build']))
            print('<td><a href=reports/rational/{}.log>{}</a></td>'.format(row['name'], row['rational']))
            print('<td><a href=reports/m3i/{}.log>{}</a></td>'.format(row['name'], row['m3i']))
            print('</tr>')

    print("</table>")

if __name__ == "__main__":
    main()