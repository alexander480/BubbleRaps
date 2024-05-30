import json

def filter_short_words(input_file_path, output_file_path, min_length=3):
    # Load the words from the input JSON file
    with open(input_file_path, 'r', encoding='utf-8') as file:
        words = json.load(file)

    # Filter out words that are less than the specified minimum length
    filtered_words = [word for word in words if len(word) >= min_length]

    # Save the filtered list of words back to a new JSON file
    with open(output_file_path, 'w', encoding='utf-8') as file:
        json.dump(filtered_words, file, indent=4)

    print(f"Filtered words saved to {output_file_path}")

# File paths
input_file_path = '/Users/awllwa/daleChallWordList.json'  # Adjust as needed
output_file_path = '/Users/awllwa/daleChallWordList_3LettersOrMore.json'  # Adjust as needed

# Call the function
filter_short_words(input_file_path, output_file_path)
