import csv

def tsv_to_csv(input_file, output_file):
    with open(input_file, 'r', newline='', encoding='utf-8') as tsvfile:
        with open(output_file, 'w', newline='', encoding='utf-8') as csvfile:
            tsvreader = csv.reader(tsvfile, delimiter='\t')
            csvwriter = csv.writer(csvfile)
            for row in tsvreader:
                csvwriter.writerow(row)

# Replace 'input.tsv' with the path to your TSV file and 'output.csv' with the desired path for the CSV output file
tsv_to_csv('combined_post_data_2_labels.tsv', 'combined_post_data_2_labels.csv')
