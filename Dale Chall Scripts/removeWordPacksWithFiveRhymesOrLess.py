import json

def load_json_file(file_path):
    """ Load data from a JSON file. """
    with open(file_path, 'r', encoding='utf-8') as file:
        return json.load(file)

def save_json_file(data, file_path):
    """ Save data to a JSON file. """
    with open(file_path, 'w', encoding='utf-8') as file:
        json.dump(data, file, indent=4)

def filter_word_packs(word_packs):
    """ Filter out packs with less than 5 rhymes. """
    return [pack for pack in word_packs if len(pack['rhymes']) >= 5]

def main():
    # Path to the input file
    input_file_path = '/Users/awllwa/daleChallWordPacks.json'
    
    # Load the word packs
    word_packs = load_json_file(input_file_path)
    
    # Filter the word packs
    filtered_word_packs = filter_word_packs(word_packs)
    
    # Save the filtered word packs to a new file
    output_file_path = '/Users/awllwa/filteredDaleChallWordPacks.json'
    save_json_file(filtered_word_packs, output_file_path)
    print(f"Filtered word packs saved to {output_file_path}")

if __name__ == "__main__":
    main()
