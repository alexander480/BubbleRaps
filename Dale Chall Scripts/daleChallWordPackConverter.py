import json

def convert_rhyme_dictionary(file_path, output_file_path):
    # Load the JSON file
    with open(file_path, 'r', encoding='utf-8') as file:
        rhyme_dict = json.load(file)

    # Convert the dictionary into the desired format
    converted_list = []
    for topic, rhymes in rhyme_dict.items():
        item = {
            "topic": topic,
            "rhymes": rhymes,
            "notRhymes": [],
            "rhymeDictionary": {rhyme: True for rhyme in rhymes},
            "allWords": rhymes
        }
        converted_list.append(item)

    # Save the converted list to a new JSON file
    with open(output_file_path, 'w', encoding='utf-8') as file:
        json.dump(converted_list, file, indent=4)

    print(f"Converted file saved to {output_file_path}")

# Specify the input and output file paths
input_file_path = '/Users/awllwa/daleChallRhymeDictionary.json'
output_file_path = '/Users/awllwa/daleChallWordPacks.json'

# Run the conversion
convert_rhyme_dictionary(input_file_path, output_file_path)
