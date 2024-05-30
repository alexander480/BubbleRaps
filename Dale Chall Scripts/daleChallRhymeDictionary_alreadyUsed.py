import json
import requests

def load_words_from_json(file_path):
    """ Load words from a JSON file. """
    with open(file_path, 'r', encoding='utf-8') as file:
        words = json.load(file)
    return words

def fetch_rhymes(word, max_results=100):
    """ Fetch rhymes for a given word using the Datamuse API. """
    api_url = f"https://api.datamuse.com/words?rel_rhy={word}&max={max_results}"
    response = requests.get(api_url)
    if response.status_code == 200:
        return [item['word'] for item in response.json()]
    else:
        print(f"Failed to fetch rhymes for {word}: HTTP {response.status_code}")
        return []

def filter_words(rhymes, word_list):
    """ Filter rhymes to include only those also in the word list. """
    return [word for word in rhymes if word in word_list]

def create_rhyme_dictionary(word_list, dale_chall_words):
    """ Create a dictionary of words with their rhyming words from the Dale-Chall list. """
    rhyme_dict = {}
    for word in word_list:
        rhymes = fetch_rhymes(word)
        filtered_rhymes = filter_words(rhymes, dale_chall_words)
        rhyme_dict[word] = filtered_rhymes
        print(f"Processed rhymes for {word}")
    return rhyme_dict

def main():
    # Path to the JSON file containing the filtered Dale-Chall word list
    input_file_path = '/Users/awllwa/daleChallWordList_3LettersOrMore.json'
    output_file_path = '/Users/awllwa/daleChallRhymeDictionary.json'
    
    # Load the Dale-Chall word list
    dale_chall_words = load_words_from_json(input_file_path)
    
    # Create the dictionary of rhymes
    rhyme_dictionary = create_rhyme_dictionary(dale_chall_words, dale_chall_words)
    
    # Save the dictionary to a new JSON file
    with open(output_file_path, 'w', encoding='utf-8') as file:
        json.dump(rhyme_dictionary, file, indent=4)

    print(f"Rhyme dictionary saved to {output_file_path}")

if __name__ == "__main__":
    main()
